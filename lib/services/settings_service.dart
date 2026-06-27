import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/app_settings.dart';
import '../data/models/server_profile.dart';

const _profilesKey = 'app_settings_profiles';
const _activeKey = 'active_profile_id';
const _onboardingKey = 'has_completed_onboarding';
const _refreshKey = 'refresh_interval';
const _keepAwakeKey = 'keep_screen_awake';
const _quickButtonsKey = 'quick_action_buttons';
const _pinnedKey = 'pinned_projects';
const _voiceProviderKey = 'voice_recognition_provider';
const _tcAppIdKey = 'tencent_asr_app_id';
const _tcSecretIdKey = 'tencent_asr_secret_id';
const _tcSecretKeyKey = 'tencent_asr_secret_key';
const _tcTokenKey = 'tencent_asr_token';

/// Persists [AppSettings] in shared preferences (profiles include tokens;
/// local-first, mirrors iOS UserDefaults).
class SettingsNotifier extends AsyncNotifier<AppSettings> {
  late SharedPreferences _prefs;

  @override
  Future<AppSettings> build() async {
    _prefs = await SharedPreferences.getInstance();
    final settings = await _load();
    // Dev bootstrap: seed a local profile so we skip onboarding during testing.
    // Persist + return directly — addProfile/completeOnboarding no-op here
    // because `state` isn't set yet during build().
    if (!settings.hasCompletedOnboarding && settings.profiles.isEmpty) {
      final AppSettings seeded;
      if (kIsWeb) {
        // Web client is served by the host service → connect to the page origin.
        seeded = AppSettings(
          profiles: [
            ServerProfile(id: 'local', name: '本机服务', url: Uri.base.origin),
          ],
          activeProfileId: 'local',
          hasCompletedOnboarding: true,
        );
      } else {
        // Native first launch: the Demo profile (offline sample data) is active
        // so the app is populated immediately (App Store review + first run),
        // with the local Mac service one tap away. 'demo' matches demoProfileUrl.
        seeded = const AppSettings(
          profiles: [
            ServerProfile(id: 'demo', name: '演示 Demo', url: 'demo'),
            ServerProfile(id: 'local', name: 'Mac (local)', url: 'http://127.0.0.1:8797'),
          ],
          activeProfileId: 'demo',
          hasCompletedOnboarding: true,
        );
      }
      await _persist(seeded);
      return seeded;
    }
    return settings;
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
      keepScreenAwake: _prefs.getBool(_keepAwakeKey) ?? false,
      quickActionButtons: _prefs.getStringList(_quickButtonsKey) ?? const [],
      pinnedProjects: _prefs.getStringList(_pinnedKey) ?? const [],
      voiceRecognitionProvider: _prefs.getString(_voiceProviderKey) ?? 'system',
      tencentAsrAppId: _prefs.getString(_tcAppIdKey) ?? '',
      tencentAsrSecretId: _prefs.getString(_tcSecretIdKey) ?? '',
      tencentAsrSecretKey: _prefs.getString(_tcSecretKeyKey) ?? '',
      tencentAsrToken: _prefs.getString(_tcTokenKey) ?? '',
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
    await _prefs.setBool(_keepAwakeKey, s.keepScreenAwake);
    await _prefs.setStringList(_quickButtonsKey, s.quickActionButtons);
    await _prefs.setStringList(_pinnedKey, s.pinnedProjects);
    await _prefs.setString(_voiceProviderKey, s.voiceRecognitionProvider);
    await _prefs.setString(_tcAppIdKey, s.tencentAsrAppId);
    await _prefs.setString(_tcSecretIdKey, s.tencentAsrSecretId);
    await _prefs.setString(_tcSecretKeyKey, s.tencentAsrSecretKey);
    await _prefs.setString(_tcTokenKey, s.tencentAsrToken);
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

  Future<void> setKeepScreenAwake(bool v) async {
    final s = state.valueOrNull;
    if (s == null) return;
    final updated = s.copyWith(keepScreenAwake: v);
    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> setQuickActionButtons(List<String> v) async {
    final s = state.valueOrNull;
    if (s == null) return;
    final updated = s.copyWith(quickActionButtons: v);
    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> setVoiceSettings({
    String? provider,
    String? appId,
    String? secretId,
    String? secretKey,
    String? token,
  }) async {
    final s = state.valueOrNull;
    if (s == null) return;
    final updated = s.copyWith(
      voiceRecognitionProvider: provider ?? s.voiceRecognitionProvider,
      tencentAsrAppId: appId ?? s.tencentAsrAppId,
      tencentAsrSecretId: secretId ?? s.tencentAsrSecretId,
      tencentAsrSecretKey: secretKey ?? s.tencentAsrSecretKey,
      tencentAsrToken: token ?? s.tencentAsrToken,
    );
    state = AsyncData(updated);
    await _persist(updated);
  }

  /// Reset preferences (refresh cadence, screen-awake, quick buttons, pins) to
  /// defaults. Server profiles and onboarding are preserved.
  Future<void> resetSettings() async {
    final s = state.valueOrNull;
    if (s == null) return;
    final updated = s.copyWith(
      refreshInterval: 2.5,
      keepScreenAwake: false,
      quickActionButtons: const [],
      pinnedProjects: const [],
    );
    state = AsyncData(updated);
    await _persist(updated);
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
