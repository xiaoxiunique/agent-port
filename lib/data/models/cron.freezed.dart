// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cron.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CronSchedule {

 String get id;/// Absolute script path (the service joins CronBox's base dir and script).
 String get script;/// Cron expression, e.g. `*/10 * * * *`.
 String get cron; String get timezone; bool get enabled; String? get nextRunAt; String? get lastRunAt;/// Runs once and then stops, rather than on a recurring schedule.
 bool get oneShot;
/// Create a copy of CronSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CronScheduleCopyWith<CronSchedule> get copyWith => _$CronScheduleCopyWithImpl<CronSchedule>(this as CronSchedule, _$identity);

  /// Serializes this CronSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CronSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.script, script) || other.script == script)&&(identical(other.cron, cron) || other.cron == cron)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.nextRunAt, nextRunAt) || other.nextRunAt == nextRunAt)&&(identical(other.lastRunAt, lastRunAt) || other.lastRunAt == lastRunAt)&&(identical(other.oneShot, oneShot) || other.oneShot == oneShot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,script,cron,timezone,enabled,nextRunAt,lastRunAt,oneShot);

@override
String toString() {
  return 'CronSchedule(id: $id, script: $script, cron: $cron, timezone: $timezone, enabled: $enabled, nextRunAt: $nextRunAt, lastRunAt: $lastRunAt, oneShot: $oneShot)';
}


}

