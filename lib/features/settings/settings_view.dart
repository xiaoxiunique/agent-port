import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api/agent_monitor_api.dart';
import '../../data/models/cc_switch.dart';
import '../../data/models/project_history.dart';
import '../../data/models/server_profile.dart';
import '../../services/api_provider.dart';
import '../../services/settings_service.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider).valueOrNull;
    if (s == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          _ServiceSection(),
          _MonitorSection(),
          _QuickButtonsSection(),
          _VoiceSection(),
          _SectionHeader('CC SWITCH'),
          _CcSwitchSection(),
          _SectionHeader('PROJECT HISTORY'),
          _ProjectHistorySection(),
          _ResetSection(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Grouped-form section header (uppercase, secondary).
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SERVICE
// ---------------------------------------------------------------------------

enum _TestState { notTested, testing, success, error }

class _ServiceSection extends ConsumerStatefulWidget {
  const _ServiceSection();
  @override
  ConsumerState<_ServiceSection> createState() => _ServiceSectionState();
}

class _ServiceSectionState extends ConsumerState<_ServiceSection> {
  final _name = TextEditingController();
  final _url = TextEditingController();
  final _token = TextEditingController();
  String? _seededId;
  _TestState _test = _TestState.notTested;
  String _testDetail = 'Not tested';

  @override
  void dispose() {
    _name.dispose();
    _url.dispose();
    _token.dispose();
    super.dispose();
  }

  ServerProfile? _active(List<ServerProfile> profiles, String activeId) {
    for (final p in profiles) {
      if (p.id == activeId) return p;
    }
    return profiles.isNotEmpty ? profiles.first : null;
  }

  void _seed(ServerProfile p) {
    _seededId = p.id;
    _name.text = p.name;
    _url.text = p.url;
    _token.text = p.token ?? '';
  }

  void _commit() {
    final s = ref.read(settingsProvider).valueOrNull;
    if (s == null || _seededId == null) return;
    final t = _token.text.trim();
    ref.read(settingsProvider.notifier).updateProfile(
          ServerProfile(
            id: _seededId!,
            name: _name.text.trim().isEmpty ? _url.text.trim() : _name.text.trim(),
            url: _url.text.trim(),
            token: t.isEmpty ? null : t,
          ),
        );
    setState(() {
      _test = _TestState.notTested;
      _testDetail = 'Not tested';
    });
  }

  Future<void> _testConnection() async {
    setState(() {
      _test = _TestState.testing;
      _testDetail = 'Testing…';
    });
    final t = _token.text.trim();
    final api = AgentMonitorApi(
      baseUrl: _url.text.trim(),
      token: t.isEmpty ? null : t,
    );
    try {
      final snap = await api.snapshot();
      if (!mounted) return;
      setState(() {
        _test = _TestState.success;
        _testDetail = '${snap.panes.length} panes';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _test = _TestState.error;
        _testDetail = 'Failed';
      });
    }
  }

  Future<void> _addServer() async {
    final notifier = ref.read(settingsProvider.notifier);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await notifier.addProfile(ServerProfile(
      id: id,
      name: 'New Server',
      url: 'http://127.0.0.1:8787',
    ));
    await notifier.setActive(id);
  }

  Future<void> _deleteServer(String id) async {
    await ref.read(settingsProvider.notifier).removeProfile(id);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider).valueOrNull;
    final profiles = s?.profiles ?? const <ServerProfile>[];
    final active = _active(profiles, s?.activeProfileId ?? '');

    if (active != null && active.id != _seededId) {
      _seed(active);
    }

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader('SERVICE'),
        _Grouped(children: [
          // Server selector
          ListTile(
            title: const Text('Server'),
            trailing: DropdownButton<String>(
              value: active?.id,
              underline: const SizedBox.shrink(),
              items: [
                for (final p in profiles)
                  DropdownMenuItem(value: p.id, child: Text(p.name)),
              ],
              onChanged: (id) {
                if (id != null) {
                  ref.read(settingsProvider.notifier).setActive(id);
                }
              },
            ),
          ),
          const Divider(height: 1),
          _FieldRow(label: 'Name', controller: _name, onCommit: _commit),
          const Divider(height: 1),
          _FieldRow(
            label: 'URL',
            controller: _url,
            keyboardType: TextInputType.url,
            onCommit: _commit,
          ),
          const Divider(height: 1),
          _FieldRow(
            label: 'Token',
            controller: _token,
            hint: 'Optional',
            obscure: true,
            onCommit: _commit,
          ),
          const Divider(height: 1),
          // Test connection
          ListTile(
            leading: const Icon(Icons.wifi_tethering),
            title: const Text('Test Connection'),
            trailing: _TestBadge(state: _test, detail: _testDetail),
            onTap: _test == _TestState.testing ? null : _testConnection,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Server'),
            onTap: _addServer,
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.delete_outline,
                color: profiles.length > 1 ? Colors.red : theme.disabledColor),
            title: Text(
              'Delete Current Server',
              style: TextStyle(
                color: profiles.length > 1 ? Colors.red : theme.disabledColor,
              ),
            ),
            enabled: profiles.length > 1 && active != null,
            onTap: active == null ? null : () => _deleteServer(active.id),
          ),
        ]),
      ],
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
    Color color;
    switch (state) {
      case _TestState.success:
        color = const Color(0xFF34C759);
      case _TestState.error:
        color = Colors.red;
      case _TestState.testing:
        color = theme.colorScheme.primary;
      case _TestState.notTested:
        color = theme.colorScheme.onSurfaceVariant;
    }
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

/// An inline label + editable value row that commits on focus loss / submit.
class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.label,
    required this.controller,
    required this.onCommit,
    this.hint,
    this.obscure = false,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onCommit;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label)),
          Expanded(
            child: Focus(
              onFocusChange: (has) {
                if (!has) onCommit();
              },
              child: TextField(
                controller: controller,
                obscureText: obscure,
                keyboardType: keyboardType,
                autocorrect: false,
                textAlign: TextAlign.right,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onCommit(),
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MONITOR
// ---------------------------------------------------------------------------

class _MonitorSection extends ConsumerWidget {
  const _MonitorSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider).valueOrNull;
    final refresh = s?.refreshInterval ?? 2.5;
    final keepAwake = s?.keepScreenAwake ?? false;
    final notifier = ref.read(settingsProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader('MONITOR'),
        _Grouped(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                const Text('Refresh'),
                const Spacer(),
                SegmentedButton<double>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: 1.0, label: Text('1s')),
                    ButtonSegment(value: 2.5, label: Text('2.5s')),
                    ButtonSegment(value: 5.0, label: Text('5s')),
                    ButtonSegment(value: 10.0, label: Text('10s')),
                  ],
                  selected: {refresh},
                  onSelectionChanged: (sel) =>
                      notifier.setRefreshInterval(sel.first),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Keep Screen Awake'),
            value: keepAwake,
            onChanged: notifier.setKeepScreenAwake,
          ),
        ]),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// QUICK BUTTONS
