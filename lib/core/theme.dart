import 'package:flutter/material.dart';

/// App-wide theme. Agent Port is dark-first (matches the native macOS/iOS apps).
class AgentPortTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF4F7CFF),
        visualDensity: VisualDensity.standard,
      );
}
