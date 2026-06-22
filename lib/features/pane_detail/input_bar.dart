import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/api.dart';
import '../../data/models/pane.dart';
import '../../services/api_provider.dart';

/// Which runtime surface the detail page shows.
enum RuntimeMode { log, terminal }

/// Unified bottom input bar: mode toggle (Logs/Terminal) + control keys +
/// text field + image upload + send. Mirrors the native `InputBar`.
class InputBar extends ConsumerStatefulWidget {
  const InputBar({
    super.key,
    required this.pane,
    required this.mode,
    required this.onToggleMode,
  });

  final Pane pane;
  final RuntimeMode mode;
  final VoidCallback onToggleMode;

  @override
  ConsumerState<InputBar> createState() => _InputBarState();
}

class _InputBarState extends ConsumerState<InputBar> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isCodex {
    final p = widget.pane;
    final haystack =
        '${p.session}\n${p.command}\n${p.title}\n${p.tail}'.toLowerCase();
    return p.session.startsWith('cx_') || haystack.contains('codex');
  }

  Future<void> _send() async {
    final text = _controller.text;
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref.read(apiProvider).send(
            SendRequest(
              paneId: widget.pane.id,
              text: text,
              submitKey: _isCodex ? 'Tab' : 'Enter',
            ),
          );
      _controller.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('发送失败: $e')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendKey(String key) async {
    try {
      await ref.read(apiProvider).sendKey(widget.pane.id, key);
    } catch (_) {}
  }

  static const _quickActions = ['继续', 'yes', 'no', 'LGTM', 'skip'];

  Future<void> _sendQuick(String text) async {
    setState(() => _sending = true);
    try {
      await ref.read(apiProvider).send(
            SendRequest(
              paneId: widget.pane.id,
              text: text,
              submitKey: _isCodex ? 'Tab' : 'Enter',
            ),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('发送失败: $e')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _pickAndUpload() async {
    try {
      final xfile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (xfile == null) return;
      final bytes = await xfile.readAsBytes();
      final contentType = _detectContentType(bytes);
      await ref
          .read(apiProvider)
          .uploadImage(bytes, contentType, paneId: widget.pane.id);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('图片已上传')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('上传失败: $e')));
      }
    }
  }

  String _detectContentType(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xff &&
        bytes[1] == 0xd8 &&
        bytes[2] == 0xff) {
      return 'image/jpeg';
    }
    if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4e &&
        bytes[3] == 0x47) {
      return 'image/png';
    }
    return 'image/jpeg';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Material(
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick action buttons row
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: _quickActions.map((label) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      label: Text(label, style: const TextStyle(fontSize: 12)),
                      visualDensity: VisualDensity.compact,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      onPressed: () => _sendQuick(label),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Input row
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 8, 6),
              child: Row(
                children: [
                  IconButton(
                icon: Icon(widget.mode == RuntimeMode.terminal
                    ? Icons.description
                    : Icons.terminal),
                tooltip: widget.mode == RuntimeMode.terminal ? '日志' : '终端',
                onPressed: widget.onToggleMode,
              ),
              PopupMenuButton<String>(
                tooltip: '控制键',
                icon: const Icon(Icons.keyboard),
                onSelected: _sendKey,
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'C-c', child: Text('Ctrl+C')),
                  PopupMenuItem(value: 'C-d', child: Text('Ctrl+D')),
                  PopupMenuItem(value: 'C-u', child: Text('Ctrl+U')),
                  PopupMenuItem(value: 'Escape', child: Text('Esc')),
                  PopupMenuItem(value: 'Tab', child: Text('Tab')),
                  PopupMenuItem(value: 'BSpace', child: Text('Backspace')),
                  PopupMenuItem(value: 'Up', child: Text('↑')),
                  PopupMenuItem(value: 'Down', child: Text('↓')),
                ],
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: const InputDecoration(
                    hintText: '输入内容…',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.image_outlined),
                tooltip: '上传图片',
                onPressed: _pickAndUpload,
              ),
              IconButton.filled(
                onPressed: _sending ? null : _send,
                icon: _sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
              ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
