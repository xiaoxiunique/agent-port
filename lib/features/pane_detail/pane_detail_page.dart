import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/pane.dart';
import '../../services/api_provider.dart';
import '../../services/pip_service.dart';
import '../../services/snapshot_service.dart';
import 'input_bar.dart';
import 'terminal_pane_view.dart';

/// Single-page pane detail with a Logs/Terminal mode toggle and a unified
/// bottom InputBar. Mirrors the native PaneDetailSheet structure (not a tab bar).
class PaneDetailPage extends ConsumerStatefulWidget {
  const PaneDetailPage({super.key, required this.paneId});

  final String paneId;

  @override
  ConsumerState<PaneDetailPage> createState() => _PaneDetailPageState();
}

class _PaneDetailPageState extends ConsumerState<PaneDetailPage> {
  RuntimeMode _mode = RuntimeMode.log;

  @override
  Widget build(BuildContext context) {
    final panes =
        ref.watch(snapshotProvider).valueOrNull?.panes ?? const <Pane>[];
    Pane? pane;
    for (final p in panes) {
      if (p.id == widget.paneId) {
        pane = p;
        break;
      }
    }
    final title = (pane?.command.isNotEmpty ?? false)
        ? pane!.command
        : (pane != null ? _shortSession(pane.session) : widget.paneId);
    final foundPane = pane;

    return Scaffold(
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
      ),
      body: foundPane == null
          ? const Center(child: Text('pane 不在当前快照'))
          : _mode == RuntimeMode.terminal
              ? TerminalPaneView(
                  api: ref.read(apiProvider),
                  paneId: widget.paneId,
                )
              : _LogView(pane: foundPane),
      bottomNavigationBar: foundPane == null
          ? null
          : InputBar(
              pane: foundPane,
              mode: _mode,
              onToggleMode: () => setState(() {
                _mode = _mode == RuntimeMode.log
                    ? RuntimeMode.terminal
                    : RuntimeMode.log;
              }),
            ),
    );
  }
}

/// Logs mode: scrollable, selectable tail text (monospace).
class _LogView extends StatelessWidget {
  const _LogView({required this.pane});
  final Pane pane;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: SelectableText(
        pane.tail,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          height: 1.3,
        ),
      ),
    );
  }
}

String _shortSession(String session) {
  final parts = session.split('_');
  return parts.length >= 2 ? '${parts[0]} / ${parts[1]}' : session;
}
