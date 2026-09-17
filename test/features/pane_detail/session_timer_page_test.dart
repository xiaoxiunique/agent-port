import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_port/data/api/agent_monitor_api.dart';
import 'package:agent_port/data/models/enums.dart';
import 'package:agent_port/data/models/pane.dart';
import 'package:agent_port/data/models/session_timer.dart';
import 'package:agent_port/features/pane_detail/session_timer_page.dart';
import 'package:agent_port/services/api_provider.dart';
import 'package:agent_port/services/demo_data.dart';
import 'package:agent_port/services/snapshot_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _CaptureAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode({'ok': true}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const _session = 'cx_project_abc12345';

Pane _pane() => const Pane(
  id: '%1',
  target: 's:0.0',
  session: _session,
  windowIndex: '0',
  windowName: 'work',
  paneIndex: '0',
  command: 'codex',
  path: '/tmp/project',
  active: true,
  title: '',
  tail: '',
  status: PaneStatus.idle,
  reason: '',
  updatedAt: '2026-09-17T00:00:00.000Z',
);

Future<_CaptureAdapter> _open(
  WidgetTester tester, {
  Map<String, SessionTimer> timers = const {},
}) async {
  final adapter = _CaptureAdapter();
  final dio = Dio()..httpClientAdapter = adapter;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        demoModeProvider.overrideWith((ref) => false),
        apiProvider.overrideWith(
          (ref) => AgentMonitorApi(baseUrl: 'http://example.test', dio: dio),
        ),
        sessionTimersProvider.overrideWith((ref) => timers),
      ],
      child: MaterialApp(home: SessionTimerPage(pane: _pane())),
    ),
  );
  await tester.pumpAndSettle();
  return adapter;
}

void main() {
  testWidgets('arming needs a prompt', (tester) async {
    final adapter = await _open(tester);

    // The interval is pre-filled, the prompt is not.
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text('定时任务需要一条 prompt'), findsOneWidget);
    expect(
      adapter.requests.where((r) => r.path == '/api/timer/enable'),
      isEmpty,
      reason: 'nothing may reach the server on a refusal',
    );
  });

  testWidgets('arming needs an interval it can read', (tester) async {
    final adapter = await _open(tester);

    await tester.enterText(find.byType(TextField).last, 'look at CI');
    // What you get by tapping into the pre-filled field and typing.
    await tester.enterText(find.byType(TextField).first, '30m2m');
    await tester.pumpAndSettle();

    // Said before it is armed, not after.
    expect(find.text('读不懂这个写法'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text('这个间隔读不懂'), findsOneWidget);
    expect(adapter.requests.where((r) => r.path == '/api/timer/enable'), isEmpty);
  });

  testWidgets('a good schedule is sent in seconds', (tester) async {
    final adapter = await _open(tester);

    await tester.enterText(find.byType(TextField).first, '15m');
    await tester.enterText(find.byType(TextField).last, 'look at CI');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    final req = adapter.requests.singleWhere(
      (r) => r.path == '/api/timer/enable',
    );
    expect(req.data, containsPair('session', _session));
    expect(req.data, containsPair('prompt', 'look at CI'));
    expect(req.data, containsPair('everySecs', 900));
    expect(req.data, containsPair('enabled', true));
  });

  testWidgets('an armed session seeds the form and can be switched off', (
    tester,
  ) async {
    final adapter = await _open(
      tester,
      timers: {
        _session: const SessionTimer(
          session: _session,
          prompt: 'look at CI',
          everySecs: 7200,
          enabled: true,
        ),
      },
    );

    // Editing starts from the current schedule, not a blank.
    expect(find.text('2h'), findsOneWidget);
    expect(find.text('look at CI'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    final req = adapter.requests.singleWhere(
      (r) => r.path == '/api/timer/enable',
    );
    expect(req.data, containsPair('enabled', false));
    expect(
      (req.data as Map).containsKey('prompt'),
      isFalse,
      reason: 'turning it off must not rewrite what it would have sent',
    );
  });
}
