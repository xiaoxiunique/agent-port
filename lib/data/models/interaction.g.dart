// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InteractionAction _$InteractionActionFromJson(Map<String, dynamic> json) =>
    _InteractionAction(
      label: json['label'] as String,
      payload: json['payload'] as String,
      style: $enumDecodeNullable(
        _$InteractionActionStyleEnumMap,
        json['style'],
      ),
    );

Map<String, dynamic> _$InteractionActionToJson(_InteractionAction instance) =>
    <String, dynamic>{
      'label': instance.label,
      'payload': instance.payload,
      'style': _$InteractionActionStyleEnumMap[instance.style],
    };

const _$InteractionActionStyleEnumMap = {
  InteractionActionStyle.$default: 'default',
  InteractionActionStyle.destructive: 'destructive',
};

_InteractionSource _$InteractionSourceFromJson(Map<String, dynamic> json) =>
    _InteractionSource(
      type: json['type'] as String,
      excerpt: json['excerpt'] as String,
    );

Map<String, dynamic> _$InteractionSourceToJson(_InteractionSource instance) =>
    <String, dynamic>{'type': instance.type, 'excerpt': instance.excerpt};

_InteractionMessage _$InteractionMessageFromJson(Map<String, dynamic> json) =>
    _InteractionMessage(
      id: json['id'] as String,
      paneId: json['paneId'] as String,
      role: $enumDecode(_$InteractionRoleEnumMap, json['role']),
      kind: $enumDecode(_$InteractionKindEnumMap, json['kind']),
      priority: $enumDecode(_$InteractionPriorityEnumMap, json['priority']),
      title: json['title'] as String,
      body: json['body'] as String,
      actions:
          (json['actions'] as List<dynamic>?)
              ?.map(
                (e) => InteractionAction.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      source: json['source'] == null
          ? null
          : InteractionSource.fromJson(json['source'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$InteractionMessageToJson(_InteractionMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paneId': instance.paneId,
      'role': _$InteractionRoleEnumMap[instance.role]!,
      'kind': _$InteractionKindEnumMap[instance.kind]!,
      'priority': _$InteractionPriorityEnumMap[instance.priority]!,
      'title': instance.title,
      'body': instance.body,
      'actions': instance.actions,
      'source': instance.source,
      'createdAt': instance.createdAt,
    };

const _$InteractionRoleEnumMap = {
  InteractionRole.agent: 'agent',
  InteractionRole.user: 'user',
  InteractionRole.system: 'system',
};

const _$InteractionKindEnumMap = {
  InteractionKind.summary: 'summary',
  InteractionKind.status: 'status',
  InteractionKind.question: 'question',
  InteractionKind.permissionRequest: 'permission_request',
  InteractionKind.progress: 'progress',
  InteractionKind.error: 'error',
  InteractionKind.done: 'done',
  InteractionKind.notification: 'notification',
};

const _$InteractionPriorityEnumMap = {
  InteractionPriority.low: 'low',
  InteractionPriority.normal: 'normal',
  InteractionPriority.high: 'high',
};