/// @nodoc
abstract mixin class $CronScheduleCopyWith<$Res>  {
  factory $CronScheduleCopyWith(CronSchedule value, $Res Function(CronSchedule) _then) = _$CronScheduleCopyWithImpl;
@useResult
$Res call({
 String id, String script, String cron, String timezone, bool enabled, String? nextRunAt, String? lastRunAt, bool oneShot
});




}
/// @nodoc
class _$CronScheduleCopyWithImpl<$Res>
    implements $CronScheduleCopyWith<$Res> {
  _$CronScheduleCopyWithImpl(this._self, this._then);

  final CronSchedule _self;
  final $Res Function(CronSchedule) _then;

/// Create a copy of CronSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? script = null,Object? cron = null,Object? timezone = null,Object? enabled = null,Object? nextRunAt = freezed,Object? lastRunAt = freezed,Object? oneShot = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,script: null == script ? _self.script : script // ignore: cast_nullable_to_non_nullable
as String,cron: null == cron ? _self.cron : cron // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,nextRunAt: freezed == nextRunAt ? _self.nextRunAt : nextRunAt // ignore: cast_nullable_to_non_nullable
as String?,lastRunAt: freezed == lastRunAt ? _self.lastRunAt : lastRunAt // ignore: cast_nullable_to_non_nullable
as String?,oneShot: null == oneShot ? _self.oneShot : oneShot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CronSchedule].
extension CronSchedulePatterns on CronSchedule {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CronSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CronSchedule() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CronSchedule value)  $default,){
final _that = this;
switch (_that) {
case _CronSchedule():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CronSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _CronSchedule() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String script,  String cron,  String timezone,  bool enabled,  String? nextRunAt,  String? lastRunAt,  bool oneShot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CronSchedule() when $default != null:
return $default(_that.id,_that.script,_that.cron,_that.timezone,_that.enabled,_that.nextRunAt,_that.lastRunAt,_that.oneShot);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String script,  String cron,  String timezone,  bool enabled,  String? nextRunAt,  String? lastRunAt,  bool oneShot)  $default,) {final _that = this;
switch (_that) {
case _CronSchedule():
return $default(_that.id,_that.script,_that.cron,_that.timezone,_that.enabled,_that.nextRunAt,_that.lastRunAt,_that.oneShot);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String script,  String cron,  String timezone,  bool enabled,  String? nextRunAt,  String? lastRunAt,  bool oneShot)?  $default,) {final _that = this;
switch (_that) {
case _CronSchedule() when $default != null:
return $default(_that.id,_that.script,_that.cron,_that.timezone,_that.enabled,_that.nextRunAt,_that.lastRunAt,_that.oneShot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CronSchedule implements CronSchedule {
  const _CronSchedule({required this.id, required this.script, required this.cron, this.timezone = '', this.enabled = false, this.nextRunAt, this.lastRunAt, this.oneShot = false});
  factory _CronSchedule.fromJson(Map<String, dynamic> json) => _$CronScheduleFromJson(json);

@override final  String id;
/// Absolute script path (the service joins CronBox's base dir and script).
@override final  String script;
/// Cron expression, e.g. `*/10 * * * *`.
@override final  String cron;
@override@JsonKey() final  String timezone;
@override@JsonKey() final  bool enabled;
@override final  String? nextRunAt;
@override final  String? lastRunAt;
/// Runs once and then stops, rather than on a recurring schedule.
@override@JsonKey() final  bool oneShot;

/// Create a copy of CronSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CronScheduleCopyWith<_CronSchedule> get copyWith => __$CronScheduleCopyWithImpl<_CronSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CronScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CronSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.script, script) || other.script == script)&&(identical(other.cron, cron) || other.cron == cron)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.nextRunAt, nextRunAt) || other.nextRunAt == nextRunAt)&&(identical(other.lastRunAt, lastRunAt) || other.lastRunAt == lastRunAt)&&(identical(other.oneShot, oneShot) || other.oneShot == oneShot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,script,cron,timezone,enabled,nextRunAt,lastRunAt,oneShot);

@override
String toString() {
  return 'CronSchedule(id: $id, script: $script, cron: $cron, timezone: $timezone, enabled: $enabled, nextRunAt: $nextRunAt, lastRunAt: $lastRunAt, oneShot: $oneShot)';
}


}

/// @nodoc
abstract mixin class _$CronScheduleCopyWith<$Res> implements $CronScheduleCopyWith<$Res> {
  factory _$CronScheduleCopyWith(_CronSchedule value, $Res Function(_CronSchedule) _then) = __$CronScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, String script, String cron, String timezone, bool enabled, String? nextRunAt, String? lastRunAt, bool oneShot
});




}
/// @nodoc
class __$CronScheduleCopyWithImpl<$Res>
    implements _$CronScheduleCopyWith<$Res> {
  __$CronScheduleCopyWithImpl(this._self, this._then);

  final _CronSchedule _self;
  final $Res Function(_CronSchedule) _then;

/// Create a copy of CronSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? script = null,Object? cron = null,Object? timezone = null,Object? enabled = null,Object? nextRunAt = freezed,Object? lastRunAt = freezed,Object? oneShot = null,}) {
  return _then(_CronSchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,script: null == script ? _self.script : script // ignore: cast_nullable_to_non_nullable
as String,cron: null == cron ? _self.cron : cron // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,nextRunAt: freezed == nextRunAt ? _self.nextRunAt : nextRunAt // ignore: cast_nullable_to_non_nullable
as String?,lastRunAt: freezed == lastRunAt ? _self.lastRunAt : lastRunAt // ignore: cast_nullable_to_non_nullable
as String?,oneShot: null == oneShot ? _self.oneShot : oneShot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CronJob {

 String get id; String? get scheduleId; String get script;/// `success`, `failure`, `running`, `queued`, `cancelled` or `skipped`.
 String get status; String? get error; String? get startedAt; String? get completedAt; int? get durationMs; String get createdAt;
/// Create a copy of CronJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CronJobCopyWith<CronJob> get copyWith => _$CronJobCopyWithImpl<CronJob>(this as CronJob, _$identity);

  /// Serializes this CronJob to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CronJob&&(identical(other.id, id) || other.id == id)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.script, script) || other.script == script)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scheduleId,script,status,error,startedAt,completedAt,durationMs,createdAt);

@override
String toString() {
  return 'CronJob(id: $id, scheduleId: $scheduleId, script: $script, status: $status, error: $error, startedAt: $startedAt, completedAt: $completedAt, durationMs: $durationMs, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CronJobCopyWith<$Res>  {
  factory $CronJobCopyWith(CronJob value, $Res Function(CronJob) _then) = _$CronJobCopyWithImpl;
@useResult
$Res call({
 String id, String? scheduleId, String script, String status, String? error, String? startedAt, String? completedAt, int? durationMs, String createdAt
});




}
/// @nodoc
class _$CronJobCopyWithImpl<$Res>
    implements $CronJobCopyWith<$Res> {
  _$CronJobCopyWithImpl(this._self, this._then);

  final CronJob _self;
  final $Res Function(CronJob) _then;

/// Create a copy of CronJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scheduleId = freezed,Object? script = null,Object? status = null,Object? error = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? durationMs = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,script: null == script ? _self.script : script // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CronJob].
extension CronJobPatterns on CronJob {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CronJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CronJob() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CronJob value)  $default,){
final _that = this;
switch (_that) {
case _CronJob():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CronJob value)?  $default,){
final _that = this;
switch (_that) {
case _CronJob() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? scheduleId,  String script,  String status,  String? error,  String? startedAt,  String? completedAt,  int? durationMs,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CronJob() when $default != null:
return $default(_that.id,_that.scheduleId,_that.script,_that.status,_that.error,_that.startedAt,_that.completedAt,_that.durationMs,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? scheduleId,  String script,  String status,  String? error,  String? startedAt,  String? completedAt,  int? durationMs,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _CronJob():
return $default(_that.id,_that.scheduleId,_that.script,_that.status,_that.error,_that.startedAt,_that.completedAt,_that.durationMs,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? scheduleId,  String script,  String status,  String? error,  String? startedAt,  String? completedAt,  int? durationMs,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CronJob() when $default != null:
return $default(_that.id,_that.scheduleId,_that.script,_that.status,_that.error,_that.startedAt,_that.completedAt,_that.durationMs,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CronJob implements CronJob {
  const _CronJob({required this.id, this.scheduleId, required this.script, required this.status, this.error, this.startedAt, this.completedAt, this.durationMs, required this.createdAt});
  factory _CronJob.fromJson(Map<String, dynamic> json) => _$CronJobFromJson(json);

@override final  String id;
@override final  String? scheduleId;
@override final  String script;
/// `success`, `failure`, `running`, `queued`, `cancelled` or `skipped`.
@override final  String status;
@override final  String? error;
@override final  String? startedAt;
@override final  String? completedAt;
@override final  int? durationMs;
@override final  String createdAt;

/// Create a copy of CronJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CronJobCopyWith<_CronJob> get copyWith => __$CronJobCopyWithImpl<_CronJob>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CronJobToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CronJob&&(identical(other.id, id) || other.id == id)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.script, script) || other.script == script)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scheduleId,script,status,error,startedAt,completedAt,durationMs,createdAt);

@override
String toString() {
  return 'CronJob(id: $id, scheduleId: $scheduleId, script: $script, status: $status, error: $error, startedAt: $startedAt, completedAt: $completedAt, durationMs: $durationMs, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CronJobCopyWith<$Res> implements $CronJobCopyWith<$Res> {
  factory _$CronJobCopyWith(_CronJob value, $Res Function(_CronJob) _then) = __$CronJobCopyWithImpl;
@override @useResult
$Res call({
 String id, String? scheduleId, String script, String status, String? error, String? startedAt, String? completedAt, int? durationMs, String createdAt
});




}
/// @nodoc
class __$CronJobCopyWithImpl<$Res>
    implements _$CronJobCopyWith<$Res> {
  __$CronJobCopyWithImpl(this._self, this._then);

  final _CronJob _self;
  final $Res Function(_CronJob) _then;

/// Create a copy of CronJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scheduleId = freezed,Object? script = null,Object? status = null,Object? error = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? durationMs = freezed,Object? createdAt = null,}) {
  return _then(_CronJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,script: null == script ? _self.script : script // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CronSchedulesResponse {

 bool get ok; List<CronSchedule> get schedules;
/// Create a copy of CronSchedulesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CronSchedulesResponseCopyWith<CronSchedulesResponse> get copyWith => _$CronSchedulesResponseCopyWithImpl<CronSchedulesResponse>(this as CronSchedulesResponse, _$identity);

  /// Serializes this CronSchedulesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CronSchedulesResponse&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other.schedules, schedules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(schedules));

@override
String toString() {
  return 'CronSchedulesResponse(ok: $ok, schedules: $schedules)';
}


}

/// @nodoc
abstract mixin class $CronSchedulesResponseCopyWith<$Res>  {
  factory $CronSchedulesResponseCopyWith(CronSchedulesResponse value, $Res Function(CronSchedulesResponse) _then) = _$CronSchedulesResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, List<CronSchedule> schedules
});




}
/// @nodoc
class _$CronSchedulesResponseCopyWithImpl<$Res>
    implements $CronSchedulesResponseCopyWith<$Res> {
  _$CronSchedulesResponseCopyWithImpl(this._self, this._then);

  final CronSchedulesResponse _self;
  final $Res Function(CronSchedulesResponse) _then;

/// Create a copy of CronSchedulesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? schedules = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,schedules: null == schedules ? _self.schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<CronSchedule>,
  ));
}

}


/// Adds pattern-matching-related methods to [CronSchedulesResponse].
extension CronSchedulesResponsePatterns on CronSchedulesResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CronSchedulesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CronSchedulesResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CronSchedulesResponse value)  $default,){
final _that = this;
switch (_that) {
case _CronSchedulesResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CronSchedulesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CronSchedulesResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  List<CronSchedule> schedules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CronSchedulesResponse() when $default != null:
return $default(_that.ok,_that.schedules);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  List<CronSchedule> schedules)  $default,) {final _that = this;
switch (_that) {
case _CronSchedulesResponse():
return $default(_that.ok,_that.schedules);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  List<CronSchedule> schedules)?  $default,) {final _that = this;
switch (_that) {
case _CronSchedulesResponse() when $default != null:
return $default(_that.ok,_that.schedules);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CronSchedulesResponse implements CronSchedulesResponse {
  const _CronSchedulesResponse({required this.ok, final  List<CronSchedule> schedules = const []}): _schedules = schedules;
  factory _CronSchedulesResponse.fromJson(Map<String, dynamic> json) => _$CronSchedulesResponseFromJson(json);

@override final  bool ok;
 final  List<CronSchedule> _schedules;
@override@JsonKey() List<CronSchedule> get schedules {
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedules);
}


/// Create a copy of CronSchedulesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CronSchedulesResponseCopyWith<_CronSchedulesResponse> get copyWith => __$CronSchedulesResponseCopyWithImpl<_CronSchedulesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CronSchedulesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CronSchedulesResponse&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other._schedules, _schedules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(_schedules));

@override
String toString() {
  return 'CronSchedulesResponse(ok: $ok, schedules: $schedules)';
}


}

/// @nodoc
abstract mixin class _$CronSchedulesResponseCopyWith<$Res> implements $CronSchedulesResponseCopyWith<$Res> {
  factory _$CronSchedulesResponseCopyWith(_CronSchedulesResponse value, $Res Function(_CronSchedulesResponse) _then) = __$CronSchedulesResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, List<CronSchedule> schedules
});




}
/// @nodoc
class __$CronSchedulesResponseCopyWithImpl<$Res>
    implements _$CronSchedulesResponseCopyWith<$Res> {
  __$CronSchedulesResponseCopyWithImpl(this._self, this._then);

  final _CronSchedulesResponse _self;
  final $Res Function(_CronSchedulesResponse) _then;

/// Create a copy of CronSchedulesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? schedules = null,}) {
  return _then(_CronSchedulesResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<CronSchedule>,
  ));
}


}


/// @nodoc
mixin _$CronJobsResponse {

 bool get ok; List<CronJob> get jobs;
/// Create a copy of CronJobsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CronJobsResponseCopyWith<CronJobsResponse> get copyWith => _$CronJobsResponseCopyWithImpl<CronJobsResponse>(this as CronJobsResponse, _$identity);

  /// Serializes this CronJobsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CronJobsResponse&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other.jobs, jobs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(jobs));

@override
String toString() {
  return 'CronJobsResponse(ok: $ok, jobs: $jobs)';
}


}

/// @nodoc
abstract mixin class $CronJobsResponseCopyWith<$Res>  {
  factory $CronJobsResponseCopyWith(CronJobsResponse value, $Res Function(CronJobsResponse) _then) = _$CronJobsResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, List<CronJob> jobs
});




}
/// @nodoc
class _$CronJobsResponseCopyWithImpl<$Res>
    implements $CronJobsResponseCopyWith<$Res> {
  _$CronJobsResponseCopyWithImpl(this._self, this._then);

  final CronJobsResponse _self;
  final $Res Function(CronJobsResponse) _then;

/// Create a copy of CronJobsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? jobs = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,jobs: null == jobs ? _self.jobs : jobs // ignore: cast_nullable_to_non_nullable
as List<CronJob>,
  ));
}

}


