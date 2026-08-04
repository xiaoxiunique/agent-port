import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/project_history.dart';
import '../../services/api_provider.dart';
import '../../services/demo_data.dart';
import 'widgets/settings_rows.dart';

/// Recently launched projects, with a shortcut to relaunch one.
///
/// Split out of settings_view.dart.

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
      backgroundColor: settingsBg(context),
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
              SettingsGrouped(children: [
                for (var i = 0; i < projects.length; i++) ...[
                  if (i > 0) const SettingsRowDivider(),
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
