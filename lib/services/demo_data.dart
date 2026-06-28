import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/enums.dart';
import '../data/models/pane.dart';
import '../data/models/project_history.dart';
import '../data/models/running_app.dart';
import '../data/models/snapshot.dart';
import '../data/models/token_usage.dart';
import '../data/models/usage_daily.dart';
import 'settings_service.dart';

/// Sentinel URL for the built-in Demo profile: fully offline sample data, no
/// network. Used so App Store review (and a first launch with no server) shows
/// the app populated and fully browsable.
const demoProfileUrl = 'demo';

/// True when the active profile is the Demo profile.
final demoModeProvider = Provider<bool>((ref) {
  final s = ref.watch(settingsProvider).valueOrNull;
  if (s == null) return false;
  for (final p in s.profiles) {
    if (p.id == s.activeProfileId) return p.url == demoProfileUrl;
  }
  return false;
});

const _claudeLog = '''
● I'll add pull-to-refresh to the session list.

● Update(lib/features/monitor/monitor_page.dart)
  ⎿ Wrapped the list in a RefreshIndicator and made the body always scrollable.

● The home list now supports pull-to-refresh. Want me to also refresh the
  token-usage chip on pull?

> yes, refresh both
''';

const _codexLog = '''
\$ codex
▌ Refactoring the request handlers into a router module…
  • extracted send/key handlers
  • added /api/usage route
  • running cargo check …
    Finished `dev` in 3.2s
▌ Done. 3 files changed, 84 insertions(+).
''';

Pane _pane({
  required String id,
  required String session,
  required String title,
  required String tail,
  required PaneStatus status,
  String reason = '',
  required String time,
}) {
  final parts = session.split('_');
  final project = parts.length >= 3 ? parts[1] : session;
  return Pane(
    id: id,
    target: '$session:1.1',
    session: session,
    windowIndex: '1',
    windowName: 'agent',
    paneIndex: '1',
    command: session.startsWith('cx_') ? 'codex' : 'claude',
    path: '/Users/dev/$project',
    active: true,
    pid: 1000 + id.hashCode.abs() % 9000,
    title: title,
    tail: tail.trim(),
    status: status,
    reason: reason,
    updatedAt: '2026-06-27T$time:00',
  );
}

/// A populated sample snapshot for Demo mode.
Snapshot demoSnapshot() => Snapshot(
      ok: true,
      now: '2026-06-27T07:30:00',
      device: const DeviceInfo(
        kind: 'mac',
        modelName: 'MacBook Pro',
        name: 'Demo Mac',
      ),
      system: const SystemStats(cpuUsage: 23, memoryUsage: 61),
      panes: [
        _pane(
          id: '%101',
          session: 'cc_agent-port_a1b2',
          title: 'Implementing pull-to-refresh',
          tail: _claudeLog,
          status: PaneStatus.waiting,
          reason: 'Waiting for your confirmation',
          time: '07:28',
        ),
        _pane(
          id: '%102',
          session: 'cx_payments-api_c3d4',
          title: 'Refactoring request handlers',
          tail: _codexLog,
          status: PaneStatus.running,
          time: '07:29',
        ),
        _pane(
          id: '%103',
          session: 'cc_blog_e5f6',
          title: 'Wrote 3 draft posts',
          tail: 'Done. Created 3 markdown files under content/posts/.',
          status: PaneStatus.done,
          time: '07:10',
        ),
        _pane(
          id: '%104',
          session: 'cc_scraper_g7h8',
          title: 'Idle — waiting for next task',
          tail: '\$ ',
          status: PaneStatus.idle,
          time: '06:50',
        ),
      ],
    );

/// Sample all-time token usage for Demo mode.
TokenUsage demoUsage() => const TokenUsage(
      ok: true,
      claude: AgentUsage(
        totalTokens: 12400000000,
        inputTokens: 9200000000,
        outputTokens: 410000000,
        cost: 642.50,
      ),
      codex: AgentUsage(
        totalTokens: 7800000000,
        inputTokens: 6100000000,
        outputTokens: 280000000,
        cost: 389.10,
      ),
    );

/// Sample per-day usage for Demo mode (newest-first, last 5 days).
UsageDaily demoUsageDaily() => const UsageDaily(
      ok: true,
      claude: AgentUsage(
        totalTokens: 12400000000,
        inputTokens: 9200000000,
        outputTokens: 410000000,
        cost: 642.50,
      ),
      codex: AgentUsage(
        totalTokens: 7800000000,
        inputTokens: 6100000000,
        outputTokens: 280000000,
        cost: 389.10,
      ),
      days: [
        DayUsage(
          date: '2026-06-28',
          claudeTokens: 84000000,
          claudeCost: 12.40,
          codexTokens: 31000000,
          codexCost: 4.10,
        ),
        DayUsage(
          date: '2026-06-27',
          claudeTokens: 312000000,
          claudeCost: 41.80,
          codexTokens: 96000000,
          codexCost: 11.20,
        ),
        DayUsage(
          date: '2026-06-26',
          claudeTokens: 268000000,
          claudeCost: 35.60,
          codexTokens: 74000000,
          codexCost: 9.05,
        ),
        DayUsage(
          date: '2026-06-25',
          claudeTokens: 190000000,
          claudeCost: 24.30,
          codexTokens: 52000000,
          codexCost: 6.40,
        ),
        DayUsage(
          date: '2026-06-24',
          claudeTokens: 145000000,
          claudeCost: 18.10,
          codexTokens: 40000000,
          codexCost: 4.90,
        ),
      ],
    );

/// Sample running apps for Demo mode (机器监控 / 电脑 tab).
List<RunningApp> demoApps() => const [
      RunningApp(
        name: 'Xcode',
        path: '/Applications/Xcode.app',
        pid: 501,
        memoryBytes: 2147483648,
        cpuPercent: 12.4,
      ),
      RunningApp(
        name: 'Simulator',
        path: '/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app',
        pid: 502,
        memoryBytes: 805306368,
        cpuPercent: 4.1,
      ),
      RunningApp(
        name: 'Google Chrome',
        path: '/Applications/Google Chrome.app',
        pid: 503,
        memoryBytes: 1610612736,
        cpuPercent: 8.0,
      ),
      RunningApp(
        name: 'Ghostty',
        path: '/Applications/Ghostty.app',
        pid: 504,
        memoryBytes: 268435456,
        cpuPercent: 2.2,
      ),
    ];

/// Sample recent projects for Demo mode (项目历史 / 添加项目 picker).
List<ProjectHistoryEntry> demoProjects() => const [
      ProjectHistoryEntry(
        path: '/Users/dev/projects/agent-port',
        name: 'agent-port',
        lastAgent: 'claude',
        lastSeenAt: '2026-06-27T07:28:00',
        launchCount: 12,
      ),
      ProjectHistoryEntry(
        path: '/Users/dev/projects/payments-api',
        name: 'payments-api',
        lastAgent: 'codex',
        lastSeenAt: '2026-06-27T07:29:00',
        launchCount: 5,
      ),
      ProjectHistoryEntry(
        path: '/Users/dev/projects/blog',
        name: 'blog',
        lastAgent: 'claude',
        lastSeenAt: '2026-06-27T07:10:00',
        launchCount: 3,
      ),
      ProjectHistoryEntry(
        path: '/Users/dev/sites/scraper',
        name: 'scraper',
        lastAgent: 'claude',
        lastSeenAt: '2026-06-26T22:50:00',
        launchCount: 2,
      ),
    ];
