import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CommandState { installed, managed, missing, conflict }

/// Mirrors the native macOS `EnvironmentController`: detects tmux/brew,
/// manages the `cc`/`cx` tmux wrappers in `~/.agent-monitor/bin`, and the
/// PATH marker in `~/.zshrc`. macOS-only; no-ops elsewhere.
class EnvironmentService extends ChangeNotifier {
  String? _tmuxVersion;
  String? _brewPath;
  CommandState _ccState = CommandState.missing;
  CommandState _cxState = CommandState.missing;
  bool _isWorking = false;
  String _lastMessage = '';

  String? get tmuxVersion => _tmuxVersion;
  String? get brewPath => _brewPath;
  CommandState get ccState => _ccState;
  CommandState get cxState => _cxState;
  bool get isWorking => _isWorking;
  String get lastMessage => _lastMessage;
  bool get tmuxInstalled => _tmuxVersion != null;

  String get _home => Platform.environment['HOME'] ?? '/';
  String get wrapperDir => '$_home/.agent-monitor/bin';

  Future<void> refresh() async {
    if (!Platform.isMacOS) return;
    final tmuxPath =
        await _firstLine('/bin/zsh', ['-lc', 'command -v tmux || true']);
    _tmuxVersion = tmuxPath == null
        ? null
        : await _firstLine('/bin/zsh', ['-lc', 'tmux -V || true']);
    _brewPath = await _firstLine('/bin/zsh', ['-lc', 'command -v brew || true']);
    if (_brewPath?.isEmpty == true) _brewPath = null;
    _ccState = await _commandState('cc');
    _cxState = await _commandState('cx');
    notifyListeners();
  }

  Future<void> installWrappers() async {
    if (!Platform.isMacOS) return;
    _isWorking = true;
    _lastMessage = '';
    notifyListeners();
    try {
      await Directory(wrapperDir).create(recursive: true);
      await _writeWrapper('cc', 'AGENT_MONITOR_CC_COMMAND', 'claude');
      await _writeWrapper('cx', 'AGENT_MONITOR_CX_COMMAND', 'codex --yolo');
      await _ensureZshrcPathBlock();
      _lastMessage = '已安装 cc/cx 包装器。在现有 shell 运行 source ~/.zshrc。';
      await refresh();
    } catch (e) {
      _lastMessage = '安装失败: $e';
    } finally {
      _isWorking = false;
      notifyListeners();
    }
  }

  Future<String?> _firstLine(String exec, List<String> args) async {
    try {
      final r = await Process.run(exec, args);
      final out = (r.stdout as String).trim();
      return out.isEmpty ? null : out.split('\n').first.trim();
    } catch (_) {
      return null;
    }
  }

  Future<CommandState> _commandState(String name) async {
    final path = '$wrapperDir/$name';
    final f = File(path);
    if (await f.exists()) {
      final content = await f.readAsString();
      if (content.contains('AGENT_MONITOR_WRAPPER')) {
        return CommandState.installed;
      }
    }
    final zshrc = File('$_home/.zshrc');
    if (await zshrc.exists()) {
      final content = await zshrc.readAsString();
      if (content.contains('_agent_tmux_run') &&
          content.contains(RegExp('^\\s*(?:function\\s+)?$name\\b',
              multiLine: true))) {
        return CommandState.managed;
      }
    }
    final typeOut = await _firstLine(
        '/bin/zsh', ['-lic', 'type -a $name 2>/dev/null || true']);
    if (typeOut == null || typeOut.isEmpty) return CommandState.missing;
    return CommandState.conflict;
  }

  Future<void> _writeWrapper(
      String name, String commandVar, String defaultCommand) async {
    const template = r'''#!/usr/bin/env bash
set -euo pipefail
# AGENT_MONITOR_WRAPPER @@NAME@@

if ! command -v tmux >/dev/null 2>&1; then
  echo "Agent Port requires tmux. Install it first: brew install tmux" >&2
  exit 1
fi

project_dir="$(pwd -P)"
base="$(basename "$project_dir" | tr -c '[:alnum:]_-' '_' | sed 's/_$//')"
hash="$(printf "%s" "$project_dir" | shasum -a 1 | awk '{print substr($1, 1, 8)}')"
session="@@NAME@@_${base}_${hash}"
agent_command="${@@COMMAND_VAR@@:-@@DEFAULT@@}"

if tmux has-session -t "$session" 2>/dev/null; then
  if [ -n "${TMUX:-}" ]; then
    exec tmux switch-client -t "$session"
  fi
  exec tmux attach-session -t "$session"
fi

if [ -n "${TMUX:-}" ]; then
  tmux new-session -d -s "$session" -c "$project_dir" "$agent_command"
  exec tmux switch-client -t "$session"
fi

exec tmux new-session -s "$session" -c "$project_dir" "$agent_command"
''';
    final content = template
        .replaceAll('@@NAME@@', name)
        .replaceAll('@@COMMAND_VAR@@', commandVar)
        .replaceAll('@@DEFAULT@@', defaultCommand);
    final path = '$wrapperDir/$name';
    await File(path).writeAsString(content);
    await Process.run('chmod', ['755', path]);
  }

  Future<void> _ensureZshrcPathBlock() async {
    final zshrc = File('$_home/.zshrc');
    const marker = '# >>> agent-monitor >>>';
    final block = '''

# >>> agent-monitor >>>
export PATH="\$HOME/.agent-monitor/bin:\$PATH"
# <<< agent-monitor <<<
''';
    final existing = await zshrc.exists() ? await zshrc.readAsString() : '';
    if (existing.contains(marker)) return;
    final updated = existing.isEmpty ? '${block.trim()}\n' : '$existing$block';
    await zshrc.writeAsString(updated);
  }
}

final environmentServiceProvider =
    ChangeNotifierProvider<EnvironmentService>((ref) {
  return EnvironmentService();
});
