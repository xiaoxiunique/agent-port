import 'package:agent_port/services/pane_log_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('cleanPaneLog — opencode chrome', () {
    test('drops the launch banner, status footer and progress bar', () {
      // Captured verbatim from a live `opencode --auto --mini` pane.
      const raw = '''
█▀▀█ █▀▀█ █▀▀█ █▀▀▄ █▀▀▀ █▀▀█ █▀▀█ █▀▀█
█  █ █  █ █▀▀▀ █  █ █    █  █ █  █ █▀▀▀
▀▀▀▀ █▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀
› 用一句话说明你是谁
我是编码智能体。
▣ Build · Big Pickle · 2m 2s
╹▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
 ■■■⬝⬝⬝⬝⬝  esc interrupt
''';
      final out = cleanPaneLog(raw);

      expect(out, contains('› 用一句话说明你是谁'));
      expect(out, contains('我是编码智能体。'));

      expect(out, isNot(contains('█')));
      expect(out, isNot(contains('▣')));
      expect(out, isNot(contains('esc interrupt')));
      expect(out, isNot(contains('▀')));
    });

    test('keeps the ┃ gutter — those lines carry real output', () {
      // opencode draws tool results inside a left gutter. Filtering the gutter
      // would take the file excerpts and search hits with it.
      const raw = '''
  ┃  === CLAUDE.md ===
  ┃  143:10. 资产固定 → asset_hashes.json 记录关键资产的 SHA256
  ┃  Click to expand
''';
      final out = cleanPaneLog(raw);

      expect(out, contains('=== CLAUDE.md ==='));
      expect(out, contains('asset_hashes.json'));
      expect(out, contains('Click to expand'));
    });

    test('a line that merely mentions the glyphs survives', () {
      // The progress-bar rule keys on the glyphs *and* the label together, so
      // prose about interrupting is not swallowed.
      final out = cleanPaneLog('press esc interrupt to stop the run\n');
      expect(out, contains('press esc interrupt to stop the run'));
    });

    test('existing Claude/Codex rules still apply', () {
      final out = cleanPaneLog('-- INSERT --\nreal output\n');
      expect(out, isNot(contains('INSERT')));
      expect(out, contains('real output'));
    });
  });
}
