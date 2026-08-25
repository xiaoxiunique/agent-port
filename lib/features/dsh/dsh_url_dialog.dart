import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/dsh_service.dart';

/// Override the DeepSeek relay address by hand.
///
/// The host reports where it put the relay, but not whether *this* device can
/// reach it — a tailnet name can resolve to something else on the phone's
/// network, and a tunnel is an address the host knows nothing about. Blank
/// restores auto-discovery.
///
/// Shared by the settings row and the DeepSeek tab's failure state, since a
/// failure is exactly when you need to set one.
Future<void> promptDshUrl(
  BuildContext context,
  WidgetRef ref,
  String current,
) async {
  final controller = TextEditingController(text: current);
  final messenger = ScaffoldMessenger.of(context);

  final value = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('DeepSeek 地址'),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.url,
        autocorrect: false,
        decoration: const InputDecoration(
          hintText: 'https://host:8788,留空自动发现',
        ),
        onSubmitted: (v) => Navigator.of(ctx).pop(v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(controller.text),
          child: const Text('保存'),
        ),
      ],
    ),
  );
  if (value == null) return;

  final trimmed = value.trim();
  if (trimmed.isNotEmpty && !isValidDshUrl(trimmed)) {
    // A WebView handed a schemeless string fails with an error code that
    // explains nothing, so reject it here where we can say why.
    messenger.showSnackBar(
      const SnackBar(content: Text('地址无效,需要带 http:// 或 https://')),
    );
    return;
  }
  await ref.read(dshOverrideUrlProvider.notifier).set(trimmed);
}

/// An address a WebView can actually load: absolute, with a host.
bool isValidDshUrl(String raw) {
  final uri = Uri.tryParse(raw.trim());
  if (uri == null) return false;
  // `hasAuthority` is true for "https://" — the authority is present but
  // empty — so the host has to be checked on its own.
  if (uri.host.isEmpty) return false;
  return uri.scheme == 'http' || uri.scheme == 'https';
}
