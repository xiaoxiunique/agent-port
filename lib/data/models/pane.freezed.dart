// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pane.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Pane {

 String get id; String get target; String get session; String get windowIndex; String get windowName; String get paneIndex; String get command; String get path; bool get active; int? get pid; String get title; String get tail; PaneStatus get status; String get reason; String get updatedAt; List<InteractionMessage> get messages;
/// Create a copy of Pane
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaneCopyWith<Pane> get copyWith => _$PaneCopyWithImpl<Pane>(this as Pane, _$identity);

  /// Serializes this Pane to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pane&&(identical(other.id, id) || other.id == id)&&(identical(other.target, target) || other.target == target)&&(identical(other.session, session) || other.session == session)&&(identical(other.windowIndex, windowIndex) || other.windowIndex == windowIndex)&&(identical(other.windowName, windowName) || other.windowName == windowName)&&(identical(other.paneIndex, paneIndex) || other.paneIndex == paneIndex)&&(identical(other.command, command) || other.command == command)&&(identical(other.path, path) || other.path == path)&&(identical(other.active, active) || other.active == active)&&(identical(other.pid, pid) || other.pid == pid)&&(identical(other.title, title) || other.title == title)&&(identical(other.tail, tail) || other.tail == tail)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.messages, messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,target,session,windowIndex,windowName,paneIndex,command,path,active,pid,title,tail,status,reason,updatedAt,const DeepCollectionEquality().hash(messages));

@override
String toString() {
  return 'Pane(id: $id, target: $target, session: $session, windowIndex: $windowIndex, windowName: $windowName, paneIndex: $paneIndex, command: $command, path: $path, active: $active, pid: $pid, title: $title, tail: $tail, status: $status, reason: $reason, updatedAt: $updatedAt, messages: $messages)';
}


}

/// @nodoc
abstract mixin class $PaneCopyWith<$Res>  {
  factory $PaneCopyWith(Pane value, $Res Function(Pane) _then) = _$PaneCopyWithImpl;
@useResult
$Res call({
 String id, String target, String session, String windowIndex, String windowName, String paneIndex, String command, String path, bool active, int? pid, String title, String tail, PaneStatus status, String reason, String updatedAt, List<InteractionMessage> messages
});




}
/// @nodoc
class _$PaneCopyWithImpl<$Res>
    implements $PaneCopyWith<$Res> {
  _$PaneCopyWithImpl(this._self, this._then);

  final Pane _self;
  final $Res Function(Pane) _then;

/// Create a copy of Pane
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? target = null,Object? session = null,Object? windowIndex = null,Object? windowName = null,Object? paneIndex = null,Object? command = null,Object? path = null,Object? active = null,Object? pid = freezed,Object? title = null,Object? tail = null,Object? status = null,Object? reason = null,Object? updatedAt = null,Object? messages = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as String,windowIndex: null == windowIndex ? _self.windowIndex : windowIndex // ignore: cast_nullable_to_non_nullable
as String,windowName: null == windowName ? _self.windowName : windowName // ignore: cast_nullable_to_non_nullable
as String,paneIndex: null == paneIndex ? _self.paneIndex : paneIndex // ignore: cast_nullable_to_non_nullable
as String,command: null == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,pid: freezed == pid ? _self.pid : pid // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tail: null == tail ? _self.tail : tail // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaneStatus,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<InteractionMessage>,
  ));
}

}


