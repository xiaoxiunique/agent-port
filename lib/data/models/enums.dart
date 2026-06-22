import 'package:json_annotation/json_annotation.dart';

/// tmux pane agent status. Matches Rust `PaneStatus` (serde camelCase):
/// `running | waiting | idle | failed | done`.
enum PaneStatus { running, waiting, idle, failed, done }

/// Who authored an interaction message. serde camelCase.
enum InteractionRole { agent, user, system }

/// Kind of interaction. Matches server serde (snake_case for the multi-word
/// variant); confirmed against the native iOS `Pane.swift` mapping.
enum InteractionKind {
  summary,
  status,
  question,
  @JsonValue('permission_request')
  permissionRequest,
  progress,
  error,
  done,
  notification,
}

enum InteractionPriority { low, normal, high }

/// Button style on an interaction action. `default` collides with a Dart
/// keyword, so the value is aliased via [JsonValue].
enum InteractionActionStyle {
  @JsonValue('default')
  $default,
  destructive,
}

/// Who authored an agent event. serde default (lowercase).
enum AgentEventRole { agent, user, system }

/// Kind of agent event. Multi-word variants are snake_case on the wire.
enum AgentEventKind {
  text,
  @JsonValue('tool_call')
  toolCall,
  @JsonValue('tool_result')
  toolResult,
  turn,
  status,
}
