import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../onboarding/scan_add_flow.dart';

import '../../data/api/agent_monitor_api.dart';
import '../../data/models/cc_switch.dart';
import '../../data/models/running_app.dart';
import '../../data/models/server_profile.dart';
import '../../services/api_provider.dart';
import '../../services/demo_data.dart';
import '../../services/settings_service.dart';
import '../../services/snapshot_service.dart';
import 'usage_page.dart';
import 'widgets/settings_rows.dart';

// ===========================================================================
// Main settings page — iOS-style master list (label + current value + chevron);
// each row drills into a dedicated sub-page.
// ===========================================================================

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider).valueOrNull;
    if (s == null) {
      return Scaffold(
        backgroundColor: settingsBg(context),
        appBar: AppBar(title: const Text('设置')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final quickCount =
        s.quickActionButtons.isEmpty ? 5 : s.quickActionButtons.length;
    final notifier = ref.read(settingsProvider.notifier);
    String activeName = '未配置';
    for (final p in s.profiles) {
      if (p.id == s.activeProfileId) activeName = p.name;
    }

    return Scaffold(
      backgroundColor: settingsBg(context),
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: settingsBg(context),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 4, bottom: 100),
        children: [
          const SettingsSectionHeader('连接'),
          SettingsGrouped(children: [
            SettingsRow(
              icon: Icons.dns_outlined,
              tint: const Color(0xFF007AFF),
              label: '服务器',
              value: activeName,
              onTap: () => _push(context, const _ServersListPage()),
            ),
          ]),
          const SettingsSectionHeader('监控'),
          SettingsGrouped(children: [
            // The 电脑 tab was removed from the shell; this keeps the screen
            // reachable, since it owns the screenshot and running-apps controls.
            SettingsRow(
              icon: Icons.computer_outlined,
              tint: const Color(0xFF34C759),
              label: '电脑控制',
              value: '截图 / 应用',
              onTap: () => _push(context, const DevicesPage()),
            ),
            const SettingsRowDivider(),
            SettingsRow(
              icon: Icons.timer_outlined,
              tint: const Color(0xFFFF9500),
              label: '刷新频率',
              value: _refreshLabel(s.refreshInterval),
              onTap: () => _push(context, const _RefreshPage()),
            ),
            const SettingsRowDivider(),
            SettingsRowSwitch(
              icon: Icons.brightness_high_outlined,
              tint: const Color(0xFF5856D6),
              label: '常亮屏幕',
              value: s.keepScreenAwake,
              onChanged: notifier.setKeepScreenAwake,
            ),
          ]),
          const SettingsSectionHeader('输入'),
          SettingsGrouped(children: [
            SettingsRow(
              icon: Icons.bolt_outlined,
              tint: const Color(0xFF30B0C7),
              label: '快捷按钮',
              value: '$quickCount 个',
              onTap: () => _push(context, const _QuickButtonsPage()),
            ),
          ]),
          const SettingsSectionHeader('工具'),
          SettingsGrouped(children: [
            SettingsRow(
              icon: Icons.insights_outlined,
              tint: const Color(0xFF34C759),
              label: '用量统计',
              onTap: () => _push(context, const UsagePage()),
            ),
            const SettingsRowDivider(),
            SettingsRow(
              icon: Icons.hub_outlined,
              tint: const Color(0xFFAF52DE),
              label: 'CC Switch',
              onTap: () => _push(context, const _CcSwitchPage()),
            ),
          ]),
          const SizedBox(height: 24),
          SettingsGrouped(children: [
            SettingsRow(
              icon: Icons.restart_alt,
              tint: const Color(0xFFFF3B30),
              label: '重置设置',
              destructive: true,
              onTap: () => _confirmReset(context, ref),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('重置设置'),
        content: const Text('重置刷新频率、息屏、快捷按钮等偏好(服务器配置保留)。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false), child: const Text('取消')),
          FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(c, true),
              child: const Text('重置')),
        ],
      ),
    );
    if (ok == true) await ref.read(settingsProvider.notifier).resetSettings();
  }
}

/// Settings background — a light grey so white cards pop (matches the native
/// settings aesthetic); follows dark mode.

String _refreshLabel(double v) {
  if (v == v.roundToDouble()) return '${v.toInt()}s';
  return '${v}s';
}

void _push(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

// ===========================================================================
// 电脑 (Devices) tab — monitor the active Mac: running apps (+ machines).
// ===========================================================================

class DevicesPage extends ConsumerStatefulWidget {
  const DevicesPage({super.key});

  @override
  ConsumerState<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends ConsumerState<DevicesPage> {
  Future<AppsResponse>? _apps;
  int _screenBust = 0; // 0 = not captured yet

  Future<AppsResponse> _loadApps() {
    if (ref.read(demoModeProvider)) {
      return Future.value(AppsResponse(ok: true, apps: demoApps()));
    }
    return ref.read(apiProvider).listApps();
  }

  @override
  void initState() {
    super.initState();
    _apps = _loadApps();
  }

  void _reloadApps() {
    setState(() {
      _apps = _loadApps();
    });
  }

  void _captureScreen() {
    setState(() => _screenBust = DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _quitApp(String name) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('退出 $name?'),
        content: const Text('将向该应用发送「退出」(可能弹出保存提示)。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false), child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.pop(c, true), child: const Text('退出')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(apiProvider).quitApp(name);
    } catch (_) {}
    await Future<void>.delayed(const Duration(milliseconds: 900));
    _reloadApps();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider).valueOrNull;
    final profiles = s?.profiles ?? const <ServerProfile>[];
    final activeId = s?.activeProfileId ?? '';
    final reachable = ref.watch(snapshotProvider).valueOrNull?.ok ?? false;
    final api = ref.read(apiProvider);
    // Reload apps when the active server changes.
    ref.listen(apiProvider, (_, _) {
      _reloadApps();
      setState(() => _screenBust = 0);
    });

    String activeName = '未配置';
    for (final p in profiles) {
      if (p.id == activeId) activeName = p.name;
    }

    return Scaffold(
      backgroundColor: settingsBg(context),
      appBar: AppBar(
        backgroundColor: settingsBg(context),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: reachable ? const Color(0xFF34C759) : Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Text(activeName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '打开应用',
            onPressed: () => _push(
              context,
              _OpenAppPage(api: api, onOpened: _reloadApps),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _reloadApps(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 4, bottom: 100),
          children: [
            SettingsSectionHeader(
              '屏幕',
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                iconSize: 20,
                visualDensity: VisualDensity.compact,
                onPressed: _captureScreen,
              ),
            ),
            _ScreenCard(
              api: api,
              bust: _screenBust,
              onCapture: _captureScreen,
            ),
            SettingsSectionHeader(
              '运行中的应用',
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                iconSize: 20,
                visualDensity: VisualDensity.compact,
                onPressed: _reloadApps,
              ),
            ),
            _AppsList(future: _apps, api: api, onQuit: _quitApp),
          ],
        ),
      ),
    );
  }
}

/// Servers list sub-page (reached from Settings → 服务器): pick active, edit,
/// add, delete machines.
class _ServersListPage extends ConsumerWidget {
  const _ServersListPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider).valueOrNull;
    final profiles = s?.profiles ?? const <ServerProfile>[];
    final activeId = s?.activeProfileId ?? '';
    final reachable = ref.watch(snapshotProvider).valueOrNull?.ok ?? false;
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: settingsBg(context),
      appBar: AppBar(
        title: const Text('服务器'),
        backgroundColor: settingsBg(context),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 32),
        children: [
          SettingsGrouped(children: [
            for (var i = 0; i < profiles.length; i++) ...[
              if (i > 0) const SettingsRowDivider(),
              _DeviceRow(
                profile: profiles[i],
                active: profiles[i].id == activeId,
                online: profiles[i].id == activeId && reachable,
                onTap: () => notifier.setActive(profiles[i].id),
                onEdit: () =>
                    _push(context, ServerEditPage(profileId: profiles[i].id)),
              ),
            ],
          ]),
          const SizedBox(height: 16),
          SettingsGrouped(children: [
            if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) ...[
              SettingsNavRow(
                label: '扫码添加',
                leading: Icons.qr_code_scanner,
                accent: true,
                onTap: () => scanAndAddServer(context, ref),
              ),
              const SettingsRowDivider(),
            ],
            SettingsNavRow(
              label: '添加服务器',
              leading: Icons.add,
              accent: true,
              onTap: () => _push(context, const ServerEditPage()),
            ),
          ]),
        ],
      ),
    );
  }
}

