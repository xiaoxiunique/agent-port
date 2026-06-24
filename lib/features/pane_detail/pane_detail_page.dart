import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/models/pane.dart';
import '../../data/models/pane_ext.dart';
import '../../services/api_provider.dart';
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

    // The console/terminal screen is always dark (matches the native detail
    // sheet), regardless of the system theme.
    return Theme(
      data: AgentPortTheme.dark,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title, overflow: TextOverflow.ellipsis),
          actions: [
            if (foundPane != null && !kIsWeb && Platform.isIOS)
              IconButton(
                icon: const Icon(Icons.picture_in_picture),
                tooltip: '画中画',
                onPressed: () async {
                  if (await PipService.isSupported) {
                    await PipService.start(
                      title: foundPane.command.isNotEmpty
                          ? foundPane.command
                          : foundPane.session,
                      status: foundPane.status.name,
                      body: foundPane.tail,
                    );
                  }
                },
              ),
          ],
        ),
        body: foundPane == null
            ? const Center(child: Text('pane 不在当前快照'))
            : Column(
                children: [
                  Expanded(
                    child: _mode == RuntimeMode.terminal
                        ? TerminalPaneView(
                            api: ref.read(apiProvider),
                            paneId: widget.paneId,
                          )
                        : _LogView(pane: foundPane),
                  ),
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

  @override
  void initState() {
    super.initState();
    _service = _make();
    _service.addListener(_onLog);
  }

  PaneLogService _make() => PaneLogService(
        api: ref.read(apiProvider),
        paneId: widget.pane.id,
        initialTail: widget.pane.tail,
      );

  @override
  void didUpdateWidget(_LogView old) {
    super.didUpdateWidget(old);
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
    _service.removeListener(_onLog);
    _service.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _service.text;
    return Column(
      children: [
        _StatusHeader(pane: widget.pane, state: _service.state),
        Expanded(
          child: Stack(
            children: [
              if (text.isEmpty)
                const Center(
                  child: Text('暂无运行输出',
                      style: TextStyle(color: Colors.white38)),
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
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        height: 1.3,
                        color: AgentPortTheme.terminalForeground,
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
    final color = statusColor(pane.status, Brightness.dark);
    final reason = pane.reason.trim();
    final connecting =
        state == PaneLogState.connecting || state == PaneLogState.reconnecting;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      color: Colors.white.withValues(alpha: 0.04),
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
                style: const TextStyle(color: Colors.white54, fontSize: 12),
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
    return Material(
      color: Colors.white.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

