import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api/agent_monitor_api.dart';
import '../../data/models/cc_switch.dart';
import '../../data/models/project_history.dart';
import '../../data/models/running_app.dart';
import '../../data/models/server_profile.dart';
import '../../services/api_provider.dart';
import '../../services/demo_data.dart';
import '../../services/settings_service.dart';
import '../../services/snapshot_service.dart';

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
        backgroundColor: _settingsBg(context),
        appBar: AppBar(title: const Text('Settings')),
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
      backgroundColor: _settingsBg(context),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: _settingsBg(context),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 4, bottom: 100),
        children: [
          const _SectionHeader('连接'),
          _Grouped(children: [
            _Row(
              icon: Icons.dns_outlined,
              tint: const Color(0xFF007AFF),
              label: '服务器',
              value: activeName,
              onTap: () => _push(context, const _ServersListPage()),
            ),
          ]),
          const _SectionHeader('监控'),
          _Grouped(children: [
            _Row(
              icon: Icons.timer_outlined,
              tint: const Color(0xFFFF9500),
              label: '刷新频率',
              value: _refreshLabel(s.refreshInterval),
              onTap: () => _push(context, const _RefreshPage()),
            ),
            const _RowDivider(),
            _RowSwitch(
              icon: Icons.brightness_high_outlined,
              tint: const Color(0xFF5856D6),
              label: '常亮屏幕',
              value: s.keepScreenAwake,
              onChanged: notifier.setKeepScreenAwake,
            ),
          ]),
          const _SectionHeader('输入'),
          _Grouped(children: [
            _Row(
              icon: Icons.bolt_outlined,
              tint: const Color(0xFF30B0C7),
              label: '快捷按钮',
              value: '$quickCount 个',
              onTap: () => _push(context, const _QuickButtonsPage()),
            ),
            const _RowDivider(),
            _Row(
              icon: Icons.mic_none_outlined,
              tint: const Color(0xFFFF2D55),
              label: '语音识别',
              value: s.voiceRecognitionProvider == 'tencent' ? '腾讯云' : '系统',
              onTap: () => _push(context, const _VoicePage()),
            ),
          ]),
          const _SectionHeader('工具'),
          _Grouped(children: [
            _Row(
              icon: Icons.hub_outlined,
              tint: const Color(0xFFAF52DE),
              label: 'CC Switch',
              onTap: () => _push(context, const _CcSwitchPage()),
            ),
          ]),
          const SizedBox(height: 24),
          _Grouped(children: [
            _Row(
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
Color _settingsBg(BuildContext context) {
  final b = Theme.of(context).brightness;
  return b == Brightness.dark ? const Color(0xFF0D0D0F) : const Color(0xFFF2F2F7);
}

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
      backgroundColor: _settingsBg(context),
      appBar: AppBar(
        backgroundColor: _settingsBg(context),
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
            _SectionHeader(
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
            _SectionHeader(
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
      backgroundColor: _settingsBg(context),
      appBar: AppBar(
        title: const Text('服务器'),
        backgroundColor: _settingsBg(context),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 32),
        children: [
          _Grouped(children: [
            for (var i = 0; i < profiles.length; i++) ...[
              if (i > 0) const _RowDivider(),
              _DeviceRow(
                profile: profiles[i],
                active: profiles[i].id == activeId,
                online: profiles[i].id == activeId && reachable,
                onTap: () => notifier.setActive(profiles[i].id),
                onEdit: () =>
                    _push(context, _ServerEditPage(profileId: profiles[i].id)),
              ),
            ],
          ]),
          const SizedBox(height: 16),
          _Grouped(children: [
            _NavRow(
              label: '添加服务器',
              leading: Icons.add,
              accent: true,
              onTap: () => _push(context, const _ServerEditPage()),
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
      return _Grouped(children: [
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
          return const _Grouped(children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ]);
        }
        if (snap.hasError || snap.data == null || !snap.data!.ok) {
          return const _Grouped(children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('获取失败 — 当前服务端未提供 /api/apps(需更新 Agent Monitor 服务)',
                  style: TextStyle(color: Colors.grey)),
            ),
          ]);
        }
        final apps = snap.data!.apps;
        if (apps.isEmpty) {
          return const _Grouped(children: [
            Padding(
                padding: EdgeInsets.all(16),
                child: Text('无运行中的应用')),
          ]);
        }
        return _Grouped(children: [
          for (var i = 0; i < apps.length; i++) ...[
            if (i > 0) const _RowDivider(),
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
      backgroundColor: _settingsBg(context),
      appBar: AppBar(
        title: const Text('打开应用'),
        backgroundColor: _settingsBg(context),
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
          _IconBox(icon: Icons.computer, tint: active ? const Color(0xFF007AFF) : tint),
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

class _ServerEditPage extends ConsumerStatefulWidget {
  const _ServerEditPage({this.profileId});
  final String? profileId;

  @override
  ConsumerState<_ServerEditPage> createState() => _ServerEditPageState();
}

class _ServerEditPageState extends ConsumerState<_ServerEditPage> {
  final _name = TextEditingController();
  final _url = TextEditingController();
  final _token = TextEditingController();
  bool _seeded = false;
  _TestState _test = _TestState.idle;
  String _testDetail = '未测试';

  bool get _isNew => widget.profileId == null;

  @override
  void dispose() {
    _name.dispose();
    _url.dispose();
    _token.dispose();
    super.dispose();
  }

  void _seedFrom(ServerProfile? p) {
    _seeded = true;
    _name.text = p?.name ?? '';
    _url.text = p?.url ?? 'http://127.0.0.1:8787';
    _token.text = p?.token ?? '';
  }

  Future<void> _testConnection() async {
    setState(() {
      _test = _TestState.testing;
      _testDetail = '测试中…';
    });
    final t = _token.text.trim();
    final api = AgentMonitorApi(baseUrl: _url.text.trim(), token: t.isEmpty ? null : t);
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
    final name =
        _name.text.trim().isEmpty ? _url.text.trim() : _name.text.trim();
    final profile = ServerProfile(
      id: widget.profileId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      url: _url.text.trim(),
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
      backgroundColor: _settingsBg(context),
      appBar: AppBar(
        title: Text(_isNew ? '添加服务器' : '编辑服务器'),
        actions: [
          TextButton(onPressed: _save, child: const Text('保存')),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          _Grouped(children: [
            _TextFieldRow(label: '名称', controller: _name, hint: '可选'),
            const _RowDivider(),
            _TextFieldRow(
                label: 'URL',
                controller: _url,
                hint: 'http://…',
                keyboardType: TextInputType.url),
            const _RowDivider(),
            _TextFieldRow(
                label: 'Token', controller: _token, hint: '可选', obscure: true),
          ]),
          const SizedBox(height: 16),
          _Grouped(children: [
            ListTile(
              leading: const Icon(Icons.wifi_tethering),
              title: const Text('测试连接'),
              trailing: _TestBadge(state: _test, detail: _testDetail),
              onTap: _test == _TestState.testing ? null : _testConnection,
            ),
          ]),
          if (canDelete) ...[
            const SizedBox(height: 16),
            _Grouped(children: [
              _NavRow(label: '删除服务器', destructive: true, onTap: _delete),
            ]),
          ],
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
      backgroundColor: _settingsBg(context),
      appBar: AppBar(title: const Text('刷新频率')),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          _Grouped(children: [
            for (var i = 0; i < _options.length; i++) ...[
              if (i > 0) const _RowDivider(),
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
      backgroundColor: _settingsBg(context),
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
          _Grouped(children: [
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
// Sub-page: Voice input
// ===========================================================================

class _VoicePage extends ConsumerStatefulWidget {
  const _VoicePage();
  @override
  ConsumerState<_VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends ConsumerState<_VoicePage> {
  final _appId = TextEditingController();
  final _secretId = TextEditingController();
  final _secretKey = TextEditingController();
  final _token = TextEditingController();
  bool _seeded = false;

  @override
  void dispose() {
    _appId.dispose();
    _secretId.dispose();
    _secretKey.dispose();
    _token.dispose();
    super.dispose();
  }

  void _commit() {
    ref.read(settingsProvider.notifier).setVoiceSettings(
          appId: _appId.text.trim(),
          secretId: _secretId.text.trim(),
          secretKey: _secretKey.text.trim(),
          token: _token.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider).valueOrNull;
    final provider = s?.voiceRecognitionProvider ?? 'system';
    if (!_seeded && s != null) {
      _seeded = true;
      _appId.text = s.tencentAsrAppId;
      _secretId.text = s.tencentAsrSecretId;
      _secretKey.text = s.tencentAsrSecretKey;
      _token.text = s.tencentAsrToken;
    }
    final isTencent = provider == 'tencent';
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: _settingsBg(context),
      appBar: AppBar(title: const Text('语音识别')),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          _Grouped(children: [
            RadioGroup<String>(
              groupValue: provider,
              onChanged: (v) => notifier.setVoiceSettings(provider: v),
              child: const Column(
                children: [
                  RadioListTile<String>(
                    value: 'system',
                    title: Text('系统'),
                    subtitle: Text('Apple Speech / Android 系统语音'),
                  ),
                  _RowDivider(),
                  RadioListTile<String>(
                    value: 'tencent',
                    title: Text('腾讯云'),
                    subtitle: Text('实时 ASR(16k_zh),需填写凭证'),
                  ),
                ],
              ),
            ),
          ]),
          if (isTencent) ...[
            const _SectionHeader('腾讯云凭证'),
            _Grouped(children: [
              _TextFieldRow(label: 'AppID', controller: _appId, onChanged: (_) => _commit()),
              const _RowDivider(),
              _TextFieldRow(label: 'SecretId', controller: _secretId, onChanged: (_) => _commit()),
              const _RowDivider(),
              _TextFieldRow(label: 'SecretKey', controller: _secretKey, obscure: true, onChanged: (_) => _commit()),
              const _RowDivider(),
              _TextFieldRow(label: 'Token', controller: _token, hint: '可选', obscure: true, onChanged: (_) => _commit()),
            ]),
          ],
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
      backgroundColor: _settingsBg(context),
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
                _SectionHeader(app.title),
                _Grouped(children: [
                  for (var i = 0; i < app.providers.length; i++) ...[
                    if (i > 0) const _RowDivider(),
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
// Sub-page: Project history
// ===========================================================================

/// Recent-projects picker: pick a past project and launch Claude/Codex on it.
/// Reached from the home list's "添加项目" entry. Public so the monitor feature
/// can reuse it.
class ProjectHistoryPage extends ConsumerStatefulWidget {
  const ProjectHistoryPage({super.key});
  @override
  ConsumerState<ProjectHistoryPage> createState() => _ProjectHistoryPageState();
}

class _ProjectHistoryPageState extends ConsumerState<ProjectHistoryPage> {
  Future<ProjectHistoryResponse>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<ProjectHistoryResponse> _load() {
    if (ref.read(demoModeProvider)) {
      return Future.value(
          ProjectHistoryResponse(ok: true, projects: demoProjects()));
    }
    return ref.read(apiProvider).projectHistory();
  }

  void _reload() => setState(() => _future = _load());

  Future<void> _launch(String path, String agent) async {
    if (ref.read(demoModeProvider)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('演示模式下无法启动项目')),
      );
      return;
    }
    try {
      await ref.read(apiProvider).launchProject(path: path, agent: agent);
      _reload();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('已启动:$agent @ $path')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('启动失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _settingsBg(context),
      appBar: AppBar(
        title: const Text('项目历史'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: FutureBuilder<ProjectHistoryResponse>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || snap.data == null) {
            return const Center(
                child: Text('暂不可用', style: TextStyle(color: Colors.grey)));
          }
          final projects = snap.data!.projects;
          if (projects.isEmpty) {
            return const Center(child: Text('暂无项目'));
          }
          return ListView(
            children: [
              const SizedBox(height: 12),
              _Grouped(children: [
                for (var i = 0; i < projects.length; i++) ...[
                  if (i > 0) const _RowDivider(),
                  ListTile(
                    title: Text(projects[i].name),
                    subtitle: Text(projects[i].path,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.terminal),
                          tooltip: 'Claude',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _launch(projects[i].path, 'claude'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.code),
                          tooltip: 'Codex',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _launch(projects[i].path, 'codex'),
                        ),
                      ],
                    ),
                  ),
                ],
              ]),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

// ===========================================================================
// Shared building blocks
// ===========================================================================

/// Grouped-form section header (uppercase, secondary).
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text, {this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 22, trailing == null ? 20 : 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// A row that shows a label, an optional current value, and a chevron; drills
/// into a sub-page on tap. Mirrors iOS Settings rows.
class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.label,
    this.onTap,
    this.leading,
    this.destructive = false,
    this.accent = false,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? leading;
  final bool destructive;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor = destructive
        ? Colors.red
        : accent
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface;
    return ListTile(
      leading: leading == null
          ? null
          : Icon(leading, color: labelColor, size: 22),
      title: Text(label, style: TextStyle(color: labelColor)),
      trailing: destructive
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 6),
                Icon(Icons.chevron_right,
                    size: 20, color: theme.colorScheme.outline),
              ],
            ),
      onTap: onTap,
    );
  }
}

/// A row inside a grouped settings card: icon + label + current value +
/// chevron. (Destructive variant: red, no value/chevron.)
class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.tint,
    required this.label,
    this.value,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final Color tint;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: _IconBox(icon: icon, tint: destructive ? Colors.red : tint),
      title: Text(label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: destructive ? Colors.red : theme.colorScheme.onSurface)),
      trailing: destructive
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value != null)
                  Flexible(
                    child: Text(value!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            color: theme.colorScheme.onSurfaceVariant)),
                  ),
                const SizedBox(width: 6),
                Icon(Icons.chevron_right,
                    size: 20, color: theme.colorScheme.outline),
              ],
            ),
    );
  }
}

/// A row inside a grouped settings card with a trailing switch.
class _RowSwitch extends StatelessWidget {
  const _RowSwitch({
    required this.icon,
    required this.tint,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color tint;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () => onChanged(!value),
      leading: _IconBox(icon: icon, tint: tint),
      title: Text(label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface)),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

/// Rounded icon chip used on the left of a settings row.
class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, required this.tint});
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 19, color: tint),
    );
  }
}

/// Inline label + right-aligned editable value row (for forms).
class _TextFieldRow extends StatelessWidget {
  const _TextFieldRow({
    required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(width: 92, child: Text(label)),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              autocorrect: false,
              textAlign: TextAlign.right,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 1px inset divider between grouped rows.
class _RowDivider extends StatelessWidget {
  const _RowDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, indent: 16, endIndent: 0);
}

/// A rounded elevated card holding sub-page rows (white on grey, subtle shadow).
class _Grouped extends StatelessWidget {
  const _Grouped({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.0 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: theme.brightness == Brightness.dark
            ? Border.all(color: theme.dividerColor)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}
