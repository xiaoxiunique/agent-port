import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/pane.dart';
import '../../services/api_provider.dart';
import '../../services/pip_service.dart';
import '../../services/snapshot_service.dart';
import 'actions_tab.dart';
import 'status_tab.dart';
import 'terminal_pane_view.dart';

/// Three-tab pane detail: Terminal (interactive), Actions (messages), Status.
class PaneDetailPage extends ConsumerWidget {
  const PaneDetailPage({super.key, required this.paneId});

  final String paneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panes =
        ref.watch(snapshotProvider).valueOrNull?.panes ?? const <Pane>[];
    Pane? pane;
    for (final p in panes) {
      if (p.id == paneId) {
        pane = p;
        break;
      }
    }
    final title = (pane?.command.isNotEmpty ?? false)
        ? pane!.command
        : (pane != null ? _shortSession(pane.session) : paneId);
    final foundPane = pane;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title, overflow: TextOverflow.ellipsis),
          actions: [
            if (foundPane != null && Platform.isIOS)
              IconButton(
                icon: const Icon(Icons.picture_in_picture),
                tooltip: '画中画',
                onPressed: () async {
                  if (await PipService.isSupported) {
                    await PipService.start(
                      title: foundPane.command.isNotEmpty
                          ? foundPane.command
                          : foundPane.session,
                      status: foundPane.status.name,
                      body: foundPane.tail,
                    );
                  }
                },
              ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Terminal'),
              Tab(text: 'Actions'),
              Tab(text: 'Status'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TerminalPaneView(
              api: ref.read(apiProvider),
              paneId: paneId,
            ),
            pane != null
                ? ActionsTab(pane: pane)
                : const Center(child: Text('pane 不在当前快照')),
            StatusTab(paneId: paneId),
          ],
        ),
      ),
    );
  }
}

String _shortSession(String session) {
  final parts = session.split('_');
  return parts.length >= 2 ? '${parts[0]} / ${parts[1]}' : session;
}
