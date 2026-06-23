import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../services/environment_service.dart';
import '../../services/host_service.dart';

/// macOS server-side main window.
///
/// This Mac is the **server**: it runs the Rust service and exposes it to
/// clients (phone / web). The window is a control panel — service status, the
/// address clients connect to (with a scannable QR), start/stop/restart, and
/// host environment checks. The actual monitoring UI lives on the clients.
class ServerHomePage extends ConsumerStatefulWidget {
  const ServerHomePage({super.key});

  @override
  ConsumerState<ServerHomePage> createState() => _ServerHomePageState();
}

class _ServerHomePageState extends ConsumerState<ServerHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(environmentServiceProvider).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final host = ref.watch(hostServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent Port 服务端'),
        centerTitle: false,
      ),
      // hostServiceProvider is a plain Provider; rebuild on its notifyListeners.
      body: ListenableBuilder(
        listenable: host,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _StatusCard(state: host.state, reachable: host.isReachable),
            const SizedBox(height: 16),
            _ConnectionCard(lanUrl: host.lanUrl, localUrl: host.serviceUrl),
            const SizedBox(height: 16),
            _ActionButtons(host: host),
            if (host.lastMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                host.lastMessage,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const Divider(height: 40),
            const _EnvironmentSection(),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.state, required this.reachable});
  final ServiceState state;
  final bool reachable;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (state) {
      ServiceState.running => (Colors.green, '运行中'),
      ServiceState.starting => (Colors.orange, '启动中'),
      ServiceState.failed => (Colors.red, '故障'),
      ServiceState.idle => (Colors.grey, '未运行'),
    };
    return Card(
      child: ListTile(
        leading: Icon(Icons.circle, color: color, size: 16),
        title: Text('服务状态:$label'),
        subtitle: Text(reachable ? '健康检查:可达' : '健康检查:不可达'),
      ),
    );
  }
}

/// The address clients connect to. The LAN URL is the one phones/web use; the
/// QR encodes it so a phone can scan to fill it in. 127.0.0.1 is shown smaller
/// as a same-machine fallback.
class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({required this.lanUrl, required this.localUrl});
  final String? lanUrl;
  final String localUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = lanUrl;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('客户端连接地址', style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(
              '手机 / Web 客户端用此地址连接(同一局域网)',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 16),
            if (url == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('正在检测局域网地址…'),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: QrImageView(
                      data: url,
                      size: 132,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          url,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => _copy(context, url),
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('复制地址'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 32),
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(Icons.computer,
                    size: 16, color: theme.hintColor),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectableText(
                    localUrl,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.copy, size: 16),
                  onPressed: () => _copy(context, localUrl),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已复制')),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.host});
  final HostService host;

  @override
  Widget build(BuildContext context) {
    final running = host.state == ServiceState.running;
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonal(
            onPressed: running ? null : () => host.startService(),
            child: const Text('启动'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () => host.restartService(),
            child: const Text('重启'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: running ? () => host.stopService() : null,
            child: const Text('停止'),
          ),
        ),
      ],
    );
  }
}

class _EnvironmentSection extends ConsumerWidget {
  const _EnvironmentSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(environmentServiceProvider);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('环境', style: theme.textTheme.labelLarge),
        ),
        Card(
          child: Column(
            children: [
              ListTile(
                dense: true,
                leading: Icon(
                  env.tmuxInstalled ? Icons.check_circle : Icons.error_outline,
                  color: env.tmuxInstalled ? Colors.green : Colors.red,
                  size: 20,
                ),
                title: const Text('tmux'),
                subtitle: Text(env.tmuxVersion ?? '未安装'),
              ),
              ListTile(
                dense: true,
                title: const Text('cc'),
                subtitle: Text(_stateLabel(env.ccState)),
              ),
              ListTile(
                dense: true,
                title: const Text('cx'),
                subtitle: Text(_stateLabel(env.cxState)),
              ),
            ],
          ),
        ),
        if (env.ccState != CommandState.installed ||
            env.cxState != CommandState.installed)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FilledButton.tonal(
              onPressed: env.isWorking ? null : () => env.installWrappers(),
              child: Text(env.isWorking ? '安装中…' : '安装 cc/cx 包装器'),
            ),
          ),
        if (env.lastMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(env.lastMessage, style: theme.textTheme.bodySmall),
          ),
      ],
    );
  }

  String _stateLabel(CommandState s) => switch (s) {
        CommandState.installed => '已安装 (~/.agent-monitor/bin)',
        CommandState.managed => '由 ~/.zshrc 管理',
        CommandState.missing => '未安装',
        CommandState.conflict => '冲突(其他来源)',
      };
}
