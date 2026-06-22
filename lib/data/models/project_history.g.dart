// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectHistoryEntry _$ProjectHistoryEntryFromJson(Map<String, dynamic> json) =>
    _ProjectHistoryEntry(
      path: json['path'] as String,
      name: json['name'] as String,
      lastAgent: json['lastAgent'] as String,
      lastSeenAt: json['lastSeenAt'] as String,
      launchCount: (json['launchCount'] as num).toInt(),
    );

Map<String, dynamic> _$ProjectHistoryEntryToJson(
  _ProjectHistoryEntry instance,
) => <String, dynamic>{
  'path': instance.path,
  'name': instance.name,
  'lastAgent': instance.lastAgent,
  'lastSeenAt': instance.lastSeenAt,
  'launchCount': instance.launchCount,
};

_ProjectHistoryResponse _$ProjectHistoryResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectHistoryResponse(
  ok: json['ok'] as bool,
  projects:
      (json['projects'] as List<dynamic>?)
          ?.map((e) => ProjectHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ProjectHistoryResponseToJson(
  _ProjectHistoryResponse instance,
) => <String, dynamic>{'ok': instance.ok, 'projects': instance.projects};
