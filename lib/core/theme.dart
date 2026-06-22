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
  static const _lightSecondary = Color(0xFFFAFAFC); // page background
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
    final pageBg = isDark ? _darkPrimary : _lightSecondary;
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

  /// Card drop shadow (AgentMonitorTheme.cardShadow).
  static Color cardShadow(Brightness b) => b == Brightness.dark
      ? Colors.black.withValues(alpha: 0.18)
      : Colors.black.withValues(alpha: 0.045);

  /// Terminal palette — always dark, regardless of system theme
  /// (TerminalPaneView.swift:66-69).
  static const terminalBackground = Color(0xFF050605);
  static const terminalForeground = Color(0xFFDBE6D1);
  static const terminalCursor = Color(0xFF9DE07B);

  /// xterm theme matching the native SwiftTerm colors.
  static const terminalTheme = TerminalTheme(
    cursor: terminalCursor,
    selection: Color(0x559DE07B),
    foreground: terminalForeground,
    background: terminalBackground,
    black: Color(0xFF000000),
    red: Color(0xFFCD3131),
    green: Color(0xFF0DBC79),
    yellow: Color(0xFFE5E510),
    blue: Color(0xFF2472C8),
    magenta: Color(0xFFBC3FBC),
    cyan: Color(0xFF11A8CD),
    white: Color(0xFFE5E5E5),
    brightBlack: Color(0xFF666666),
    brightRed: Color(0xFFF14C4C),
    brightGreen: Color(0xFF23D18B),
    brightYellow: Color(0xFFF5F543),
    brightBlue: Color(0xFF3B8EEA),
    brightMagenta: Color(0xFFD670D6),
    brightCyan: Color(0xFF29B8DB),
    brightWhite: Color(0xFFFFFFFF),
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
