import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/models/files.dart';
import '../../services/file_service.dart';
import 'file_browser_page.dart';

/// Entry point for file browsing: the project directories the host allows.
///
/// The host derives these from the projects it already knows (live pane cwds
/// and project history) and refuses anything outside them, so this list is
/// also the boundary of what the app can reach.
class FileRootsPage extends ConsumerWidget {
  const FileRootsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(fileRootsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('文件'),
        actions: [
          IconButton(
            tooltip: '刷新',
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () => ref.invalidate(fileRootsProvider),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _Error(
          error: e,
          onRetry: () => ref.invalidate(fileRootsProvider),
        ),
        data: (roots) => roots.isEmpty
            ? const _Empty()
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(fileRootsProvider),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                  itemCount: roots.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _RootCard(root: roots[i]),
                ),
              ),
      ),
    );
  }
}

class _RootCard extends StatelessWidget {
  const _RootCard({required this.root});
  final FileRoot root;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    return Material(
      color: AgentPortTheme.surface(b),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => FileBrowserPage(path: root.path, title: root.name),
        )),
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
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(Icons.folder,
                      size: 20, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        root.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        root.path,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.hintColor),
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

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 140),
        Icon(Icons.folder_off, size: 44, color: theme.hintColor),
        const SizedBox(height: 12),
        Center(
          child: Text('没有可浏览的项目目录',
              style: TextStyle(color: theme.hintColor)),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text('先在电脑上启动一个 agent 会话',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
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
