import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../services/environment_service.dart';
import '../../services/host_service.dart';
import '../../services/permission_service.dart';

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
            _ConnectionCard(
              lanUrl: host.lanUrl,
              localUrl: host.serviceUrl,
              tailscaleUrl: host.tailscaleUrl,
            ),
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
            const _PermissionsCard(),
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

/// The address clients connect to. When this Mac is on a tailnet the QR encodes
/// the Tailscale address (works across networks); the LAN address is then shown
/// as a secondary line. Falls back to the LAN address when there's no tailnet.
/// 127.0.0.1 is shown smaller as a same-machine fallback.
class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({
    required this.lanUrl,
    required this.localUrl,
    required this.tailscaleUrl,
  });
  final String? lanUrl;
  final String localUrl;
  final String? tailscaleUrl;

  /// Strip the scheme for a compact `host:port` display.
  static String _hostPort(String url) =>
      url.replaceFirst(RegExp(r'^https?://'), '');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = tailscaleUrl ?? lanUrl;
    final isTailscale = tailscaleUrl != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('客户端连接地址', style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(
              '手机 / Web 客户端扫码或填入此地址连接',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 16),
            if (primary == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('正在检测连接地址…'),
              )
            else ...[
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
                      data: primary,
                      size: 132,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: SelectableText(
                                _hostPort(primary),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isTailscale) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Tailscale',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => _copy(context, primary),
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
              // With Tailscale as the primary QR, keep the LAN address reachable
              // as a secondary same-network option.
              if (isTailscale && lanUrl != null) ...[
                const SizedBox(height: 12),
                _SecondaryAddressRow(
                  icon: Icons.wifi,
                  label: '局域网',
                  url: lanUrl!,
                  onCopy: () => _copy(context, lanUrl!),
                ),
              ],
            ],
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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () {
                  Process.run('open', [localUrl]);
                },
                icon: const Icon(Icons.open_in_browser, size: 18),
                label: const Text('在浏览器打开客户端'),
              ),
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

/// A compact "<label>: host:port  [copy]" line for a secondary connect address.
class _SecondaryAddressRow extends StatelessWidget {
  const _SecondaryAddressRow({
    required this.icon,
    required this.label,
    required this.url,
    required this.onCopy,
  });
  final IconData icon;
  final String label;
  final String url;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.hintColor),
        const SizedBox(width: 8),
        Text('$label:',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
        const SizedBox(width: 6),
        Expanded(
          child: SelectableText(
            _ConnectionCard._hostPort(url),
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.hintColor),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.copy, size: 16),
          onPressed: onCopy,
        ),
      ],
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

/// Guides the user through granting Screen Recording, which the control-center
/// screenshot / window-preview features need (the embedded service shells out
/// to `screencapture`). Automation is only mentioned — macOS prompts for it on
/// demand and its status can't be queried reliably.
class _PermissionsCard extends ConsumerWidget {
  const _PermissionsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final granted = ref.watch(screenRecordingProvider);
    final notifier = ref.read(screenRecordingProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('系统权限', style: theme.textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          '控制中心的截图 / 窗口预览需要屏幕录制权限。',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  granted ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: granted ? Colors.green : Colors.orange,
                ),
                title: const Text('屏幕录制'),
                subtitle: Text(granted ? '已授权' : '未授权 — 无法截图 / 预览窗口'),
                trailing: granted
                    ? TextButton(
                        onPressed: () => notifier.refresh(),
                        child: const Text('重新检测'),
                      )
                    : FilledButton.tonal(
                        onPressed: () => notifier.request(),
                        child: const Text('去授权'),
                      ),
              ),
              if (!granted)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => notifier.openSettings(),
                        icon: const Icon(Icons.settings, size: 16),
                        label: const Text('打开系统设置'),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => notifier.refresh(),
                        child: const Text('重新检测'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '提示:首次截图 / 控制其他应用时,macOS 会单独弹出「自动化」授权,点允许即可。'
          '刚授权屏幕录制后,可能需要重启服务(上方「重启」)才对截图生效。',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
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
        Text('开发工具', style: theme.textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          '在这台 Mac 上检测并一键安装 agent CLI(自动优先 Homebrew)',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              for (final t in env.devTools)
                _ToolRow(
                  info: t,
                  installing: env.installingTool == t.tool,
                  busy: env.installingTool != null,
                  onInstall: () =>
                      ref.read(environmentServiceProvider).install(t.tool),
                ),
            ],
          ),
        ),
        if (env.installingTool != null) ...[
          const SizedBox(height: 8),
          _InstallLog(lines: env.installLog),
        ],
        const SizedBox(height: 20),
        Text('rmux 启动包装器(cc / cx)', style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                dense: true,
                leading: const SizedBox(width: 20),
                title: const Text('cc'),
                subtitle: Text(_stateLabel(env.ccState)),
              ),
              ListTile(
                dense: true,
                leading: const SizedBox(width: 20),
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
            padding: const EdgeInsets.only(top: 12),
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

class _ToolRow extends StatelessWidget {
  const _ToolRow({
    required this.info,
    required this.installing,
    required this.busy,
    required this.onInstall,
  });

  final ToolInfo info;
  final bool installing;
  final bool busy;
  final VoidCallback onInstall;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, color) = info.installed
        ? (Icons.check_circle, Colors.green)
        : info.blockedReason != null
            ? (Icons.remove_circle_outline, theme.hintColor)
            : (Icons.radio_button_unchecked, theme.hintColor);
    final subtitle = info.installed
        ? (info.version ?? '已安装')
        : (info.blockedReason ?? '未安装');

    Widget trailing;
    if (installing) {
      trailing = const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (info.installed) {
      trailing = const SizedBox.shrink();
    } else {
      trailing = TextButton(
        onPressed: (busy || info.blockedReason != null) ? null : onInstall,
        child: const Text('安装'),
      );
    }

    return ListTile(
      dense: true,
      leading: Icon(icon, color: color, size: 20),
      title: Text(EnvironmentService.toolLabel(info.tool)),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: trailing,
    );
  }
}

/// Scrolling tail of the running installer's output.
class _InstallLog extends StatelessWidget {
  const _InstallLog({required this.lines});
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final tail = lines.length > 14 ? lines.sublist(lines.length - 14) : lines;
    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        reverse: true,
        child: Text(
          tail.join('\n'),
          style: const TextStyle(
            color: Color(0xFFD4D4D4),
            fontFamily: 'monospace',
            fontSize: 11.5,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
