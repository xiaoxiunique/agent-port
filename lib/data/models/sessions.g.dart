// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PastSession _$PastSessionFromJson(Map<String, dynamic> json) => _PastSession(
  id: json['id'] as String,
  modified: (json['modified'] as num?)?.toDouble() ?? 0,
  size: (json['size'] as num?)?.toInt() ?? 0,
  summary: json['summary'] as String?,
);

Map<String, dynamic> _$PastSessionToJson(_PastSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'modified': instance.modified,
      'size': instance.size,
      'summary': instance.summary,
    };

_AgentSessions _$AgentSessionsFromJson(Map<String, dynamic> json) =>
    _AgentSessions(
      agent: json['agent'] as String,
      sessions:
          (json['sessions'] as List<dynamic>?)
              ?.map((e) => PastSession.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AgentSessionsToJson(_AgentSessions instance) =>
    <String, dynamic>{'agent': instance.agent, 'sessions': instance.sessions};

_SessionsResponse _$SessionsResponseFromJson(Map<String, dynamic> json) =>
    _SessionsResponse(
      ok: json['ok'] as bool,
      agents:
          (json['agents'] as List<dynamic>?)
              ?.map((e) => AgentSessions.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      error: json['error'] as String?,
    );

Map<String, dynamic> _$SessionsResponseToJson(_SessionsResponse instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'agents': instance.agents,
      'error': instance.error,
    };

_ResumeSessionRequest _$ResumeSessionRequestFromJson(
  Map<String, dynamic> json,
) => _ResumeSessionRequest(
  path: json['path'] as String,
  agent: json['agent'] as String,
  sessionId: json['sessionId'] as String,
  suffix: json['suffix'] as String,
);

Map<String, dynamic> _$ResumeSessionRequestToJson(
  _ResumeSessionRequest instance,
) => <String, dynamic>{
  'path': instance.path,
  'agent': instance.agent,
  'sessionId': instance.sessionId,
  'suffix': instance.suffix,
};

_ResumeSessionResponse _$ResumeSessionResponseFromJson(
  Map<String, dynamic> json,
) => _ResumeSessionResponse(
  ok: json['ok'] as bool,
  session: json['session'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$ResumeSessionResponseToJson(
  _ResumeSessionResponse instance,
) => <String, dynamic>{
  'ok': instance.ok,
  'session': instance.session,
  'error': instance.error,
};