/// Adds pattern-matching-related methods to [CronJobsResponse].
extension CronJobsResponsePatterns on CronJobsResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CronJobsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CronJobsResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CronJobsResponse value)  $default,){
final _that = this;
switch (_that) {
case _CronJobsResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CronJobsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CronJobsResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  List<CronJob> jobs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CronJobsResponse() when $default != null:
return $default(_that.ok,_that.jobs);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  List<CronJob> jobs)  $default,) {final _that = this;
switch (_that) {
case _CronJobsResponse():
return $default(_that.ok,_that.jobs);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  List<CronJob> jobs)?  $default,) {final _that = this;
switch (_that) {
case _CronJobsResponse() when $default != null:
return $default(_that.ok,_that.jobs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CronJobsResponse implements CronJobsResponse {
  const _CronJobsResponse({required this.ok, final  List<CronJob> jobs = const []}): _jobs = jobs;
  factory _CronJobsResponse.fromJson(Map<String, dynamic> json) => _$CronJobsResponseFromJson(json);

@override final  bool ok;
 final  List<CronJob> _jobs;
@override@JsonKey() List<CronJob> get jobs {
  if (_jobs is EqualUnmodifiableListView) return _jobs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jobs);
}


/// Create a copy of CronJobsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CronJobsResponseCopyWith<_CronJobsResponse> get copyWith => __$CronJobsResponseCopyWithImpl<_CronJobsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CronJobsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CronJobsResponse&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other._jobs, _jobs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(_jobs));

@override
String toString() {
  return 'CronJobsResponse(ok: $ok, jobs: $jobs)';
}


}

/// @nodoc
abstract mixin class _$CronJobsResponseCopyWith<$Res> implements $CronJobsResponseCopyWith<$Res> {
  factory _$CronJobsResponseCopyWith(_CronJobsResponse value, $Res Function(_CronJobsResponse) _then) = __$CronJobsResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, List<CronJob> jobs
});




}
/// @nodoc
class __$CronJobsResponseCopyWithImpl<$Res>
    implements _$CronJobsResponseCopyWith<$Res> {
  __$CronJobsResponseCopyWithImpl(this._self, this._then);

  final _CronJobsResponse _self;
  final $Res Function(_CronJobsResponse) _then;

/// Create a copy of CronJobsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? jobs = null,}) {
  return _then(_CronJobsResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,jobs: null == jobs ? _self._jobs : jobs // ignore: cast_nullable_to_non_nullable
as List<CronJob>,
  ));
}


}


