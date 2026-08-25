import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_provider.dart';
import 'demo_data.dart';

/// Custom display names for sessions, keyed by multiplexer session name.
///
/// Kept apart from the snapshot rather than added to `Pane`: that model is
/// generated, and a codegen run is currently broken. The map is also small and
/// changes far less often than the snapshot, so refetching it on rename is
/// cheaper than widening the 2.5s poll.
class SessionLabels extends AsyncNotifier<Map<String, String>> {
  @override
  Future<Map<String, String>> build() async {
    if (ref.watch(demoModeProvider)) return const {};
    try {
      return await ref.watch(apiProvider).sessionLabels();
    } on DioException {
      // An older host has no such endpoint. No labels is the same as none set.
      return const {};
    }
  }

  /// Rename [session], or clear its label when [label] is blank.
  Future<void> rename(String session, String label) async {
    final api = ref.read(apiProvider);
    final updated = await api.setSessionLabel(session, label.trim());
    state = AsyncData(updated);
  }
}

final sessionLabelsProvider =
    AsyncNotifierProvider<SessionLabels, Map<String, String>>(
  SessionLabels.new,
);
