// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pane.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Pane _$PaneFromJson(Map<String, dynamic> json) => _Pane(
  id: json['id'] as String,
  target: json['target'] as String,
  session: json['session'] as String,
  windowIndex: json['windowIndex'] as String,
  windowName: json['windowName'] as String,
  paneIndex: json['paneIndex'] as String,
  command: json['command'] as String,
  path: json['path'] as String,
  active: json['active'] as bool,
  pid: (json['pid'] as num?)?.toInt(),
  title: json['title'] as String,
  tail: json['tail'] as String,
  status: $enumDecode(_$PaneStatusEnumMap, json['status']),
  reason: json['reason'] as String,
  updatedAt: json['updatedAt'] as String,
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => InteractionMessage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PaneToJson(_Pane instance) => <String, dynamic>{
  'id': instance.id,
  'target': instance.target,
  'session': instance.session,
  'windowIndex': instance.windowIndex,
  'windowName': instance.windowName,
  'paneIndex': instance.paneIndex,
  'command': instance.command,
  'path': instance.path,
  'active': instance.active,
  'pid': instance.pid,
  'title': instance.title,
  'tail': instance.tail,
  'status': _$PaneStatusEnumMap[instance.status]!,
  'reason': instance.reason,
  'updatedAt': instance.updatedAt,
  'messages': instance.messages,
};

const _$PaneStatusEnumMap = {
  PaneStatus.running: 'running',
  PaneStatus.waiting: 'waiting',
  PaneStatus.idle: 'idle',
  PaneStatus.failed: 'failed',
  PaneStatus.done: 'done',
};
