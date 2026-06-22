import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme.dart';
import '../../data/models/api.dart';
import '../../data/models/cc_switch.dart';
import '../../data/models/pane.dart';
import '../../data/models/pane_ext.dart';
import '../../services/api_provider.dart';
import '../../services/settings_service.dart';
import '../../services/tencent_asr_service.dart';
import '../../services/voice_input_service.dart';

/// Which runtime surface the detail page shows.
enum RuntimeMode { log, terminal }

/// Unified bottom input bar. Mirrors the native `InputBar`
/// (PaneDetailSheet.swift): an accessory row (provider pill / Goal / Keys /
/// More) above a composer (text field + image + send). Voice input is omitted
/// (it needs a native ASR plugin).
class InputBar extends ConsumerStatefulWidget {
  const InputBar({
    super.key,
    required this.pane,
    required this.mode,
    required this.onToggleMode,
    this.onKilled,
  });

  final Pane pane;
  final RuntimeMode mode;
  final VoidCallback onToggleMode;

  /// Called after the pane is killed so the parent can navigate away.
  final VoidCallback? onKilled;

  @override
  ConsumerState<InputBar> createState() => _InputBarState();
}

class _InputBarState extends ConsumerState<InputBar> {
  final _controller = TextEditingController();
  final _voice = VoiceInputController();
  bool _sending = false;
  bool _goalMode = false;
  bool _refineMode = false;
  bool _vimMode = false;
  bool _voiceMode = false;

  Future<CcSwitchStatusResponse>? _ccFuture;

  @override
  void initState() {
    super.initState();
    _ccFuture = ref.read(apiProvider).ccSwitchStatus();
    _controller.addListener(() => setState(() {}));
    _voice.addListener(_onVoice);
  }

