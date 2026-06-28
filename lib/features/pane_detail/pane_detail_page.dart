import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/models/pane.dart';
import '../../data/models/pane_ext.dart';
import '../../data/models/pending.dart';
import '../../services/api_provider.dart';
import '../../services/demo_data.dart';
import '../../services/pane_log_service.dart';
import '../../services/pip_service.dart';
import '../../services/snapshot_service.dart';
import 'input_bar.dart';
import 'terminal_pane_view.dart';

/// Single-page pane detail with a Logs/Terminal mode toggle and a unified
/// bottom InputBar. Mirrors the native PaneDetailSheet structure (not a tab bar).
class PaneDetailPage extends ConsumerStatefulWidget {
  const PaneDetailPage({super.key, required this.paneId});

  final String paneId;

  @override
  ConsumerState<PaneDetailPage> createState() => _PaneDetailPageState();
}

class _PaneDetailPageState extends ConsumerState<PaneDetailPage> {
  RuntimeMode _mode = RuntimeMode.log;

  @override
  Widget build(BuildContext context) {
    final panes =
        ref.watch(snapshotProvider).valueOrNull?.panes ?? const <Pane>[];
    Pane? pane;
    for (final p in panes) {
      if (p.id == widget.paneId) {
        pane = p;
        break;
      }
    }
    final title = (pane?.cleanTitle.isNotEmpty ?? false)
        ? pane!.projectName
        : (pane != null ? pane.projectName : widget.paneId);
    final foundPane = pane;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, overflow: TextOverflow.ellipsis),
        actions: [
          if (foundPane != null && !kIsWeb && Platform.isIOS)
            IconButton(
              icon: const Icon(Icons.picture_in_picture),
              tooltip: '画中画',
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                if (!await PipService.isSupported) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('此设备不支持画中画')),
                  );
                  return;
                }
                try {
                  await PipService.start(
                    title: foundPane.command.isNotEmpty
                        ? foundPane.command
                        : foundPane.session,
                    status: foundPane.status.name,
                    body: foundPane.tail,
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('画中画启动失败: $e')),
                  );
                }
              },
            ),
        ],
      ),
      // The xterm terminal stays dark regardless of system theme (matches the
      // native detail sheet); the log view and the surrounding shell follow
      // the system light/dark setting.
      body: foundPane == null
          ? const Center(child: Text('pane 不在当前快照'))
          : Column(
              children: [
                Expanded(
                  child: _mode == RuntimeMode.terminal
                      ? Theme(
                          data: AgentPortTheme.dark,
                          child: TerminalPaneView(
                            api: ref.read(apiProvider),
                            paneId: widget.paneId,
                          ),
                        )
                      : _LogView(pane: foundPane),
                ),
                _PendingBar(paneId: widget.paneId),
                InputBar(
                  pane: foundPane,
                  mode: _mode,
                  onToggleMode: () => setState(() {
                    _mode = _mode == RuntimeMode.log
                        ? RuntimeMode.terminal
                        : RuntimeMode.log;
                  }),
                  onKilled: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
    );
  }
}

/// Logs mode: live `/pane-log/ws` stream with accumulation, a status header,
/// auto-follow when near the bottom, and copy. Mirrors the native
/// `PaneRealtimeLogContainer`.
class _LogView extends ConsumerStatefulWidget {
  const _LogView({required this.pane});
  final Pane pane;

  @override
  ConsumerState<_LogView> createState() => _LogViewState();
}

class _LogViewState extends ConsumerState<_LogView> {
  late PaneLogService _service;
  final _scroll = ScrollController();
  bool _autoFollow = true;
  bool _demo = false;

  @override
  void initState() {
    super.initState();
    _demo = ref.read(demoModeProvider);
    if (!_demo) {
      _service = _make();
      _service.addListener(_onLog);
    }
  }

  PaneLogService _make() => PaneLogService(
        api: ref.read(apiProvider),
        paneId: widget.pane.id,
        initialTail: widget.pane.tail,
      );

  @override
  void didUpdateWidget(_LogView old) {
    super.didUpdateWidget(old);
    if (_demo) return;
    if (old.pane.id != widget.pane.id) {
      _service.removeListener(_onLog);
      _service.dispose();
      _service = _make()..addListener(_onLog);
    }
  }

