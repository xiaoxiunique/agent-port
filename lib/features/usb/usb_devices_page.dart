import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/models/usb_device.dart';
import '../../services/usb_service.dart';

/// USB devices physically connected to the host.
///
/// Only available when the host is macOS (uses ioreg). On other platforms
/// `available` is false and the screen shows a single hint row.
class UsbDevicesPage extends ConsumerWidget {
  const UsbDevicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(usbDevicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('USB 设备'),
        actions: [
          IconButton(
            tooltip: '刷新',
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () => ref.invalidate(usbDevicesProvider),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _Error(
          error: e,
          onRetry: () => ref.invalidate(usbDevicesProvider),
        ),
        data: (r) {
          if (!r.available) {
            return const _Hint(text: 'USB 设备检测仅支持 macOS 主机');
          }
          if (r.devices.isEmpty) {
            return const _Hint(text: '没有检测到 USB 设备');
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(usbDevicesProvider),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: r.devices.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _DeviceCard(device: r.devices[i]),
            ),
          );
        },
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.device});
  final UsbDevice device;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    final isPhone = ['xiao', 'samsung', 'apple inc', 'iphone', 'huawei', 'oppo',
          'vivo', 'oneplus', 'google', 'pixel', 'motorola', 'redmi']
        .any((k) => device.vendor.toLowerCase().contains(k));

    return Material(
      color: AgentPortTheme.surface(b),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: device.serial != null
            ? () {
                Clipboard.setData(ClipboardData(text: device.serial!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('序列号已复制')),
                );
              }
            : null,
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
                    color: (isPhone ? Colors.green : theme.hintColor)
                        .withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    isPhone ? Icons.phone_android : Icons.usb,
                    size: 20,
                    color: isPhone ? Colors.green : theme.hintColor,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        device.product,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        device.vendor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.hintColor),
                      ),
                      if (device.serial != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          device.serial!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (device.serial != null)
                  Icon(Icons.copy,
                      size: 16, color: theme.colorScheme.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 140),
        Icon(Icons.usb_off, size: 44, color: theme.hintColor),
        const SizedBox(height: 12),
        Center(
          child: Text(text, style: TextStyle(color: theme.hintColor)),
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
