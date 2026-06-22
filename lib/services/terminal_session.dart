import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xterm/xterm.dart';

import '../data/api/agent_monitor_api.dart';

enum TerminalConnectionState { connecting, ready, closed, error }

/// Bridges an xterm [Terminal] to the server-side PTY exposed over
/// `/terminal/ws`. The PTY itself lives on the server (via tmux attach), so
/// this side only renders bytes and forwards input — no local PTY needed.
class TerminalSession extends ChangeNotifier {
  TerminalSession({required AgentMonitorApi api, required this.paneId})
      : _api = api {
    terminal = Terminal();
    terminal.onOutput = _onTerminalOutput;
    terminal.onResize = _onTerminalResize;
    _connect();
  }

  final AgentMonitorApi _api;
  final String paneId;
  late final Terminal terminal;

  TerminalConnectionState _state = TerminalConnectionState.connecting;
  TerminalConnectionState get state => _state;

  WebSocketChannel? _socket;

  void _connect() {
    final base = _api.wsUri('/terminal/ws');
    final qp = Map<String, String>.from(base.queryParameters)
      ..['paneId'] = paneId
      ..['cols'] = '96'
      ..['rows'] = '28';
    final uri = base.replace(queryParameters: qp);

    try {
      _socket = WebSocketChannel.connect(uri);
    } catch (_) {
      _setState(TerminalConnectionState.error);
      return;
    }
    _socket!.stream.listen(
      _onMessage,
      onError: (_) => _setState(TerminalConnectionState.error),
      onDone: () {
        if (_state != TerminalConnectionState.error) _setState(TerminalConnectionState.closed);
      },
    );
  }

  void _onMessage(dynamic message) {
    try {
      final json = jsonDecode(message as String) as Map<String, dynamic>;
      switch (json['type']) {
        case 'ready':
          _setState(TerminalConnectionState.ready);
          break;
        case 'data':
          terminal.write(json['data'] as String);
          break;
        case 'exit':
          _setState(TerminalConnectionState.closed);
          break;
        case 'error':
          _setState(TerminalConnectionState.error);
          break;
      }
    } catch (_) {
      // Ignore malformed frames.
    }
  }

  void _onTerminalOutput(String data) {
    _socket?.sink.add(jsonEncode({'type': 'input', 'data': data}));
  }

  void _onTerminalResize(int width, int height, int pw, int ph) {
    _socket?.sink.add(jsonEncode({
      'type': 'resize',
      'cols': width,
      'rows': height,
    }));
  }

  void _setState(TerminalConnectionState s) {
    if (_state == s) return;
    _state = s;
    notifyListeners();
  }

  @override
  void dispose() {
    _socket?.sink.close();
    super.dispose();
  }
}
