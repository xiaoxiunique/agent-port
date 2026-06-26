import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/agent_monitor_api.dart';
import '../data/models/token_usage.dart';
import 'settings_service.dart';

/// The [AgentMonitorApi] for the active server profile. Watches settings, so
/// switching profiles rebuilds this provider — and anything that watches it
/// (e.g. the snapshot stream) reconnects to the new server.
final apiProvider = Provider<AgentMonitorApi>((ref) {
  final settings = ref.watch(settingsProvider).valueOrNull;
  if (settings != null && settings.activeProfileId.isNotEmpty) {
    for (final p in settings.profiles) {
      if (p.id == settings.activeProfileId) {
        return AgentMonitorApi(baseUrl: p.url, token: p.token);
      }
    }
  }
  // Pre-onboarding / dev fallback. On web the client is served by the host
  // itself, so default to the page origin (same-origin, no CORS); on native,
  // the local service on :8797.
  return AgentMonitorApi(
    baseUrl: kIsWeb ? Uri.base.origin : 'http://127.0.0.1:8797',
  );
});

/// Total Claude Code + Codex token usage (server-side ccusage, cached ~5 min).
/// Refetched when the active profile changes.
final usageProvider = FutureProvider.autoDispose<TokenUsage>((ref) async {
  return ref.watch(apiProvider).usage();
});
