// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  profiles:
      (json['profiles'] as List<dynamic>?)
          ?.map((e) => ServerProfile.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  activeProfileId: json['activeProfileId'] as String? ?? '',
  hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
  refreshInterval: (json['refreshInterval'] as num?)?.toDouble() ?? 2.5,
  keepScreenAwake: json['keepScreenAwake'] as bool? ?? false,
  quickActionButtons:
      (json['quickActionButtons'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  pinnedProjects:
      (json['pinnedProjects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'profiles': instance.profiles,
      'activeProfileId': instance.activeProfileId,
      'hasCompletedOnboarding': instance.hasCompletedOnboarding,
      'refreshInterval': instance.refreshInterval,
      'keepScreenAwake': instance.keepScreenAwake,
      'quickActionButtons': instance.quickActionButtons,
      'pinnedProjects': instance.pinnedProjects,
    };
