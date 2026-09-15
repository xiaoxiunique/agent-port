import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_router/go_router.dart';
import 'package:agent_port/data/models/enums.dart';
import 'package:agent_port/data/models/pane.dart';
import 'package:agent_port/data/models/app_settings.dart';
import 'package:agent_port/data/models/pane_ext.dart';
import 'package:agent_port/data/models/snapshot.dart';
import 'package:agent_port/features/monitor/monitor_page.dart';
import 'package:agent_port/features/monitor/project_sessions_page.dart';
import 'package:agent_port/services/settings_service.dart';
import 'package:agent_port/services/snapshot_service.dart';

Pane _pane(String session, {PaneStatus status = PaneStatus.idle}) => Pane(
  id: session,
  target: 's:0.0',
  session: session,
  windowIndex: '0',
  windowName: '',
  paneIndex: '0',
  command: '',
  path: '',
  active: false,
  title: '',
  tail: '',
  status: status,
  reason: '',
  updatedAt: '2026-06-21T00:00:00.000Z',
);

/// One project with three agents in it, and one with a single agent. The shape
/// the home list has to reduce: five rows that all said "reverse".
Snapshot _snapshot() => Snapshot(
  ok: true,
  now: '2026-06-21T00:00:00.000Z',
  panes: [
    _pane('cx_reverse_bb8c2d50'),
    _pane('oc_reverse_bb8c2d50', status: PaneStatus.waiting),
    _pane('cc_reverse_bb8c2d50'),
    _pane('p_sitin_914497fb', status: PaneStatus.running),
  ],
);

class _Snap extends SnapshotNotifier {
  @override
  AsyncValue<Snapshot> build() => AsyncValue.data(_snapshot());
}

class _Empty extends SnapshotNotifier {
  @override
  AsyncValue<Snapshot> build() =>
      AsyncValue.data(const Snapshot(ok: true, now: ''));
}

class _Onboarded extends SettingsNotifier {
  @override
  Future<AppSettings> build() async =>
      const AppSettings(hasCompletedOnboarding: true);
}

/// The home list under a router, so a tap actually navigates.
///
/// `/` is the monitor page rather than the app's own root, which branches on
/// the platform — on a test host that is macOS, and macOS gets the server
/// window. The destinations are the real ones; the pane page is stubbed
/// because what it renders needs a live server, and what is under test here is
/// where a tap goes.
Future<void> _pumpApp(WidgetTester tester, {bool empty = false}) async {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const MonitorPage()),
      GoRoute(
        path: '/project/:project',
        builder: (_, state) =>
            ProjectSessionsPage(project: state.pathParameters['project']!),
      ),
      GoRoute(
        path: '/pane/:paneId',
        builder: (_, state) => Scaffold(
          body: Text('pane:${state.pathParameters['paneId']}'),
        ),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith(() => _Onboarded()),
        if (empty)
          snapshotProvider.overrideWith(() => _Empty())
        else
          snapshotProvider.overrideWith(() => _Snap()),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('home list', () {
    testWidgets('one row per project, not one per session', (tester) async {
      await _pumpApp(tester);

      // Two projects, four sessions: two rows.
      expect(find.text('reverse'), findsOneWidget);
      expect(find.text('sitin'), findsOneWidget);
      // The three sessions of `reverse` are not rows of their own.
      expect(find.text('codex'), findsNothing);
      expect(find.text('opencode'), findsNothing);
      // The row says how many are in there instead.
      expect(find.text('3 个会话'), findsOneWidget);
      // A lone session names itself, since the row stands in for it.
      expect(find.text('pi'), findsOneWidget);
    });

    testWidgets('a project with several sessions opens a list of them', (
      tester,
    ) async {
      await _pumpApp(tester);
      await tester.tap(find.text('reverse'));
      await tester.pumpAndSettle();

      // Second level: the sessions, each naming its agent.
      expect(find.text('codex'), findsOneWidget);
      expect(find.text('opencode'), findsOneWidget);
      expect(find.text('claude'), findsOneWidget);
      // And not the other project's.
      expect(find.text('pi'), findsNothing);
    });

    testWidgets('a project with one session opens it directly', (tester) async {
      await _pumpApp(tester);
      await tester.tap(find.text('sitin'));
      await tester.pumpAndSettle();

      // Straight to the pane, with no list of one in between: the session's
      // own page is titled with its id, and there is no project list showing.
      expect(find.textContaining('pane:'), findsOneWidget);
      expect(find.text('3 个会话'), findsNothing);
    });

    testWidgets('shows empty state when no panes', (tester) async {
      await _pumpApp(tester, empty: true);
      expect(find.text('没有运行中的 rmux 会话'), findsOneWidget);
    });
  });

  group('what a project row has to say', () {
    /// The row stands in for everything inside it, so the one session that is
    /// blocked on you has to reach the surface — not the first, not the busiest.
    test('a waiting session sets the project dot', () {
      final groups = groupPanesByProject(sortedPanes(_snapshot().panes));
      final reverse = groups.firstWhere((g) => g.project == 'reverse');
      expect(reverse.panes.length, 3);
      expect(reverse.mostUrgent, PaneStatus.waiting);

      ProjectGroup of(List<PaneStatus> s) =>
          ProjectGroup('x', [for (final e in s) _pane('cc_x_1', status: e)]);
      expect(of([PaneStatus.idle, PaneStatus.done]).mostUrgent, PaneStatus.done);
      expect(
        of([PaneStatus.done, PaneStatus.failed]).mostUrgent,
        PaneStatus.failed,
      );
      expect(
        of([PaneStatus.failed, PaneStatus.running]).mostUrgent,
        PaneStatus.running,
      );
      expect(
        of([PaneStatus.running, PaneStatus.waiting]).mostUrgent,
        PaneStatus.waiting,
      );
    });

    test('grouping keeps a project together and in sorted order', () {
      final groups = groupPanesByProject(sortedPanes(_snapshot().panes));
      expect(groups.map((g) => g.project).toList(), ['reverse', 'sitin']);
      expect(
        groups.first.panes.every((p) => p.projectName == 'reverse'),
        isTrue,
      );
    });
  });
}