// ---------------------------------------------------------------------------

const _defaultQuickButtons = ['继续', 'yes', 'no', 'LGTM', 'skip'];
const _maxQuickButtons = 12;

class _QuickButtonsSection extends ConsumerWidget {
  const _QuickButtonsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider).valueOrNull;
    final notifier = ref.read(settingsProvider.notifier);
    final buttons = (s?.quickActionButtons ?? const <String>[]).isEmpty
        ? _defaultQuickButtons
        : s!.quickActionButtons;

    void update(List<String> next) => notifier.setQuickActionButtons(next);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader('QUICK BUTTONS'),
        _Grouped(children: [
          for (var i = 0; i < buttons.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            ListTile(
              dense: true,
              title: Text(buttons[i]),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () {
                  final next = [...buttons]..removeAt(i);
                  update(next);
                },
              ),
            ),
          ],
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Button'),
            enabled: buttons.length < _maxQuickButtons,
            onTap: () async {
              final text = await _promptButton(context);
              if (text != null && text.trim().isNotEmpty) {
                update([...buttons, text.trim()]);
              }
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore Defaults'),
            onTap: () => update(_defaultQuickButtons),
          ),
        ]),
      ],
    );
  }

  Future<String?> _promptButton(BuildContext context) {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Quick Button'),
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

// ---------------------------------------------------------------------------
// VOICE INPUT
// ---------------------------------------------------------------------------

class _VoiceSection extends ConsumerStatefulWidget {
  const _VoiceSection();
  @override
  ConsumerState<_VoiceSection> createState() => _VoiceSectionState();
}

class _VoiceSectionState extends ConsumerState<_VoiceSection> {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader('VOICE INPUT'),
        _Grouped(children: [
          ListTile(
            title: const Text('Recognition'),
            trailing: DropdownButton<String>(
              value: provider,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: 'system', child: Text('System')),
                DropdownMenuItem(value: 'tencent', child: Text('Tencent')),
              ],
              onChanged: (v) {
                if (v != null) {
                  ref
                      .read(settingsProvider.notifier)
                      .setVoiceSettings(provider: v);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Text(
              isTencent
                  ? '使用腾讯云实时 ASR(16k_zh);需填写下方凭证。'
                  : '使用系统语音识别(iOS/macOS Apple Speech、Android SpeechRecognizer)。',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (isTencent) ...[
            const Divider(height: 1),
            _FieldRow(label: 'AppID', controller: _appId, onCommit: _commit),
            const Divider(height: 1),
            _FieldRow(
                label: 'SecretId', controller: _secretId, onCommit: _commit),
            const Divider(height: 1),
            _FieldRow(
                label: 'SecretKey',
                controller: _secretKey,
                obscure: true,
                onCommit: _commit),
            const Divider(height: 1),
            _FieldRow(
                label: 'Token',
                controller: _token,
                hint: 'Optional',
                obscure: true,
                onCommit: _commit),
          ],
        ]),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// RESET
// ---------------------------------------------------------------------------

class _ResetSection extends ConsumerWidget {
  const _ResetSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader('RESET'),
        _Grouped(children: [
          ListTile(
            leading: const Icon(Icons.settings_backup_restore, color: Colors.red),
            title: const Text('Reset Settings',
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Reset Settings'),
                  content: const Text('重置刷新频率、息屏、快捷按钮等偏好(服务器配置保留)。'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('取消')),
                    FilledButton(
                        style:
                            FilledButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('重置')),
                  ],
                ),
              );
              if (ok == true) {
                await ref.read(settingsProvider.notifier).resetSettings();
              }
            },
          ),
        ]),
      ],
    );
  }
}

