// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SystemStats _$SystemStatsFromJson(Map<String, dynamic> json) => _SystemStats(
  cpuUsage: json['cpuUsage'] as num?,
  memoryUsage: json['memoryUsage'] as num?,
);

Map<String, dynamic> _$SystemStatsToJson(_SystemStats instance) =>
    <String, dynamic>{
      'cpuUsage': instance.cpuUsage,
      'memoryUsage': instance.memoryUsage,
    };

_DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => _DeviceInfo(
  name: json['name'] as String?,
  modelIdentifier: json['modelIdentifier'] as String?,
  kind: json['kind'] as String,
  modelName: json['modelName'] as String,
);

Map<String, dynamic> _$DeviceInfoToJson(_DeviceInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'modelIdentifier': instance.modelIdentifier,
      'kind': instance.kind,
      'modelName': instance.modelName,
    };

_Snapshot _$SnapshotFromJson(Map<String, dynamic> json) => _Snapshot(
  ok: json['ok'] as bool,
  now: json['now'] as String,
  panes:
      (json['panes'] as List<dynamic>?)
          ?.map((e) => Pane.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  system: json['system'] == null
      ? null
      : SystemStats.fromJson(json['system'] as Map<String, dynamic>),
  device: json['device'] == null
      ? null
      : DeviceInfo.fromJson(json['device'] as Map<String, dynamic>),
  error: json['error'] as String?,
);

Map<String, dynamic> _$SnapshotToJson(_Snapshot instance) => <String, dynamic>{
  'ok': instance.ok,
  'now': instance.now,
  'panes': instance.panes,
  'system': instance.system,
  'device': instance.device,
  'error': instance.error,
};
