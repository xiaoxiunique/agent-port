import 'enums.dart';
import 'pane.dart';

/// Display helpers ported verbatim from the native iOS app
/// (`AppSettings.projectName`, `PaneListItem.cleanTitle/displayTitle`,
/// `sortedWorkSessions`). Kept as pure functions so both the list and the
/// detail page render identical text.
extension PaneDisplay on Pane {
  /// Project name derived from the tmux session id (AppSettings.swift:337).
  /// `cc_<project>_<hash>` → `<project>`; `cx_<project>` → `<project>`.
  String get projectName {
    final parts = session.split('_');
    if (parts.length >= 3) {
      return parts.sublist(1, parts.length - 1).join('_');
    }
    if (parts.length == 2) return parts[1];
    return session;
  }

  /// Title with the leading Claude Code braille spinner stripped
  /// (MonitorView.swift:1113-1122).
  String get cleanTitle {
    var t = title;
    while (t.isNotEmpty) {
      final c = t.runes.first;
      final isSpinner = (c >= 0x2800 && c <= 0x28FF) || c == 0x2733 || c == 0x20;
      if (!isSpinner) break;
      t = String.fromCharCodes(t.runes.skip(1));
    }
    return t.trim();
  }

  /// Secondary line shown under the project name (MonitorView.swift:1124-1132).
  String get displayTitle {
    final ct = cleanTitle;
    if (ct.isNotEmpty && ct != command) return ct;
    if (command.isNotEmpty) return command;
    return session;
  }

  /// True for Codex panes. Matches native `Pane.isCodexPane` (Pane.swift:102):
  /// `cx_` prefix OR "codex" anywhere in session/command/title/tail.
  bool get isCodexPane {
    if (session.startsWith('cx_')) return true;
    final haystack = '$session\n$command\n$title\n$tail'.toLowerCase();
    return haystack.contains('codex');
  }

  /// Submit key for `/api/send` (Pane.swift:107): Tab for Codex, else Enter.
  String get sendSubmitKey => isCodexPane ? 'Tab' : 'Enter';

  /// True for Claude Code panes (session prefix `cc_`).
  bool get isClaudePane => session.startsWith('cc_');
}

/// Human-readable status label (RealtimeLogPanel header / status pills).
extension PaneStatusLabel on PaneStatus {
  String get label {
    switch (this) {
      case PaneStatus.running:
        return 'Running';
      case PaneStatus.waiting:
        return 'Waiting';
      case PaneStatus.idle:
        return 'Idle';
      case PaneStatus.failed:
        return 'Failed';
      case PaneStatus.done:
        return 'Done';
    }
  }
}

/// Sort priority by status (MonitorView.swift:791-799):
/// waiting → failed → running → done → idle.
/// Sort panes in a **stable** order that does not jump when a session's live
/// status changes — status is shown only as a colored dot, never as position.
/// Order: pinned projects first (in pinned order), then project name, then
/// Claude before Codex, then a stable session/pane id. Crucially it never keys
/// on `updatedAt`, so ongoing activity alone never reshuffles the list.
List<Pane> sortedPanes(List<Pane> panes, {List<String> pinned = const []}) {
  final list = [...panes];
  list.sort((a, b) {
    final aProj = a.projectName;
    final bProj = b.projectName;
    final aPin = pinned.contains(aProj);
    final bPin = pinned.contains(bProj);
    if (aPin != bPin) return aPin ? -1 : 1;
    if (aPin && bPin) {
      final ai = pinned.indexOf(aProj);
      final bi = pinned.indexOf(bProj);
      if (ai != bi) return ai.compareTo(bi);
    }
    if (aProj != bProj) {
      return aProj.toLowerCase().compareTo(bProj.toLowerCase());
    }
    if (a.isClaudePane != b.isClaudePane) return a.isClaudePane ? -1 : 1;
    final s = a.session.compareTo(b.session);
    if (s != 0) return s;
    return a.id.compareTo(b.id);
  });
  return list;
}
