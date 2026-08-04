import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cron.dart';
import '../../services/cron_service.dart';
import 'cron_job_log_page.dart';

/// CronBox scheduled jobs: what's scheduled, what ran, and what failed.
///
/// Only reachable when `capabilities.cronbox` is true, so this never has to
/// render a "CronBox isn't installed" state.
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
        title: const Text('定时任务'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: '刷新',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('计划'), icon: Icon(Icons.schedule)),
                ButtonSegment(value: 1, label: Text('运行记录'), icon: Icon(Icons.history)),
              ],
              selected: {_tab},
              onSelectionChanged: (s) => setState(() => _tab = s.first),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _tab == 0 ? const _SchedulesList() : const _JobsList(),
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
      error: (e, _) => _ErrorView(error: e, onRetry: () => ref.invalidate(cronSchedulesProvider)),
      data: (schedules) {
        if (schedules.isEmpty) {
          return const _EmptyView(icon: Icons.schedule, text: '还没有定时任务');
        }
        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 96),
          itemCount: schedules.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) => _ScheduleTile(schedule: schedules[i]),
        );
      },
    );
  }
}

class _ScheduleTile extends ConsumerWidget {
  const _ScheduleTile({required this.schedule});
  final CronSchedule schedule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final name = schedule.script.split('/').last;
    return ListTile(
      leading: Icon(
        schedule.enabled ? Icons.play_circle : Icons.pause_circle,
        color: schedule.enabled ? Colors.green : theme.hintColor,
      ),
      title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            schedule.cron,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.primary,
            ),
          ),
          if (schedule.nextRunAt case final next?)
            Text(
              schedule.enabled ? '下次 ${_shortTime(next)}' : '已暂停',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
        ],
      ),
      isThreeLine: schedule.nextRunAt != null,
      trailing: PopupMenuButton<String>(
        onSelected: (action) => _act(context, ref, action),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: schedule.enabled ? 'disable' : 'enable',
            child: ListTile(
              dense: true,
              leading: Icon(schedule.enabled ? Icons.pause : Icons.play_arrow),
              title: Text(schedule.enabled ? '暂停' : '启用'),
            ),
          ),
          const PopupMenuItem(
            value: 'trigger',
            child: ListTile(
              dense: true,
              leading: Icon(Icons.bolt),
              title: Text('立即运行'),
            ),
          ),
        ],
      ),
      onTap: () => _showHistory(context, schedule),
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
          // the outcome — the job appears in 运行记录 as it progresses.
          _ => '已触发,稍后在运行记录中查看',
        }),
      ));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('操作失败:$e')));
    }
  }

  void _showHistory(BuildContext context, CronSchedule s) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _ScheduleHistoryPage(schedule: s),
    ));
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
          onRetry: () => ref.invalidate(cronJobsForScheduleProvider(schedule.id)),
        ),
        data: (jobs) => jobs.isEmpty
            ? const _EmptyView(icon: Icons.history, text: '还没有运行记录')
            : ListView.separated(
                itemCount: jobs.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, i) => _JobTile(job: jobs[i]),
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
      error: (e, _) => _ErrorView(error: e, onRetry: () => ref.invalidate(cronJobsProvider)),
      data: (jobs) {
        if (jobs.isEmpty) {
          return const _EmptyView(icon: Icons.history, text: '还没有运行记录');
        }
        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 96),
          itemCount: jobs.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, i) => _JobTile(job: jobs[i]),
        );
      },
    );
  }
}

class _JobTile extends StatelessWidget {
  const _JobTile({required this.job});
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
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        job.script.split('/').last,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        [
          _shortTime(job.createdAt),
          if (job.durationMs case final ms?) _duration(ms),
          if (job.error?.isNotEmpty ?? false) job.error!,
        ].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall,
      ),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CronJobLogPage(job: job),
      )),
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
        const SizedBox(height: 120),
        Icon(icon, size: 48, color: theme.hintColor),
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
        const SizedBox(height: 100),
        Icon(Icons.cloud_off, size: 48, color: Theme.of(context).hintColor),
        const SizedBox(height: 12),
        Center(child: Text('读取失败:$error', textAlign: TextAlign.center)),
        const SizedBox(height: 12),
        Center(child: FilledButton.tonal(onPressed: onRetry, child: const Text('重试'))),
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
