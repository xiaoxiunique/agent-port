import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        appBar: AppBar(title: const Text('设置')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          _header(context, '服务器'),
          ...s.profiles.map((p) => _ProfileTile(
                profile: p,
                active: p.id == s.activeProfileId,
                onActivate: () =>
                    ref.read(settingsProvider.notifier).setActive(p.id),
                onEdit: () => _editProfile(context, ref, p),
                onDelete: () =>
                    ref.read(settingsProvider.notifier).removeProfile(p.id),
              )),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('添加服务器'),
            onTap: () => _editProfile(context, ref, null),
          ),
          const Divider(height: 32),
          const _CcSwitchSection(),
          const Divider(height: 32),
          const _ProjectHistorySection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(text, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.profile,
    required this.active,
    required this.onActivate,
    required this.onEdit,
    required this.onDelete,
  });
  final ServerProfile profile;
  final bool active;
  final VoidCallback onActivate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        active ? Icons.radio_button_checked : Icons.radio_button_off,
        color: active ? theme.colorScheme.primary : null,
      ),
      title: Text(profile.name),
      subtitle: Text(profile.url),
      onTap: onActivate,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(
              icon: const Icon(Icons.delete_outline), onPressed: onDelete),
        ],
      ),
    );
  }
}

Future<void> _editProfile(
  BuildContext context,
  WidgetRef ref,
  ServerProfile? existing,
) async {
  final name = TextEditingController(text: existing?.name ?? '');
  final url =
      TextEditingController(text: existing?.url ?? 'http://127.0.0.1:8797');
  final token = TextEditingController(text: existing?.token ?? '');
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(existing == null ? '添加服务器' : '编辑服务器'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: name,
              decoration: const InputDecoration(labelText: '名称')),
          TextField(
              controller: url,
              decoration: const InputDecoration(labelText: '地址'),
              autocorrect: false),
          TextField(
              controller: token,
              decoration: const InputDecoration(labelText: 'Token(可选)'),
              obscureText: true,
              autocorrect: false),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消')),
        FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('保存')),
      ],
    ),
  );
  if (ok != true) return;
  final notifier = ref.read(settingsProvider.notifier);
  final t = token.text.trim();
  final p = ServerProfile(
    id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    name: name.text.trim().isEmpty ? url.text.trim() : name.text.trim(),
    url: url.text.trim(),
    token: t.isEmpty ? null : t,
  );
  if (existing == null) {
    await notifier.addProfile(p);
  } else {
    await notifier.updateProfile(p);
  }
}

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(children: [
            const Expanded(
                child: Text('CC Switch',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _reload,
                iconSize: 20),
          ]),
        ),
        FutureBuilder<CcSwitchStatusResponse>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2)));
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(app.title,
                        style: Theme.of(context).textTheme.labelMedium),
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
      ],
    );
  }
}

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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('已启动:$agent @ $path')));
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(children: [
            const Expanded(
                child: Text('项目历史',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _reload,
                iconSize: 20),
          ]),
        ),
        FutureBuilder<ProjectHistoryResponse>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2)));
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
              children: projects
                  .map((p) => ListTile(
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
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
