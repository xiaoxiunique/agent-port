import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme.dart';
import '../../data/models/api.dart';
import '../../data/models/cc_switch.dart';
import '../../data/models/pane.dart';
import '../../data/models/pane_ext.dart';
import '../../services/api_provider.dart';
import '../../services/demo_data.dart';
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
  bool _vimMode = false;
  bool _voiceMode = false;

  Future<CcSwitchStatusResponse>? _ccFuture;

  @override
  void initState() {
    super.initState();
    if (!ref.read(demoModeProvider)) {
      _ccFuture = ref.read(apiProvider).ccSwitchStatus();
    }
    _controller.addListener(() => setState(() {}));
    _voice.addListener(_onVoice);
  }

  bool get _isDemo => ref.read(demoModeProvider);

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
    if (_isDemo) {
      _snack('演示模式:连接你自己的服务后即可发送');
      return;
    }
    HapticFeedback.lightImpact();
    final goal = _goalMode;
    setState(() {
      _sending = true;
      _goalMode = false;
    });
    try {
      final api = ref.read(apiProvider);
      final payload = goal ? _goalText(raw) : raw;
      await api.send(SendRequest(
        paneId: widget.pane.id,
        text: payload,
        submitKey: widget.pane.sendSubmitKey,
        vimMode: _vimMode,
      ));
      _controller.clear();
      ref.invalidate(pendingProvider(widget.pane.id));
    } catch (e) {
      if (mounted) {
        setState(() => _goalMode = goal);
        _snack('发送失败: $e');
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendPreset(String text) async {
    if (_isDemo) {
      _snack('演示模式:仅供预览');
      return;
    }
    setState(() => _sending = true);
    try {
      await ref.read(apiProvider).send(SendRequest(
            paneId: widget.pane.id,
            text: text,
            submitKey: widget.pane.sendSubmitKey,
            vimMode: _vimMode,
          ));
      ref.invalidate(pendingProvider(widget.pane.id));
    } catch (e) {
      if (mounted) _snack('发送失败: $e');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendKey(String key) async {
    if (_isDemo) {
      _snack('演示模式:仅供预览');
      return;
    }
    HapticFeedback.selectionClick();
    try {
      await ref.read(apiProvider).sendKey(widget.pane.id, key);
    } catch (e) {
      if (mounted) _snack('发送失败: $e');
    }
  }

  Future<void> _switchProvider(String providerId) async {
    if (_isDemo) {
      _snack('演示模式:仅供预览');
      return;
    }
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
    if (_isDemo) {
      _snack('演示模式:仅供预览');
      return;
    }
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
    if (_isDemo) {
      _snack('演示模式:仅供预览');
      return;
    }
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
            // Accessory row (provider pill / Goal / Keys / More)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 3),
              child: SizedBox(
                height: 30,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _ProviderPill(
                      appType: _ccAppType,
                      future: _ccFuture,
                      onSwitch: _switchProvider,
                      onRefresh: () => setState(() =>
                          _ccFuture = ref.read(apiProvider).ccSwitchStatus()),
                    ),
                    const SizedBox(width: 6),
                    _AccessoryButton(
                      icon: Icons.adjust,
                      label: _goalMode ? 'Goal on' : 'Goal',
                      selected: _goalMode,
                      onTap: () => setState(() => _goalMode = !_goalMode),
                    ),
                    const SizedBox(width: 6),
                    _keysMenu(isClaude),
                    const SizedBox(width: 6),
                    _moreMenu(isClaude),
                  ],
                ),
              ),
            ),
            // Composer row
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
              child: _voiceMode ? _voiceComposer(theme) : _textComposer(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textComposer(ThemeData theme) {
    final b = theme.brightness;
    final canSend = _controller.text.trim().isNotEmpty && !_sending;
    return Container(
      constraints: const BoxConstraints(minHeight: 42),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: AgentPortTheme.separator(b)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ComposerIcon(
            icon: Icons.graphic_eq,
            variant: _ComposerVariant.plain,
            onTap: () => setState(() => _voiceMode = true),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: _controller.text.length > 120 ? 10 : 4,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintText: '这里输入...',
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 9),
              ),
            ),
          ),
          _ComposerIcon(
            icon: Icons.camera_alt_outlined,
            variant: _ComposerVariant.plain,
            onTap: _pickAndUpload,
          ),
          _ComposerIcon(
            icon: Icons.arrow_upward,
            variant: _ComposerVariant.filledCircle,
            loading: _sending,
            active: canSend,
            onTap: canSend ? _send : null,
          ),
        ],
      ),
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
    return _AccessoryButton(
      icon: Icons.keyboard_command_key,
      label: 'Keys',
      onTap: () => _openKeysSheet(isClaude),
    );
  }

  static const _keyItems = [
    ('ESC', 'C-['),
    ('Enter', 'Enter'),
    ('TAB', 'Tab'),
    ('C-c', 'C-c'),
    ('C-d', 'C-d'),
    ('C-u', 'C-u'),
    ('↑', 'Up'),
    ('↓', 'Down'),
    ('⌫', 'BSpace'),
  ];

  void _openKeysSheet(bool isClaude) {
    _showSheet(
      title: '控制键',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (label, key) in _keyItems)
                _KeyChip(label: label, onTap: () => _sendKey(key)),
            ],
          ),
          if (isClaude) ...[
            const SizedBox(height: 16),
            Text('Claude Vim',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _KeyChip(label: 'vim ⌫', onTap: () => _sendKey('VimBackspace')),
                _KeyChip(label: 'vim clr', onTap: () => _sendKey('VimClear')),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _openMoreSheet(bool isClaude) {
    _showSheet(
      title: '更多',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionChip(
                icon: widget.mode == RuntimeMode.terminal
                    ? Icons.description_outlined
                    : Icons.terminal,
                label: widget.mode == RuntimeMode.terminal ? '日志' : '终端',
                onTap: () {
                  Navigator.pop(context);
                  widget.onToggleMode();
                },
              ),
              if (isClaude)
                _ActionChip(
                  icon: Icons.edit_outlined,
                  label: 'Vim',
                  selected: _vimMode,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _vimMode = !_vimMode);
                  },
                ),
              _ActionChip(
                icon: Icons.cancel_outlined,
                label: '关闭 Pane',
                destructive: true,
                onTap: () {
                  Navigator.pop(context);
                  _kill();
                },
              ),
            ],
          ),
          if (_quickReplies.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('快捷回复',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final q in _quickReplies)
                  _ActionChip(
                    icon: Icons.reply,
                    label: q,
                    maxWidth: 220,
                    onTap: () {
                      Navigator.pop(context);
                      _sendPreset(q);
                    },
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _moreMenu(bool isClaude) {
    return _AccessoryButton(
      icon: Icons.more_horiz,
      label: 'More',
      onTap: () => _openMoreSheet(isClaude),
    );
  }

  /// Dark, rounded bottom sheet shared by the Keys / More popups (iOS-style).
  void _showSheet({
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      isScrollControlled: true,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: AgentPortTheme.elevatedSurface(theme.brightness),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          border: Border.all(color: AgentPortTheme.separator(theme.brightness)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Grabber
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 4),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text(title,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant)),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Accessory-row pill (TerminalAccessoryLabel: rounded-rect r6, height 32,
/// icon 12 / label 11 semibold; selected = accent fill, white text).
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
    final fg = selected
        ? Colors.white
        : theme.colorScheme.onSurface.withValues(alpha: 0.82);
    final fill = selected
        ? theme.colorScheme.primary
        : (b == Brightness.dark
            ? Colors.white.withValues(alpha: 0.10)
            : Colors.black.withValues(alpha: 0.05));
    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 30,
          constraints: const BoxConstraints(minWidth: 34),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AgentPortTheme.separator(b)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: fg),
              const SizedBox(width: 5),
              Text(label,
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ComposerVariant { plain, filledCircle }

/// Circular composer button (ComposerIconLabel). `plain` has no background.
class _ComposerIcon extends StatelessWidget {
  const _ComposerIcon({
    required this.icon,
    required this.variant,
    this.onTap,
    this.loading = false,
    this.active = true,
  });

  final IconData icon;
  final _ComposerVariant variant;
  final VoidCallback? onTap;
  final bool loading;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    final filled = variant == _ComposerVariant.filledCircle;
    final plain = variant == _ComposerVariant.plain;
    final bg = filled
        ? (active
            ? theme.colorScheme.primary
            : theme.colorScheme.primary.withValues(alpha: 0.35))
        : (plain ? Colors.transparent : AgentPortTheme.softFill(b));
    final fg = filled
        ? Colors.white
        : theme.colorScheme.onSurface.withValues(alpha: plain ? 0.6 : 0.82);
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: (filled || plain)
              ? null
              : Border.all(
                  color: AgentPortTheme.separator(b).withValues(alpha: 0.82)),
        ),
        child: loading
            ? Padding(
                padding: const EdgeInsets.all(9),
                child: CircularProgressIndicator(strokeWidth: 2, color: fg),
              )
            : Icon(icon, size: filled ? 18 : 19, color: fg),
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
          child: Container(
            constraints: const BoxConstraints(minWidth: 88, maxWidth: 150),
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              color: b == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.13)
                  : Colors.black.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AgentPortTheme.separator(b)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hub, size: 14, color: theme.colorScheme.onSurface),
                const SizedBox(width: 6),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appType,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 9,
                              height: 1.1,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurfaceVariant)),
                      Text(providerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              height: 1.1,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.84))),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.unfold_more,
                    size: 12, color: theme.colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A tappable control-key chip inside the Keys sheet.
class _KeyChip extends StatelessWidget {
  const _KeyChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    return Material(
      color: b == Brightness.dark
          ? Colors.white.withValues(alpha: 0.10)
          : Colors.black.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 56),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AgentPortTheme.separator(b)),
          ),
          child: Center(
            widthFactor: 1,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}

/// A compact icon+label chip for the More sheet — mirrors [_KeyChip]'s look so
/// More stays as tight as Keys. Supports a selected (accent fill) and a
/// destructive (red) state, and an optional width cap for long quick replies.
class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.destructive = false,
    this.maxWidth,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool destructive;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    final accent = theme.colorScheme.primary;
    final fg = destructive
        ? Colors.red
        : selected
            ? Colors.white
            : theme.colorScheme.onSurface;
    final bg = selected
        ? accent
        : (b == Brightness.dark
            ? Colors.white.withValues(alpha: 0.10)
            : Colors.black.withValues(alpha: 0.05));
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 40,
          constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: selected ? accent : AgentPortTheme.separator(b)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: 6),
              Flexible(
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: fg)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
