// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cron.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CronSchedule _$CronScheduleFromJson(Map<String, dynamic> json) =>
    _CronSchedule(
      id: json['id'] as String,
      script: json['script'] as String,
      cron: json['cron'] as String,
      timezone: json['timezone'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      nextRunAt: json['nextRunAt'] as String?,
      lastRunAt: json['lastRunAt'] as String?,
      oneShot: json['oneShot'] as bool? ?? false,
    );

Map<String, dynamic> _$CronScheduleToJson(_CronSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'script': instance.script,
      'cron': instance.cron,
      'timezone': instance.timezone,
      'enabled': instance.enabled,
      'nextRunAt': instance.nextRunAt,
      'lastRunAt': instance.lastRunAt,
      'oneShot': instance.oneShot,
    };

_CronJob _$CronJobFromJson(Map<String, dynamic> json) => _CronJob(
  id: json['id'] as String,
  scheduleId: json['scheduleId'] as String?,
  script: json['script'] as String,
  status: json['status'] as String,
  error: json['error'] as String?,
  startedAt: json['startedAt'] as String?,
  completedAt: json['completedAt'] as String?,
  durationMs: (json['durationMs'] as num?)?.toInt(),
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$CronJobToJson(_CronJob instance) => <String, dynamic>{
  'id': instance.id,
  'scheduleId': instance.scheduleId,
  'script': instance.script,
  'status': instance.status,
  'error': instance.error,
  'startedAt': instance.startedAt,
  'completedAt': instance.completedAt,
  'durationMs': instance.durationMs,
  'createdAt': instance.createdAt,
};

_CronSchedulesResponse _$CronSchedulesResponseFromJson(
  Map<String, dynamic> json,
) => _CronSchedulesResponse(
  ok: json['ok'] as bool,
  schedules:
      (json['schedules'] as List<dynamic>?)
          ?.map((e) => CronSchedule.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$CronSchedulesResponseToJson(
  _CronSchedulesResponse instance,
) => <String, dynamic>{'ok': instance.ok, 'schedules': instance.schedules};

_CronJobsResponse _$CronJobsResponseFromJson(Map<String, dynamic> json) =>
    _CronJobsResponse(
      ok: json['ok'] as bool,
      jobs:
          (json['jobs'] as List<dynamic>?)
              ?.map((e) => CronJob.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CronJobsResponseToJson(_CronJobsResponse instance) =>
    <String, dynamic>{'ok': instance.ok, 'jobs': instance.jobs};

_CronLogResponse _$CronLogResponseFromJson(Map<String, dynamic> json) =>
    _CronLogResponse(
      ok: json['ok'] as bool,
      id: json['id'] as String? ?? '',
      logs: json['logs'] as String? ?? '',
    );

Map<String, dynamic> _$CronLogResponseToJson(_CronLogResponse instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'id': instance.id,
      'logs': instance.logs,
    };
