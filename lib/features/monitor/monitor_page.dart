import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final settings = ref.watch(settingsProvider).valueOrNull;
    final snapAsync = ref.watch(snapshotProvider);
    final reachable = snapAsync.valueOrNull?.ok ?? false;

    String profileName = 'Agent Port';
    if (settings != null) {
      for (final p in settings.profiles) {
        if (p.id == settings.activeProfileId) {
          profileName = p.name;
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.circle,
              size: 10,
              color: reachable ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                profileName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
    return ListView.builder(
      itemCount: snapshot.panes.length,
      itemBuilder: (_, i) => _PaneTile(pane: snapshot.panes[i]),
    );
  }
}

/// Simplified row matching the native list: icon + name + subtitle + time + chevron.
class _PaneTile extends StatelessWidget {
  const _PaneTile({required this.pane});
  final Pane pane;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = pane.command.isNotEmpty
        ? pane.command
        : _shortSession(pane.session);
    final subtitle = pane.path.isNotEmpty ? pane.path : pane.session;
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.terminal,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_timeOfDay(pane.updatedAt), style: theme.textTheme.bodySmall),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () {
        if (pane.id.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('该会话 pane id 为空,无法打开详情')),
          );
          return;
        }
        context.push('/pane/${pane.id}');
      },
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

String _shortSession(String session) {
  final parts = session.split('_');
  if (parts.length >= 2) return '${parts[0]} / ${parts[1]}';
  return session;
}

String _timeOfDay(String iso) {
  if (iso.length >= 16) return iso.substring(11, 16);
  return '';
}
