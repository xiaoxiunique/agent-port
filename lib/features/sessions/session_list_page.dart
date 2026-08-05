import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/models/sessions.dart';
import '../../services/api_provider.dart';
import '../../services/demo_data.dart';
import '../../services/session_service.dart';

/// Past Claude Code and Codex conversations for one project.
///
/// Tapping one reopens it in a *separate* session, so whatever is already
/// running in the project's main session keeps going. The suffix that
/// distinguishes it is asked for on tap.
class SessionListPage extends ConsumerStatefulWidget {
  const SessionListPage({super.key, required this.path, this.title});

  /// Project directory whose conversations to list.
  final String path;
  final String? title;

  @override
  ConsumerState<SessionListPage> createState() => _SessionListPageState();
}

class _SessionListPageState extends ConsumerState<SessionListPage> {
  /// Set while a resume request is in flight, to block a second tap.
  String? _resuming;

  Future<void> _open(String agent, PastSession session) async {
    if (_resuming != null) return;

    if (ref.read(demoModeProvider)) {
      _toast('演示模式下无法恢复会话');
      return;
    }

    final suffix = await _askSuffix(session);
    if (suffix == null || !mounted) return;

    setState(() => _resuming = session.id);
    try {
      final name = await ref.read(apiProvider).resumeSession(
            path: widget.path,
            agent: agent,
            sessionId: session.id,
            suffix: suffix,
          );
      if (mounted) _toast('已在 $name 中打开');
    } catch (e) {
      if (mounted) _toast('恢复失败:$e');
    } finally {
      if (mounted) setState(() => _resuming = null);
    }
  }

  /// Ask for the suffix that names the new session. Pre-filled with a short
  /// default so confirming straight away still produces a usable name.
  Future<String?> _askSuffix(PastSession session) {
    final controller = TextEditingController(text: 'resume');
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('新会话后缀'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (session.summary != null) ...[
              Text(
                session.summary!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(ctx).hintColor, fontSize: 13),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: controller,
              autofocus: true,
              maxLength: 24,
              decoration: const InputDecoration(
                hintText: '例如 debug、试验',
                helperText: '会话名会加上这个后缀,不影响正在运行的会话',
              ),
              onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('打开'),
          ),
        ],
      ),
    ).then((v) => (v == null || v.isEmpty) ? null : v);
  }

  void _toast(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(projectSessionsProvider(widget.path));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '历史会话', overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: '刷新',
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () =>
                ref.invalidate(projectSessionsProvider(widget.path)),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _Error(
          error: e,
          onRetry: () => ref.invalidate(projectSessionsProvider(widget.path)),
        ),
        data: (agents) {
          final total =
              agents.fold<int>(0, (n, a) => n + a.sessions.length);
          if (total == 0) return const _Empty();

          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(projectSessionsProvider(widget.path)),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                for (final group in agents)
                  if (group.sessions.isNotEmpty) ...[
                    _GroupHeader(agent: group.agent, count: group.sessions.length),
                    for (final s in group.sessions) ...[
                      _SessionCard(
                        session: s,
                        agent: group.agent,
                        busy: _resuming == s.id,
                        onTap: () => _open(group.agent, s),
                      ),
                      const SizedBox(height: 8),
                    ],
                    const SizedBox(height: 10),
                  ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.agent, required this.count});
  final String agent;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 10),
      child: Row(
        children: [
          Icon(_iconFor(agent), size: 15, color: _tintFor(agent, theme)),
          const SizedBox(width: 6),
          Text(
            _labelFor(agent),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          Text('$count', style: TextStyle(fontSize: 12, color: theme.hintColor)),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.session,
    required this.agent,
    required this.busy,
    required this.onTap,
  });

  final PastSession session;
  final String agent;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    final tint = _tintFor(agent, theme);

    return Material(
      color: AgentPortTheme.surface(b),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: busy ? null : onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: b == Brightness.dark
                ? Border.all(color: AgentPortTheme.separator(b))
                : null,
            boxShadow: [
              BoxShadow(
                color: AgentPortTheme.cardShadow(b),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: tint.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(_iconFor(agent), size: 18, color: tint),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        session.summary ?? '(无描述)',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: session.summary == null
                              ? theme.hintColor
                              : null,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${_relativeTime(session.modified)} · '
                        '${_humanSize(session.size)} · '
                        '${_shortId(session.id)}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (busy)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(Icons.play_circle_outline,
                      size: 20, color: theme.colorScheme.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Icon(Icons.history_toggle_off, size: 44, color: theme.hintColor),
        const SizedBox(height: 12),
        Center(
          child: Text('这个项目还没有会话记录',
              style: TextStyle(color: theme.hintColor)),
        ),
      ],
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 100),
        Icon(Icons.history_toggle_off,
            size: 44, color: Theme.of(context).hintColor),
        const SizedBox(height: 12),
        Center(child: Text('无法读取会话:$error', textAlign: TextAlign.center)),
        const SizedBox(height: 12),
        Center(
          child: FilledButton.tonal(onPressed: onRetry, child: const Text('重试')),
        ),
      ],
    );
  }
}

IconData _iconFor(String agent) =>
    agent == 'codex' ? Icons.code : Icons.terminal;

Color _tintFor(String agent, ThemeData theme) =>
    agent == 'codex' ? Colors.teal : theme.colorScheme.primary;

String _labelFor(String agent) =>
    agent == 'codex' ? 'Codex' : 'Claude Code';

/// First 8 characters — what the agents' own resume pickers show.
String _shortId(String id) => id.length <= 8 ? id : id.substring(0, 8);

String _humanSize(int bytes) {
  if (bytes < 1024) return '${bytes}B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).round()}KB';
  return '${(bytes / 1024 / 1024).toStringAsFixed(1)}MB';
}

String _relativeTime(double epochSeconds) {
  if (epochSeconds <= 0) return '未知';
  final then = DateTime.fromMillisecondsSinceEpoch(
      (epochSeconds * 1000).round());
  final delta = DateTime.now().difference(then);
  if (delta.isNegative || delta.inMinutes < 1) return '刚刚';
  if (delta.inHours < 1) return '${delta.inMinutes}分钟前';
  if (delta.inDays < 1) return '${delta.inHours}小时前';
  return '${delta.inDays}天前';
}
