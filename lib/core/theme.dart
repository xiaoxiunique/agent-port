import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

import '../data/models/enums.dart';

/// App-wide theme. Mirrors the native `AgentMonitorTheme` (SwiftUI): the list
/// and settings surfaces follow the system light/dark setting, while the
/// terminal is always dark. Color values are taken verbatim from
/// `AgentMonitorTheme.swift`.
class AgentPortTheme {
  // --- Raw palette (AgentMonitorTheme.swift:4-10) ---
  static const _darkPrimary = Color(0xFF0D0D0F); // page background
  static const _darkSecondary = Color(0xFF1C1C1F); // surface / card
  static const _darkTertiary = Color(0xFF2B2B2E); // elevated surface
  static const _lightPrimary = Color(0xFFFFFFFF); // surface / card
  static const _lightTertiary = Color(0xFFF2F2F7); // elevated surface

  // iOS system accent (systemBlue), light/dark variants.
  static const _accentLight = Color(0xFF007AFF);
  static const _accentDark = Color(0xFF0A84FF);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: isDark ? _accentDark : _accentLight,
      brightness: brightness,
    ).copyWith(
      surface: isDark ? _darkSecondary : _lightPrimary,
      surfaceContainerHighest: isDark ? _darkTertiary : _lightTertiary,
    );
    // Grouped grey page background so white cards/rows pop and every tab shares
    // the same backdrop behind the floating (glass) tab bar. Slightly deeper
    // than systemGroupedBackground so the white cards read as clearly lifted.
    final pageBg = isDark ? _darkPrimary : const Color(0xFFE8E8EE);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: pageBg,
      visualDensity: VisualDensity.standard,
      dividerColor: separator(brightness),
      appBarTheme: AppBarTheme(
        backgroundColor: pageBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      cardTheme: CardThemeData(
        color: isDark ? _darkSecondary : _lightPrimary,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
    );
  }

  /// Card / list-row surface (AgentMonitorTheme.surface).
  static Color surface(Brightness b) =>
      b == Brightness.dark ? _darkSecondary : _lightPrimary;

  /// Elevated surface behind avatars etc. (AgentMonitorTheme.elevatedSurface).
  static Color elevatedSurface(Brightness b) =>
      b == Brightness.dark ? _darkTertiary : _lightPrimary;

  /// Hairline separator / card stroke (AgentMonitorTheme.separator).
  static Color separator(Brightness b) => b == Brightness.dark
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.black.withValues(alpha: 0.06);

  /// Subtle fill for chips/pills (AgentMonitorTheme.softFill).
  static Color softFill(Brightness b) => b == Brightness.dark
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.black.withValues(alpha: 0.055);

  /// Card drop shadow — matches the settings `_Grouped` look (subtle in light,
  /// none in dark where a hairline border defines the card instead).
  static Color cardShadow(Brightness b) => b == Brightness.dark
      ? Colors.black.withValues(alpha: 0.0)
      : Colors.black.withValues(alpha: 0.05);

  /// Terminal palette — always dark, regardless of system theme.
  ///
  /// Mirrors the user's Ghostty setup: the "Matrix" theme with `foreground`
  /// overridden to #00ff41. Matrix's own foreground (#426644) is dim enough to
  /// read as disabled text, so it serves as the secondary tone here instead.
  static const terminalBackground = Color(0xFF0F191C);
  static const terminalForeground = Color(0xFF00FF41);
  static const terminalCursor = Color(0xFF00FF41);

  /// Muted green for metadata and hints. Matrix's own foreground (#426644) is
  /// what Ghostty would use, but at 2.7:1 on this background it fails WCAG AA
  /// for body text — unreadable on a phone. Palette entry 15 is the next green
  /// up and clears AA at 4.7:1.
  static const terminalDim = Color(0xFF678C61);

  /// One step up from the background, for cards and bars on a terminal-themed
  /// page. Taken from Matrix's selection background.
  static const terminalSurface = Color(0xFF18282E);

  /// Dark theme for the pane detail page, so the log view, terminal and input
  /// bar share the terminal's colors instead of the app's neutral grey.
  static ThemeData get terminal => _buildTerminal();

  static ThemeData _buildTerminal() {
    final base = _build(Brightness.dark);
    final scheme = base.colorScheme.copyWith(
      primary: terminalForeground,
      onPrimary: terminalBackground,
      surface: terminalSurface,
      onSurface: terminalForeground,
      surfaceContainerHighest: terminalSurface,
      // Secondary text (status reasons, hints) — anything reading a "muted"
      // role lands on the dim green rather than Material's default grey.
      onSurfaceVariant: terminalDim,
      outline: terminalDim,
      outlineVariant: terminalDim.withValues(alpha: 0.4),
      secondary: terminalDim,
      onSecondary: terminalBackground,
    );
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: terminalBackground,
      canvasColor: terminalBackground,
      dividerColor: terminalDim.withValues(alpha: 0.35),
      hintColor: terminalDim,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: terminalBackground,
        foregroundColor: terminalForeground,
      ),
      // The log view renders plain Text with no explicit color, so the body
      // styles are what actually tint it.
      textTheme: base.textTheme.apply(
        bodyColor: terminalForeground,
        displayColor: terminalForeground,
      ),
      iconTheme: const IconThemeData(color: terminalForeground),
    );
  }

  /// xterm theme — the Ghostty "Matrix" palette.
  static const terminalTheme = TerminalTheme(
    cursor: terminalCursor,
    selection: Color(0x5500FF87),
    foreground: terminalForeground,
    background: terminalBackground,
    black: Color(0xFF0F191C),
    red: Color(0xFF23755A),
    green: Color(0xFF82D967),
    yellow: Color(0xFFFFD700),
    blue: Color(0xFF3F5242),
    magenta: Color(0xFF409931),
    cyan: Color(0xFF50B45A),
    white: Color(0xFF507350),
    brightBlack: Color(0xFF688060),
    brightRed: Color(0xFF2FC079),
    brightGreen: Color(0xFF90D762),
    brightYellow: Color(0xFFFAFF00),
    brightBlue: Color(0xFF4F7E7E),
    brightMagenta: Color(0xFF11FF25),
    brightCyan: Color(0xFFC1FF8A),
    brightWhite: Color(0xFF678C61),
    // Search hits keep high-contrast colors — the Matrix greens are too close
    // to each other to mark a hit legibly.
    searchHitBackground: Color(0xFFFFFF2B),
    searchHitBackgroundCurrent: Color(0xFF31FF26),
    searchHitForeground: Color(0xFF000000),
  );
}

/// Canonical pane-status color map. Mirrors native `statusColor(_:)`
/// (MonitorView.swift:1225-1233). Light/dark variants use the iOS system
/// colors so the dots read correctly on both backgrounds.
Color statusColor(PaneStatus status, Brightness b) {
  final dark = b == Brightness.dark;
  switch (status) {
    case PaneStatus.running:
      return dark ? const Color(0xFF30D158) : const Color(0xFF34C759);
    case PaneStatus.waiting:
      return dark ? const Color(0xFFFFD60A) : const Color(0xFFFFCC00);
    case PaneStatus.idle:
      return const Color(0xFF8E8E93);
    case PaneStatus.failed:
      return dark ? const Color(0xFFFF453A) : const Color(0xFFFF3B30);
    case PaneStatus.done:
      return dark ? const Color(0xFF0A84FF) : const Color(0xFF007AFF);
  }
}
