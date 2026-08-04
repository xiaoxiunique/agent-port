import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/models/cron.dart';
import '../../services/cron_service.dart';
import 'cron_job_log_page.dart';

/// CronBox scheduled jobs: what's scheduled, what ran, and what failed.
///
/// Only reachable when `capabilities.cronbox` is true, so this never has to
/// render a "CronBox isn't installed" state.
///
/// Styling follows the rest of the app (see monitor_page): a grouped grey page
/// with white rounded cards, hairline strokes in dark mode and a soft shadow in
/// light — not stock Material list tiles.
class CronPage extends ConsumerStatefulWidget {
  const CronPage({super.key});

  @override
  ConsumerState<CronPage> createState() => _CronPageState();
}

class _CronPageState extends ConsumerState<CronPage> {
  int _tab = 0;

  Future<void> _refresh() async {
    ref.invalidate(cronSchedulesProvider);
    ref.invalidate(cronJobsProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: _Segmented(
          index: _tab,
          labels: const ['计划', '运行记录'],
          onChanged: (i) => setState(() => _tab = i),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: _refresh,
            tooltip: '刷新',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _tab == 0 ? const _SchedulesList() : const _JobsList(),
      ),
    );
  }
}

/// Pill-shaped segmented control matching the app's iOS look, in place of
/// Material's [SegmentedButton] (which brings its own outlined styling).
class _Segmented extends StatelessWidget {
  const _Segmented({
    required this.index,
    required this.labels,
    required this.onChanged,
  });

  final int index;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AgentPortTheme.elevatedSurface(b).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AgentPortTheme.separator(b)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < labels.length; i++)
            GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: i == index
                      ? AgentPortTheme.surface(b)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: i == index
                      ? [
                          BoxShadow(
                            color: AgentPortTheme.cardShadow(b),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        i == index ? FontWeight.w600 : FontWeight.w500,
                    color: i == index
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The app's standard white rounded card: hairline stroke in dark, soft shadow
/// in light. Mirrors monitor_page's pane card so the two screens read alike.
class _Card extends StatelessWidget {
  const _Card({required this.child, this.onTap});
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    return Material(
      color: AgentPortTheme.surface(b),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
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
          child: Padding(padding: const EdgeInsets.all(14), child: child),
        ),
      ),
    );
  }
}

class _SchedulesList extends ConsumerWidget {
  const _SchedulesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(cronSchedulesProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(
        error: e,
        onRetry: () => ref.invalidate(cronSchedulesProvider),
      ),
      data: (schedules) {
        if (schedules.isEmpty) {
          return const _EmptyView(icon: Icons.schedule, text: '还没有定时任务');
        }
        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          itemCount: schedules.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, i) => _ScheduleCard(schedule: schedules[i]),
        );
      },
    );
  }
}

class _ScheduleCard extends ConsumerWidget {
  const _ScheduleCard({required this.schedule});
  final CronSchedule schedule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    final on = schedule.enabled;
    return _Card(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => _ScheduleHistoryPage(schedule: schedule),
      )),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (on ? Colors.green : theme.hintColor)
                  .withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              on ? Icons.schedule : Icons.pause,
              size: 20,
              color: on ? Colors.green : theme.hintColor,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  schedule.script.split('/').last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AgentPortTheme.elevatedSurface(b),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        schedule.cron,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontFamily: 'monospace',
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        on
                            ? (schedule.nextRunAt == null
                                ? ''
                                : '下次 ${_shortTime(schedule.nextRunAt!)}')
                            : '已暂停',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.hintColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _ScheduleMenu(schedule: schedule),
        ],
      ),
    );
  }
}

