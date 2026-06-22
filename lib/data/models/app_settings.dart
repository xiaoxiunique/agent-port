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
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
