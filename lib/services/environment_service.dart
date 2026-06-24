import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CommandState { installed, managed, missing, conflict }

/// A dev tool the server can detect and one-click install on the host Mac.
enum DevTool { homebrew, node, tmux, claudeCode, codex }

/// Detected state of a [DevTool] for the UI. [blockedReason] is non-null when
/// the tool is missing and can't be auto-installed yet (e.g. needs Homebrew).
class ToolInfo {
  const ToolInfo(this.tool, this.installed, this.version, this.blockedReason);
  final DevTool tool;
  final bool installed;
  final String? version;
  final String? blockedReason;
}

/// Mirrors the native macOS `EnvironmentController`: detects tmux/brew,
/// manages the `cc`/`cx` tmux wrappers in `~/.agent-monitor/bin`, and the
/// PATH marker in `~/.zshrc`. macOS-only; no-ops elsewhere.
class EnvironmentService extends ChangeNotifier {
  String? _tmuxVersion;
  String? _brewPath;
  String? _brewVersion;
  String? _nodeVersion;
  String? _claudeVersion;
  String? _codexVersion;
  CommandState _ccState = CommandState.missing;
  CommandState _cxState = CommandState.missing;
  bool _isWorking = false;
  String _lastMessage = '';
  DevTool? _installingTool;
  final List<String> _installLog = [];

  String? get tmuxVersion => _tmuxVersion;
  String? get brewPath => _brewPath;
  CommandState get ccState => _ccState;
  CommandState get cxState => _cxState;
  bool get isWorking => _isWorking;
  String get lastMessage => _lastMessage;
  bool get tmuxInstalled => _tmuxVersion != null;
  bool get brewInstalled => _brewPath != null && _brewPath!.isNotEmpty;
  DevTool? get installingTool => _installingTool;
  List<String> get installLog => List.unmodifiable(_installLog);

  /// Ordered tool list for the server panel.
  List<ToolInfo> get devTools => DevTool.values.map((t) {
        final (installed, version) = _toolState(t);
        final reason = installed ? null : _installPlan(t).$2;
        return ToolInfo(t, installed, version, reason);
      }).toList();

  static String toolLabel(DevTool t) => switch (t) {
        DevTool.homebrew => 'Homebrew',
        DevTool.node => 'Node.js',
        DevTool.tmux => 'tmux',
        DevTool.claudeCode => 'Claude Code',
        DevTool.codex => 'Codex',
      };

  (bool, String?) _toolState(DevTool t) => switch (t) {
        DevTool.homebrew => (brewInstalled, _brewVersion),
        DevTool.node => (_nodeVersion != null, _nodeVersion),
        DevTool.tmux => (tmuxInstalled, _tmuxVersion),
        DevTool.claudeCode => (_claudeVersion != null, _claudeVersion),
        DevTool.codex => (_codexVersion != null, _codexVersion),
      };

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
    _brewVersion =
        brewInstalled ? await _version('brew --version') : null;
    _nodeVersion =
        await _has('node') ? await _version('node --version') : null;
    _claudeVersion =
        await _has('claude') ? await _version('claude --version') : null;
    _codexVersion =
        await _has('codex') ? await _version('codex --version') : null;
    _ccState = await _commandState('cc');
    _cxState = await _commandState('cx');
    notifyListeners();
  }

  /// One-click install for a [DevTool] on the host Mac. Streams the installer's
  /// output into [installLog]; auto strategy prefers Homebrew, falls back to
  /// the official installer script / npm.
  Future<void> install(DevTool tool) async {
    if (!Platform.isMacOS || _installingTool != null || _isWorking) return;
    final (cmd, blocked) = _installPlan(tool);
    if (cmd == null) {
      _lastMessage = blocked ?? '无法自动安装 ${toolLabel(tool)}';
      notifyListeners();
      return;
    }
    _installingTool = tool;
    _installLog.clear();
    _lastMessage = '';
    notifyListeners();
    try {
      final proc = await Process.start(
        '/bin/zsh',
        ['-lc', cmd],
        environment: const {
          'NONINTERACTIVE': '1',
          'HOMEBREW_NO_AUTO_UPDATE': '1',
          'HOMEBREW_NO_ENV_HINTS': '1',
        },
      );
      proc.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(_appendLog);
      proc.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(_appendLog);
      final code = await proc.exitCode;
      await refresh();
      _lastMessage = code == 0
          ? '${toolLabel(tool)} 安装完成'
          : '${toolLabel(tool)} 安装失败 (code $code),见日志';
    } catch (e) {
      _lastMessage = '安装出错: $e';
    } finally {
      _installingTool = null;
      notifyListeners();
    }
  }

  /// Resolve the install command (or a reason it's blocked) for [tool].
  (String?, String?) _installPlan(DevTool tool) => switch (tool) {
        DevTool.homebrew => (
            r'/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"',
            null,
          ),
        DevTool.node => brewInstalled
            ? ('brew install node', null)
            : (null, '需先安装 Homebrew'),
        DevTool.tmux => brewInstalled
            ? ('brew install tmux', null)
            : (null, '需先安装 Homebrew'),
        DevTool.claudeCode => (
            'curl -fsSL https://claude.ai/install.sh | bash',
            null,
          ),
        DevTool.codex => brewInstalled
            ? ('brew install codex', null)
            : _nodeVersion != null
                ? ('npm install -g @openai/codex', null)
                : (null, '需 Homebrew 或 Node'),
      };

  void _appendLog(String line) {
    _installLog.add(line);
    if (_installLog.length > 300) {
      _installLog.removeRange(0, _installLog.length - 300);
    }
    notifyListeners();
  }

  Future<bool> _has(String bin) async {
    final p = await _firstLine('/bin/zsh', ['-lc', 'command -v $bin || true']);
    return p != null && p.isNotEmpty;
  }

  Future<String?> _version(String shellCmd) =>
      _firstLine('/bin/zsh', ['-lc', '$shellCmd 2>/dev/null || true']);

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
