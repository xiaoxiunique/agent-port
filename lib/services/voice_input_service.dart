import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'tencent_asr_service.dart';

enum VoiceState { idle, initializing, listening, unavailable, error }

/// Push-to-talk voice input with two backends, mirroring the native app's
/// VOICE INPUT providers:
///  * `system` — on-device recognizer (Apple Speech / Android SpeechRecognizer)
///    via `speech_to_text`.
///  * `tencent` — Tencent Cloud real-time ASR via [TencentAsrService].
/// The provider + credentials are passed in at [start] time.
class VoiceInputController extends ChangeNotifier {
  final SpeechToText _stt = SpeechToText();
  final TencentAsrService _tencent = TencentAsrService();

  VoiceState _state = VoiceState.idle;
  VoiceState get state => _state;

  String _transcript = '';
  String get transcript => _transcript;

  bool _initialized = false;
  bool _usingTencent = false;

  void _set(VoiceState s) {
    if (_state == s) return;
    _state = s;
    notifyListeners();
  }

  Future<bool> _ensureSystemInit() async {
    if (_initialized) return true;
    _set(VoiceState.initializing);
    final ok = await _stt.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (_state == VoiceState.listening && !_usingTencent) {
            _set(VoiceState.idle);
          }
        }
      },
      onError: (_) => _set(VoiceState.error),
    );
    _initialized = ok;
    if (!ok) _set(VoiceState.unavailable);
    return ok;
  }

  /// Begin listening. Pass [tencent] config to use the Tencent backend;
  /// otherwise the on-device recognizer is used. Returns false if unavailable.
  Future<bool> start({TencentAsrConfig? tencent, String? localeId}) async {
    _transcript = '';
    if (tencent != null && tencent.isComplete) {
      _usingTencent = true;
      _set(VoiceState.listening);
      final ok = await _tencent.start(
        tencent,
        onPartial: (t) {
          _transcript = t;
          notifyListeners();
        },
        onError: (msg) {
          _set(VoiceState.error);
        },
      );
      if (!ok) {
        _usingTencent = false;
        _set(VoiceState.unavailable);
      }
      return ok;
    }

    _usingTencent = false;
    if (!await _ensureSystemInit()) return false;
    _set(VoiceState.listening);
    await _stt.listen(
      onResult: (r) {
        _transcript = r.recognizedWords;
        notifyListeners();
      },
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        localeId: localeId,
      ),
    );
    return true;
  }

  /// Stop listening and return the final transcript.
  Future<String> stop() async {
    if (_usingTencent) {
      _transcript = await _tencent.stop();
    } else if (_stt.isListening) {
      await _stt.stop();
    }
    if (_state == VoiceState.listening) _set(VoiceState.idle);
    return _transcript;
  }

  Future<void> cancel() async {
    if (_usingTencent) {
      await _tencent.stop();
    } else if (_stt.isListening) {
      await _stt.cancel();
    }
    _transcript = '';
    if (_state == VoiceState.listening) _set(VoiceState.idle);
  }

  @override
  void dispose() {
    _stt.cancel();
    _tencent.dispose();
    super.dispose();
  }
}
