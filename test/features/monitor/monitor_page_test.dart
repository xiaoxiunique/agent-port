import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agent_port/data/models/enums.dart';
import 'package:agent_port/data/models/pane.dart';
import 'package:agent_port/data/models/app_settings.dart';
import 'package:agent_port/data/models/pane_ext.dart';
import 'package:agent_port/data/models/snapshot.dart';
import 'package:agent_port/features/monitor/monitor_page.dart';
import 'package:agent_port/services/collapsed_projects_service.dart';
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

/// One project with three agents in it, and a second with one. The shape that
/// made the flat list unreadable: five rows all naming the same project.
Snapshot _snapshot() => Snapshot(
  ok: true,
  now: '2026-06-21T00:00:00.000Z',
  panes: [
    _pane('cx_reverse_bb8c2d50', status: PaneStatus.idle),
    _pane('oc_reverse_bb8c2d50', status: PaneStatus.waiting),
    _pane('cc_reverse_bb8c2d50', status: PaneStatus.idle),
    _pane('p_sitin_914497fb', status: PaneStatus.running),
  ],
);

class _Snap extends SnapshotNotifier {
  @override
  AsyncValue<Snapshot> build() => AsyncValue.data(_snapshot());
}

class _Onboarded extends SettingsNotifier {
  @override
  Future<AppSettings> build() async =>
      const AppSettings(hasCompletedOnboarding: true);
}

class _Collapsed extends CollapsedProjects {
  _Collapsed(this._initial);
  final Set<String> _initial;
  @override
  Future<Set<String>> build() async => _initial;
  @override
  Future<void> toggle(String project) async {
    final next = {...state.value ?? const <String>{}};
    if (!next.remove(project)) next.add(project);
    state = AsyncData(next);
  }
}

Future<void> _pumpHome(WidgetTester tester, {Set<String> folded = const {}}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith(() => _Onboarded()),
        snapshotProvider.overrideWith(() => _Snap()),
        collapsedProjectsProvider.overrideWith(() => _Collapsed({...folded})),
      ],
      child: const MaterialApp(home: MonitorPage()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('home list grouping', () {
    testWidgets('a project is named once, and its agents name themselves', (
      tester,
    ) async {
      await _pumpHome(tester);

      // The heading carries the project — once, however many sessions it holds.
      expect(find.text('reverse'), findsOneWidget);
      expect(find.text('sitin'), findsOneWidget);
      // And each card says which agent it is, which is what tells the three
      // sessions of `reverse` apart. Before grouping they all read "reverse".
      expect(find.text('codex'), findsOneWidget);
      expect(find.text('opencode'), findsOneWidget);
      expect(find.text('claude'), findsOneWidget);
      expect(find.text('pi'), findsOneWidget);
      // The count sits beside the heading.
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('folding a project hides its sessions and keeps the heading', (
      tester,
    ) async {
      await _pumpHome(tester);
      expect(find.text('codex'), findsOneWidget);

      await tester.tap(find.text('reverse'));
      await tester.pumpAndSettle();

      // Gone: the three cards. Still there: the project, and the other group.
      expect(find.text('codex'), findsNothing);
      expect(find.text('opencode'), findsNothing);
      expect(find.text('reverse'), findsOneWidget);
      expect(find.text('pi'), findsOneWidget);

      // And back again.
      await tester.tap(find.text('reverse'));
      await tester.pumpAndSettle();
      expect(find.text('codex'), findsOneWidget);
    });

    testWidgets('a project folded last time comes back folded', (tester) async {
      await _pumpHome(tester, folded: {'reverse'});
      expect(find.text('reverse'), findsOneWidget);
      expect(find.text('codex'), findsNothing);
      expect(find.text('pi'), findsOneWidget, reason: 'only reverse was folded');
    });
  });

  group('most urgent status', () {
    /// Folded, the heading is the only thing left of the project, so it has to
    /// carry the session that is blocked on you — not the first one, and not
    /// the busiest.
    test('a waiting session outranks everything else in its project', () {
      final groups = groupPanesByProject(sortedPanes(_snapshot().panes));
      final reverse = groups.firstWhere((g) => g.project == 'reverse');
      expect(reverse.panes.length, 3);
      expect(reverse.mostUrgent, PaneStatus.waiting);

      // The order amux uses, checked end to end rather than assumed.
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

    test('grouping keeps the order sorting put the panes in', () {
      final groups = groupPanesByProject(sortedPanes(_snapshot().panes));
      expect(groups.map((g) => g.project).toList(), ['reverse', 'sitin']);
      // A project's panes stay together rather than being scattered.
      expect(groups.first.panes.every((p) => p.projectName == 'reverse'), isTrue);
    });
  });

  testWidgets('shows empty state when no panes', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsProvider.overrideWith(() => _Onboarded()),
          snapshotProvider.overrideWith(
            () => _EmptySnapshotNotifier(),
          ),
        ],
        child: const MaterialApp(home: MonitorPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('没有运行中的 rmux 会话'), findsOneWidget);
  });
}

class _EmptySnapshotNotifier extends SnapshotNotifier {
  @override
  AsyncValue<Snapshot> build() =>
      AsyncValue.data(const Snapshot(ok: true, now: ''));
}
