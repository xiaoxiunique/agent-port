import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/app_settings.dart';
import '../data/models/server_profile.dart';

const _profilesKey = 'app_settings_profiles';
const _activeKey = 'active_profile_id';
const _onboardingKey = 'has_completed_onboarding';
const _refreshKey = 'refresh_interval';

/// Persists [AppSettings] in shared preferences (profiles include tokens;
/// local-first, mirrors iOS UserDefaults).
class SettingsNotifier extends AsyncNotifier<AppSettings> {
  late SharedPreferences _prefs;

  @override
  Future<AppSettings> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _load();
  }

  Future<AppSettings> _load() async {
    final json = _prefs.getString(_profilesKey) ?? '[]';
    final list = jsonDecode(json) as List<dynamic>;
    final profiles = list
        .map((e) => ServerProfile.fromJson(e as Map<String, dynamic>))
        .toList();
    final activeId = _prefs.getString(_activeKey) ??
        (profiles.isNotEmpty ? profiles.first.id : '');
    return AppSettings(
      profiles: profiles,
      activeProfileId: activeId,
      hasCompletedOnboarding: _prefs.getBool(_onboardingKey) ?? false,
      refreshInterval: _prefs.getDouble(_refreshKey) ?? 2.5,
    );
  }

  Future<void> _persist(AppSettings s) async {
    await _prefs.setString(
      _profilesKey,
      jsonEncode(s.profiles.map((p) => p.toJson()).toList()),
    );
    await _prefs.setString(_activeKey, s.activeProfileId);
    await _prefs.setBool(_onboardingKey, s.hasCompletedOnboarding);
    await _prefs.setDouble(_refreshKey, s.refreshInterval);
  }

  Future<void> addProfile(ServerProfile p) async {
    final s = state.valueOrNull;
    if (s == null) return;
    final updated = s.copyWith(
      profiles: [...s.profiles, p],
      activeProfileId: s.activeProfileId.isEmpty ? p.id : s.activeProfileId,
    );
    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> updateProfile(ServerProfile p) async {
    final s = state.valueOrNull;
    if (s == null) return;
    final updated = s.copyWith(
      profiles: s.profiles.map((e) => e.id == p.id ? p : e).toList(),
    );
    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> removeProfile(String id) async {
    final s = state.valueOrNull;
    if (s == null) return;
    final remaining = s.profiles.where((p) => p.id != id).toList();
    final activeId = s.activeProfileId == id
        ? (remaining.isNotEmpty ? remaining.first.id : '')
        : s.activeProfileId;
    final updated = s.copyWith(profiles: remaining, activeProfileId: activeId);
    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> setActive(String id) async {
    final s = state.valueOrNull;
    if (s == null) return;
    final updated = s.copyWith(activeProfileId: id);
    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> completeOnboarding() async {
    final s = state.valueOrNull;
    if (s == null) return;
    final updated = s.copyWith(hasCompletedOnboarding: true);
    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> setRefreshInterval(double v) async {
    final s = state.valueOrNull;
    if (s == null) return;
    final updated = s.copyWith(refreshInterval: v);
    state = AsyncData(updated);
    await _persist(updated);
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
