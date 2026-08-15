import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../services/dsh_service.dart';

/// DeepSeek Harness, shown as its own web UI rather than reimplemented.
///
/// dsh is plugin-based and moves quickly; embedding its interface means the
/// trajectory view, skills, model picker and permission modes all work without
/// this app knowing they exist. The host relays the UI on a second port —
/// dsh binds loopback only — and reports it via `/api/capabilities`.
class DshPage extends ConsumerStatefulWidget {
  const DshPage({super.key});

  @override
  ConsumerState<DshPage> createState() => _DshPageState();
}

class _DshPageState extends ConsumerState<DshPage> {
  WebViewController? _controller;
  String? _loadedUrl;
  bool _loading = true;

  void _ensureController(String url) {
    // Rebuilt only when the endpoint itself changes (host switch, relay
    // restart), so scroll position and page state survive normal rebuilds.
    if (_loadedUrl == url && _controller != null) return;
    _loadedUrl = url;
    _loading = true;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(dshEndpointProvider);

    // No app bar: dsh's own UI has a header, and a second one just eats
    // vertical space on a phone. SafeArea keeps it clear of the notch, and
    // the bottom is left to the tab bar.
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _Unavailable(
          message: '无法连接:$e',
          onRetry: () => ref.invalidate(dshEndpointProvider),
        ),
        data: (endpoint) {
          if (!endpoint.usable) {
            return _Unavailable(
              onRetry: () => ref.invalidate(dshEndpointProvider),
              message: endpoint.available
                  // dsh answered the host's probe but the relay isn't up:
                  // the daemon was already running when dsh started.
                  ? 'DeepSeek Harness 在运行,但转发还没启动。\n'
                      '在电脑上重启 amux serve 即可。'
                  : '电脑上没有运行 DeepSeek Harness。\n\n'
                      '启动方式:\n'
                      'dsh web --trusted-host <电脑地址>',
            );
          }
          _ensureController(endpoint.url!);
          return Stack(
            children: [
              WebViewWidget(controller: _controller!),
              if (_loading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
          },
        ),
      ),
    );
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.travel_explore, size: 44, color: theme.hintColor),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.hintColor, height: 1.5),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              FilledButton.tonal(onPressed: onRetry, child: const Text('重试')),
            ],
          ],
        ),
      ),
    );
  }
}
