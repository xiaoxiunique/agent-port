import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

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

/// In-app audio player. Streams from the host via the download endpoint and
/// offers play/pause, seek and a time readout — no handoff to the system
/// player. A single instance is created per preview, so leaving the page
/// stops playback.
class _AudioBody extends ConsumerStatefulWidget {
  const _AudioBody({required this.entry, required this.size});
  final FileEntry entry;
  final int size;

  @override
  ConsumerState<_AudioBody> createState() => _AudioBodyState();
}

class _AudioBodyState extends ConsumerState<_AudioBody> {
  AudioPlayer? _player;
  bool _ready = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final url = ref.read(apiProvider).fileDownloadUrl(widget.entry.path);
    final player = AudioPlayer();
    _player = player;
    try {
      await player.setUrl(url);
      if (mounted) setState(() => _ready = true);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  String _fmt(Duration? d) {
    if (d == null) return '--:--';
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final player = _player;

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
            Text(widget.entry.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              humanSize(widget.size),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 20),

            if (_error.isNotEmpty)
              Text(_error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.error, fontSize: 13))
            else if (!_ready)
              const SizedBox(
                  width: 28, height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2.5))
            else
              _PlayerControls(player: player!, fmt: _fmt),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () => downloadEntry(context, ref, widget.entry),
              child: const Text('下载到手机'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Play/pause, seek bar and time readout, fed by just_audio streams.
class _PlayerControls extends StatefulWidget {
  const _PlayerControls({required this.player, required this.fmt});
  final AudioPlayer player;
  final String Function(Duration?) fmt;

  @override
  State<_PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<_PlayerControls> {
  double _dragValue = -1; // -1 = follow playback, else a mid-drag position

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final player = widget.player;

    return StreamBuilder<Duration?>(
      stream: player.durationStream,
      builder: (context, durSnap) {
        final total = durSnap.data ?? Duration.zero;

        return StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, stateSnap) {
            final playing = stateSnap.data?.playing ?? false;
            final loading = stateSnap.data?.processingState ==
                ProcessingState.loading;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<Duration?>(
                  stream: player.positionStream,
                  builder: (context, posSnap) {
                    final pos = posSnap.data ?? Duration.zero;
                    final shown = _dragValue >= 0
                        ? Duration(seconds: _dragValue.round())
                        : pos;
                    final frac = total.inMilliseconds == 0
                        ? 0.0
                        : (shown.inMilliseconds / total.inMilliseconds)
                            .clamp(0.0, 1.0);
                    return Row(
                      children: [
                        Text(widget.fmt(shown),
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.hintColor)),
                        Expanded(
                          child: Slider(
                            value: frac.toDouble(),
                            onChanged: loading
                                ? null
                                : (v) => setState(() => _dragValue =
                                    v * total.inMilliseconds),
                            onChangeEnd: (v) async {
                              final t = v * total.inMilliseconds;
                              await player.seek(Duration(milliseconds: t.round()));
                              setState(() => _dragValue = -1);
                            },
                          ),
                        ),
                        Text(widget.fmt(total),
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.hintColor)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 4),
                IconButton(
                  iconSize: 48,
                  icon: Icon(
                    loading
                        ? Icons.hourglass_top
                        : playing
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () async {
                    if (playing) {
                      await player.pause();
                    } else {
                      await player.play();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
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
