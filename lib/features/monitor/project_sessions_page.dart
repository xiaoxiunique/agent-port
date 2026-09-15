import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/pane_ext.dart';
import '../../core/widgets/content_pane.dart';
import '../../services/snapshot_service.dart';
import 'monitor_page.dart' show PaneCard;

/// The sessions running in one project.
///
/// Reached only from a project that has more than one — the home list opens a
/// lone session directly, because a list of one is a tap that asks nothing.
class ProjectSessionsPage extends ConsumerWidget {
  const ProjectSessionsPage({super.key, required this.project});

  final String project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(snapshotProvider).valueOrNull;
    final panes = snapshot == null
        ? const []
        : groupPanesByProject(sortedPanes(snapshot.panes))
              .where((g) => g.project == project)
              .expand((g) => g.panes)
              .toList();

    return Scaffold(
      appBar: AppBar(title: Text(project)),
      body: panes.isEmpty
          // The last session here was killed, or the server went away while
          // this page was open. Say so rather than showing an empty page.
          ? Center(
              child: Text(
                '$project 没有在运行的会话了',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : ContentPane(
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
                itemCount: panes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) => PaneCard(pane: panes[i]),
              ),
            ),
    );
  }
}
