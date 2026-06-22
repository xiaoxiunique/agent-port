import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../data/api/agent_monitor_api.dart';

enum PaneLogState { connecting, live, reconnecting, error }

/// Live per-pane log stream over `/pane-log/ws` with accumulation, an 800-line
/// cap, log-noise cleaning, HTTP fallback, and reconnect. Mirrors the native
/// `PaneLogWebSocketService` + `PaneRealtimeLogContainer` (PaneDetailSheet.swift).
class PaneLogService extends ChangeNotifier {
  PaneLogService({
    required AgentMonitorApi api,
    required this.paneId,
    String initialTail = '',
  }) : _api = api {
    if (initialTail.isNotEmpty) {
      _text = cleanPaneLog(initialTail);
    }
    _seedFromHttp();
    _connect();
  }

  static const int lineLimit = 800;

  final AgentMonitorApi _api;
  final String paneId;

  String _text = '';
  String get text => _text;

  PaneLogState _state = PaneLogState.connecting;
  PaneLogState get state => _state;

  WebSocketChannel? _socket;
  StreamSubscription? _sub;
  Timer? _reconnectTimer;
  bool _disposed = false;
  String? _lastCapturedAt;

  void _setState(PaneLogState s) {
    if (_state == s || _disposed) return;
    _state = s;
    notifyListeners();
  }

  void _setText(String t) {
    if (_text == t || _disposed) return;
    _text = t;
    notifyListeners();
  }

  Future<void> _seedFromHttp() async {
    try {
      final r = await _api.paneContext(paneId, lines: lineLimit);
      final tail = r.tail;
      if (_disposed || tail == null || tail.isEmpty) return;
      // Only seed if we don't yet have fresher live content.
      if (_text.isEmpty) _setText(cleanPaneLog(tail));
    } catch (_) {
      // Non-fatal; the WS or a later refresh will populate.
    }
  }

  void _connect() {
    if (_disposed) return;
    final base = _api.wsUri('/pane-log/ws');
    final qp = Map<String, String>.from(base.queryParameters)
      ..['paneId'] = paneId
      ..['lines'] = '$lineLimit';
    final uri = base.replace(queryParameters: qp);
    try {
      _socket = WebSocketChannel.connect(uri);
    } catch (_) {
      _scheduleReconnect();
      return;
    }
    _sub = _socket!.stream.listen(
      _onMessage,
      onError: (_) => _onClosed(),
      onDone: _onClosed,
    );
  }

  void _onMessage(dynamic message) {
    try {
      final json = jsonDecode(message as String) as Map<String, dynamic>;
      switch (json['type']) {
        case 'paneLog':
          final tail = json['tail'] as String?;
          if (tail == null) return;
          final capturedAt = json['capturedAt'] as String?;
          // Ignore frames older than what we already show.
          if (capturedAt != null &&
              _lastCapturedAt != null &&
              capturedAt.compareTo(_lastCapturedAt!) < 0) {
            return;
          }
          _lastCapturedAt = capturedAt ?? _lastCapturedAt;
          _setState(PaneLogState.live);
          _setText(cleanPaneLog(tail));
          break;
        case 'error':
          _setState(PaneLogState.error);
          break;
      }
    } catch (_) {
      // Ignore malformed frames.
    }
  }

  void _onClosed() {
    _sub?.cancel();
    _sub = null;
    _socket = null;
    if (_disposed) return;
    _setState(PaneLogState.reconnecting);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(milliseconds: 700), () {
      if (!_disposed) _connect();
    });
  }

  /// Ask the server to push a fresh capture (PaneLogWebSocketService.requestRefresh).
  void requestRefresh() {
    try {
      _socket?.sink.add('{"type":"refresh"}');
    } catch (_) {}
  }

  @override
  void dispose() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _sub?.cancel();
    _socket?.sink.close();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Log cleaning — port of native `LogText.compact`/`normalize`
// (PaneDetailSheet.swift:1648-1809). Strips ANSI, leading spinner glyphs,
// vim-mode/permission noise, separator-only lines; dedupes consecutive lines;
// collapses blank runs; caps to the last [limit] lines.
// ---------------------------------------------------------------------------

final _ansiCsi = RegExp(r'\x1B\[[0-9;?]*[ -/]*[@-~]');
final _ansiOsc = RegExp(r'\x1B\][^\x07\x1B]*(\x07|\x1B\\)');

String cleanPaneLog(String tail, {int limit = PaneLogService.lineLimit}) {
  final lines = <String>[];
  var prevBlank = false;
  for (final raw in tail.split('\n')) {
    final n = _normalizeLine(raw);
    if (n == null) continue;
    if (n.isEmpty) {
      if (!prevBlank && lines.isNotEmpty) {
        lines.add('');
        prevBlank = true;
      }
      continue;
    }
    prevBlank = false;
    if (lines.isEmpty || lines.last != n) lines.add(n);
  }
  final capped =
      lines.length > limit ? lines.sublist(lines.length - limit) : lines;
  return capped.join('\n').replaceFirst(RegExp(r'\s+$'), '');
}

String? _normalizeLine(String line) {
  // Strip ANSI escapes + carriage returns.
  var v = line
      .replaceAll(_ansiOsc, '')
      .replaceAll(_ansiCsi, '')
      .replaceAll('\r', '');

  // Strip leading Claude Code braille spinner glyphs.
  while (v.isNotEmpty) {
    final c = v.runes.first;
    final isSpinner =
        (c >= 0x2800 && c <= 0x28FF) || c == 0x2733 || c == 0x20;
    if (!isSpinner) break;
    v = String.fromCharCodes(v.runes.skip(1));
  }

  final lower = v.trim().toLowerCase();
  // Vim-mode / permission-hint noise.
  if (lower.startsWith('-- insert') ||
      lower.startsWith('-- normal') ||
      lower.startsWith('-- visual') ||
      lower.startsWith('-- replace')) {
    return null;
  }
  if (lower.contains('bypass permissions') && lower.contains('shift+tab')) {
    return null;
  }

  // Separator-only lines (box drawing / dashes / equals).
  final trimmed = v.trim();
  if (trimmed.isNotEmpty && _isSeparatorOnly(trimmed)) return null;

  return v.replaceFirst(RegExp(r'\s+$'), '');
}

const _separatorChars = {
  0x2500, // ─
  0x2501, // ━
  0x2550, // ═
  0x2014, // —
  0x2013, // –
  0x2D, // -
  0x3D, // =
  0x5F, // _
  0x20, // space
};

bool _isSeparatorOnly(String s) {
  for (final c in s.runes) {
    if (!_separatorChars.contains(c)) return false;
  }
  return true;
}