/// On-demand main-display screenshot card.
class _ScreenCard extends StatelessWidget {
  const _ScreenCard({
    required this.api,
    required this.bust,
    required this.onCapture,
  });

  final AgentMonitorApi api;
  final int bust;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (bust == 0) {
      return SettingsGrouped(children: [
        ListTile(
          leading: const Icon(Icons.desktop_windows_outlined),
          title: const Text('点击截屏'),
          subtitle: const Text('查看 Mac 当前主屏(需屏幕录制权限)'),
          trailing: const Icon(Icons.chevron_right),
          onTap: onCapture,
        ),
      ]);
    }
    final url = api.screenUrl(bust: bust);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => _FullScreenImage(url: url),
          )),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.network(
              url,
              key: ValueKey(bust),
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
              errorBuilder: (context, _, _) => Container(
                color: theme.colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: const Text('截屏失败 — 需在被监控 Mac 上授予「屏幕录制」权限',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FullScreenImage extends StatelessWidget {
  const _FullScreenImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          maxScale: 5,
          child: Image.network(url, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

/// The running-apps section body — handles loading / error / list states.
class _AppsList extends StatelessWidget {
  const _AppsList({required this.future, required this.api, required this.onQuit});
  final Future<AppsResponse>? future;
  final AgentMonitorApi api;
  final void Function(String name) onQuit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppsResponse>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const SettingsGrouped(children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ]);
        }
        if (snap.hasError || snap.data == null || !snap.data!.ok) {
          return const SettingsGrouped(children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('获取失败 — 当前服务端未提供 /api/apps(需更新 Agent Monitor 服务)',
                  style: TextStyle(color: Colors.grey)),
            ),
          ]);
        }
        final apps = snap.data!.apps;
        if (apps.isEmpty) {
          return const SettingsGrouped(children: [
            Padding(
                padding: EdgeInsets.all(16),
                child: Text('无运行中的应用')),
          ]);
        }
        return SettingsGrouped(children: [
          for (var i = 0; i < apps.length; i++) ...[
            if (i > 0) const SettingsRowDivider(),
            _AppRow(app: apps[i], api: api, onQuit: onQuit),
          ],
        ]);
      },
    );
  }
}

