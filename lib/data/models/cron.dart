import 'package:freezed_annotation/freezed_annotation.dart';

part 'cron.freezed.dart';
part 'cron.g.dart';

/// A CronBox schedule, from `GET /api/cron/schedules`.
@freezed
abstract class CronSchedule with _$CronSchedule {
  const factory CronSchedule({
    required String id,

    /// Absolute script path (the service joins CronBox's base dir and script).
    required String script,

    /// Cron expression, e.g. `*/10 * * * *`.
    required String cron,
    @Default('') String timezone,
    @Default(false) bool enabled,
    String? nextRunAt,
    String? lastRunAt,

    /// Runs once and then stops, rather than on a recurring schedule.
    @Default(false) bool oneShot,
  }) = _CronSchedule;

  factory CronSchedule.fromJson(Map<String, dynamic> json) =>
      _$CronScheduleFromJson(json);
}

/// One execution of a scheduled script, from `GET /api/cron/jobs`.
///
/// Logs are deliberately absent: they run to tens of MB across all history, so
/// they're fetched per job through `GET /api/cron/log`.
@freezed
abstract class CronJob with _$CronJob {
  const factory CronJob({
    required String id,
    String? scheduleId,
    required String script,

    /// `success`, `failure`, `running`, `queued`, `cancelled` or `skipped`.
    required String status,
    String? error,
    String? startedAt,
    String? completedAt,
    int? durationMs,
    required String createdAt,
  }) = _CronJob;

  factory CronJob.fromJson(Map<String, dynamic> json) =>
      _$CronJobFromJson(json);
}

@freezed
abstract class CronSchedulesResponse with _$CronSchedulesResponse {
  const factory CronSchedulesResponse({
    required bool ok,
    @Default([]) List<CronSchedule> schedules,
  }) = _CronSchedulesResponse;

  factory CronSchedulesResponse.fromJson(Map<String, dynamic> json) =>
      _$CronSchedulesResponseFromJson(json);
}

@freezed
abstract class CronJobsResponse with _$CronJobsResponse {
  const factory CronJobsResponse({
    required bool ok,
    @Default([]) List<CronJob> jobs,
  }) = _CronJobsResponse;

  factory CronJobsResponse.fromJson(Map<String, dynamic> json) =>
      _$CronJobsResponseFromJson(json);
}

@freezed
abstract class CronLogResponse with _$CronLogResponse {
  const factory CronLogResponse({
    required bool ok,
    @Default('') String id,

    /// Captured output. Truncated from the front by the service when large,
    /// so the tail — where a failure's cause usually is — survives.
    @Default('') String logs,
  }) = _CronLogResponse;

  factory CronLogResponse.fromJson(Map<String, dynamic> json) =>
      _$CronLogResponseFromJson(json);
}
