import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/theme.dart';
import '../../data/models/pane.dart';
import '../../data/models/pane_ext.dart';
import '../../data/models/server_profile.dart';
import '../../data/models/snapshot.dart';
import '../../services/settings_service.dart';
import '../../services/snapshot_service.dart';
import '../onboarding/onboarding_view.dart';
import 'agent_avatar.dart';

class MonitorPage extends ConsumerWidget {
  const MonitorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    return settingsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
    final snap = snapAsync.valueOrNull;
    final reachable = snap?.ok ?? false;
    final profiles = settings?.profiles ?? const <ServerProfile>[];
    final activeId = settings?.activeProfileId ?? '';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: _MachineTabBar(
          profiles: profiles,
          activeId: activeId,
          reachable: reachable,
          device: snap?.device,
          onSelect: (id) =>
              ref.read(settingsProvider.notifier).setActive(id),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: '设置',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: snapAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorState(
          message: '$e',
          onRetry: () => ref.invalidate(snapshotProvider),
        ),
        data: (snap) => _Body(snapshot: snap),
      ),
    );
  }
}

/// Horizontal, scrollable server chips (MonitorView.swift `MachineTabBar`).
/// Only the active server is polled, so its chip shows the live green/grey
/// status dot; inactive chips render grey until selected.
class _MachineTabBar extends StatelessWidget {
  const _MachineTabBar({
    required this.profiles,
    required this.activeId,
    required this.reachable,
    required this.device,
    required this.onSelect,
  });

  final List<ServerProfile> profiles;
  final String activeId;
  final bool reachable;
  final DeviceInfo? device;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return const Text('Agent Port');
    }
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: profiles.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final p = profiles[i];
          final active = p.id == activeId;
          return _MachineChip(
            profile: p,
            active: active,
            online: active && reachable,
            device: active ? device : null,
            onTap: () => onSelect(p.id),
          );
        },
      ),
    );
  }
}

class _MachineChip extends StatelessWidget {
  const _MachineChip({
    required this.profile,
    required this.active,
    required this.online,
    required this.device,
    required this.onTap,
  });

  final ServerProfile profile;
  final bool active;
  final bool online;
  final DeviceInfo? device;
  final VoidCallback onTap;

  IconData get _deviceIcon {
    final haystack = [
      profile.name,
      device?.kind,
      device?.modelIdentifier,
      device?.modelName,
      device?.name,
    ].whereType<String>().join(' ').toLowerCase();
    if (haystack.contains('macbook') || haystack.contains('laptop')) {
      return Icons.laptop_mac;
    }
    if (haystack.contains('imac') ||
        haystack.contains('studio') ||
        haystack.contains('mini')) {
      return Icons.desktop_mac;
    }
    return Icons.computer;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    return Material(
      color: active ? AgentPortTheme.softFill(b) : Colors.transparent,
      shape: StadiumBorder(
        side: BorderSide(
          color: active ? AgentPortTheme.separator(b) : Colors.transparent,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_deviceIcon, size: 16, color: theme.colorScheme.onSurface),
              const SizedBox(width: 7),
              Text(
                profile.name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 7),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: online ? const Color(0xFF34C759) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
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
    final panes = sortedPanes(snapshot.panes);
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      itemCount: panes.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        if (i == panes.length) return const _ProductFooter();
        return _PaneCard(pane: panes[i]);
      },
    );
  }
}

/// White rounded card row (MonitorView.swift `PaneListItem`):
/// avatar + project name + time + cleaned title + chevron.
class _PaneCard extends StatelessWidget {
  const _PaneCard({required this.pane});
  final Pane pane;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    return Material(
      color: AgentPortTheme.surface(b),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          if (pane.id.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('该会话 pane id 为空,无法打开详情')),
            );
            return;
          }
          context.push('/pane/${pane.id}');
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AgentPortTheme.separator(b)),
            boxShadow: [
              BoxShadow(
                color: AgentPortTheme.cardShadow(b),
                blurRadius: b == Brightness.dark ? 12 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AgentAvatar(session: pane.session, size: 44),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              pane.projectName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _timeOfDay(pane.updatedAt),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        pane.displayTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.chevron_right,
                    size: 18, color: theme.colorScheme.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductFooter extends StatelessWidget {
  const _ProductFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 18),
      child: Center(
        child: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snap) {
            final info = snap.data;
            final text = info == null
                ? 'Agent Port'
                : 'Agent Port · v${info.version} (${info.buildNumber})';
            return Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.72),
              ),
            );
          },
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

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 40),
            const SizedBox(height: 12),
            Text('连接失败:\n$message', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}

String _timeOfDay(String iso) {
  final dt = DateTime.tryParse(iso)?.toLocal();
  if (dt == null) return '';
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