class _AppRow extends StatelessWidget {
  const _AppRow({required this.app, required this.api, required this.onQuit});
  final RunningApp app;
  final AgentMonitorApi api;
  final void Function(String name) onQuit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () => _showScreenshot(context),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          api.appIconUrl(app.path),
          width: 34,
          height: 34,
          fit: BoxFit.contain,
          errorBuilder: (context, _, _) => Container(
            width: 34,
            height: 34,
            color: theme.colorScheme.surfaceContainerHighest,
            child: Icon(Icons.apps,
                size: 19, color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ),
      title: Text(app.name,
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      subtitle: Text('${_formatBytes(app.memoryBytes)} · ${app.cpuPercent.toStringAsFixed(0)}% CPU',
          style: TextStyle(
              fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
      trailing: IconButton(
        icon: const Icon(Icons.power_settings_new, size: 20),
        color: Colors.red.withValues(alpha: 0.85),
        tooltip: '退出',
        onPressed: () => onQuit(app.name),
      ),
    );
  }

  void _showScreenshot(BuildContext context) {
    final url = api.appScreenshotUrl(app.pid,
        bust: DateTime.now().millisecondsSinceEpoch);
    showDialog<void>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Dialog(
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(app.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(ctx).size.height * 0.7,
                  ),
                  child: InteractiveViewer(
                    maxScale: 5,
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) =>
                          progress == null
                              ? child
                              : const SizedBox(
                                  height: 200,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2)),
                                ),
                      errorBuilder: (context, _, _) => Padding(
                        padding: const EdgeInsets.all(28),
                        child: Text('该应用没有可见窗口,或截图失败(需屏幕录制权限)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String _formatBytes(int bytes) {
  if (bytes >= 1 << 30) return '${(bytes / (1 << 30)).toStringAsFixed(1)} GB';
  return '${(bytes / (1 << 20)).round()} MB';
}

/// Installed-app picker (电脑 → 右上角「打开应用」): searchable list of all
/// installed apps; tapping one launches it on the host Mac.
class _OpenAppPage extends StatefulWidget {
  const _OpenAppPage({required this.api, required this.onOpened});
  final AgentMonitorApi api;
  final VoidCallback onOpened;

  @override
  State<_OpenAppPage> createState() => _OpenAppPageState();
}

class _OpenAppPageState extends State<_OpenAppPage> {
  Future<InstalledAppsResponse>? _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = widget.api.listInstalledApps();
  }

  Future<void> _open(InstalledApp app) async {
    try {
      await widget.api.openApp(app.path);
    } catch (_) {}
    widget.onOpened();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('已打开 ${app.name}')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: settingsBg(context),
      appBar: AppBar(
        title: const Text('打开应用'),
        backgroundColor: settingsBg(context),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              autofocus: false,
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: '搜索应用',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<InstalledAppsResponse>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2));
                }
                if (snap.hasError || snap.data == null || !snap.data!.ok) {
                  return const Center(
                      child: Text('获取失败', style: TextStyle(color: Colors.grey)));
                }
                final apps = snap.data!.apps
                    .where((a) =>
                        _query.isEmpty || a.name.toLowerCase().contains(_query))
                    .toList();
                if (apps.isEmpty) {
                  return const Center(child: Text('无匹配应用'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: apps.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 64),
                  itemBuilder: (context, i) {
                    final app = apps[i];
                    final theme = Theme.of(context);
                    return ListTile(
                      onTap: () => _open(app),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.api.appIconUrl(app.path),
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                          errorBuilder: (context, _, _) => Container(
                            width: 32,
                            height: 32,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(Icons.apps,
                                size: 18,
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                      title: Text(app.name,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({
    required this.profile,
    required this.active,
    required this.online,
    required this.onTap,
    required this.onEdit,
  });

  final ServerProfile profile;
  final bool active;
  final bool online;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = active ? const Color(0xFF34C759) : const Color(0xFF8E8E93);
    return ListTile(
      onTap: onTap,
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          SettingsIconBox(icon: Icons.computer, tint: active ? const Color(0xFF007AFF) : tint),
          if (active)
            Positioned(
              right: -1,
              bottom: -1,
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: online ? const Color(0xFF34C759) : const Color(0xFF8E8E93),
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(profile.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: Text(profile.url,
          maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (active)
            Text(online ? '在线' : '离线',
                style: TextStyle(
                    fontSize: 13,
                    color: online
                        ? const Color(0xFF34C759)
                        : theme.colorScheme.onSurfaceVariant)),
          IconButton(
            icon: Icon(Icons.info_outline, color: theme.colorScheme.outline),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Sub-page: Server edit / add
// ===========================================================================

enum _TestState { idle, testing, success, error }

class ServerEditPage extends ConsumerStatefulWidget {
  const ServerEditPage({super.key, this.profileId, this.initialUrl});
  final String? profileId;

  /// When adding a new server, prefill the address fields from this URL (used
  /// by the scan flow's fallback). Ignored when editing an existing profile.
  final String? initialUrl;

  @override
  ConsumerState<ServerEditPage> createState() => ServerEditPageState();
}

class ServerEditPageState extends ConsumerState<ServerEditPage> {
  final _name = TextEditingController();
  final _host = TextEditingController();
  final _port = TextEditingController();
  final _token = TextEditingController();
  bool _seeded = false;
  String _scheme = 'http';
  _TestState _test = _TestState.idle;
  String _testDetail = '未测试';

  bool get _isNew => widget.profileId == null;

  @override
  void dispose() {
    _name.dispose();
    _host.dispose();
    _port.dispose();
    _token.dispose();
    super.dispose();
  }

  void _seedFrom(ServerProfile? p) {
    _seeded = true;
    _name.text = p?.name ?? '';
    // When adding via the scan fallback, seed the address from the scanned URL.
    final srcUrl = p?.url ?? widget.initialUrl ?? '';
    final u = Uri.tryParse(srcUrl);
    if (u != null && u.host.isNotEmpty) {
      _scheme = u.scheme.isEmpty ? 'http' : u.scheme;
      _host.text = u.host;
      _port.text = u.hasPort ? u.port.toString() : '';
    } else {
      _host.text = '127.0.0.1';
      _port.text = '8787';
    }
    _token.text = p?.token ?? '';
  }

  /// Compose the stored URL from the separate address + port fields. Tolerant
  /// of a full URL or `host:port` pasted straight into the address field.
  String _composeUrl() {
    var host = _host.text.trim();
    var port = _port.text.trim();
    var scheme = _scheme;
    if (host.contains('://')) {
      final u = Uri.tryParse(host);
      if (u != null && u.host.isNotEmpty) {
        scheme = u.scheme;
        host = u.host;
        if (u.hasPort) port = u.port.toString();
      }
    } else {
      final colon = host.lastIndexOf(':');
      if (colon > 0 && int.tryParse(host.substring(colon + 1)) != null) {
        port = host.substring(colon + 1);
        host = host.substring(0, colon);
      }
    }
    host = host.replaceAll('/', '');
    if (port.isEmpty) port = '8787';
    return '$scheme://$host:$port';
  }

  Future<void> _testConnection() async {
    setState(() {
      _test = _TestState.testing;
      _testDetail = '测试中…';
    });
    final t = _token.text.trim();
    final api = AgentMonitorApi(baseUrl: _composeUrl(), token: t.isEmpty ? null : t);
    try {
      final snap = await api.snapshot();
      if (!mounted) return;
      setState(() {
        _test = _TestState.success;
        _testDetail = '${snap.panes.length} 个会话';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _test = _TestState.error;
        _testDetail = '失败';
      });
    }
  }

  void _save() {
    final notifier = ref.read(settingsProvider.notifier);
    final t = _token.text.trim();
    final url = _composeUrl();
    final fallback = Uri.tryParse(url)?.host ?? url;
    final name = _name.text.trim().isEmpty ? fallback : _name.text.trim();
    final profile = ServerProfile(
      id: widget.profileId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      url: url,
      token: t.isEmpty ? null : t,
    );
    if (_isNew) {
      notifier.addProfile(profile);
      notifier.setActive(profile.id);
    } else {
      notifier.updateProfile(profile);
    }
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('删除服务器'),
        content: Text('确定删除「${_name.text}」?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false), child: const Text('取消')),
          FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(c, true),
              child: const Text('删除')),
        ],
      ),
    );
    if (ok == true && mounted) {
      ref.read(settingsProvider.notifier).removeProfile(widget.profileId!);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider).valueOrNull;
    final profiles = s?.profiles ?? const <ServerProfile>[];
    if (!_seeded) {
      _seedFrom(_isNew
          ? null
          : profiles.cast<ServerProfile?>().firstWhere(
                (p) => p?.id == widget.profileId,
                orElse: () => null,
              ));
    }
    final canDelete = !_isNew && profiles.length > 1;

    return Scaffold(
      backgroundColor: settingsBg(context),
      appBar: AppBar(
        title: Text(_isNew ? '添加服务器' : '编辑服务器'),
        actions: [
          TextButton(onPressed: _save, child: const Text('保存')),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          if (_isNew) const _SetupHint(),
          SettingsGrouped(children: [
            SettingsTextFieldRow(label: '名称', controller: _name, hint: '可选'),
            const SettingsRowDivider(),
            SettingsTextFieldRow(
                label: '地址',
                controller: _host,
                hint: 'IP 或域名',
                keyboardType: TextInputType.url),
            const SettingsRowDivider(),
            SettingsTextFieldRow(
                label: '端口',
                controller: _port,
                hint: '8787',
                keyboardType: TextInputType.number),
            const SettingsRowDivider(),
            SettingsTextFieldRow(
                label: 'Token', controller: _token, hint: '可选', obscure: true),
          ]),
          const SizedBox(height: 16),
          SettingsGrouped(children: [
            ListTile(
              leading: const Icon(Icons.wifi_tethering),
              title: const Text('测试连接'),
              trailing: _TestBadge(state: _test, detail: _testDetail),
              onTap: _test == _TestState.testing ? null : _testConnection,
            ),
          ]),
          if (canDelete) ...[
            const SizedBox(height: 16),
            SettingsGrouped(children: [
              SettingsNavRow(label: '删除服务器', destructive: true, onTap: _delete),
            ]),
          ],
        ],
      ),
    );
  }
}

/// Setup guidance shown at the top of the add-server form (new profiles only):
/// the app can't connect to anything until the user runs a service on their
/// Mac, so tell them how.
class _SetupHint extends StatelessWidget {
  const _SetupHint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final muted = theme.colorScheme.onSurfaceVariant;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: primary),
              const SizedBox(width: 6),
              Text('还没有可连接的服务?',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: primary)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('在你的 Mac 上装并运行 amux:', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const SelectableText(
              'brew install amux && amux serve',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12.5),
            ),
          ),
          const SizedBox(height: 8),
          Text('再回这里填这台 Mac 的 IP(局域网或 Tailscale)。详见 amux.cc',
              style: TextStyle(fontSize: 12, color: muted)),
          const SizedBox(height: 4),
          Text('需要「电脑」标签的应用管理 / 截图?改用 Agent Port 的 macOS 版。',
              style: TextStyle(fontSize: 12, color: muted)),
        ],
      ),
    );
  }
}

class _TestBadge extends StatelessWidget {
  const _TestBadge({required this.state, required this.detail});
  final _TestState state;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (state) {
      _TestState.success => const Color(0xFF34C759),
      _TestState.error => Colors.red,
      _TestState.testing => theme.colorScheme.primary,
      _TestState.idle => theme.colorScheme.onSurfaceVariant,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(detail, style: TextStyle(fontSize: 12, color: color)),
    );
  }
}

// ===========================================================================
// Sub-page: Refresh interval
// ===========================================================================

class _RefreshPage extends ConsumerWidget {
  const _RefreshPage();

  static const _options = [1.0, 2.5, 5.0, 10.0];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(
        settingsProvider.select((s) => s.valueOrNull?.refreshInterval ?? 2.5));
    final notifier = ref.read(settingsProvider.notifier);
    return Scaffold(
      backgroundColor: settingsBg(context),
      appBar: AppBar(title: const Text('刷新频率')),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          SettingsGrouped(children: [
            for (var i = 0; i < _options.length; i++) ...[
              if (i > 0) const SettingsRowDivider(),
              ListTile(
                title: Text(_refreshLabel(_options[i])),
                trailing: current == _options[i]
                    ? const Icon(Icons.check, color: Color(0xFF34C759))
                    : null,
                onTap: () => notifier.setRefreshInterval(_options[i]),
              ),
            ],
          ]),
        ],
      ),
    );
  }
}

// ===========================================================================
// Sub-page: Quick buttons
// ===========================================================================

const _defaultQuickButtons = ['继续', 'yes', 'no', 'LGTM', 'skip'];
const _maxQuickButtons = 12;

class _QuickButtonsPage extends ConsumerWidget {
  const _QuickButtonsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider).valueOrNull;
    final notifier = ref.read(settingsProvider.notifier);
    final buttons = (s?.quickActionButtons ?? const <String>[]).isEmpty
        ? _defaultQuickButtons
        : s!.quickActionButtons;
    void update(List<String> next) => notifier.setQuickActionButtons(next);

    return Scaffold(
      backgroundColor: settingsBg(context),
      appBar: AppBar(
        title: const Text('快捷按钮'),
        actions: [
          TextButton(
            onPressed: () => update(_defaultQuickButtons),
            child: const Text('恢复默认'),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          SettingsGrouped(children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < buttons.length; i++)
                    InputChip(
                      label: Text(buttons[i]),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => update([...buttons]..removeAt(i)),
                      visualDensity: VisualDensity.compact,
                    ),
                  if (buttons.length < _maxQuickButtons)
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 18),
                      label: const Text('添加'),
                      onPressed: () async {
                        final text = await _promptButton(context);
                        if (text != null && text.trim().isNotEmpty) {
                          update([...buttons, text.trim()]);
                        }
                      },
                    ),
                ],
              ),
            ),
          ]),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Text('发送给 agent 的常用回复,在输入栏「More」里使用。',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Future<String?> _promptButton(BuildContext context) {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('添加快捷按钮'),
        content: TextField(
          controller: c,
          autofocus: true,
          decoration: const InputDecoration(hintText: '按钮文本'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, c.text),
              child: const Text('添加')),
        ],
      ),
    );
  }
}

