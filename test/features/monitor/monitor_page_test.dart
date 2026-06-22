import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agent_port/data/models/enums.dart';
import 'package:agent_port/data/models/pane.dart';
import 'package:agent_port/data/models/app_settings.dart';
import 'package:agent_port/data/models/snapshot.dart';
import 'package:agent_port/features/monitor/monitor_page.dart';
import 'package:agent_port/services/settings_service.dart';
import 'package:agent_port/services/snapshot_service.dart';

Snapshot _fakeSnapshot() => Snapshot(
      ok: true,
      now: '2026-06-21T00:00:00.000Z',
      panes: [
        Pane(
          id: 'p1',
          target: 's:0.0',
          session: 'cc-myproject_abc123',
          windowIndex: '0',
          windowName: 'work',
          paneIndex: '0',
          command: 'claude',
          path: '/home/me/myproject',
          active: true,
          title: '',
          tail: 'line one\nline two',
          status: PaneStatus.waiting,
          reason: '',
          updatedAt: '2026-06-21T00:00:00.000Z',
        ),
        Pane(
          id: 'p2',
          target: 's:1.0',
          session: 'cx_other_def',
          windowIndex: '0',
          windowName: '',
          paneIndex: '0',
          command: '',
          path: '',
          active: false,
          title: '',
          tail: '',
          status: PaneStatus.running,
          reason: '',
          updatedAt: '2026-06-21T00:00:00.000Z',
        ),
      ],
      system: const SystemStats(cpuUsage: 42, memoryUsage: 60),
    );

class _FakeSnapshotNotifier extends SnapshotNotifier {
  @override
  AsyncValue<Snapshot> build() => AsyncValue.data(_fakeSnapshot());
}

class _EmptySnapshotNotifier extends SnapshotNotifier {
  @override
  AsyncValue<Snapshot> build() =>
      AsyncValue.data(const Snapshot(ok: true, now: ''));
}

class _OnboardedSettingsNotifier extends SettingsNotifier {
  @override
  Future<AppSettings> build() async =>
      const AppSettings(hasCompletedOnboarding: true);
}

void main() {
  testWidgets('renders pane list with status chips and metrics',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsProvider.overrideWith(() => _OnboardedSettingsNotifier()),
          snapshotProvider.overrideWith(() => _FakeSnapshotNotifier()),
        ],
        child: const MaterialApp(home: MonitorPage()),
      ),
    );
    await tester.pumpAndSettle();

    // two status chips
    expect(find.text('waiting'), findsOneWidget);
    expect(find.text('running'), findsOneWidget);
    // command title from p1 (command non-empty)
    expect(find.text('claude'), findsWidgets);
    // system metrics
    expect(find.text('CPU'), findsOneWidget);
    expect(find.text('42%'), findsOneWidget);
    expect(find.text('MEM'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    // last-line preview from p1 tail
    expect(find.text('line two'), findsOneWidget);
  });

  testWidgets('shows empty state when no panes', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsProvider.overrideWith(() => _OnboardedSettingsNotifier()),
          snapshotProvider.overrideWith(() => _EmptySnapshotNotifier()),
        ],
        child: const MaterialApp(home: MonitorPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('没有运行中的 tmux 会话'), findsOneWidget);
  });
}
