import 'package:freezed_annotation/freezed_annotation.dart';

import 'server_profile.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// App-wide settings. Mirrors iOS `AppSettings`.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default([]) List<ServerProfile> profiles,
    @Default('') String activeProfileId,
    @Default(false) bool hasCompletedOnboarding,
    @Default(2.5) double refreshInterval,
    @Default(false) bool keepScreenAwake,
    @Default([]) List<String> quickActionButtons,
    @Default([]) List<String> pinnedProjects,
    @Default('system') String voiceRecognitionProvider,
    @Default('') String tencentAsrAppId,
    @Default('') String tencentAsrSecretId,
    @Default('') String tencentAsrSecretKey,
    @Default('') String tencentAsrToken,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
