import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/environment_service.dart';
import '../../services/host_service.dart';

/// Floating dialog-style control center for the macOS menu bar app.
/// Shows service status, URL (with copy), and start/stop/restart controls.
class ControlCenterDialog extends ConsumerWidget {
  const ControlCenterDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final host = ref.watch(hostServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('控制中心')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatusCard(state: host.state, reachable: host.isReachable),
            const SizedBox(height: 16),
            _UrlCard(url: host.serviceUrl),
            if (host.lanUrl != null) _UrlCard(url: host.lanUrl!),
            const SizedBox(height: 16),
            _ActionButtons(host: host),
            const Divider(height: 32),
            const _EnvironmentSection(),
            if (host.lastMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(host.lastMessage,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
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
        title: Text('服务状态: $label'),
        subtitle: Text(reachable ? '健康检查: 可达' : '健康检查: 不可达'),
      ),
    );
  }
}

class _UrlCard extends StatelessWidget {
  const _UrlCard({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.link),
        title: const Text('服务地址'),
        subtitle: SelectableText(url),
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: url));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('已复制')),
            );
          },
        ),
      ),
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

class _EnvironmentSection extends ConsumerStatefulWidget {
  const _EnvironmentSection();
  @override
  ConsumerState<_EnvironmentSection> createState() =>
      _EnvironmentSectionState();
}

class _EnvironmentSectionState extends ConsumerState<_EnvironmentSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(environmentServiceProvider).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  env.rmuxInstalled
                      ? Icons.check_circle
                      : Icons.error_outline,
                  color: env.rmuxInstalled ? Colors.green : Colors.red,
                  size: 20,
                ),
                title: const Text('rmux'),
                subtitle: Text(env.rmuxVersion ?? '未安装'),
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
