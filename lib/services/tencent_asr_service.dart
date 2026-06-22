import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Credentials for Tencent Cloud real-time ASR.
class TencentAsrConfig {
  const TencentAsrConfig({
    required this.appId,
    required this.secretId,
    required this.secretKey,
    this.token = '',
    this.engine = '16k_zh',
  });

  final String appId;
  final String secretId;
  final String secretKey;
  final String token;
  final String engine;

  bool get isComplete =>
      appId.isNotEmpty && secretId.isNotEmpty && secretKey.isNotEmpty;
}

/// Tencent Cloud real-time speech recognition over its documented WebSocket
/// protocol (`wss://asr.cloud.tencent.com/asr/v2/<appid>`), streaming 16 kHz
/// 16-bit mono PCM. This replaces the native app's closed-source
/// `TencentRealtimeSpeechRecognizer` SDK with a pure-Dart implementation of the
/// same cloud service.
class TencentAsrService {
  static const _host = 'asr.cloud.tencent.com';
  static const _path = '/asr/v2/';

  final AudioRecorder _recorder = AudioRecorder();
  WebSocketChannel? _socket;
  StreamSubscription<Uint8List>? _audioSub;
  final _segments = <int, String>{};
  final _frame = BytesBuilder();

  bool _active = false;
  void Function(String partial)? _onPartial;
  void Function(String message)? _onError;

  String get _transcript {
    final keys = _segments.keys.toList()..sort();
    return keys.map((k) => _segments[k]).join();
  }

  /// Build the signed wss URL per the Tencent real-time ASR spec: sort the
  /// query params, HMAC-SHA1 the `host+path+appid?query` string with the secret
  /// key, base64 it, and append it url-encoded as `signature`.
  Uri _signedUri(TencentAsrConfig c) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final rng = Random();
    final params = <String, String>{
      'secretid': c.secretId,
      'timestamp': '$now',
      'expired': '${now + 86400}',
      'nonce': '${rng.nextInt(1 << 31)}',
      'engine_model_type': c.engine,
      'voice_id': _voiceId(rng),
      'voice_format': '1', // PCM
      'needvad': '1',
      if (c.token.isNotEmpty) 'token': c.token,
    };
    final sortedKeys = params.keys.toList()..sort();
    final query = sortedKeys.map((k) => '$k=${params[k]}').join('&');
    final signOrigin = '$_host$_path${c.appId}?$query';
    final sig = base64.encode(
      Hmac(sha1, utf8.encode(c.secretKey)).convert(utf8.encode(signOrigin)).bytes,
    );
    final encodedSig = Uri.encodeComponent(sig);
    return Uri.parse('wss://$_host$_path${c.appId}?$query&signature=$encodedSig');
  }

  String _voiceId(Random rng) {
    const hex = '0123456789abcdef';
    return List.generate(32, (_) => hex[rng.nextInt(16)]).join();
  }

  /// Start recognition. [onPartial] fires with the accumulating transcript.
  /// Returns false if the mic permission is missing or config is incomplete.
  Future<bool> start(
    TencentAsrConfig config, {
    required void Function(String partial) onPartial,
    required void Function(String message) onError,
  }) async {
    if (_active || !config.isComplete) return false;
    if (!await _recorder.hasPermission()) return false;
    _onPartial = onPartial;
    _onError = onError;
    _segments.clear();
    _frame.clear();

    try {
      _socket = WebSocketChannel.connect(_signedUri(config));
    } catch (e) {
      onError('连接腾讯 ASR 失败: $e');
      return false;
    }
    _active = true;
    _socket!.stream.listen(_onMessage, onError: (e) {
      _onError?.call('腾讯 ASR 连接错误: $e');
      _cleanup();
    }, onDone: _cleanup);

    final stream = await _recorder.startStream(const RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 16000,
      numChannels: 1,
    ));
    // Batch into ~40 ms frames (16000 Hz * 2 bytes * 0.04 s = 1280 bytes).
    _audioSub = stream.listen((data) {
      _frame.add(data);
      while (_frame.length >= 1280) {
        final bytes = _frame.toBytes();
        final send = bytes.sublist(0, 1280);
        _frame.clear();
        if (bytes.length > 1280) _frame.add(bytes.sublist(1280));
        _socket?.sink.add(send);
      }
    });
    return true;
  }

  void _onMessage(dynamic message) {
    try {
      final json = jsonDecode(message as String) as Map<String, dynamic>;
      final code = json['code'] as int? ?? 0;
      if (code != 0) {
        _onError?.call(
            '腾讯 ASR 错误 $code: ${json['message'] ?? ''}');
        return;
      }
      final result = json['result'] as Map<String, dynamic>?;
      if (result != null) {
        final index = result['index'] as int? ?? 0;
        final text = result['voice_text_str'] as String? ?? '';
        _segments[index] = text;
        _onPartial?.call(_transcript);
      }
    } catch (_) {
      // Ignore malformed frames.
    }
  }

  /// Stop streaming, flush, signal end-of-audio, and return the final transcript.
  Future<String> stop() async {
    if (!_active) return _transcript;
    await _audioSub?.cancel();
    _audioSub = null;
    try {
      await _recorder.stop();
    } catch (_) {}
    // Flush any remaining buffered PCM and signal end.
    if (_frame.length > 0) {
      _socket?.sink.add(_frame.toBytes());
      _frame.clear();
    }
    try {
      _socket?.sink.add('{"type":"end"}');
    } catch (_) {}
    final text = _transcript;
    // Give the server a moment to return trailing results, then close.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _cleanup();
    return _transcript.isNotEmpty ? _transcript : text;
  }

  void _cleanup() {
    _active = false;
    _audioSub?.cancel();
    _audioSub = null;
    _socket?.sink.close();
    _socket = null;
  }

  Future<void> dispose() async {
    await _audioSub?.cancel();
    try {
      await _recorder.dispose();
    } catch (_) {}
    _socket?.sink.close();
  }
}
