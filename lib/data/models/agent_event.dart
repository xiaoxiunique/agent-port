import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'agent_event.freezed.dart';
part 'agent_event.g.dart';

/// Where an agent event originated.
@freezed
abstract class AgentEventSource with _$AgentEventSource {
  const factory AgentEventSource({
    required String agent,
    String? path,
    String? sessionId,
  }) = _AgentEventSource;

  factory AgentEventSource.fromJson(Map<String, dynamic> json) =>
      _$AgentEventSourceFromJson(json);
}

/// One entry in a pane's agent event timeline.
@freezed
abstract class AgentEvent with _$AgentEvent {
  const factory AgentEvent({
    required String id,
    required String paneId,
    required AgentEventRole role,
    required AgentEventKind kind,
    required String title,
    required String body,
    required String createdAt,
    String? toolName,
    String? callId,
    String? status,
  }) = _AgentEvent;

  factory AgentEvent.fromJson(Map<String, dynamic> json) =>
      _$AgentEventFromJson(json);
}

/// `GET /api/pane/events` response.
@freezed
abstract class AgentEventsResponse with _$AgentEventsResponse {
  const factory AgentEventsResponse({
    required bool ok,
    String? paneId,
    AgentEventSource? source,
    @Default([]) List<AgentEvent> events,
    String? capturedAt,
    String? error,
  }) = _AgentEventsResponse;

  factory AgentEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$AgentEventsResponseFromJson(json);
}
