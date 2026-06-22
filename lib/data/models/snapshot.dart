import 'package:freezed_annotation/freezed_annotation.dart';

import 'pane.dart';

part 'snapshot.freezed.dart';
part 'snapshot.g.dart';

/// Host system stats. Percentages 0–100; `num` to tolerate int or double
/// payloads from the server.
@freezed
abstract class SystemStats with _$SystemStats {
  const factory SystemStats({
    num? cpuUsage,
    num? memoryUsage,
  }) = _SystemStats;

  factory SystemStats.fromJson(Map<String, dynamic> json) =>
      _$SystemStatsFromJson(json);
}

/// Identifying info about the host machine.
@freezed
abstract class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    String? name,
    String? modelIdentifier,
    required String kind,
    required String modelName,
  }) = _DeviceInfo;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
}

/// Full state snapshot served by `GET /api/snapshot` and `WS /ws`.
@freezed
abstract class Snapshot with _$Snapshot {
  const factory Snapshot({
    required bool ok,
    required String now,
    @Default([]) List<Pane> panes,
    SystemStats? system,
    DeviceInfo? device,
    String? error,
  }) = _Snapshot;

  factory Snapshot.fromJson(Map<String, dynamic> json) =>
      _$SnapshotFromJson(json);
}
