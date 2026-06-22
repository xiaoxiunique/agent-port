import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';
import 'interaction.dart';

part 'pane.freezed.dart';
part 'pane.g.dart';

/// A single tmux pane running an agent session.
@freezed
abstract class Pane with _$Pane {
  const factory Pane({
    required String id,
    required String target,
    required String session,
    required String windowIndex,
    required String windowName,
    required String paneIndex,
    required String command,
    required String path,
    required bool active,
    int? pid,
    required String title,
    required String tail,
    required PaneStatus status,
    required String reason,
    required String updatedAt,
    @Default([]) List<InteractionMessage> messages,
  }) = _Pane;

  factory Pane.fromJson(Map<String, dynamic> json) => _$PaneFromJson(json);
}