  void _onVoice() {
    if (!mounted) return;
    // Live partial transcript into the field while listening.
    if (_voice.state == VoiceState.listening) {
      _controller.text = _voice.transcript;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _voice.removeListener(_onVoice);
    _voice.dispose();
    super.dispose();
  }

  String get _ccAppType => widget.pane.isCodexPane ? 'codex' : 'claude';

  /// `/goal` wrapper, verbatim from native `goalModeText(for:)`
  /// (PaneDetailSheet.swift:3223).
  String _goalText(String text) =>
      '/goal\n请使用 goal 模式，先创建一个 goal，然后持续推进直到完成或明确阻塞：\n\n$text';

  Future<void> _send() async {
    final raw = _controller.text.trim();
    if (raw.isEmpty || _sending) return;
    final refine = _refineMode;
    final goal = _goalMode;
    setState(() {
      _sending = true;
      _goalMode = false;
      _refineMode = false;
    });
    try {
      final api = ref.read(apiProvider);
      var text = raw;
      if (refine) {
        final r = await api.refineText(text);
        if (r.text != null && r.text!.isNotEmpty) text = r.text!;
      }
      final payload = goal ? _goalText(text) : text;
      await api.send(SendRequest(
        paneId: widget.pane.id,
        text: payload,
        submitKey: widget.pane.sendSubmitKey,
        vimMode: _vimMode,
      ));
      _controller.clear();
    } catch (e) {
      if (mounted) {
        setState(() {
          _goalMode = goal;
          _refineMode = refine;
        });
        _snack('发送失败: $e');
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendPreset(String text) async {
    setState(() => _sending = true);
    try {
      await ref.read(apiProvider).send(SendRequest(
            paneId: widget.pane.id,
            text: text,
            submitKey: widget.pane.sendSubmitKey,
            vimMode: _vimMode,
          ));
    } catch (e) {
      if (mounted) _snack('发送失败: $e');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendKey(String key) async {
    try {
      await ref.read(apiProvider).sendKey(widget.pane.id, key);
    } catch (e) {
      if (mounted) _snack('发送失败: $e');
    }
  }

  Future<void> _switchProvider(String providerId) async {
    try {
      await ref
          .read(apiProvider)
          .switchCcProvider(appType: _ccAppType, providerId: providerId);
      setState(() => _ccFuture = ref.read(apiProvider).ccSwitchStatus());
    } catch (e) {
      if (mounted) _snack('切换失败: $e');
    }
  }

  Future<void> _kill() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('关闭 Pane'),
        content: const Text('确定要 kill 这个 pane 吗?此操作不可撤销。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false), child: const Text('取消')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(apiProvider).killSession(paneId: widget.pane.id);
      widget.onKilled?.call();
    } catch (e) {
      if (mounted) _snack('关闭失败: $e');
    }
  }

  Future<void> _startVoice() async {
    final s = ref.read(settingsProvider).valueOrNull;
    TencentAsrConfig? tc;
    if (s != null && s.voiceRecognitionProvider == 'tencent') {
      tc = TencentAsrConfig(
        appId: s.tencentAsrAppId,
        secretId: s.tencentAsrSecretId,
        secretKey: s.tencentAsrSecretKey,
        token: s.tencentAsrToken,
      );
    }
    final ok = await _voice.start(tencent: tc);
    if (!ok && mounted) _snack('语音不可用(检查麦克风/语音识别权限或腾讯凭证)');
  }

  Future<void> _stopVoice() async {
    final text = await _voice.stop();
    if (!mounted) return;
    if (text.trim().isNotEmpty) {
      _controller.text = text;
      setState(() => _voiceMode = false);
    }
  }

  Future<void> _pickAndUpload() async {
    try {
      final xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (xfile == null) return;
      final bytes = await xfile.readAsBytes();
      final contentType = _detectContentType(bytes);
      final r = await ref
          .read(apiProvider)
          .uploadImage(bytes, contentType, paneId: widget.pane.id);
      // Mirror native: insert an editable prompt referencing the uploaded path
      // rather than auto-sending (PaneDetailSheet.swift:3171).
      if (r.path != null && r.path!.isNotEmpty) {
        final existing = _controller.text;
        _controller.text =
            existing.isEmpty ? r.path! : '$existing\n${r.path!}';
      } else {
        _snack('图片已上传');
      }
    } catch (e) {
      if (mounted) _snack('上传失败: $e');
    }
  }

  String _detectContentType(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xff &&
        bytes[1] == 0xd8 &&
        bytes[2] == 0xff) {
      return 'image/jpeg';
    }
    if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4e &&
        bytes[3] == 0x47) {
      return 'image/png';
    }
    return 'image/jpeg';
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  List<String> get _quickReplies {
    final s = ref.read(settingsProvider).valueOrNull;
    final list = s?.quickActionButtons ?? const <String>[];
    return list.isEmpty ? const ['继续', 'yes', 'no', 'LGTM', 'skip'] : list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isClaude = widget.pane.isClaudePane;
    return SafeArea(
      top: false,
      child: Material(
        color: theme.colorScheme.surface,
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(height: 1, color: AgentPortTheme.separator(theme.brightness)),
            // Accessory row
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _ProviderPill(
                    appType: _ccAppType,
                    future: _ccFuture,
                    onSwitch: _switchProvider,
                    onRefresh: () => setState(
                        () => _ccFuture = ref.read(apiProvider).ccSwitchStatus()),
                  ),
                  const SizedBox(width: 6),
                  _AccessoryButton(
                    icon: Icons.flag_outlined,
                    label: _goalMode ? 'Goal on' : 'Goal',
                    selected: _goalMode,
                    onTap: () => setState(() => _goalMode = !_goalMode),
                  ),
                  const SizedBox(width: 6),
                  _AccessoryButton(
                    icon: Icons.auto_fix_high,
                    label: 'Refine',
                    selected: _refineMode,
                    onTap: () => setState(() => _refineMode = !_refineMode),
                  ),
                  const SizedBox(width: 6),
                  _keysMenu(isClaude),
                  const SizedBox(width: 6),
                  _moreMenu(isClaude),
                ],
              ),
            ),
            // Composer row
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 8, 6),
              child: _voiceMode ? _voiceComposer(theme) : _textComposer(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textComposer(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.mic_none),
          tooltip: '语音输入',
          onPressed: () => setState(() => _voiceMode = true),
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            minLines: 1,
            maxLines: _controller.text.length > 120 ? 10 : 4,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: '这里输入...',
              filled: true,
              fillColor: AgentPortTheme.softFill(theme.brightness),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.image_outlined),
          tooltip: '上传图片',
          onPressed: _pickAndUpload,
        ),
        IconButton.filled(
          onPressed: _sending ? null : _send,
          icon: _sending
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.arrow_upward),
        ),
      ],
    );
  }

  Widget _voiceComposer(ThemeData theme) {
    final listening = _voice.state == VoiceState.listening;
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard),
          tooltip: '键盘输入',
          onPressed: () => setState(() => _voiceMode = false),
        ),
        Expanded(
          child: GestureDetector(
            onLongPressStart: (_) => _startVoice(),
            onLongPressEnd: (_) => _stopVoice(),
            child: Container(
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: listening
                    ? theme.colorScheme.primary.withValues(alpha: 0.18)
                    : AgentPortTheme.softFill(theme.brightness),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: listening
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(listening ? Icons.graphic_eq : Icons.mic,
                      size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(listening ? '松开结束' : '按住 说话',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _keysMenu(bool isClaude) {
    return PopupMenuButton<String>(
      tooltip: '控制键',
      onSelected: _sendKey,
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'C-[', child: Text('ESC')),
        const PopupMenuItem(value: 'Enter', child: Text('Enter')),
        const PopupMenuItem(value: 'Tab', child: Text('TAB')),
        const PopupMenuItem(value: 'C-c', child: Text('C-c')),
        const PopupMenuItem(value: 'C-d', child: Text('C-d')),
        const PopupMenuItem(value: 'C-u', child: Text('C-u')),
        const PopupMenuItem(value: 'Up', child: Text('↑')),
        const PopupMenuItem(value: 'Down', child: Text('↓')),
        const PopupMenuItem(value: 'BSpace', child: Text('⌫')),
        if (isClaude) ...[
          const PopupMenuDivider(),
          const PopupMenuItem(value: 'VimBackspace', child: Text('vim ⌫')),
          const PopupMenuItem(value: 'VimClear', child: Text('vim clr')),
        ],
      ],
      child: const _AccessoryButton(icon: Icons.keyboard, label: 'Keys'),
    );
  }

  Widget _moreMenu(bool isClaude) {
    return PopupMenuButton<String>(
      tooltip: '更多',
      onSelected: (v) {
        if (v == 'toggle') {
          widget.onToggleMode();
        } else if (v == 'vim') {
          setState(() => _vimMode = !_vimMode);
        } else if (v == 'kill') {
          _kill();
        } else if (v.startsWith('preset:')) {
          _sendPreset(v.substring(7));
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'toggle',
          child: Text(
              widget.mode == RuntimeMode.terminal ? '打开日志' : '打开终端'),
        ),
        if (isClaude)
          PopupMenuItem(
            value: 'vim',
            child: Text(_vimMode ? '关闭 Vim 模式' : '开启 Vim 模式'),
          ),
        const PopupMenuDivider(),
        for (final q in _quickReplies)
          PopupMenuItem(value: 'preset:$q', child: Text(q)),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'kill',
          child: Text('关闭 Pane', style: TextStyle(color: Colors.red)),
        ),
      ],
      child: const _AccessoryButton(icon: Icons.more_horiz, label: 'More'),
    );
  }
}

/// A small pill button in the accessory row (TerminalAccessoryLabel).
class _AccessoryButton extends StatelessWidget {
  const _AccessoryButton({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    final fg = selected ? theme.colorScheme.primary : theme.colorScheme.onSurface;
    return Material(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.12)
          : AgentPortTheme.softFill(b),
      shape: StadiumBorder(
        side: BorderSide(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.4)
              : Colors.transparent,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: fg),
              const SizedBox(width: 5),
              Text(label, style: TextStyle(fontSize: 13, color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Two-line provider pill: app type over the active provider, with a menu of
/// providers + refresh (MiniCcSwitchProviderMenu, PaneDetailSheet.swift:3645).
class _ProviderPill extends StatelessWidget {
  const _ProviderPill({
    required this.appType,
    required this.future,
    required this.onSwitch,
    required this.onRefresh,
  });

  final String appType;
  final Future<CcSwitchStatusResponse>? future;
  final ValueChanged<String> onSwitch;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    return FutureBuilder<CcSwitchStatusResponse>(
      future: future,
      builder: (context, snap) {
        CcSwitchApp? app;
        final apps = snap.data?.apps ?? const <CcSwitchApp>[];
        for (final a in apps) {
          if (a.appType == appType) {
            app = a;
            break;
          }
        }
        CcSwitchProvider? current;
        for (final p in app?.providers ?? const <CcSwitchProvider>[]) {
          if (p.isCurrent) {
            current = p;
            break;
          }
        }
        final providerName = current?.name ?? '—';

        return PopupMenuButton<String>(
          tooltip: '切换 provider',
          onSelected: (v) {
            if (v == '__refresh__') {
              onRefresh();
            } else {
              onSwitch(v);
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: '__refresh__', child: Text('刷新')),
            const PopupMenuDivider(),
            for (final p in app?.providers ?? const <CcSwitchProvider>[])
              PopupMenuItem(
                value: p.id,
                enabled: !p.isCurrent && p.hasApiKey,
                child: Row(
                  children: [
                    Icon(
                      p.isCurrent
                          ? Icons.check_circle
                          : Icons.radio_button_off,
                      size: 18,
                      color: p.isCurrent ? Colors.green : null,
                    ),
                    const SizedBox(width: 8),
                    Text(p.name),
                  ],
                ),
              ),
          ],
          child: Material(
            color: AgentPortTheme.softFill(b),
            shape: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.hub_outlined, size: 16),
                  const SizedBox(width: 6),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appType,
                          style: TextStyle(
                              fontSize: 10,
                              color: theme.colorScheme.onSurfaceVariant)),
                      Text(providerName,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.unfold_more, size: 14),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