  void _onLog() {
    if (!mounted) return;
    setState(() {});
    if (_autoFollow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        }
      });
    }
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final atBottom =
        _scroll.position.pixels >= _scroll.position.maxScrollExtent - 40;
    if (atBottom != _autoFollow) setState(() => _autoFollow = atBottom);
  }

  @override
  void dispose() {
    if (!_demo) {
      _service.removeListener(_onLog);
      _service.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_demo) {
      return Column(
        children: [
          _StatusHeader(pane: widget.pane, state: PaneLogState.live),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: SelectableText(
                widget.pane.tail.isEmpty ? '暂无运行输出' : widget.pane.tail,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.3,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      );
    }
    final text = _service.text;
    return Column(
      children: [
        _StatusHeader(pane: widget.pane, state: _service.state),
        Expanded(
          child: Stack(
            children: [
              if (text.isEmpty)
                Center(
                  child: Text('暂无运行输出',
                      style: TextStyle(color: Theme.of(context).hintColor)),
                )
              else
                NotificationListener<ScrollNotification>(
                  onNotification: (_) {
                    _onScroll();
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: SelectableText(
                      text,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        height: 1.3,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Row(
                  children: [
                    if (!_autoFollow)
                      _RoundButton(
                        icon: Icons.arrow_downward,
                        onTap: () {
                          setState(() => _autoFollow = true);
                          if (_scroll.hasClients) {
                            _scroll.jumpTo(_scroll.position.maxScrollExtent);
                          }
                        },
                      ),
                    const SizedBox(width: 8),
                    _RoundButton(
                      icon: Icons.copy,
                      onTap: text.isEmpty
                          ? null
                          : () {
                              Clipboard.setData(ClipboardData(text: text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('已复制日志')),
                              );
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Status color block above the log (RealtimeLogPanel header).
class _StatusHeader extends StatelessWidget {
  const _StatusHeader({required this.pane, required this.state});
  final Pane pane;
  final PaneLogState state;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final color = statusColor(pane.status, b);
    final reason = pane.reason.trim();
    final connecting =
        state == PaneLogState.connecting || state == PaneLogState.reconnecting;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      color: AgentPortTheme.softFill(b),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            pane.status.label,
            style: TextStyle(
                color: color, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          if (reason.isNotEmpty) ...[
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                reason,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12),
              ),
            ),
          ] else
            const Spacer(),
          if (connecting)
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 1.6),
            ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: (dark ? Colors.white : Colors.black).withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon,
              size: 18, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}

/// Pending-message queue strip shown above the InputBar. Lists messages held
/// because Claude was busy; each can be edited or deleted. Hidden when empty.
/// Refetches on every snapshot tick so delivered messages drop off live.
class _PendingBar extends ConsumerWidget {
  const _PendingBar({required this.paneId});
  final String paneId;

  Future<void> _edit(
      BuildContext context, WidgetRef ref, PendingMessage m) async {
    final controller = TextEditingController(text: m.text);
    final text = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('编辑待发送消息'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c), child: const Text('取消')),
          FilledButton(
            onPressed: () => Navigator.pop(c, controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (text == null || text.isEmpty || text == m.text) return;
    try {
      await ref.read(apiProvider).pendingUpdate(paneId, m.id, text);
    } finally {
      ref.invalidate(pendingProvider(paneId));
    }
  }

  Future<void> _delete(WidgetRef ref, PendingMessage m) async {
    try {
      await ref.read(apiProvider).pendingDelete(paneId, m.id);
    } finally {
      ref.invalidate(pendingProvider(paneId));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep the queue live: re-fetch whenever a new snapshot arrives (the server
    // flushes messages as the pane goes idle).
    ref.listen(snapshotProvider, (_, _) {
      ref.invalidate(pendingProvider(paneId));
    });

    final messages =
        ref.watch(pendingProvider(paneId)).valueOrNull?.messages ?? const [];
    if (messages.isEmpty) return const SizedBox.shrink();

    final brightness = Theme.of(context).brightness;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 168),
      decoration: BoxDecoration(
        color: AgentPortTheme.softFill(brightness),
        border: Border(
          top: BorderSide(color: AgentPortTheme.separator(brightness)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 8, 4),
            child: Row(
              children: [
                Icon(Icons.schedule,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  '待发送 ${messages.length}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'Claude 空闲后自动发送',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 6),
              itemCount: messages.length,
              itemBuilder: (context, i) => _PendingRow(
                message: messages[i],
                onEdit: () => _edit(context, ref, messages[i]),
                onDelete: () => _delete(ref, messages[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingRow extends StatelessWidget {
  const _PendingRow({
    required this.message,
    required this.onEdit,
    required this.onDelete,
  });
  final PendingMessage message;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 3, 6, 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              message.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 13,
                height: 1.25,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            visualDensity: VisualDensity.compact,
            tooltip: '编辑',
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            visualDensity: VisualDensity.compact,
            tooltip: '删除',
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