// ===========================================================================
// Sub-page: CC Switch
// ===========================================================================

class _CcSwitchPage extends ConsumerStatefulWidget {
  const _CcSwitchPage();
  @override
  ConsumerState<_CcSwitchPage> createState() => _CcSwitchPageState();
}

class _CcSwitchPageState extends ConsumerState<_CcSwitchPage> {
  Future<CcSwitchStatusResponse>? _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(apiProvider).ccSwitchStatus();
  }

  void _reload() =>
      setState(() => _future = ref.read(apiProvider).ccSwitchStatus());

  Future<void> _switch(String appType, String providerId) async {
    try {
      await ref
          .read(apiProvider)
          .switchCcProvider(appType: appType, providerId: providerId);
      _reload();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('切换失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: settingsBg(context),
      appBar: AppBar(
        title: const Text('CC Switch'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: FutureBuilder<CcSwitchStatusResponse>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || snap.data == null || !snap.data!.ok) {
            return const Center(
                child: Text('暂不可用', style: TextStyle(color: Colors.grey)));
          }
          final apps = snap.data!.apps;
          if (apps.isEmpty) {
            return const Center(child: Text('无 provider'));
          }
          return ListView(
            children: [
              for (final app in apps) ...[
                SettingsSectionHeader(app.title),
                SettingsGrouped(children: [
                  for (var i = 0; i < app.providers.length; i++) ...[
                    if (i > 0) const SettingsRowDivider(),
                    ListTile(
                      leading: Icon(
                        app.providers[i].isCurrent
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: app.providers[i].isCurrent
                            ? const Color(0xFF34C759)
                            : Theme.of(context).colorScheme.outline,
                      ),
                      title: Text(app.providers[i].name),
                      subtitle:
                          Text(app.providers[i].hasApiKey ? '已配置 key' : '未配置 key'),
                      enabled:
                          !app.providers[i].isCurrent && app.providers[i].hasApiKey,
                      onTap: () => _switch(app.appType, app.providers[i].id),
                    ),
                  ],
                ]),
              ],
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

// ===========================================================================
// Sub-page: Usage statistics
// ===========================================================================



/// Usage detail: all-time total, today, and a per-day Claude + Codex breakdown.
/// Backed by `GET /api/usage/daily` (ccusage). Reached from Settings → 用量统计.
