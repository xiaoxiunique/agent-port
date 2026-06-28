import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/agent_monitor_api.dart';
import '../data/models/pending.dart';
import '../data/models/token_usage.dart';
import '../data/models/usage_daily.dart';
import 'demo_data.dart';
import 'settings_service.dart';

/// The [AgentMonitorApi] for the active server profile. Watches settings, so
/// switching profiles rebuilds this provider — and anything that watches it
/// (e.g. the snapshot stream) reconnects to the new server.
final apiProvider = Provider<AgentMonitorApi>((ref) {
  final settings = ref.watch(settingsProvider).valueOrNull;
  if (settings != null && settings.activeProfileId.isNotEmpty) {
    for (final p in settings.profiles) {
      if (p.id == settings.activeProfileId) {
        // The Demo profile's sentinel url ('demo') is not a valid URL; hand the
        // client a harmless absolute placeholder so eager URL parsing (e.g.
        // Image.network for app icons) doesn't throw. Demo code paths return
        // offline sample data and never actually hit the network.
        final url = p.url == demoProfileUrl ? 'http://demo.invalid' : p.url;
        return AgentMonitorApi(baseUrl: url, token: p.token);
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
  if (ref.watch(demoModeProvider)) return demoUsage();
  return ref.watch(apiProvider).usage();
});

/// Per-day Claude + Codex spend (server-side ccusage daily, cached ~5 min).
final usageDailyProvider = FutureProvider.autoDispose<UsageDaily>((ref) async {
  if (ref.watch(demoModeProvider)) return demoUsageDaily();
  return ref.watch(apiProvider).usageDaily();
});

/// Pending-message queue for a pane (Claude Code only). Empty in Demo mode.
/// Invalidate after sending/editing, or on each snapshot tick, to keep it live.
final pendingProvider =
    FutureProvider.autoDispose.family<PendingList, String>((ref, paneId) async {
  if (ref.watch(demoModeProvider)) return PendingList.empty(paneId);
  return ref.watch(apiProvider).pendingList(paneId);
});
