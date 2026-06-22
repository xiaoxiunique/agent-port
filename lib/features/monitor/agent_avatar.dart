import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// Brand avatar for an agent session, keyed off the tmux session prefix
/// (`cc_` → Claude, `cx_` → Codex, else a generic terminal glyph). Mirrors the
/// native `AgentAvatar` (MonitorView.swift:1183-1223).
class AgentAvatar extends StatelessWidget {
  const AgentAvatar({super.key, required this.session, this.size = 48});

  final String session;
  final double size;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final radius = BorderRadius.circular(size * 0.16);

    Widget child;
    if (session.startsWith('cc_')) {
      child = Container(
        color: AgentPortTheme.elevatedSurface(brightness),
        padding: EdgeInsets.all(size * 0.1),
        child: Image.asset('assets/claude-avatar.png', fit: BoxFit.contain),
      );
    } else if (session.startsWith('cx_')) {
      child = Container(
        color: AgentPortTheme.elevatedSurface(brightness),
        padding: EdgeInsets.all(size * 0.06),
        child: Image.asset('assets/codex-avatar.png', fit: BoxFit.contain),
      );
    } else {
      child = Container(
        color: Colors.grey,
        alignment: Alignment.center,
        child: Icon(Icons.terminal, size: size * 0.4, color: Colors.white),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(width: size, height: size, child: child),
    );
  }
}
