import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

import '../../core/theme.dart';
import '../../data/api/agent_monitor_api.dart';
import '../../services/terminal_session.dart';

/// Interactive terminal attached to a pane's server-side PTY over
/// `/terminal/ws`. Renders ANSI output via xterm and forwards keystrokes.
class TerminalPaneView extends StatefulWidget {
  const TerminalPaneView({
    super.key,
    required this.api,
    required this.paneId,
  });

  final AgentMonitorApi api;
  final String paneId;

  @override
  State<TerminalPaneView> createState() => _TerminalPaneViewState();
}

class _TerminalPaneViewState extends State<TerminalPaneView> {
  late final TerminalSession _session;

  @override
  void initState() {
    super.initState();
    _session = TerminalSession(api: widget.api, paneId: widget.paneId)
      ..addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _session.removeListener(_onChanged);
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AgentPortTheme.terminalBackground,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: TerminalView(
              _session.terminal,
              theme: AgentPortTheme.terminalTheme,
              backgroundOpacity: 1,
              autofocus: true,
              simulateScroll: false,
            ),
          ),
          if (_session.state != TerminalConnectionState.ready) _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    final s = _session.state;
    final msg = switch (s) {
      TerminalConnectionState.connecting => '连接终端…',
      TerminalConnectionState.closed => '终端已断开',
      TerminalConnectionState.error => '连接失败',
      TerminalConnectionState.ready => '',
    };
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (s == TerminalConnectionState.connecting)
              const CircularProgressIndicator()
            else
              const Icon(Icons.error_outline, size: 32),
            const SizedBox(height: 8),
            Text(msg),
          ],
        ),
      ),
    );
  }
}
