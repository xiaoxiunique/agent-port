import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/agent_event.dart';
import '../../services/api_provider.dart';
import '../../data/models/enums.dart';

/// Agent event timeline for a pane (`GET /api/pane/events`).
class StatusTab extends ConsumerStatefulWidget {
  const StatusTab({super.key, required this.paneId});
  final String paneId;

  @override
  ConsumerState<StatusTab> createState() => _StatusTabState();
}

class _StatusTabState extends ConsumerState<StatusTab> {
  Future<AgentEventsResponse>? _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(apiProvider).paneEvents(widget.paneId);
  }

  void _reload() {
    setState(() {
      _future = ref.read(apiProvider).paneEvents(widget.paneId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AgentEventsResponse>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('加载失败: ${snap.error}'),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: _reload, child: const Text('重试')),
              ],
            ),
          );
        }
        final events = snap.data?.events ?? const [];
        if (events.isEmpty) {
          return const Center(child: Text('暂无 agent 事件'));
        }
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: events.length,
            itemBuilder: (_, i) => _EventTile(event: events[i]),
          ),
        );
      },
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});
  final AgentEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(_icon(event.kind), color: theme.colorScheme.primary),
        title:
            Text(event.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.body.isNotEmpty)
              Text(event.body, maxLines: 3, overflow: TextOverflow.ellipsis),
            if (event.toolName != null)
              Text('tool: ${event.toolName}', style: theme.textTheme.labelSmall),
          ],
        ),
        trailing: Text(
          _time(event.createdAt),
          style: theme.textTheme.labelSmall,
        ),
      ),
    );
  }

  IconData _icon(AgentEventKind k) => switch (k) {
        AgentEventKind.text => Icons.text_snippet,
        AgentEventKind.toolCall => Icons.build,
        AgentEventKind.toolResult => Icons.check_circle_outline,
        AgentEventKind.turn => Icons.refresh,
        AgentEventKind.status => Icons.info_outline,
      };

  String _time(String s) => s.length >= 19 ? s.substring(11, 19) : s;
}
