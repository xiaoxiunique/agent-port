import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/models/pane_ext.dart';

/// Brand avatar for an agent session, keyed off the amux session prefix:
/// `cc` Claude, `cx` Codex, `oc` opencode, `p` pi, and a terminal glyph for
/// anything amux does not name. Mirrors the native `AgentAvatar`
/// (MonitorView.swift:1183-1223).
///
/// Claude and Codex ship as bare glyphs and sit on a tile in the app's own
/// surface colour, so they follow light and dark. opencode and pi ship as
/// finished icons — background, corners and all — and are drawn full bleed,
/// because putting a brand's own tile inside another tile reads as a mistake.
class AgentAvatar extends StatelessWidget {
  const AgentAvatar({super.key, required this.session, this.size = 48});

  final String session;
  final double size;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final radius = BorderRadius.circular(size * 0.16);

    final child = switch (sessionAgentAlias(session)) {
      'cc' => _glyph(brightness, 'assets/claude-avatar.png', 0.1),
      'cx' => _glyph(brightness, 'assets/codex-avatar.png', 0.06),
      'oc' => Image.asset('assets/opencode-avatar.png', fit: BoxFit.cover),
      'p' => Image.asset('assets/pi-avatar.png', fit: BoxFit.cover),
      _ => Container(
        color: Colors.grey,
        alignment: Alignment.center,
        child: Icon(Icons.terminal, size: size * 0.4, color: Colors.white),
      ),
    };

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(width: size, height: size, child: child),
    );
  }

  Widget _glyph(Brightness brightness, String asset, double inset) => Container(
    color: AgentPortTheme.elevatedSurface(brightness),
    padding: EdgeInsets.all(size * inset),
    child: Image.asset(asset, fit: BoxFit.contain),
  );
}
