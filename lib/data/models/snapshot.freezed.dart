// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SystemStats {

 num? get cpuUsage; num? get memoryUsage;
/// Create a copy of SystemStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SystemStatsCopyWith<SystemStats> get copyWith => _$SystemStatsCopyWithImpl<SystemStats>(this as SystemStats, _$identity);

  /// Serializes this SystemStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SystemStats&&(identical(other.cpuUsage, cpuUsage) || other.cpuUsage == cpuUsage)&&(identical(other.memoryUsage, memoryUsage) || other.memoryUsage == memoryUsage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cpuUsage,memoryUsage);

@override
String toString() {
  return 'SystemStats(cpuUsage: $cpuUsage, memoryUsage: $memoryUsage)';
}


}

/// @nodoc
abstract mixin class $SystemStatsCopyWith<$Res>  {
  factory $SystemStatsCopyWith(SystemStats value, $Res Function(SystemStats) _then) = _$SystemStatsCopyWithImpl;
@useResult
$Res call({
 num? cpuUsage, num? memoryUsage
});




}
/// @nodoc
class _$SystemStatsCopyWithImpl<$Res>
    implements $SystemStatsCopyWith<$Res> {
  _$SystemStatsCopyWithImpl(this._self, this._then);

  final SystemStats _self;
  final $Res Function(SystemStats) _then;

/// Create a copy of SystemStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cpuUsage = freezed,Object? memoryUsage = freezed,}) {
  return _then(_self.copyWith(
cpuUsage: freezed == cpuUsage ? _self.cpuUsage : cpuUsage // ignore: cast_nullable_to_non_nullable
as num?,memoryUsage: freezed == memoryUsage ? _self.memoryUsage : memoryUsage // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [SystemStats].
extension SystemStatsPatterns on SystemStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SystemStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SystemStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SystemStats value)  $default,){
final _that = this;
switch (_that) {
case _SystemStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SystemStats value)?  $default,){
final _that = this;
switch (_that) {
case _SystemStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num? cpuUsage,  num? memoryUsage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SystemStats() when $default != null:
return $default(_that.cpuUsage,_that.memoryUsage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num? cpuUsage,  num? memoryUsage)  $default,) {final _that = this;
switch (_that) {
case _SystemStats():
return $default(_that.cpuUsage,_that.memoryUsage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num? cpuUsage,  num? memoryUsage)?  $default,) {final _that = this;
switch (_that) {
case _SystemStats() when $default != null:
return $default(_that.cpuUsage,_that.memoryUsage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SystemStats implements SystemStats {
  const _SystemStats({this.cpuUsage, this.memoryUsage});
  factory _SystemStats.fromJson(Map<String, dynamic> json) => _$SystemStatsFromJson(json);

@override final  num? cpuUsage;
@override final  num? memoryUsage;

/// Create a copy of SystemStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SystemStatsCopyWith<_SystemStats> get copyWith => __$SystemStatsCopyWithImpl<_SystemStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SystemStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SystemStats&&(identical(other.cpuUsage, cpuUsage) || other.cpuUsage == cpuUsage)&&(identical(other.memoryUsage, memoryUsage) || other.memoryUsage == memoryUsage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cpuUsage,memoryUsage);

@override
String toString() {
  return 'SystemStats(cpuUsage: $cpuUsage, memoryUsage: $memoryUsage)';
}


}

/// @nodoc
abstract mixin class _$SystemStatsCopyWith<$Res> implements $SystemStatsCopyWith<$Res> {
  factory _$SystemStatsCopyWith(_SystemStats value, $Res Function(_SystemStats) _then) = __$SystemStatsCopyWithImpl;
@override @useResult
$Res call({
 num? cpuUsage, num? memoryUsage
});




}
/// @nodoc
class __$SystemStatsCopyWithImpl<$Res>
    implements _$SystemStatsCopyWith<$Res> {
  __$SystemStatsCopyWithImpl(this._self, this._then);

  final _SystemStats _self;
  final $Res Function(_SystemStats) _then;

/// Create a copy of SystemStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cpuUsage = freezed,Object? memoryUsage = freezed,}) {
  return _then(_SystemStats(
cpuUsage: freezed == cpuUsage ? _self.cpuUsage : cpuUsage // ignore: cast_nullable_to_non_nullable
as num?,memoryUsage: freezed == memoryUsage ? _self.memoryUsage : memoryUsage // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$DeviceInfo {

 String? get name; String? get modelIdentifier; String get kind; String get modelName;
/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<DeviceInfo> get copyWith => _$DeviceInfoCopyWithImpl<DeviceInfo>(this as DeviceInfo, _$identity);

  /// Serializes this DeviceInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.modelIdentifier, modelIdentifier) || other.modelIdentifier == modelIdentifier)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.modelName, modelName) || other.modelName == modelName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,modelIdentifier,kind,modelName);

@override
String toString() {
  return 'DeviceInfo(name: $name, modelIdentifier: $modelIdentifier, kind: $kind, modelName: $modelName)';
}


}

/// @nodoc
abstract mixin class $DeviceInfoCopyWith<$Res>  {
  factory $DeviceInfoCopyWith(DeviceInfo value, $Res Function(DeviceInfo) _then) = _$DeviceInfoCopyWithImpl;
@useResult
$Res call({
 String? name, String? modelIdentifier, String kind, String modelName
});




}
/// @nodoc
class _$DeviceInfoCopyWithImpl<$Res>
    implements $DeviceInfoCopyWith<$Res> {
  _$DeviceInfoCopyWithImpl(this._self, this._then);

  final DeviceInfo _self;
  final $Res Function(DeviceInfo) _then;

/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? modelIdentifier = freezed,Object? kind = null,Object? modelName = null,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,modelIdentifier: freezed == modelIdentifier ? _self.modelIdentifier : modelIdentifier // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceInfo].
extension DeviceInfoPatterns on DeviceInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceInfo value)  $default,){
final _that = this;
switch (_that) {
case _DeviceInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceInfo value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? modelIdentifier,  String kind,  String modelName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceInfo() when $default != null:
return $default(_that.name,_that.modelIdentifier,_that.kind,_that.modelName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? modelIdentifier,  String kind,  String modelName)  $default,) {final _that = this;
switch (_that) {
case _DeviceInfo():
return $default(_that.name,_that.modelIdentifier,_that.kind,_that.modelName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? modelIdentifier,  String kind,  String modelName)?  $default,) {final _that = this;
switch (_that) {
case _DeviceInfo() when $default != null:
return $default(_that.name,_that.modelIdentifier,_that.kind,_that.modelName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceInfo implements DeviceInfo {
  const _DeviceInfo({this.name, this.modelIdentifier, required this.kind, required this.modelName});
  factory _DeviceInfo.fromJson(Map<String, dynamic> json) => _$DeviceInfoFromJson(json);

@override final  String? name;
@override final  String? modelIdentifier;
@override final  String kind;
@override final  String modelName;

/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceInfoCopyWith<_DeviceInfo> get copyWith => __$DeviceInfoCopyWithImpl<_DeviceInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.modelIdentifier, modelIdentifier) || other.modelIdentifier == modelIdentifier)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.modelName, modelName) || other.modelName == modelName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,modelIdentifier,kind,modelName);

@override
String toString() {
  return 'DeviceInfo(name: $name, modelIdentifier: $modelIdentifier, kind: $kind, modelName: $modelName)';
}


}

/// @nodoc
abstract mixin class _$DeviceInfoCopyWith<$Res> implements $DeviceInfoCopyWith<$Res> {
  factory _$DeviceInfoCopyWith(_DeviceInfo value, $Res Function(_DeviceInfo) _then) = __$DeviceInfoCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? modelIdentifier, String kind, String modelName
});




}
/// @nodoc
class __$DeviceInfoCopyWithImpl<$Res>
    implements _$DeviceInfoCopyWith<$Res> {
  __$DeviceInfoCopyWithImpl(this._self, this._then);

  final _DeviceInfo _self;
  final $Res Function(_DeviceInfo) _then;

/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? modelIdentifier = freezed,Object? kind = null,Object? modelName = null,}) {
  return _then(_DeviceInfo(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,modelIdentifier: freezed == modelIdentifier ? _self.modelIdentifier : modelIdentifier // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Snapshot {

 bool get ok; String get now; List<Pane> get panes; SystemStats? get system; DeviceInfo? get device; String? get error;
/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnapshotCopyWith<Snapshot> get copyWith => _$SnapshotCopyWithImpl<Snapshot>(this as Snapshot, _$identity);

  /// Serializes this Snapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Snapshot&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.now, now) || other.now == now)&&const DeepCollectionEquality().equals(other.panes, panes)&&(identical(other.system, system) || other.system == system)&&(identical(other.device, device) || other.device == device)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,now,const DeepCollectionEquality().hash(panes),system,device,error);

@override
String toString() {
  return 'Snapshot(ok: $ok, now: $now, panes: $panes, system: $system, device: $device, error: $error)';
}


}

/// @nodoc
abstract mixin class $SnapshotCopyWith<$Res>  {
  factory $SnapshotCopyWith(Snapshot value, $Res Function(Snapshot) _then) = _$SnapshotCopyWithImpl;
@useResult
$Res call({
 bool ok, String now, List<Pane> panes, SystemStats? system, DeviceInfo? device, String? error
});


$SystemStatsCopyWith<$Res>? get system;$DeviceInfoCopyWith<$Res>? get device;

}
/// @nodoc
class _$SnapshotCopyWithImpl<$Res>
    implements $SnapshotCopyWith<$Res> {
  _$SnapshotCopyWithImpl(this._self, this._then);

  final Snapshot _self;
  final $Res Function(Snapshot) _then;

/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? now = null,Object? panes = null,Object? system = freezed,Object? device = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as String,panes: null == panes ? _self.panes : panes // ignore: cast_nullable_to_non_nullable
as List<Pane>,system: freezed == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as SystemStats?,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceInfo?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SystemStatsCopyWith<$Res>? get system {
    if (_self.system == null) {
    return null;
  }

  return $SystemStatsCopyWith<$Res>(_self.system!, (value) {
    return _then(_self.copyWith(system: value));
  });
}/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res>? get device {
    if (_self.device == null) {
    return null;
  }

  return $DeviceInfoCopyWith<$Res>(_self.device!, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [Snapshot].
extension SnapshotPatterns on Snapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Snapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Snapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Snapshot value)  $default,){
final _that = this;
switch (_that) {
case _Snapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Snapshot value)?  $default,){
final _that = this;
switch (_that) {
case _Snapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String now,  List<Pane> panes,  SystemStats? system,  DeviceInfo? device,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Snapshot() when $default != null:
return $default(_that.ok,_that.now,_that.panes,_that.system,_that.device,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String now,  List<Pane> panes,  SystemStats? system,  DeviceInfo? device,  String? error)  $default,) {final _that = this;
switch (_that) {
case _Snapshot():
return $default(_that.ok,_that.now,_that.panes,_that.system,_that.device,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String now,  List<Pane> panes,  SystemStats? system,  DeviceInfo? device,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _Snapshot() when $default != null:
return $default(_that.ok,_that.now,_that.panes,_that.system,_that.device,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Snapshot implements Snapshot {
  const _Snapshot({required this.ok, required this.now, final  List<Pane> panes = const [], this.system, this.device, this.error}): _panes = panes;
  factory _Snapshot.fromJson(Map<String, dynamic> json) => _$SnapshotFromJson(json);

@override final  bool ok;
@override final  String now;
 final  List<Pane> _panes;
@override@JsonKey() List<Pane> get panes {
  if (_panes is EqualUnmodifiableListView) return _panes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_panes);
}

@override final  SystemStats? system;
@override final  DeviceInfo? device;
@override final  String? error;

/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnapshotCopyWith<_Snapshot> get copyWith => __$SnapshotCopyWithImpl<_Snapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Snapshot&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.now, now) || other.now == now)&&const DeepCollectionEquality().equals(other._panes, _panes)&&(identical(other.system, system) || other.system == system)&&(identical(other.device, device) || other.device == device)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,now,const DeepCollectionEquality().hash(_panes),system,device,error);

@override
String toString() {
  return 'Snapshot(ok: $ok, now: $now, panes: $panes, system: $system, device: $device, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SnapshotCopyWith<$Res> implements $SnapshotCopyWith<$Res> {
  factory _$SnapshotCopyWith(_Snapshot value, $Res Function(_Snapshot) _then) = __$SnapshotCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String now, List<Pane> panes, SystemStats? system, DeviceInfo? device, String? error
});


@override $SystemStatsCopyWith<$Res>? get system;@override $DeviceInfoCopyWith<$Res>? get device;

}
/// @nodoc
class __$SnapshotCopyWithImpl<$Res>
    implements _$SnapshotCopyWith<$Res> {
  __$SnapshotCopyWithImpl(this._self, this._then);

  final _Snapshot _self;
  final $Res Function(_Snapshot) _then;

/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? now = null,Object? panes = null,Object? system = freezed,Object? device = freezed,Object? error = freezed,}) {
  return _then(_Snapshot(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as String,panes: null == panes ? _self._panes : panes // ignore: cast_nullable_to_non_nullable
as List<Pane>,system: freezed == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as SystemStats?,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceInfo?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SystemStatsCopyWith<$Res>? get system {
    if (_self.system == null) {
    return null;
  }

  return $SystemStatsCopyWith<$Res>(_self.system!, (value) {
    return _then(_self.copyWith(system: value));
  });
}/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res>? get device {
    if (_self.device == null) {
    return null;
  }

  return $DeviceInfoCopyWith<$Res>(_self.device!, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}

// dart format on
