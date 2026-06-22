import 'package:freezed_annotation/freezed_annotation.dart';

part 'api.freezed.dart';
part 'api.g.dart';

/// `POST /api/send` body.
@freezed
abstract class SendRequest with _$SendRequest {
  const factory SendRequest({
    required String paneId,
    required String text,
    bool? enter,
    String? submitKey, // 'Enter' | 'Tab'
    bool? vimMode,
  }) = _SendRequest;

  factory SendRequest.fromJson(Map<String, dynamic> json) =>
      _$SendRequestFromJson(json);
}

/// Shared response shape for `/api/send` and `/api/key` — updated terminal tail.
@freezed
abstract class PaneCommandResponse with _$PaneCommandResponse {
  const factory PaneCommandResponse({
    required bool ok,
    String? paneId,
    String? tail,
    String? capturedAt,
  }) = _PaneCommandResponse;

  factory PaneCommandResponse.fromJson(Map<String, dynamic> json) =>
      _$PaneCommandResponseFromJson(json);
}

/// `POST /api/refine-text` response.
@freezed
abstract class RefineTextResponse with _$RefineTextResponse {
  const factory RefineTextResponse({
    required bool ok,
    String? text,
    bool? changed,
    bool? fallback,
    String? error,
  }) = _RefineTextResponse;

  factory RefineTextResponse.fromJson(Map<String, dynamic> json) =>
      _$RefineTextResponseFromJson(json);
}

/// `POST /api/upload-image` response.
@freezed
abstract class UploadedImageResponse with _$UploadedImageResponse {
  const factory UploadedImageResponse({
    required bool ok,
    String? path,
    int? size,
    String? contentType,
  }) = _UploadedImageResponse;

  factory UploadedImageResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadedImageResponseFromJson(json);
}

/// `GET /api/pane/context` response.
@freezed
abstract class PaneContextResponse with _$PaneContextResponse {
  const factory PaneContextResponse({
    required bool ok,
    String? paneId,
    int? lines,
    String? tail,
    String? capturedAt,
  }) = _PaneContextResponse;

  factory PaneContextResponse.fromJson(Map<String, dynamic> json) =>
      _$PaneContextResponseFromJson(json);
}

/// `POST /api/session/kill` body.
@freezed
abstract class KillSessionRequest with _$KillSessionRequest {
  const factory KillSessionRequest({
    String? paneId,
    String? session,
  }) = _KillSessionRequest;

  factory KillSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$KillSessionRequestFromJson(json);
}

/// `POST /api/project-history/launch` body.
@freezed
abstract class LaunchProjectRequest with _$LaunchProjectRequest {
  const factory LaunchProjectRequest({
    required String path,
    required String agent,
  }) = _LaunchProjectRequest;

  factory LaunchProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$LaunchProjectRequestFromJson(json);
}

/// `POST /api/cc-switch/switch` body.
@freezed
abstract class CcSwitchSwitchRequest with _$CcSwitchSwitchRequest {
  const factory CcSwitchSwitchRequest({
    required String appType,
    required String providerId,
  }) = _CcSwitchSwitchRequest;

  factory CcSwitchSwitchRequest.fromJson(Map<String, dynamic> json) =>
      _$CcSwitchSwitchRequestFromJson(json);
}
