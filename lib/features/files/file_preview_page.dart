import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/models/files.dart';
import '../../services/file_service.dart';
import 'file_browser_page.dart';

/// Inline preview of one file, with a download fallback.
///
/// The host only returns text it considers previewable — UTF-8 and under its
/// size cap. Anything else comes back flagged, and this offers the download
/// instead of rendering mojibake.
class FilePreviewPage extends ConsumerWidget {
  const FilePreviewPage({super.key, required this.entry});
  final FileEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(filePreviewProvider(entry.path));

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.name, overflow: TextOverflow.ellipsis),
        actions: [
          if (async.valueOrNull?.text ?? false)
            IconButton(
              tooltip: '复制',
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: async.value!.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已复制')),
                );
              },
            ),
          IconButton(
            tooltip: '下载',
            icon: const Icon(Icons.download, size: 20),
            onPressed: () => downloadEntry(context, ref, entry),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('无法读取:$e', textAlign: TextAlign.center),
          ),
        ),
        data: (preview) => preview.text
            ? _TextBody(content: preview.content)
            : _NotPreviewable(preview: preview, entry: entry, theme: theme),
      ),
    );
  }
}

class _TextBody extends StatelessWidget {
  const _TextBody({required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    // Dark code surface regardless of theme, matching the terminal and the
    // cron log view.
    return Container(
      color: const Color(0xFF1E1E1E),
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SelectableText(
          content,
          style: const TextStyle(
            color: Color(0xFFD4D4D4),
            fontFamily: 'monospace',
            fontSize: 12,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

class _NotPreviewable extends ConsumerWidget {
  const _NotPreviewable({
    required this.preview,
    required this.entry,
    required this.theme,
  });

  final FilePreview preview;
  final FileEntry entry;
  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = theme.brightness;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: AgentPortTheme.elevatedSurface(b),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.insert_drive_file,
                  size: 30, color: theme.hintColor),
            ),
            const SizedBox(height: 16),
            Text(
              preview.reason == 'too large to preview'
                  ? '文件较大,无法在线预览'
                  : '这是二进制文件,无法预览',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              _humanSize(preview.size),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => downloadEntry(context, ref, entry),
              icon: const Icon(Icons.download, size: 18),
              label: const Text('下载'),
            ),
          ],
        ),
      ),
    );
  }
}

String _humanSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
  }
  return '${(bytes / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
}