/// Adds pattern-matching-related methods to [Pane].
extension PanePatterns on Pane {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pane value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pane() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pane value)  $default,){
final _that = this;
switch (_that) {
case _Pane():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pane value)?  $default,){
final _that = this;
switch (_that) {
case _Pane() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String target,  String session,  String windowIndex,  String windowName,  String paneIndex,  String command,  String path,  bool active,  int? pid,  String title,  String tail,  PaneStatus status,  String reason,  String updatedAt,  List<InteractionMessage> messages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pane() when $default != null:
return $default(_that.id,_that.target,_that.session,_that.windowIndex,_that.windowName,_that.paneIndex,_that.command,_that.path,_that.active,_that.pid,_that.title,_that.tail,_that.status,_that.reason,_that.updatedAt,_that.messages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String target,  String session,  String windowIndex,  String windowName,  String paneIndex,  String command,  String path,  bool active,  int? pid,  String title,  String tail,  PaneStatus status,  String reason,  String updatedAt,  List<InteractionMessage> messages)  $default,) {final _that = this;
switch (_that) {
case _Pane():
return $default(_that.id,_that.target,_that.session,_that.windowIndex,_that.windowName,_that.paneIndex,_that.command,_that.path,_that.active,_that.pid,_that.title,_that.tail,_that.status,_that.reason,_that.updatedAt,_that.messages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String target,  String session,  String windowIndex,  String windowName,  String paneIndex,  String command,  String path,  bool active,  int? pid,  String title,  String tail,  PaneStatus status,  String reason,  String updatedAt,  List<InteractionMessage> messages)?  $default,) {final _that = this;
switch (_that) {
case _Pane() when $default != null:
return $default(_that.id,_that.target,_that.session,_that.windowIndex,_that.windowName,_that.paneIndex,_that.command,_that.path,_that.active,_that.pid,_that.title,_that.tail,_that.status,_that.reason,_that.updatedAt,_that.messages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pane implements Pane {
  const _Pane({required this.id, required this.target, required this.session, required this.windowIndex, required this.windowName, required this.paneIndex, required this.command, required this.path, required this.active, this.pid, required this.title, required this.tail, required this.status, required this.reason, required this.updatedAt, final  List<InteractionMessage> messages = const []}): _messages = messages;
  factory _Pane.fromJson(Map<String, dynamic> json) => _$PaneFromJson(json);

@override final  String id;
@override final  String target;
@override final  String session;
@override final  String windowIndex;
@override final  String windowName;
@override final  String paneIndex;
@override final  String command;
@override final  String path;
@override final  bool active;
@override final  int? pid;
@override final  String title;
@override final  String tail;
@override final  PaneStatus status;
@override final  String reason;
@override final  String updatedAt;
 final  List<InteractionMessage> _messages;
@override@JsonKey() List<InteractionMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of Pane
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaneCopyWith<_Pane> get copyWith => __$PaneCopyWithImpl<_Pane>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaneToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pane&&(identical(other.id, id) || other.id == id)&&(identical(other.target, target) || other.target == target)&&(identical(other.session, session) || other.session == session)&&(identical(other.windowIndex, windowIndex) || other.windowIndex == windowIndex)&&(identical(other.windowName, windowName) || other.windowName == windowName)&&(identical(other.paneIndex, paneIndex) || other.paneIndex == paneIndex)&&(identical(other.command, command) || other.command == command)&&(identical(other.path, path) || other.path == path)&&(identical(other.active, active) || other.active == active)&&(identical(other.pid, pid) || other.pid == pid)&&(identical(other.title, title) || other.title == title)&&(identical(other.tail, tail) || other.tail == tail)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._messages, _messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,target,session,windowIndex,windowName,paneIndex,command,path,active,pid,title,tail,status,reason,updatedAt,const DeepCollectionEquality().hash(_messages));

@override
String toString() {
  return 'Pane(id: $id, target: $target, session: $session, windowIndex: $windowIndex, windowName: $windowName, paneIndex: $paneIndex, command: $command, path: $path, active: $active, pid: $pid, title: $title, tail: $tail, status: $status, reason: $reason, updatedAt: $updatedAt, messages: $messages)';
}


}

/// @nodoc
abstract mixin class _$PaneCopyWith<$Res> implements $PaneCopyWith<$Res> {
  factory _$PaneCopyWith(_Pane value, $Res Function(_Pane) _then) = __$PaneCopyWithImpl;
@override @useResult
$Res call({
 String id, String target, String session, String windowIndex, String windowName, String paneIndex, String command, String path, bool active, int? pid, String title, String tail, PaneStatus status, String reason, String updatedAt, List<InteractionMessage> messages
});




}
/// @nodoc
class __$PaneCopyWithImpl<$Res>
    implements _$PaneCopyWith<$Res> {
  __$PaneCopyWithImpl(this._self, this._then);

  final _Pane _self;
  final $Res Function(_Pane) _then;

/// Create a copy of Pane
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? target = null,Object? session = null,Object? windowIndex = null,Object? windowName = null,Object? paneIndex = null,Object? command = null,Object? path = null,Object? active = null,Object? pid = freezed,Object? title = null,Object? tail = null,Object? status = null,Object? reason = null,Object? updatedAt = null,Object? messages = null,}) {
  return _then(_Pane(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as String,windowIndex: null == windowIndex ? _self.windowIndex : windowIndex // ignore: cast_nullable_to_non_nullable
as String,windowName: null == windowName ? _self.windowName : windowName // ignore: cast_nullable_to_non_nullable
as String,paneIndex: null == paneIndex ? _self.paneIndex : paneIndex // ignore: cast_nullable_to_non_nullable
as String,command: null == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,pid: freezed == pid ? _self.pid : pid // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tail: null == tail ? _self.tail : tail // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaneStatus,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<InteractionMessage>,
  ));
}


}

// dart format on
