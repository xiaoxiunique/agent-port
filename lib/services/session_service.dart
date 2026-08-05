import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/sessions.dart';
import 'api_provider.dart';
import 'demo_data.dart';

/// Past Claude/Codex conversations for one project directory, newest first.
///
/// Keyed on the directory, so opening a different project refetches. The host
/// parses transcript files to build this, which can take a moment on projects
/// with long histories.
final projectSessionsProvider = FutureProvider.autoDispose
    .family<List<AgentSessions>, String>((ref, path) async {
  if (ref.watch(demoModeProvider)) return const [];
  return ref.watch(apiProvider).projectSessions(path);
});
