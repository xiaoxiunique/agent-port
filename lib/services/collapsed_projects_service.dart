import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _collapsedKey = 'collapsed_projects';

/// Which projects are folded shut on the home list.
///
/// Persisted, because a list tidied once should stay tidy — re-opening every
/// group at each launch is the same as not having folded them.
///
/// Deliberately not part of `AppSettings`: that is a generated freezed model
/// describing how the app behaves, and this is view state describing what you
/// are looking at. Keeping it here also means the home list can gain and lose
/// this without a codegen run.
class CollapsedProjects extends AsyncNotifier<Set<String>> {
  late SharedPreferences _prefs;

  @override
  Future<Set<String>> build() async {
    _prefs = await SharedPreferences.getInstance();
    return (_prefs.getStringList(_collapsedKey) ?? const <String>[]).toSet();
  }

  /// Fold a project shut, or open it again.
  Future<void> toggle(String project) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final next = {...current};
    if (!next.remove(project)) next.add(project);
    state = AsyncData(next);
    await _prefs.setStringList(_collapsedKey, next.toList());
  }
}

final collapsedProjectsProvider =
    AsyncNotifierProvider<CollapsedProjects, Set<String>>(
      CollapsedProjects.new,
    );
