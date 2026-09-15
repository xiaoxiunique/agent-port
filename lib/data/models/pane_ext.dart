import 'enums.dart';
import 'pane.dart';

/// Which agent a session belongs to, from the prefix amux names it with.
///
/// `cc_amux_4d8e0883` is Claude, `cx_…` Codex, `oc_…` opencode, `p_…` pi. A
/// provider hangs off the prefix with a dash (`cc-glm_…`) and is not part of
/// the answer.
///
/// One function, because there were two and both knew only half the agents —
/// so opencode and pi sessions drew the fallback terminal glyph while the
/// sorting quietly treated them as "not Claude".
String? sessionAgentAlias(String session) {
  final underscore = session.indexOf('_');
  if (underscore <= 0) return null;
  final prefix = session.substring(0, underscore);
  final dash = prefix.indexOf('-');
  final alias = dash > 0 ? prefix.substring(0, dash) : prefix;
  return switch (alias) {
    'cc' || 'cx' || 'oc' || 'p' => alias,
    _ => null,
  };
}

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

  /// True for Codex panes. The amux session prefix is authoritative: `cx_` and
  /// `cx-provider_` are Codex; `cc_` and `cc-provider_` are Claude Code.
  /// Only when no known amux prefix is present do we fall back to stable
  /// session/command text — never volatile title/tail.
  bool get isCodexPane {
    // A known prefix settles it, opencode and pi included. Falling through to
    // the text search for those meant a project with "codex" in its name made
    // an opencode pane submit with Tab, which is not its submit key.
    final alias = sessionAgentAlias(session);
    if (alias != null) return alias == 'cx';
    return '$session\n$command'.toLowerCase().contains('codex');
  }

  /// Submit key for `/api/send` (Pane.swift:107): Tab for Codex, else Enter.
  String get sendSubmitKey => isCodexPane ? 'Tab' : 'Enter';

  /// True for Claude Code panes (session prefix `cc_` or `cc-provider_`).
  bool get isClaudePane => sessionAgentAlias(session) == 'cc';
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
