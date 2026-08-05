import 'package:freezed_annotation/freezed_annotation.dart';

part 'sessions.freezed.dart';
part 'sessions.g.dart';

/// One past conversation with an agent, as recorded in the agent's own store.
@freezed
abstract class PastSession with _$PastSession {
  const factory PastSession({
    required String id,

    /// Seconds since the epoch of the transcript's last write.
    @Default(0) double modified,

    /// Transcript size on disk — a rough proxy for how much is in it.
    @Default(0) int size,

    /// Claude's own generated title, or the opening user prompt for Codex,
    /// which records none. Null when neither was readable.
    String? summary,
  }) = _PastSession;

  factory PastSession.fromJson(Map<String, dynamic> json) =>
      _$PastSessionFromJson(json);
}

/// Conversations for one agent in one directory.
@freezed
abstract class AgentSessions with _$AgentSessions {
  const factory AgentSessions({
    /// "claude" or "codex".
    required String agent,
    @Default([]) List<PastSession> sessions,
  }) = _AgentSessions;

  factory AgentSessions.fromJson(Map<String, dynamic> json) =>
      _$AgentSessionsFromJson(json);
}

@freezed
abstract class SessionsResponse with _$SessionsResponse {
  const factory SessionsResponse({
    required bool ok,
    @Default([]) List<AgentSessions> agents,
    String? error,
  }) = _SessionsResponse;

  factory SessionsResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionsResponseFromJson(json);
}

@freezed
abstract class ResumeSessionRequest with _$ResumeSessionRequest {
  const factory ResumeSessionRequest({
    required String path,
    required String agent,
    required String sessionId,

    /// Distinguishes the new multiplexer session from the project's primary
    /// one, so resuming doesn't disturb whatever is already running there.
    required String suffix,
  }) = _ResumeSessionRequest;

  factory ResumeSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$ResumeSessionRequestFromJson(json);
}

@freezed
abstract class ResumeSessionResponse with _$ResumeSessionResponse {
  const factory ResumeSessionResponse({
    required bool ok,

    /// Name of the multiplexer session now running the conversation.
    String? session,
    String? error,
  }) = _ResumeSessionResponse;

  factory ResumeSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$ResumeSessionResponseFromJson(json);
}
