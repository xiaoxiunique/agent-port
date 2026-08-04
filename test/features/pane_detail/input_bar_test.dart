import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:agent_port/data/api/agent_monitor_api.dart';
import 'package:agent_port/data/models/enums.dart';
import 'package:agent_port/data/models/pane.dart';
import 'package:agent_port/features/pane_detail/input_bar.dart';
import 'package:agent_port/services/api_provider.dart';
import 'package:agent_port/services/demo_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _CaptureAdapter implements HttpClientAdapter {
  _CaptureAdapter({this.ccSwitchBody});

  final requests = <RequestOptions>[];
  final Map<String, Object?>? ccSwitchBody;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final body = switch (options.path) {
      '/api/send' => {'ok': true, 'queued': false, 'pendingCount': 0},
      '/api/cc-switch' => ccSwitchBody ?? {'ok': true, 'apps': <Object>[]},
      '/api/cc-switch/switch' =>
        ccSwitchBody ?? {'ok': true, 'apps': <Object>[]},
      _ => {'ok': true},
    };
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Pane _pane() => const Pane(
  id: '%1',
  target: 's:0.0',
  session: 'cx-openai_project_abc123',
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
  updatedAt: '2026-07-20T00:00:00.000Z',
);

void main() {
  testWidgets('Resume button sends /resume', (tester) async {
    final adapter = _CaptureAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final api = AgentMonitorApi(baseUrl: 'http://example.test', dio: dio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          demoModeProvider.overrideWith((ref) => false),
          apiProvider.overrideWith((ref) => api),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: InputBar(
              pane: _pane(),
              mode: RuntimeMode.log,
              onToggleMode: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Resume'));
    await tester.pumpAndSettle();

    final send = adapter.requests.singleWhere((r) => r.path == '/api/send');
    expect(send.data, containsPair('paneId', '%1'));
    expect(send.data, containsPair('text', '/resume'));
    expect(send.data, containsPair('submitKey', 'Enter'));
  });

  testWidgets('provider selector opens bottom sheet and switches provider', (
    tester,
  ) async {
    final adapter = _CaptureAdapter(
      ccSwitchBody: {
        'ok': true,
        'apps': [
          {
            'appType': 'codex',
            'title': 'Codex',
            'activeProviderId': 'openai',
            'providers': [
              {
                'id': 'openai',
                'appType': 'codex',
                'name': 'OpenAI',
                'isCurrent': true,
                'hasApiKey': true,
              },
              {
                'id': 'glm',
                'appType': 'codex',
                'name': 'GLM',
                'isCurrent': false,
                'hasApiKey': true,
              },
            ],
          },
        ],
      },
    );
    final dio = Dio()..httpClientAdapter = adapter;
    final api = AgentMonitorApi(baseUrl: 'http://example.test', dio: dio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          demoModeProvider.overrideWith((ref) => false),
          apiProvider.overrideWith((ref) => api),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: InputBar(
              pane: _pane(),
              mode: RuntimeMode.log,
              onToggleMode: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('OpenAI'));
    await tester.pumpAndSettle();
    expect(find.text('切换 Provider'), findsOneWidget);

    await tester.tap(find.text('GLM'));
    await tester.pumpAndSettle();

    final switchRequest = adapter.requests.singleWhere(
      (r) => r.path == '/api/cc-switch/switch',
    );
    expect(switchRequest.data, containsPair('appType', 'codex'));
    expect(switchRequest.data, containsPair('providerId', 'glm'));
  });
}
