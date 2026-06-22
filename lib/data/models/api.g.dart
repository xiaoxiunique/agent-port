// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SendRequest _$SendRequestFromJson(Map<String, dynamic> json) => _SendRequest(
  paneId: json['paneId'] as String,
  text: json['text'] as String,
  enter: json['enter'] as bool?,
  submitKey: json['submitKey'] as String?,
  vimMode: json['vimMode'] as bool?,
);

Map<String, dynamic> _$SendRequestToJson(_SendRequest instance) =>
    <String, dynamic>{
      'paneId': instance.paneId,
      'text': instance.text,
      'enter': instance.enter,
      'submitKey': instance.submitKey,
      'vimMode': instance.vimMode,
    };

_PaneCommandResponse _$PaneCommandResponseFromJson(Map<String, dynamic> json) =>
    _PaneCommandResponse(
      ok: json['ok'] as bool,
      paneId: json['paneId'] as String?,
      tail: json['tail'] as String?,
      capturedAt: json['capturedAt'] as String?,
    );

Map<String, dynamic> _$PaneCommandResponseToJson(
  _PaneCommandResponse instance,
) => <String, dynamic>{
  'ok': instance.ok,
  'paneId': instance.paneId,
  'tail': instance.tail,
  'capturedAt': instance.capturedAt,
};

_RefineTextResponse _$RefineTextResponseFromJson(Map<String, dynamic> json) =>
    _RefineTextResponse(
      ok: json['ok'] as bool,
      text: json['text'] as String?,
      changed: json['changed'] as bool?,
      fallback: json['fallback'] as bool?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$RefineTextResponseToJson(_RefineTextResponse instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'text': instance.text,
      'changed': instance.changed,
      'fallback': instance.fallback,
      'error': instance.error,
    };

_UploadedImageResponse _$UploadedImageResponseFromJson(
  Map<String, dynamic> json,
) => _UploadedImageResponse(
  ok: json['ok'] as bool,
  path: json['path'] as String?,
  size: (json['size'] as num?)?.toInt(),
  contentType: json['contentType'] as String?,
);

Map<String, dynamic> _$UploadedImageResponseToJson(
  _UploadedImageResponse instance,
) => <String, dynamic>{
  'ok': instance.ok,
  'path': instance.path,
  'size': instance.size,
  'contentType': instance.contentType,
};

_PaneContextResponse _$PaneContextResponseFromJson(Map<String, dynamic> json) =>
    _PaneContextResponse(
      ok: json['ok'] as bool,
      paneId: json['paneId'] as String?,
      lines: (json['lines'] as num?)?.toInt(),
      tail: json['tail'] as String?,
      capturedAt: json['capturedAt'] as String?,
    );

Map<String, dynamic> _$PaneContextResponseToJson(
  _PaneContextResponse instance,
) => <String, dynamic>{
  'ok': instance.ok,
  'paneId': instance.paneId,
  'lines': instance.lines,
  'tail': instance.tail,
  'capturedAt': instance.capturedAt,
};

_KillSessionRequest _$KillSessionRequestFromJson(Map<String, dynamic> json) =>
    _KillSessionRequest(
      paneId: json['paneId'] as String?,
      session: json['session'] as String?,
    );

Map<String, dynamic> _$KillSessionRequestToJson(_KillSessionRequest instance) =>
    <String, dynamic>{'paneId': instance.paneId, 'session': instance.session};

_LaunchProjectRequest _$LaunchProjectRequestFromJson(
  Map<String, dynamic> json,
) => _LaunchProjectRequest(
  path: json['path'] as String,
  agent: json['agent'] as String,
);

Map<String, dynamic> _$LaunchProjectRequestToJson(
  _LaunchProjectRequest instance,
) => <String, dynamic>{'path': instance.path, 'agent': instance.agent};

_CcSwitchSwitchRequest _$CcSwitchSwitchRequestFromJson(
  Map<String, dynamic> json,
) => _CcSwitchSwitchRequest(
  appType: json['appType'] as String,
  providerId: json['providerId'] as String,
);

Map<String, dynamic> _$CcSwitchSwitchRequestToJson(
  _CcSwitchSwitchRequest instance,
) => <String, dynamic>{
  'appType': instance.appType,
  'providerId': instance.providerId,
};
