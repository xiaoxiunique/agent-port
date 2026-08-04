import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme.dart';
import '../../data/models/files.dart';
import '../../services/api_provider.dart';
import '../../services/file_service.dart';
import 'file_preview_page.dart';

/// Browse a project directory on the host and download from it.
///
/// Read-only by design. The host restricts every request to the project
/// directories it already knows about, so navigation can't leave them; "up"
/// stops at the listing's declared root.
class FileBrowserPage extends ConsumerStatefulWidget {
  const FileBrowserPage({super.key, required this.path, this.title});

  /// Directory to open. Must be inside one of the host's browsable roots.
  final String path;
  final String? title;

  @override
  ConsumerState<FileBrowserPage> createState() => _FileBrowserPageState();
}

class _FileBrowserPageState extends ConsumerState<FileBrowserPage> {
  late String _path = widget.path;
  bool _showAll = false;

  void _open(FileEntry entry) {
    if (entry.isDir) {
      setState(() => _path = entry.path);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => FilePreviewPage(entry: entry),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = (path: _path, showAll: _showAll);
    final async = ref.watch(fileListProvider(args));
    final name = _path.split('/').last;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? name, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: _showAll ? '隐藏构建/隐藏文件' : '显示全部文件',
            icon: Icon(_showAll ? Icons.visibility : Icons.visibility_off,
                size: 20),
            onPressed: () => setState(() => _showAll = !_showAll),
          ),
          IconButton(
            tooltip: '刷新',
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () => ref.invalidate(fileListProvider(args)),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _Error(
          error: e,
          onRetry: () => ref.invalidate(fileListProvider(args)),
        ),
        data: (listing) => Column(
          children: [
            _Breadcrumb(
              path: listing.path,
              root: listing.root,
              onNavigate: (p) => setState(() => _path = p),
            ),
            Expanded(
              child: listing.entries.isEmpty
                  ? const _Empty()
                  : RefreshIndicator(
                      onRefresh: () async =>
                          ref.invalidate(fileListProvider(args)),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: listing.entries.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => _EntryCard(
                          entry: listing.entries[i],
                          onTap: () => _open(listing.entries[i]),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Path segments from the root down to the current directory. Navigation stops
/// at the root because anything above it is refused by the host.
class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({
    required this.path,
    required this.root,
    required this.onNavigate,
  });

  final String path;
  final String root;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rootName = root.split('/').last;
    final rest = path.length > root.length
        ? path.substring(root.length).split('/').where((s) => s.isNotEmpty).toList()
        : <String>[];

    final crumbs = <(String, String)>[(rootName, root)];
    var acc = root;
    for (final seg in rest) {
      acc = '$acc/$seg';
      crumbs.add((seg, acc));
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: crumbs.length,
        separatorBuilder: (_, _) => Icon(Icons.chevron_right,
            size: 15, color: theme.colorScheme.outline),
        itemBuilder: (_, i) {
          final (label, target) = crumbs[i];
          final last = i == crumbs.length - 1;
          return Center(
            child: GestureDetector(
              onTap: last ? null : () => onNavigate(target),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: last ? FontWeight.w600 : FontWeight.w400,
                  color: last
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.primary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry, required this.onTap});
  final FileEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    final (icon, tint) = _iconFor(entry, theme);

    return Material(
      color: AgentPortTheme.surface(b),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
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
                  child: Icon(icon, size: 18, color: tint),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        entry.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      if (!entry.isDir) ...[
                        const SizedBox(height: 2),
                        Text(
                          humanSize(entry.size),
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.hintColor),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  entry.isDir ? Icons.chevron_right : Icons.more_horiz,
                  size: 18,
                  color: theme.colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  (IconData, Color) _iconFor(FileEntry e, ThemeData theme) {
    if (e.isDir) return (Icons.folder, theme.colorScheme.primary);
    final ext = e.name.contains('.') ? e.name.split('.').last.toLowerCase() : '';
    return switch (ext) {
      'png' || 'jpg' || 'jpeg' || 'gif' || 'webp' || 'svg' =>
        (Icons.image, Colors.purple),
      'zip' || 'gz' || 'tgz' || 'tar' => (Icons.archive, Colors.brown),
      'pdf' => (Icons.picture_as_pdf, Colors.red),
      'md' => (Icons.article, Colors.blue),
      'json' || 'toml' || 'yaml' || 'yml' => (Icons.data_object, Colors.orange),
      'log' || 'txt' => (Icons.subject, theme.hintColor),
      _ => (Icons.insert_drive_file, theme.hintColor),
    };
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
        Icon(Icons.folder_open, size: 44, color: theme.hintColor),
        const SizedBox(height: 12),
        Center(
          child: Text('这个目录是空的', style: TextStyle(color: theme.hintColor)),
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
        Icon(Icons.folder_off, size: 44, color: Theme.of(context).hintColor),
        const SizedBox(height: 12),
        Center(child: Text('无法打开目录:$error', textAlign: TextAlign.center)),
        const SizedBox(height: 12),
        Center(
          child: FilledButton.tonal(onPressed: onRetry, child: const Text('重试')),
        ),
      ],
    );
  }
}

/// Hand the download URL to the system browser: it streams to the OS
/// downloader, which handles large files and "save to Files" without the app
/// buffering anything.
Future<void> downloadEntry(
  BuildContext context,
  WidgetRef ref,
  FileEntry entry,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final url = ref.read(apiProvider).fileDownloadUrl(entry.path);
  final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  if (!ok) {
    messenger.showSnackBar(const SnackBar(content: Text('无法打开下载链接')));
  }
}

/// Shared by the preview page.
String humanSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
  }
  return '${(bytes / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
}
