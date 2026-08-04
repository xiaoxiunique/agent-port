import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          const Divider(height: 1),
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
    final failed = job.status == 'failure';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text(job.status),
                backgroundColor: failed
                    ? theme.colorScheme.errorContainer
                    : theme.colorScheme.surfaceContainerHighest,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 8),
              if (job.durationMs case final ms?)
                Text('耗时 ${(ms / 1000).toStringAsFixed(1)}s',
                    style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(job.script, style: theme.textTheme.bodySmall),
          if (job.error case final e? when e.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(e, style: TextStyle(color: theme.colorScheme.error)),
          ],
        ],
      ),
    );
  }
}
