import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/agent_monitor_api.dart';
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
  // Pre-onboarding / dev fallback: local LaunchAgent service on :8797.
  return AgentMonitorApi(baseUrl: 'http://127.0.0.1:8797');
});
