import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/enums.dart';
import '../../data/models/pane.dart';
import '../../data/models/snapshot.dart';
import '../../services/settings_service.dart';
import '../../services/snapshot_service.dart';
import '../onboarding/onboarding_view.dart';

class MonitorPage extends ConsumerWidget {
  const MonitorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    return settingsAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Agent Port')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('设置加载失败:\n$e')),
      ),
      data: (s) => s.hasCompletedOnboarding
          ? _monitor(context, ref)
          : const OnboardingView(),
    );
  }

  Widget _monitor(BuildContext context, WidgetRef ref) {
    final snapAsync = ref.watch(snapshotProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent Port'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: snapAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('连接失败:\n$e', textAlign: TextAlign.center),
          ),
        ),
        data: (snap) => _Body(snapshot: snap),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.snapshot});
  final Snapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.panes.isEmpty) {
      return const _EmptyState();
    }
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (snapshot.system != null)
          _SystemStrip(stats: snapshot.system!, device: snapshot.device),
        ...snapshot.panes.map((p) => _PaneTile(pane: p)),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SystemStrip extends StatelessWidget {
  const _SystemStrip({required this.stats, this.device});
  final SystemStats stats;
  final DeviceInfo? device;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border:
            Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: Row(
        children: [
          if (device != null) ...[
            Icon(Icons.laptop_mac, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                device!.modelName,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          _Metric(label: 'CPU', value: stats.cpuUsage),
          _Metric(label: 'MEM', value: stats.memoryUsage),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final num? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = value == null ? '—' : '${value!.toStringAsFixed(0)}%';
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          Text(pct, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _PaneTile extends StatelessWidget {
  const _PaneTile({required this.pane});
  final Pane pane;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title =
        pane.command.isNotEmpty ? pane.command : _shortSession(pane.session);
    final subtitle = pane.path.isNotEmpty ? pane.path : pane.session;
    final lastLine = _lastLine(pane.tail);

    return Container(
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: statusColor(pane.status)),
            Expanded(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusChip(status: pane.status),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    if (lastLine != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          lastLine,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  if (pane.id.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          '该会话 pane id 为空(异常 session 名),无法打开详情。'
                          '用 tmux new -s <name> 建正常会话来测试终端。',
                        ),
                      ),
                    );
                    return;
                  }
                  context.push('/pane/${pane.id}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final PaneStatus status;

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        statusLabel(status),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.terminal,
                size: 48, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            const Text('没有运行中的 tmux 会话'),
            const SizedBox(height: 4),
            Text('在目标机器上启动 tmux + agent', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

// --- helpers ---

Color statusColor(PaneStatus s) => switch (s) {
      PaneStatus.running => Colors.blue,
      PaneStatus.waiting => Colors.amber,
      PaneStatus.failed => Colors.redAccent,
      PaneStatus.done => Colors.green,
      PaneStatus.idle => Colors.grey,
    };

String statusLabel(PaneStatus s) => switch (s) {
      PaneStatus.running => 'running',
      PaneStatus.waiting => 'waiting',
      PaneStatus.failed => 'failed',
      PaneStatus.done => 'done',
      PaneStatus.idle => 'idle',
    };

String _shortSession(String session) {
  final parts = session.split('_');
  if (parts.length >= 2) return '${parts[0]} / ${parts[1]}';
  return session;
}

String? _lastLine(String tail) {
  final lines = tail.split('\n').where((l) => l.trim().isNotEmpty).toList();
  return lines.isEmpty ? null : lines.last;
}
