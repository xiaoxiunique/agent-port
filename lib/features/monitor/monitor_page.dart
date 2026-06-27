import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/theme.dart';
import '../../data/models/pane.dart';
import '../../data/models/pane_ext.dart';
import '../../data/models/server_profile.dart';
import '../../data/models/snapshot.dart';
import '../../data/models/token_usage.dart';
import '../../services/api_provider.dart';
import '../../services/settings_service.dart';
import '../../services/snapshot_service.dart';
import '../onboarding/onboarding_view.dart';
import '../settings/settings_view.dart' show ProjectHistoryPage;
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
        actions: const [_UsageChip(), SizedBox(width: 6)],
      ),
      body: snapAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorState(
          message: '$e',
          onRetry: () => ref.invalidate(snapshotProvider),
        ),
        data: (snap) => RefreshIndicator(
          onRefresh: () {
            ref.invalidate(usageProvider);
            return ref.read(snapshotProvider.notifier).refresh();
          },
          child: _Body(snapshot: snap),
        ),
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
      // Scrollable so pull-to-refresh works even with no sessions. The add
      // entry stays reachable so a fresh install can launch its first session.
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
              child: Column(
                children: const [
                  _EmptyState(),
                  SizedBox(height: 16),
                  _AddProjectCard(),
                ],
              ),
            ),
          ),
        ),
      );
    }
    final panes = sortedPanes(snapshot.panes);
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      itemCount: panes.length + 2,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        if (i < panes.length) return _PaneCard(pane: panes[i]);
        if (i == panes.length) return const _AddProjectCard();
        return const _ProductFooter();
      },
    );
  }
}

/// Last item of the home list: opens the recent-projects picker to launch a new
/// Claude/Codex session, so adding doesn't require a trip to Settings.
class _AddProjectCard extends StatelessWidget {
  const _AddProjectCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProjectHistoryPage()),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Row(
              children: [
                Icon(Icons.add_circle_outline,
                    size: 24, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '添加项目',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '从历史项目启动 Claude / Codex',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
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
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (pane.id.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('该会话 pane id 为空,无法打开详情')),
            );
            return;
          }
          // Pane ids contain '%' (e.g. "%14"); encode so go_router doesn't
          // treat it as a percent-escape and corrupt the round-trip.
          context.push('/pane/${Uri.encodeComponent(pane.id)}');
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: b == Brightness.dark
                ? Border.all(color: AgentPortTheme.separator(b))
                : null,
            boxShadow: [
              BoxShadow(
                color: AgentPortTheme.cardShadow(b),
                blurRadius: 10,
                offset: const Offset(0, 2),
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

String _fmtTokens(int n) {
  if (n >= 1000000000) return '${(n / 1e9).toStringAsFixed(1)}B';
  if (n >= 1000000) return '${(n / 1e6).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1e3).toStringAsFixed(1)}K';
  return '$n';
}

/// Compact top-right token-usage readout: Claude + Codex all-time totals.
/// Tap for a per-agent breakdown.
class _UsageChip extends ConsumerWidget {
  const _UsageChip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(usageProvider).valueOrNull;
    if (usage == null || !usage.ok) return const SizedBox.shrink();
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _showUsageDetail(context, usage),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _UsageRow(
              asset: 'assets/claude-avatar.png',
              tokens: usage.claude.totalTokens,
            ),
            const SizedBox(height: 3),
            _UsageRow(
              asset: 'assets/codex-avatar.png',
              tokens: usage.codex.totalTokens,
            ),
          ],
        ),
      ),
    );
  }
}

class _UsageRow extends StatelessWidget {
  const _UsageRow({required this.asset, required this.tokens});
  final String asset;
  final int tokens;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Image.asset(asset, width: 14, height: 14, fit: BoxFit.cover),
        ),
        const SizedBox(width: 5),
        Text(
          _fmtTokens(tokens),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

void _showUsageDetail(BuildContext context, TokenUsage u) {
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Token 用量(累计)'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _usageSection('Claude Code', u.claude),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          _usageSection('Codex', u.codex),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
      ],
    ),
  );
}

Widget _usageSection(String name, AgentUsage a) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      Text('总计 ${_fmtTokens(a.totalTokens)}  ·  \$${a.cost.toStringAsFixed(2)}'),
      Text(
        '输入 ${_fmtTokens(a.inputTokens)} · 输出 ${_fmtTokens(a.outputTokens)}',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ],
  );
}
