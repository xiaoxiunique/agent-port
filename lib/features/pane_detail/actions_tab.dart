import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/api.dart';
import '../../services/api_provider.dart';
import '../../data/models/enums.dart';
import '../../data/models/interaction.dart';
import '../../data/models/pane.dart';

/// Interaction messages list + composer (text input, control keys, send).
class ActionsTab extends ConsumerWidget {
  const ActionsTab({super.key, required this.pane});
  final Pane pane;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = pane.messages;
    return Column(
      children: [
        Expanded(
          child: messages.isEmpty
              ? const Center(child: Text('暂无交互消息'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (_, i) => _MessageCard(
                    message: messages[i],
                    paneId: pane.id,
                  ),
                ),
        ),
        Composer(pane: pane),
      ],
    );
  }
}

class _MessageCard extends ConsumerWidget {
  const _MessageCard({required this.message, required this.paneId});
  final InteractionMessage message;
  final String paneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    message.title,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (message.priority == InteractionPriority.high)
                  const Icon(Icons.priority_high,
                      size: 16, color: Colors.redAccent),
              ],
            ),
            const SizedBox(height: 6),
            Text(message.body, style: theme.textTheme.bodyMedium),
            if (message.actions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: message.actions
                    .map((a) => ActionChip(
                          label: Text(a.label),
                          onPressed: () => _sendPayload(ref, a.payload),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _sendPayload(WidgetRef ref, String payload) async {
    try {
      await ref
          .read(apiProvider)
          .send(SendRequest(paneId: paneId, text: payload));
    } catch (_) {}
  }
}

class Composer extends ConsumerStatefulWidget {
  const Composer({super.key, required this.pane});
  final Pane pane;

  @override
  ConsumerState<Composer> createState() => _ComposerState();
}

class _ComposerState extends ConsumerState<Composer> {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发送失败: $e')),
        );
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

  Future<void> _pickAndUpload() async {
    try {
      final xfile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (xfile == null) return;
      final bytes = await xfile.readAsBytes();
      final contentType = _detectContentType(bytes);
      await ref.read(apiProvider).uploadImage(
            bytes,
            contentType,
            paneId: widget.pane.id,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('图片已上传')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('上传失败: $e')),
        );
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
    return SafeArea(
      top: false,
      child: Material(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
          child: Row(
            children: [
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
              const SizedBox(width: 8),
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
      ),
    );
  }
}
