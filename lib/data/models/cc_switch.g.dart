// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cc_switch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CcSwitchProvider _$CcSwitchProviderFromJson(Map<String, dynamic> json) =>
    _CcSwitchProvider(
      id: json['id'] as String,
      appType: json['appType'] as String,
      name: json['name'] as String,
      isCurrent: json['isCurrent'] as bool,
      baseUrl: json['baseUrl'] as String?,
      hasApiKey: json['hasApiKey'] as bool,
    );

Map<String, dynamic> _$CcSwitchProviderToJson(_CcSwitchProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appType': instance.appType,
      'name': instance.name,
      'isCurrent': instance.isCurrent,
      'baseUrl': instance.baseUrl,
      'hasApiKey': instance.hasApiKey,
    };

_CcSwitchApp _$CcSwitchAppFromJson(Map<String, dynamic> json) => _CcSwitchApp(
  appType: json['appType'] as String,
  title: json['title'] as String,
  activeProviderId: json['activeProviderId'] as String?,
  providers:
      (json['providers'] as List<dynamic>?)
          ?.map((e) => CcSwitchProvider.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$CcSwitchAppToJson(_CcSwitchApp instance) =>
    <String, dynamic>{
      'appType': instance.appType,
      'title': instance.title,
      'activeProviderId': instance.activeProviderId,
      'providers': instance.providers,
    };

_CcSwitchStatusResponse _$CcSwitchStatusResponseFromJson(
  Map<String, dynamic> json,
) => _CcSwitchStatusResponse(
  ok: json['ok'] as bool,
  apps:
      (json['apps'] as List<dynamic>?)
          ?.map((e) => CcSwitchApp.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$CcSwitchStatusResponseToJson(
  _CcSwitchStatusResponse instance,
) => <String, dynamic>{'ok': instance.ok, 'apps': instance.apps};
