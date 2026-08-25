import 'package:agent_port/data/models/pane.dart';
import 'package:agent_port/data/models/enums.dart';
import 'package:agent_port/data/models/pane_ext.dart';
import 'package:flutter_test/flutter_test.dart';

Pane _pane(String session) => Pane(
      id: '%1',
      target: 't',
      session: session,
      windowIndex: '0',
      windowName: 'w',
      paneIndex: '0',
      command: 'claude',
      path: '/tmp',
      active: true,
      title: 'x',
      tail: '',
      status: PaneStatus.idle,
      reason: '',
      updatedAt: '2026-08-25T00:00:00Z',
    );

/// Mirrors the resolution `_PaneCard` does: a non-empty label wins, otherwise
/// the name derived from the session id.
String resolve(Map<String, String> labels, Pane p) {
  final l = labels[p.session];
  return (l != null && l.isNotEmpty) ? l : p.projectName;
}

void main() {
  group('session display name', () {
    test('falls back to the derived project name when unlabelled', () {
      expect(resolve(const {}, _pane('cc_amux_4d8e0883')), 'amux');
    });

    test('a label replaces the derived name', () {
      final labels = {'cc_amux_4d8e0883': 'iPad 适配'};
      expect(resolve(labels, _pane('cc_amux_4d8e0883')), 'iPad 适配');
    });

    test('a label on another session does not leak', () {
      final labels = {'cc_other_1111aaaa': '别的'};
      expect(resolve(labels, _pane('cc_amux_4d8e0883')), 'amux');
    });

    test('an empty label is treated as cleared', () {
      // The server deletes the key on an empty label, but a stale map or an
      // older host could still carry one; it must not blank the card.
      final labels = {'cc_amux_4d8e0883': ''};
      expect(resolve(labels, _pane('cc_amux_4d8e0883')), 'amux');
    });

    test('project names containing underscores survive', () {
      expect(resolve(const {}, _pane('cx_banxiaoku_v2_9993a2ec')),
          'banxiaoku_v2');
    });
  });
}
