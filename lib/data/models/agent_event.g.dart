// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgentEventSource _$AgentEventSourceFromJson(Map<String, dynamic> json) =>
    _AgentEventSource(
      agent: json['agent'] as String,
      path: json['path'] as String?,
      sessionId: json['sessionId'] as String?,
    );

Map<String, dynamic> _$AgentEventSourceToJson(_AgentEventSource instance) =>
    <String, dynamic>{
      'agent': instance.agent,
      'path': instance.path,
      'sessionId': instance.sessionId,
    };

_AgentEvent _$AgentEventFromJson(Map<String, dynamic> json) => _AgentEvent(
  id: json['id'] as String,
  paneId: json['paneId'] as String,
  role: $enumDecode(_$AgentEventRoleEnumMap, json['role']),
  kind: $enumDecode(_$AgentEventKindEnumMap, json['kind']),
  title: json['title'] as String,
  body: json['body'] as String,
  createdAt: json['createdAt'] as String,
  toolName: json['toolName'] as String?,
  callId: json['callId'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$AgentEventToJson(_AgentEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paneId': instance.paneId,
      'role': _$AgentEventRoleEnumMap[instance.role]!,
      'kind': _$AgentEventKindEnumMap[instance.kind]!,
      'title': instance.title,
      'body': instance.body,
      'createdAt': instance.createdAt,
      'toolName': instance.toolName,
      'callId': instance.callId,
      'status': instance.status,
    };

const _$AgentEventRoleEnumMap = {
  AgentEventRole.agent: 'agent',
  AgentEventRole.user: 'user',
  AgentEventRole.system: 'system',
};

const _$AgentEventKindEnumMap = {
  AgentEventKind.text: 'text',
  AgentEventKind.toolCall: 'tool_call',
  AgentEventKind.toolResult: 'tool_result',
  AgentEventKind.turn: 'turn',
  AgentEventKind.status: 'status',
};

_AgentEventsResponse _$AgentEventsResponseFromJson(Map<String, dynamic> json) =>
    _AgentEventsResponse(
      ok: json['ok'] as bool,
      paneId: json['paneId'] as String?,
      source: json['source'] == null
          ? null
          : AgentEventSource.fromJson(json['source'] as Map<String, dynamic>),
      events:
          (json['events'] as List<dynamic>?)
              ?.map((e) => AgentEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      capturedAt: json['capturedAt'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$AgentEventsResponseToJson(
  _AgentEventsResponse instance,
) => <String, dynamic>{
  'ok': instance.ok,
  'paneId': instance.paneId,
  'source': instance.source,
  'events': instance.events,
  'capturedAt': instance.capturedAt,
  'error': instance.error,
};