/// A rounded grouped container holding form rows (iOS inset-grouped look).
class _Grouped extends StatelessWidget {
  const _Grouped({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CC SWITCH (Flutter addition — provider switching is also on the input bar)
// ---------------------------------------------------------------------------

class _CcSwitchSection extends ConsumerStatefulWidget {
  const _CcSwitchSection();
  @override
  ConsumerState<_CcSwitchSection> createState() => _CcSwitchSectionState();
}

class _CcSwitchSectionState extends ConsumerState<_CcSwitchSection> {
  Future<CcSwitchStatusResponse>? _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(apiProvider).ccSwitchStatus();
  }

  void _reload() {
    setState(() {
      _future = ref.read(apiProvider).ccSwitchStatus();
    });
  }

  Future<void> _switch(String appType, String providerId) async {
    try {
      await ref.read(apiProvider).switchCcProvider(
            appType: appType,
            providerId: providerId,
          );
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
    return _Grouped(children: [
      ListTile(
        dense: true,
        title: const Text('Providers'),
        trailing: IconButton(
            icon: const Icon(Icons.refresh), onPressed: _reload, iconSize: 20),
      ),
      FutureBuilder<CcSwitchStatusResponse>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
          }
          if (snap.hasError || snap.data == null || !snap.data!.ok) {
            return Padding(
                padding: const EdgeInsets.all(16),
                child: Text('不可用${snap.hasError ? ': ${snap.error}' : ''}'));
          }
          final apps = snap.data!.apps;
          if (apps.isEmpty) {
            return const Padding(
                padding: EdgeInsets.all(16), child: Text('无 provider'));
          }
          return Column(
            children: [
              for (final app in apps) ...[
                const Divider(height: 1),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(app.title,
                        style: Theme.of(context).textTheme.labelMedium),
                  ),
                ),
                for (final p in app.providers)
                  ListTile(
                    dense: true,
                    leading: Icon(
                      p.isCurrent
                          ? Icons.check_circle
                          : Icons.radio_button_off,
                      size: 20,
                      color: p.isCurrent ? Colors.green : null,
                    ),
                    title: Text(p.name),
                    subtitle: Text(p.hasApiKey ? '已配置 key' : '未配置 key'),
                    enabled: !p.isCurrent && p.hasApiKey,
                    onTap: () => _switch(app.appType, p.id),
                  ),
              ],
            ],
          );
        },
      ),
    ]);
  }
}

// ---------------------------------------------------------------------------
// PROJECT HISTORY (Flutter addition)
// ---------------------------------------------------------------------------

class _ProjectHistorySection extends ConsumerStatefulWidget {
  const _ProjectHistorySection();
  @override
  ConsumerState<_ProjectHistorySection> createState() =>
      _ProjectHistorySectionState();
}

class _ProjectHistorySectionState extends ConsumerState<_ProjectHistorySection> {
  Future<ProjectHistoryResponse>? _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(apiProvider).projectHistory();
  }

  void _reload() {
    setState(() {
      _future = ref.read(apiProvider).projectHistory();
    });
  }

  Future<void> _launch(String path, String agent) async {
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
    return _Grouped(children: [
      ListTile(
        dense: true,
        title: const Text('Recent Projects'),
        trailing: IconButton(
            icon: const Icon(Icons.refresh), onPressed: _reload, iconSize: 20),
      ),
      FutureBuilder<ProjectHistoryResponse>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
          }
          if (snap.hasError || snap.data == null) {
            return Padding(
                padding: const EdgeInsets.all(16),
                child: Text('不可用${snap.hasError ? ': ${snap.error}' : ''}'));
          }
          final projects = snap.data!.projects;
          if (projects.isEmpty) {
            return const Padding(
                padding: EdgeInsets.all(16), child: Text('暂无项目'));
          }
          return Column(
            children: [
              for (final p in projects) ...[
                const Divider(height: 1),
                ListTile(
                  dense: true,
                  title: Text(p.name),
                  subtitle: Text(p.path),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.terminal),
                        tooltip: 'Claude',
                        onPressed: () => _launch(p.path, 'claude'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.code),
                        tooltip: 'Codex',
                        onPressed: () => _launch(p.path, 'codex'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    ]);
  }
}
