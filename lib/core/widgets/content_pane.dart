import 'package:flutter/material.dart';

/// Caps a page's content width and centres it.
///
/// Every list in this app was written for a ~390pt column. Left alone on a 13"
/// iPad they stretch edge to edge: a settings row becomes a label on the far
/// left and a chevron 1000pt away, and a pane card becomes a very long, very
/// thin band. Clamping keeps the reading measure a person can actually scan.
///
/// Applied per page rather than in `MaterialApp.builder`, because the things
/// that genuinely want the whole width — the xterm terminal and the DeepSeek
/// webview — would be ruined by a global clamp.
class ContentPane extends StatelessWidget {
  const ContentPane({super.key, required this.child, this.maxWidth = 720});

  final Widget child;

  /// Roughly a comfortable reading column. Wider than this and rows start to
  /// read as two disconnected halves.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    // Centred with padding rather than Align/Center on purpose: those hand the
    // child *loose* constraints, and a full-height ListView underneath needs
    // the tight height it was given. Padding passes the height straight
    // through and only narrows the width.
    return LayoutBuilder(
      builder: (context, constraints) {
        final slack = constraints.maxWidth - maxWidth;
        if (!slack.isFinite || slack <= 0) return child;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: slack / 2),
          child: child,
        );
      },
    );
  }
}
