import 'package:agent_port/data/models/enums.dart';
import 'package:agent_port/data/models/pane.dart';
import 'package:agent_port/data/models/pane_ext.dart';
import 'package:agent_port/features/monitor/agent_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Pane _pane(String session, {String command = 'x'}) => Pane(
  id: '%1',
  target: 't',
  session: session,
  windowIndex: '0',
  windowName: 'w',
  paneIndex: '0',
  command: command,
  path: '/tmp',
  active: true,
  title: 'x',
  tail: '',
  status: PaneStatus.idle,
  reason: '',
  updatedAt: '2026-08-25T00:00:00Z',
);

/// The asset an avatar draws, or null when it fell back to the terminal glyph.
Future<String?> _assetFor(WidgetTester tester, String session) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: AgentAvatar(session: session))),
  );
  final images = tester.widgetList<Image>(find.byType(Image));
  if (images.isEmpty) return null;
  return (images.first.image as AssetImage).assetName;
}

void main() {
  group('agent avatar', () {
    testWidgets('every agent amux can start has its own logo', (tester) async {
      expect(await _assetFor(tester, 'cc_amux_4d8e0883'), contains('claude'));
      expect(await _assetFor(tester, 'cx_reverse_bb8c2d50'), contains('codex'));
      // The two that used to land on the grey terminal icon.
      expect(await _assetFor(tester, 'oc_reverse_bb8c2d50'), contains('opencode'));
      expect(await _assetFor(tester, 'p_sitin_914497fb'), contains('pi-avatar'));
    });

    testWidgets('a provider suffix does not hide the agent', (tester) async {
      // `cc-glm_…` is still Claude; the provider hangs off the prefix.
      expect(await _assetFor(tester, 'cc-glm_amux_4d8e0883'), contains('claude'));
      expect(await _assetFor(tester, 'oc-kimi_reverse_bb8c2d50'), contains('opencode'));
    });

    testWidgets('something amux did not name still draws something', (
      tester,
    ) async {
      expect(await _assetFor(tester, 'random-session'), isNull);
      expect(find.byIcon(Icons.terminal), findsOneWidget);
    });
  });

  group('agent from the session prefix', () {
    test('a known prefix settles which agent it is', () {
      expect(sessionAgentAlias('oc_reverse_bb8c2d50'), 'oc');
      expect(sessionAgentAlias('p_sitin_914497fb'), 'p');
      expect(sessionAgentAlias('oc_reverse_bb8c2d50-2'), 'oc');
      expect(sessionAgentAlias('not-an-amux-session'), isNull);
    });

    /// The fallback searches the session and command for "codex", which is fine
    /// for a session amux did not name and wrong for one it did: an opencode
    /// pane in a project called `codex-tools` would submit with Tab.
    test('a project named after codex does not make opencode submit with Tab', () {
      final opencode = _pane('oc_codex_tools_998937d4', command: 'opencode');
      expect(opencode.isCodexPane, isFalse);
      expect(opencode.sendSubmitKey, 'Enter');

      final pi = _pane('p_codex_tools_998937d4', command: 'pi');
      expect(pi.isCodexPane, isFalse);

      // Real Codex still is, and an unnamed session still falls back to text.
      expect(_pane('cx_reverse_bb8c2d50').isCodexPane, isTrue);
      expect(_pane('stray', command: 'codex resume').isCodexPane, isTrue);
    });
  });
}
