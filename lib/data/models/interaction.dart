import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'interaction.freezed.dart';
part 'interaction.g.dart';

/// A clickable button attached to an interaction message.
@freezed
abstract class InteractionAction with _$InteractionAction {
  const factory InteractionAction({
    required String label,
    required String payload,
    InteractionActionStyle? style,
  }) = _InteractionAction;

  factory InteractionAction.fromJson(Map<String, dynamic> json) =>
      _$InteractionActionFromJson(json);
}

/// Where an interaction message came from (currently only log-derived).
@freezed
abstract class InteractionSource with _$InteractionSource {
  const factory InteractionSource({
    required String type,
    required String excerpt,
  }) = _InteractionSource;

  factory InteractionSource.fromJson(Map<String, dynamic> json) =>
      _$InteractionSourceFromJson(json);
}

/// A structured agent/user/system message attached to a pane.
@freezed
abstract class InteractionMessage with _$InteractionMessage {
  const factory InteractionMessage({
    required String id,
    required String paneId,
    required InteractionRole role,
    required InteractionKind kind,
    required InteractionPriority priority,
    required String title,
    required String body,
    @Default([]) List<InteractionAction> actions,
    InteractionSource? source,
    required String createdAt,
  }) = _InteractionMessage;

  factory InteractionMessage.fromJson(Map<String, dynamic> json) =>
      _$InteractionMessageFromJson(json);
}