/// @nodoc
mixin _$CronLogResponse {

 bool get ok; String get id;/// Captured output. Truncated from the front by the service when large,
/// so the tail — where a failure's cause usually is — survives.
 String get logs;
/// Create a copy of CronLogResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CronLogResponseCopyWith<CronLogResponse> get copyWith => _$CronLogResponseCopyWithImpl<CronLogResponse>(this as CronLogResponse, _$identity);

  /// Serializes this CronLogResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CronLogResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.id, id) || other.id == id)&&(identical(other.logs, logs) || other.logs == logs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,id,logs);

@override
String toString() {
  return 'CronLogResponse(ok: $ok, id: $id, logs: $logs)';
}


}

/// @nodoc
abstract mixin class $CronLogResponseCopyWith<$Res>  {
  factory $CronLogResponseCopyWith(CronLogResponse value, $Res Function(CronLogResponse) _then) = _$CronLogResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, String id, String logs
});




}
/// @nodoc
class _$CronLogResponseCopyWithImpl<$Res>
    implements $CronLogResponseCopyWith<$Res> {
  _$CronLogResponseCopyWithImpl(this._self, this._then);

  final CronLogResponse _self;
  final $Res Function(CronLogResponse) _then;

/// Create a copy of CronLogResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? id = null,Object? logs = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CronLogResponse].
extension CronLogResponsePatterns on CronLogResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CronLogResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CronLogResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CronLogResponse value)  $default,){
final _that = this;
switch (_that) {
case _CronLogResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CronLogResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CronLogResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String id,  String logs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CronLogResponse() when $default != null:
return $default(_that.ok,_that.id,_that.logs);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String id,  String logs)  $default,) {final _that = this;
switch (_that) {
case _CronLogResponse():
return $default(_that.ok,_that.id,_that.logs);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String id,  String logs)?  $default,) {final _that = this;
switch (_that) {
case _CronLogResponse() when $default != null:
return $default(_that.ok,_that.id,_that.logs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CronLogResponse implements CronLogResponse {
  const _CronLogResponse({required this.ok, this.id = '', this.logs = ''});
  factory _CronLogResponse.fromJson(Map<String, dynamic> json) => _$CronLogResponseFromJson(json);

@override final  bool ok;
@override@JsonKey() final  String id;
/// Captured output. Truncated from the front by the service when large,
/// so the tail — where a failure's cause usually is — survives.
@override@JsonKey() final  String logs;

/// Create a copy of CronLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CronLogResponseCopyWith<_CronLogResponse> get copyWith => __$CronLogResponseCopyWithImpl<_CronLogResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CronLogResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CronLogResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.id, id) || other.id == id)&&(identical(other.logs, logs) || other.logs == logs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,id,logs);

@override
String toString() {
  return 'CronLogResponse(ok: $ok, id: $id, logs: $logs)';
}


}

/// @nodoc
abstract mixin class _$CronLogResponseCopyWith<$Res> implements $CronLogResponseCopyWith<$Res> {
  factory _$CronLogResponseCopyWith(_CronLogResponse value, $Res Function(_CronLogResponse) _then) = __$CronLogResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String id, String logs
});




}
/// @nodoc
class __$CronLogResponseCopyWithImpl<$Res>
    implements _$CronLogResponseCopyWith<$Res> {
  __$CronLogResponseCopyWithImpl(this._self, this._then);

  final _CronLogResponse _self;
  final $Res Function(_CronLogResponse) _then;

/// Create a copy of CronLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? id = null,Object? logs = null,}) {
  return _then(_CronLogResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
