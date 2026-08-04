import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/models/cron.dart';
import '../../services/cron_service.dart';

/// One job's captured output.
///
/// Logs are fetched here rather than with the job list because they're large —
/// tens of MB across all history on a real host — and the service truncates
/// from the front, so what's shown always ends at the most recent output.
class CronJobLogPage extends ConsumerWidget {
  const CronJobLogPage({super.key, required this.job});
  final CronJob job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(cronLogProvider(job.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(job.script.split('/').last),
        actions: [
          if (async.valueOrNull case final logs? when logs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: '复制日志',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: logs));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已复制')),
                );
              },
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(job: job),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('读取日志失败:$e')),
              data: (logs) => logs.isEmpty
                  ? Center(
                      child: Text('没有输出', style: TextStyle(color: theme.hintColor)),
                    )
                  : Container(
                      color: const Color(0xFF1E1E1E),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: SelectableText(
                          logs,
                          style: const TextStyle(
                            color: Color(0xFFD4D4D4),
                            fontFamily: 'monospace',
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.job});
  final CronJob job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    final failed = job.status == 'failure';
    final statusColor = switch (job.status) {
      'success' => Colors.green,
      'failure' => theme.colorScheme.error,
      'running' => Colors.blue,
      _ => theme.hintColor,
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Material(
        color: AgentPortTheme.surface(b),
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      job.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (job.durationMs case final ms?)
                    Text('耗时 ${(ms / 1000).toStringAsFixed(1)}s',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.hintColor)),
                ],
              ),
              const SizedBox(height: 10),
              SelectableText(
                job.script,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor),
              ),
              if (failed && (job.error?.isNotEmpty ?? false)) ...[
                const SizedBox(height: 8),
                Text(job.error!,
                    style: TextStyle(color: theme.colorScheme.error)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
