import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_history.freezed.dart';
part 'project_history.g.dart';

/// One recently-launched project, surfaced by `GET /api/project-history`.
@freezed
abstract class ProjectHistoryEntry with _$ProjectHistoryEntry {
  const factory ProjectHistoryEntry({
    required String path,
    required String name,
    required String lastAgent,
    required String lastSeenAt,
    required int launchCount,
  }) = _ProjectHistoryEntry;

  factory ProjectHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$ProjectHistoryEntryFromJson(json);
}

@freezed
abstract class ProjectHistoryResponse with _$ProjectHistoryResponse {
  const factory ProjectHistoryResponse({
    required bool ok,
    @Default([]) List<ProjectHistoryEntry> projects,
  }) = _ProjectHistoryResponse;

  factory ProjectHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectHistoryResponseFromJson(json);
}
