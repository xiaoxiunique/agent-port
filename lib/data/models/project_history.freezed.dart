// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectHistoryEntry {

 String get path; String get name; String get lastAgent; String get lastSeenAt; int get launchCount;
/// Create a copy of ProjectHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectHistoryEntryCopyWith<ProjectHistoryEntry> get copyWith => _$ProjectHistoryEntryCopyWithImpl<ProjectHistoryEntry>(this as ProjectHistoryEntry, _$identity);

  /// Serializes this ProjectHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectHistoryEntry&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.lastAgent, lastAgent) || other.lastAgent == lastAgent)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.launchCount, launchCount) || other.launchCount == launchCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,name,lastAgent,lastSeenAt,launchCount);

@override
String toString() {
  return 'ProjectHistoryEntry(path: $path, name: $name, lastAgent: $lastAgent, lastSeenAt: $lastSeenAt, launchCount: $launchCount)';
}


}

/// @nodoc
abstract mixin class $ProjectHistoryEntryCopyWith<$Res>  {
  factory $ProjectHistoryEntryCopyWith(ProjectHistoryEntry value, $Res Function(ProjectHistoryEntry) _then) = _$ProjectHistoryEntryCopyWithImpl;
@useResult
$Res call({
 String path, String name, String lastAgent, String lastSeenAt, int launchCount
});




}
/// @nodoc
class _$ProjectHistoryEntryCopyWithImpl<$Res>
    implements $ProjectHistoryEntryCopyWith<$Res> {
  _$ProjectHistoryEntryCopyWithImpl(this._self, this._then);

  final ProjectHistoryEntry _self;
  final $Res Function(ProjectHistoryEntry) _then;

/// Create a copy of ProjectHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? name = null,Object? lastAgent = null,Object? lastSeenAt = null,Object? launchCount = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lastAgent: null == lastAgent ? _self.lastAgent : lastAgent // ignore: cast_nullable_to_non_nullable
as String,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as String,launchCount: null == launchCount ? _self.launchCount : launchCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectHistoryEntry].
extension ProjectHistoryEntryPatterns on ProjectHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _ProjectHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String name,  String lastAgent,  String lastSeenAt,  int launchCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectHistoryEntry() when $default != null:
return $default(_that.path,_that.name,_that.lastAgent,_that.lastSeenAt,_that.launchCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String name,  String lastAgent,  String lastSeenAt,  int launchCount)  $default,) {final _that = this;
switch (_that) {
case _ProjectHistoryEntry():
return $default(_that.path,_that.name,_that.lastAgent,_that.lastSeenAt,_that.launchCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String name,  String lastAgent,  String lastSeenAt,  int launchCount)?  $default,) {final _that = this;
switch (_that) {
case _ProjectHistoryEntry() when $default != null:
return $default(_that.path,_that.name,_that.lastAgent,_that.lastSeenAt,_that.launchCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectHistoryEntry implements ProjectHistoryEntry {
  const _ProjectHistoryEntry({required this.path, required this.name, required this.lastAgent, required this.lastSeenAt, required this.launchCount});
  factory _ProjectHistoryEntry.fromJson(Map<String, dynamic> json) => _$ProjectHistoryEntryFromJson(json);

@override final  String path;
@override final  String name;
@override final  String lastAgent;
@override final  String lastSeenAt;
@override final  int launchCount;

/// Create a copy of ProjectHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectHistoryEntryCopyWith<_ProjectHistoryEntry> get copyWith => __$ProjectHistoryEntryCopyWithImpl<_ProjectHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectHistoryEntry&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.lastAgent, lastAgent) || other.lastAgent == lastAgent)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.launchCount, launchCount) || other.launchCount == launchCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,name,lastAgent,lastSeenAt,launchCount);

@override
String toString() {
  return 'ProjectHistoryEntry(path: $path, name: $name, lastAgent: $lastAgent, lastSeenAt: $lastSeenAt, launchCount: $launchCount)';
}


}

/// @nodoc
abstract mixin class _$ProjectHistoryEntryCopyWith<$Res> implements $ProjectHistoryEntryCopyWith<$Res> {
  factory _$ProjectHistoryEntryCopyWith(_ProjectHistoryEntry value, $Res Function(_ProjectHistoryEntry) _then) = __$ProjectHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String path, String name, String lastAgent, String lastSeenAt, int launchCount
});




}
/// @nodoc
class __$ProjectHistoryEntryCopyWithImpl<$Res>
    implements _$ProjectHistoryEntryCopyWith<$Res> {
  __$ProjectHistoryEntryCopyWithImpl(this._self, this._then);

  final _ProjectHistoryEntry _self;
  final $Res Function(_ProjectHistoryEntry) _then;

/// Create a copy of ProjectHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? name = null,Object? lastAgent = null,Object? lastSeenAt = null,Object? launchCount = null,}) {
  return _then(_ProjectHistoryEntry(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lastAgent: null == lastAgent ? _self.lastAgent : lastAgent // ignore: cast_nullable_to_non_nullable
as String,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as String,launchCount: null == launchCount ? _self.launchCount : launchCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProjectHistoryResponse {

 bool get ok; List<ProjectHistoryEntry> get projects;
/// Create a copy of ProjectHistoryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectHistoryResponseCopyWith<ProjectHistoryResponse> get copyWith => _$ProjectHistoryResponseCopyWithImpl<ProjectHistoryResponse>(this as ProjectHistoryResponse, _$identity);

  /// Serializes this ProjectHistoryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectHistoryResponse&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other.projects, projects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(projects));

@override
String toString() {
  return 'ProjectHistoryResponse(ok: $ok, projects: $projects)';
}


}

/// @nodoc
abstract mixin class $ProjectHistoryResponseCopyWith<$Res>  {
  factory $ProjectHistoryResponseCopyWith(ProjectHistoryResponse value, $Res Function(ProjectHistoryResponse) _then) = _$ProjectHistoryResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, List<ProjectHistoryEntry> projects
});




}
/// @nodoc
class _$ProjectHistoryResponseCopyWithImpl<$Res>
    implements $ProjectHistoryResponseCopyWith<$Res> {
  _$ProjectHistoryResponseCopyWithImpl(this._self, this._then);

  final ProjectHistoryResponse _self;
  final $Res Function(ProjectHistoryResponse) _then;

/// Create a copy of ProjectHistoryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? projects = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<ProjectHistoryEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectHistoryResponse].
extension ProjectHistoryResponsePatterns on ProjectHistoryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectHistoryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectHistoryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectHistoryResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectHistoryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectHistoryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectHistoryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  List<ProjectHistoryEntry> projects)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectHistoryResponse() when $default != null:
return $default(_that.ok,_that.projects);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  List<ProjectHistoryEntry> projects)  $default,) {final _that = this;
switch (_that) {
case _ProjectHistoryResponse():
return $default(_that.ok,_that.projects);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  List<ProjectHistoryEntry> projects)?  $default,) {final _that = this;
switch (_that) {
case _ProjectHistoryResponse() when $default != null:
return $default(_that.ok,_that.projects);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectHistoryResponse implements ProjectHistoryResponse {
  const _ProjectHistoryResponse({required this.ok, final  List<ProjectHistoryEntry> projects = const []}): _projects = projects;
  factory _ProjectHistoryResponse.fromJson(Map<String, dynamic> json) => _$ProjectHistoryResponseFromJson(json);

@override final  bool ok;
 final  List<ProjectHistoryEntry> _projects;
@override@JsonKey() List<ProjectHistoryEntry> get projects {
  if (_projects is EqualUnmodifiableListView) return _projects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_projects);
}


/// Create a copy of ProjectHistoryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectHistoryResponseCopyWith<_ProjectHistoryResponse> get copyWith => __$ProjectHistoryResponseCopyWithImpl<_ProjectHistoryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectHistoryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectHistoryResponse&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other._projects, _projects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(_projects));

@override
String toString() {
  return 'ProjectHistoryResponse(ok: $ok, projects: $projects)';
}


}

/// @nodoc
abstract mixin class _$ProjectHistoryResponseCopyWith<$Res> implements $ProjectHistoryResponseCopyWith<$Res> {
  factory _$ProjectHistoryResponseCopyWith(_ProjectHistoryResponse value, $Res Function(_ProjectHistoryResponse) _then) = __$ProjectHistoryResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, List<ProjectHistoryEntry> projects
});




}
/// @nodoc
class __$ProjectHistoryResponseCopyWithImpl<$Res>
    implements _$ProjectHistoryResponseCopyWith<$Res> {
  __$ProjectHistoryResponseCopyWithImpl(this._self, this._then);

  final _ProjectHistoryResponse _self;
  final $Res Function(_ProjectHistoryResponse) _then;

/// Create a copy of ProjectHistoryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? projects = null,}) {
  return _then(_ProjectHistoryResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,projects: null == projects ? _self._projects : projects // ignore: cast_nullable_to_non_nullable
as List<ProjectHistoryEntry>,
  ));
}


}

// dart format on