/// Actions for one schedule, presented in a bottom sheet rather than a Material
/// popup menu — closer to the iOS action-sheet idiom the app uses elsewhere.
class _ScheduleMenu extends ConsumerWidget {
  const _ScheduleMenu({required this.schedule});
  final CronSchedule schedule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.more_horiz, color: Theme.of(context).hintColor),
      onPressed: () => _open(context, ref),
    );
  }

  void _open(BuildContext context, WidgetRef ref) {
    final on = schedule.enabled;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(on ? Icons.pause_circle : Icons.play_circle),
              title: Text(on ? '暂停' : '启用'),
              onTap: () {
                Navigator.pop(sheetContext);
                _act(context, ref, on ? 'disable' : 'enable');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bolt),
              title: const Text('立即运行'),
              onTap: () {
                Navigator.pop(sheetContext);
                _act(context, ref, 'trigger');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _act(BuildContext context, WidgetRef ref, String action) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await runCronAction(ref, action: action, id: schedule.id);
      messenger.showSnackBar(SnackBar(
        content: Text(switch (action) {
          'enable' => '已启用',
          'disable' => '已暂停',
          // The run is detached on the host, so this confirms the request, not
          // the outcome — the job shows up in 运行记录 as it progresses.
          _ => '已触发,稍后在运行记录中查看',
        }),
      ));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('操作失败:$e')));
    }
  }
}

/// Runs for a single schedule.
class _ScheduleHistoryPage extends ConsumerWidget {
  const _ScheduleHistoryPage({required this.schedule});
  final CronSchedule schedule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(cronJobsForScheduleProvider(schedule.id));
    return Scaffold(
      appBar: AppBar(title: Text(schedule.script.split('/').last)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          error: e,
          onRetry: () =>
              ref.invalidate(cronJobsForScheduleProvider(schedule.id)),
        ),
        data: (jobs) => jobs.isEmpty
            ? const _EmptyView(icon: Icons.history, text: '还没有运行记录')
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: jobs.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _JobCard(job: jobs[i]),
              ),
      ),
    );
  }
}

class _JobsList extends ConsumerWidget {
  const _JobsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(cronJobsProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          _ErrorView(error: e, onRetry: () => ref.invalidate(cronJobsProvider)),
      data: (jobs) {
        if (jobs.isEmpty) {
          return const _EmptyView(icon: Icons.history, text: '还没有运行记录');
        }
        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          itemCount: jobs.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (_, i) => _JobCard(job: jobs[i]),
        );
      },
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({required this.job});
  final CronJob job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, color) = switch (job.status) {
      'success' => (Icons.check_circle, Colors.green),
      'failure' => (Icons.error, theme.colorScheme.error),
      'running' => (Icons.autorenew, Colors.blue),
      'queued' => (Icons.schedule, theme.hintColor),
      'cancelled' => (Icons.cancel, theme.hintColor),
      _ => (Icons.remove_circle_outline, theme.hintColor),
    };
    final meta = [
      _shortTime(job.createdAt),
      if (job.durationMs case final ms?) _duration(ms),
    ].join(' · ');

    return _Card(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CronJobLogPage(job: job),
      )),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  job.script.split('/').last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
                if (job.error?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 3),
                  Text(
                    job.error!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right,
              size: 18, color: theme.colorScheme.outline),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // A scroll view so pull-to-refresh still works when there's nothing here.
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 140),
        Icon(icon, size: 44, color: theme.hintColor),
        const SizedBox(height: 12),
        Center(child: Text(text, style: TextStyle(color: theme.hintColor))),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        Icon(Icons.cloud_off, size: 44, color: Theme.of(context).hintColor),
        const SizedBox(height: 12),
        Center(child: Text('读取失败:$error', textAlign: TextAlign.center)),
        const SizedBox(height: 12),
        Center(
          child: FilledButton.tonal(onPressed: onRetry, child: const Text('重试')),
        ),
      ],
    );
  }
}

/// `2026-08-04T02:00:00+00:00` → `08-04 10:00`, in local time.
String _shortTime(String iso) {
  final dt = DateTime.tryParse(iso)?.toLocal();
  if (dt == null) return iso;
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}';
}

String _duration(int ms) {
  if (ms < 1000) return '${ms}ms';
  if (ms < 60000) return '${(ms / 1000).toStringAsFixed(1)}s';
  final m = ms ~/ 60000;
  final s = (ms % 60000) ~/ 1000;
  return '${m}m${s}s';
}
