// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgentEventSource {

 String get agent; String? get path; String? get sessionId;
/// Create a copy of AgentEventSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentEventSourceCopyWith<AgentEventSource> get copyWith => _$AgentEventSourceCopyWithImpl<AgentEventSource>(this as AgentEventSource, _$identity);

  /// Serializes this AgentEventSource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentEventSource&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.path, path) || other.path == path)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agent,path,sessionId);

@override
String toString() {
  return 'AgentEventSource(agent: $agent, path: $path, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $AgentEventSourceCopyWith<$Res>  {
  factory $AgentEventSourceCopyWith(AgentEventSource value, $Res Function(AgentEventSource) _then) = _$AgentEventSourceCopyWithImpl;
@useResult
$Res call({
 String agent, String? path, String? sessionId
});




}
/// @nodoc
class _$AgentEventSourceCopyWithImpl<$Res>
    implements $AgentEventSourceCopyWith<$Res> {
  _$AgentEventSourceCopyWithImpl(this._self, this._then);

  final AgentEventSource _self;
  final $Res Function(AgentEventSource) _then;

/// Create a copy of AgentEventSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agent = null,Object? path = freezed,Object? sessionId = freezed,}) {
  return _then(_self.copyWith(
agent: null == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentEventSource].
extension AgentEventSourcePatterns on AgentEventSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentEventSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentEventSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentEventSource value)  $default,){
final _that = this;
switch (_that) {
case _AgentEventSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentEventSource value)?  $default,){
final _that = this;
switch (_that) {
case _AgentEventSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String agent,  String? path,  String? sessionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentEventSource() when $default != null:
return $default(_that.agent,_that.path,_that.sessionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String agent,  String? path,  String? sessionId)  $default,) {final _that = this;
switch (_that) {
case _AgentEventSource():
return $default(_that.agent,_that.path,_that.sessionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String agent,  String? path,  String? sessionId)?  $default,) {final _that = this;
switch (_that) {
case _AgentEventSource() when $default != null:
return $default(_that.agent,_that.path,_that.sessionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentEventSource implements AgentEventSource {
  const _AgentEventSource({required this.agent, this.path, this.sessionId});
  factory _AgentEventSource.fromJson(Map<String, dynamic> json) => _$AgentEventSourceFromJson(json);

@override final  String agent;
@override final  String? path;
@override final  String? sessionId;

/// Create a copy of AgentEventSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentEventSourceCopyWith<_AgentEventSource> get copyWith => __$AgentEventSourceCopyWithImpl<_AgentEventSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentEventSourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentEventSource&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.path, path) || other.path == path)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agent,path,sessionId);

@override
String toString() {
  return 'AgentEventSource(agent: $agent, path: $path, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class _$AgentEventSourceCopyWith<$Res> implements $AgentEventSourceCopyWith<$Res> {
  factory _$AgentEventSourceCopyWith(_AgentEventSource value, $Res Function(_AgentEventSource) _then) = __$AgentEventSourceCopyWithImpl;
@override @useResult
$Res call({
 String agent, String? path, String? sessionId
});




}
/// @nodoc
class __$AgentEventSourceCopyWithImpl<$Res>
    implements _$AgentEventSourceCopyWith<$Res> {
  __$AgentEventSourceCopyWithImpl(this._self, this._then);

  final _AgentEventSource _self;
  final $Res Function(_AgentEventSource) _then;

/// Create a copy of AgentEventSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agent = null,Object? path = freezed,Object? sessionId = freezed,}) {
  return _then(_AgentEventSource(
agent: null == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AgentEvent {

 String get id; String get paneId; AgentEventRole get role; AgentEventKind get kind; String get title; String get body; String get createdAt; String? get toolName; String? get callId; String? get status;
/// Create a copy of AgentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentEventCopyWith<AgentEvent> get copyWith => _$AgentEventCopyWithImpl<AgentEvent>(this as AgentEvent, _$identity);

  /// Serializes this AgentEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.role, role) || other.role == role)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.toolName, toolName) || other.toolName == toolName)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,paneId,role,kind,title,body,createdAt,toolName,callId,status);

@override
String toString() {
  return 'AgentEvent(id: $id, paneId: $paneId, role: $role, kind: $kind, title: $title, body: $body, createdAt: $createdAt, toolName: $toolName, callId: $callId, status: $status)';
}


}

/// @nodoc
abstract mixin class $AgentEventCopyWith<$Res>  {
  factory $AgentEventCopyWith(AgentEvent value, $Res Function(AgentEvent) _then) = _$AgentEventCopyWithImpl;
@useResult
$Res call({
 String id, String paneId, AgentEventRole role, AgentEventKind kind, String title, String body, String createdAt, String? toolName, String? callId, String? status
});




}
/// @nodoc
class _$AgentEventCopyWithImpl<$Res>
    implements $AgentEventCopyWith<$Res> {
  _$AgentEventCopyWithImpl(this._self, this._then);

  final AgentEvent _self;
  final $Res Function(AgentEvent) _then;

/// Create a copy of AgentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? paneId = null,Object? role = null,Object? kind = null,Object? title = null,Object? body = null,Object? createdAt = null,Object? toolName = freezed,Object? callId = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,paneId: null == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AgentEventRole,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AgentEventKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,toolName: freezed == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String?,callId: freezed == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentEvent].
extension AgentEventPatterns on AgentEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentEvent value)  $default,){
final _that = this;
switch (_that) {
case _AgentEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AgentEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String paneId,  AgentEventRole role,  AgentEventKind kind,  String title,  String body,  String createdAt,  String? toolName,  String? callId,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentEvent() when $default != null:
return $default(_that.id,_that.paneId,_that.role,_that.kind,_that.title,_that.body,_that.createdAt,_that.toolName,_that.callId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String paneId,  AgentEventRole role,  AgentEventKind kind,  String title,  String body,  String createdAt,  String? toolName,  String? callId,  String? status)  $default,) {final _that = this;
switch (_that) {
case _AgentEvent():
return $default(_that.id,_that.paneId,_that.role,_that.kind,_that.title,_that.body,_that.createdAt,_that.toolName,_that.callId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String paneId,  AgentEventRole role,  AgentEventKind kind,  String title,  String body,  String createdAt,  String? toolName,  String? callId,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _AgentEvent() when $default != null:
return $default(_that.id,_that.paneId,_that.role,_that.kind,_that.title,_that.body,_that.createdAt,_that.toolName,_that.callId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentEvent implements AgentEvent {
  const _AgentEvent({required this.id, required this.paneId, required this.role, required this.kind, required this.title, required this.body, required this.createdAt, this.toolName, this.callId, this.status});
  factory _AgentEvent.fromJson(Map<String, dynamic> json) => _$AgentEventFromJson(json);

@override final  String id;
@override final  String paneId;
@override final  AgentEventRole role;
@override final  AgentEventKind kind;
@override final  String title;
@override final  String body;
@override final  String createdAt;
@override final  String? toolName;
@override final  String? callId;
@override final  String? status;

/// Create a copy of AgentEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentEventCopyWith<_AgentEvent> get copyWith => __$AgentEventCopyWithImpl<_AgentEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.role, role) || other.role == role)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.toolName, toolName) || other.toolName == toolName)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,paneId,role,kind,title,body,createdAt,toolName,callId,status);

@override
String toString() {
  return 'AgentEvent(id: $id, paneId: $paneId, role: $role, kind: $kind, title: $title, body: $body, createdAt: $createdAt, toolName: $toolName, callId: $callId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AgentEventCopyWith<$Res> implements $AgentEventCopyWith<$Res> {
  factory _$AgentEventCopyWith(_AgentEvent value, $Res Function(_AgentEvent) _then) = __$AgentEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String paneId, AgentEventRole role, AgentEventKind kind, String title, String body, String createdAt, String? toolName, String? callId, String? status
});




}
/// @nodoc
class __$AgentEventCopyWithImpl<$Res>
    implements _$AgentEventCopyWith<$Res> {
  __$AgentEventCopyWithImpl(this._self, this._then);

  final _AgentEvent _self;
  final $Res Function(_AgentEvent) _then;

/// Create a copy of AgentEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? paneId = null,Object? role = null,Object? kind = null,Object? title = null,Object? body = null,Object? createdAt = null,Object? toolName = freezed,Object? callId = freezed,Object? status = freezed,}) {
  return _then(_AgentEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,paneId: null == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AgentEventRole,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AgentEventKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,toolName: freezed == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String?,callId: freezed == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AgentEventsResponse {

 bool get ok; String? get paneId; AgentEventSource? get source; List<AgentEvent> get events; String? get capturedAt; String? get error;
/// Create a copy of AgentEventsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentEventsResponseCopyWith<AgentEventsResponse> get copyWith => _$AgentEventsResponseCopyWithImpl<AgentEventsResponse>(this as AgentEventsResponse, _$identity);

  /// Serializes this AgentEventsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentEventsResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,paneId,source,const DeepCollectionEquality().hash(events),capturedAt,error);

@override
String toString() {
  return 'AgentEventsResponse(ok: $ok, paneId: $paneId, source: $source, events: $events, capturedAt: $capturedAt, error: $error)';
}


}

/// @nodoc
abstract mixin class $AgentEventsResponseCopyWith<$Res>  {
  factory $AgentEventsResponseCopyWith(AgentEventsResponse value, $Res Function(AgentEventsResponse) _then) = _$AgentEventsResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, String? paneId, AgentEventSource? source, List<AgentEvent> events, String? capturedAt, String? error
});


$AgentEventSourceCopyWith<$Res>? get source;

}
/// @nodoc
class _$AgentEventsResponseCopyWithImpl<$Res>
    implements $AgentEventsResponseCopyWith<$Res> {
  _$AgentEventsResponseCopyWithImpl(this._self, this._then);

  final AgentEventsResponse _self;
  final $Res Function(AgentEventsResponse) _then;

/// Create a copy of AgentEventsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? paneId = freezed,Object? source = freezed,Object? events = null,Object? capturedAt = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,paneId: freezed == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AgentEventSource?,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<AgentEvent>,capturedAt: freezed == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AgentEventsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentEventSourceCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $AgentEventSourceCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}


/// Adds pattern-matching-related methods to [AgentEventsResponse].
extension AgentEventsResponsePatterns on AgentEventsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentEventsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentEventsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentEventsResponse value)  $default,){
final _that = this;
switch (_that) {
case _AgentEventsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentEventsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AgentEventsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String? paneId,  AgentEventSource? source,  List<AgentEvent> events,  String? capturedAt,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentEventsResponse() when $default != null:
return $default(_that.ok,_that.paneId,_that.source,_that.events,_that.capturedAt,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String? paneId,  AgentEventSource? source,  List<AgentEvent> events,  String? capturedAt,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AgentEventsResponse():
return $default(_that.ok,_that.paneId,_that.source,_that.events,_that.capturedAt,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String? paneId,  AgentEventSource? source,  List<AgentEvent> events,  String? capturedAt,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AgentEventsResponse() when $default != null:
return $default(_that.ok,_that.paneId,_that.source,_that.events,_that.capturedAt,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentEventsResponse implements AgentEventsResponse {
  const _AgentEventsResponse({required this.ok, this.paneId, this.source, final  List<AgentEvent> events = const [], this.capturedAt, this.error}): _events = events;
  factory _AgentEventsResponse.fromJson(Map<String, dynamic> json) => _$AgentEventsResponseFromJson(json);

@override final  bool ok;
@override final  String? paneId;
@override final  AgentEventSource? source;
 final  List<AgentEvent> _events;
@override@JsonKey() List<AgentEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override final  String? capturedAt;
@override final  String? error;

/// Create a copy of AgentEventsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentEventsResponseCopyWith<_AgentEventsResponse> get copyWith => __$AgentEventsResponseCopyWithImpl<_AgentEventsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentEventsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentEventsResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,paneId,source,const DeepCollectionEquality().hash(_events),capturedAt,error);

@override
String toString() {
  return 'AgentEventsResponse(ok: $ok, paneId: $paneId, source: $source, events: $events, capturedAt: $capturedAt, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AgentEventsResponseCopyWith<$Res> implements $AgentEventsResponseCopyWith<$Res> {
  factory _$AgentEventsResponseCopyWith(_AgentEventsResponse value, $Res Function(_AgentEventsResponse) _then) = __$AgentEventsResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String? paneId, AgentEventSource? source, List<AgentEvent> events, String? capturedAt, String? error
});


@override $AgentEventSourceCopyWith<$Res>? get source;

}
/// @nodoc
class __$AgentEventsResponseCopyWithImpl<$Res>
    implements _$AgentEventsResponseCopyWith<$Res> {
  __$AgentEventsResponseCopyWithImpl(this._self, this._then);

  final _AgentEventsResponse _self;
  final $Res Function(_AgentEventsResponse) _then;

/// Create a copy of AgentEventsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? paneId = freezed,Object? source = freezed,Object? events = null,Object? capturedAt = freezed,Object? error = freezed,}) {
  return _then(_AgentEventsResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,paneId: freezed == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AgentEventSource?,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<AgentEvent>,capturedAt: freezed == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AgentEventsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentEventSourceCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $AgentEventSourceCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}

// dart format on
