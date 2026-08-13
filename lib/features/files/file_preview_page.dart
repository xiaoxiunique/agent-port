import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/models/files.dart';
import '../../services/api_provider.dart';
import '../../services/file_service.dart';
import 'file_browser_page.dart';

/// Inline preview of one file.
///
/// Three shapes, decided by the host: text renders inline, images and video
/// render from the download URL (which serves the correct content type), and
/// anything else offers a download.
class FilePreviewPage extends ConsumerWidget {
  const FilePreviewPage({super.key, required this.entry});
  final FileEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(filePreviewProvider(entry.path));
    final preview = async.valueOrNull;
    final isImage = preview?.media == 'image';

    return Scaffold(
      // Images read better against black, like a photo viewer.
      backgroundColor: isImage ? Colors.black : null,
      appBar: AppBar(
        backgroundColor: isImage ? Colors.black : null,
        foregroundColor: isImage ? Colors.white : null,
        title: Text(entry.name, overflow: TextOverflow.ellipsis),
        actions: [
          if (preview?.text ?? false)
            IconButton(
              tooltip: '复制',
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: preview!.content));
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
        data: (p) => switch (p.media) {
          'image' => _ImageBody(entry: entry),
          'video' => _VideoBody(entry: entry, size: p.size),
          'audio' => _AudioBody(entry: entry, size: p.size),
          _ => p.text
              ? _TextBody(content: p.content)
              : _NotPreviewable(preview: p, entry: entry, theme: theme),
        },
      ),
    );
  }
}

/// Pinch-to-zoom image, streamed from the download endpoint.
class _ImageBody extends ConsumerWidget {
  const _ImageBody({required this.entry});
  final FileEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.read(apiProvider).fileDownloadUrl(entry.path);
    return Center(
      child: InteractiveViewer(
        minScale: 0.8,
        maxScale: 5,
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            final total = progress.expectedTotalBytes;
            return Center(
              child: CircularProgressIndicator(
                value: total == null
                    ? null
                    : progress.cumulativeBytesLoaded / total,
              ),
            );
          },
          errorBuilder: (context, _, _) => _Failed(
            entry: entry,
            message: '图片加载失败',
          ),
        ),
      ),
    );
  }
}

/// Video hands off to the system player rather than embedding one: these
/// projects hold four video files, which doesn't justify a player dependency
/// (and the extra iOS build surface that comes with it).
class _VideoBody extends ConsumerWidget {
  const _VideoBody({required this.entry, required this.size});
  final FileEntry entry;
  final int size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
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
                color: AgentPortTheme.elevatedSurface(theme.brightness),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.play_circle_outline,
                  size: 32, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(entry.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              humanSize(size),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => downloadEntry(context, ref, entry),
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('播放'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Audio hands off to the system player too — same reasoning as video: no
/// in-app player dependency, iOS/Android just opens the downloaded file.
class _AudioBody extends ConsumerWidget {
  const _AudioBody({required this.entry, required this.size});
  final FileEntry entry;
  final int size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
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
                color: AgentPortTheme.elevatedSurface(theme.brightness),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.music_note,
                  size: 32, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(entry.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              humanSize(size),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => downloadEntry(context, ref, entry),
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('播放'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextBody extends StatelessWidget {
  const _TextBody({required this.content});  final String content;

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

class _Failed extends ConsumerWidget {
  const _Failed({required this.entry, required this.message});
  final FileEntry entry;
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.broken_image, size: 44, color: Colors.white54),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () => downloadEntry(context, ref, entry),
            child: const Text('下载'),
          ),
        ],
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
              humanSize(preview.size),
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
