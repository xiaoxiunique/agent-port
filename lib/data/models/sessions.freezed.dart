// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sessions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PastSession {

 String get id;/// Seconds since the epoch of the transcript's last write.
 double get modified;/// Transcript size on disk — a rough proxy for how much is in it.
 int get size;/// Claude's own generated title, or the opening user prompt for Codex,
/// which records none. Null when neither was readable.
 String? get summary;
/// Create a copy of PastSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PastSessionCopyWith<PastSession> get copyWith => _$PastSessionCopyWithImpl<PastSession>(this as PastSession, _$identity);

  /// Serializes this PastSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastSession&&(identical(other.id, id) || other.id == id)&&(identical(other.modified, modified) || other.modified == modified)&&(identical(other.size, size) || other.size == size)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,modified,size,summary);

@override
String toString() {
  return 'PastSession(id: $id, modified: $modified, size: $size, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $PastSessionCopyWith<$Res>  {
  factory $PastSessionCopyWith(PastSession value, $Res Function(PastSession) _then) = _$PastSessionCopyWithImpl;
@useResult
$Res call({
 String id, double modified, int size, String? summary
});




}
/// @nodoc
class _$PastSessionCopyWithImpl<$Res>
    implements $PastSessionCopyWith<$Res> {
  _$PastSessionCopyWithImpl(this._self, this._then);

  final PastSession _self;
  final $Res Function(PastSession) _then;

/// Create a copy of PastSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? modified = null,Object? size = null,Object? summary = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,modified: null == modified ? _self.modified : modified // ignore: cast_nullable_to_non_nullable
as double,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PastSession].
extension PastSessionPatterns on PastSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PastSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PastSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PastSession value)  $default,){
final _that = this;
switch (_that) {
case _PastSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PastSession value)?  $default,){
final _that = this;
switch (_that) {
case _PastSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double modified,  int size,  String? summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PastSession() when $default != null:
return $default(_that.id,_that.modified,_that.size,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double modified,  int size,  String? summary)  $default,) {final _that = this;
switch (_that) {
case _PastSession():
return $default(_that.id,_that.modified,_that.size,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double modified,  int size,  String? summary)?  $default,) {final _that = this;
switch (_that) {
case _PastSession() when $default != null:
return $default(_that.id,_that.modified,_that.size,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PastSession implements PastSession {
  const _PastSession({required this.id, this.modified = 0, this.size = 0, this.summary});
  factory _PastSession.fromJson(Map<String, dynamic> json) => _$PastSessionFromJson(json);

@override final  String id;
/// Seconds since the epoch of the transcript's last write.
@override@JsonKey() final  double modified;
/// Transcript size on disk — a rough proxy for how much is in it.
@override@JsonKey() final  int size;
/// Claude's own generated title, or the opening user prompt for Codex,
/// which records none. Null when neither was readable.
@override final  String? summary;

/// Create a copy of PastSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PastSessionCopyWith<_PastSession> get copyWith => __$PastSessionCopyWithImpl<_PastSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PastSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PastSession&&(identical(other.id, id) || other.id == id)&&(identical(other.modified, modified) || other.modified == modified)&&(identical(other.size, size) || other.size == size)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,modified,size,summary);

@override
String toString() {
  return 'PastSession(id: $id, modified: $modified, size: $size, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$PastSessionCopyWith<$Res> implements $PastSessionCopyWith<$Res> {
  factory _$PastSessionCopyWith(_PastSession value, $Res Function(_PastSession) _then) = __$PastSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, double modified, int size, String? summary
});




}
/// @nodoc
class __$PastSessionCopyWithImpl<$Res>
    implements _$PastSessionCopyWith<$Res> {
  __$PastSessionCopyWithImpl(this._self, this._then);

  final _PastSession _self;
  final $Res Function(_PastSession) _then;

/// Create a copy of PastSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? modified = null,Object? size = null,Object? summary = freezed,}) {
  return _then(_PastSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,modified: null == modified ? _self.modified : modified // ignore: cast_nullable_to_non_nullable
as double,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AgentSessions {

/// "claude" or "codex".
 String get agent; List<PastSession> get sessions;
/// Create a copy of AgentSessions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentSessionsCopyWith<AgentSessions> get copyWith => _$AgentSessionsCopyWithImpl<AgentSessions>(this as AgentSessions, _$identity);

  /// Serializes this AgentSessions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentSessions&&(identical(other.agent, agent) || other.agent == agent)&&const DeepCollectionEquality().equals(other.sessions, sessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agent,const DeepCollectionEquality().hash(sessions));

@override
String toString() {
  return 'AgentSessions(agent: $agent, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class $AgentSessionsCopyWith<$Res>  {
  factory $AgentSessionsCopyWith(AgentSessions value, $Res Function(AgentSessions) _then) = _$AgentSessionsCopyWithImpl;
@useResult
$Res call({
 String agent, List<PastSession> sessions
});




}
/// @nodoc
class _$AgentSessionsCopyWithImpl<$Res>
    implements $AgentSessionsCopyWith<$Res> {
  _$AgentSessionsCopyWithImpl(this._self, this._then);

  final AgentSessions _self;
  final $Res Function(AgentSessions) _then;

/// Create a copy of AgentSessions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agent = null,Object? sessions = null,}) {
  return _then(_self.copyWith(
agent: null == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<PastSession>,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentSessions].
extension AgentSessionsPatterns on AgentSessions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentSessions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentSessions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentSessions value)  $default,){
final _that = this;
switch (_that) {
case _AgentSessions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentSessions value)?  $default,){
final _that = this;
switch (_that) {
case _AgentSessions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String agent,  List<PastSession> sessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentSessions() when $default != null:
return $default(_that.agent,_that.sessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String agent,  List<PastSession> sessions)  $default,) {final _that = this;
switch (_that) {
case _AgentSessions():
return $default(_that.agent,_that.sessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String agent,  List<PastSession> sessions)?  $default,) {final _that = this;
switch (_that) {
case _AgentSessions() when $default != null:
return $default(_that.agent,_that.sessions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentSessions implements AgentSessions {
  const _AgentSessions({required this.agent, final  List<PastSession> sessions = const []}): _sessions = sessions;
  factory _AgentSessions.fromJson(Map<String, dynamic> json) => _$AgentSessionsFromJson(json);

/// "claude" or "codex".
@override final  String agent;
 final  List<PastSession> _sessions;
@override@JsonKey() List<PastSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}


/// Create a copy of AgentSessions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentSessionsCopyWith<_AgentSessions> get copyWith => __$AgentSessionsCopyWithImpl<_AgentSessions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentSessionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentSessions&&(identical(other.agent, agent) || other.agent == agent)&&const DeepCollectionEquality().equals(other._sessions, _sessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agent,const DeepCollectionEquality().hash(_sessions));

@override
String toString() {
  return 'AgentSessions(agent: $agent, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class _$AgentSessionsCopyWith<$Res> implements $AgentSessionsCopyWith<$Res> {
  factory _$AgentSessionsCopyWith(_AgentSessions value, $Res Function(_AgentSessions) _then) = __$AgentSessionsCopyWithImpl;
@override @useResult
$Res call({
 String agent, List<PastSession> sessions
});




}
/// @nodoc
class __$AgentSessionsCopyWithImpl<$Res>
    implements _$AgentSessionsCopyWith<$Res> {
  __$AgentSessionsCopyWithImpl(this._self, this._then);

  final _AgentSessions _self;
  final $Res Function(_AgentSessions) _then;

/// Create a copy of AgentSessions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agent = null,Object? sessions = null,}) {
  return _then(_AgentSessions(
agent: null == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<PastSession>,
  ));
}


}


/// @nodoc
mixin _$SessionsResponse {

 bool get ok; List<AgentSessions> get agents; String? get error;
/// Create a copy of SessionsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionsResponseCopyWith<SessionsResponse> get copyWith => _$SessionsResponseCopyWithImpl<SessionsResponse>(this as SessionsResponse, _$identity);

  /// Serializes this SessionsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionsResponse&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other.agents, agents)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(agents),error);

@override
String toString() {
  return 'SessionsResponse(ok: $ok, agents: $agents, error: $error)';
}


}

/// @nodoc
abstract mixin class $SessionsResponseCopyWith<$Res>  {
  factory $SessionsResponseCopyWith(SessionsResponse value, $Res Function(SessionsResponse) _then) = _$SessionsResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, List<AgentSessions> agents, String? error
});




}
/// @nodoc
class _$SessionsResponseCopyWithImpl<$Res>
    implements $SessionsResponseCopyWith<$Res> {
  _$SessionsResponseCopyWithImpl(this._self, this._then);

  final SessionsResponse _self;
  final $Res Function(SessionsResponse) _then;

/// Create a copy of SessionsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? agents = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,agents: null == agents ? _self.agents : agents // ignore: cast_nullable_to_non_nullable
as List<AgentSessions>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionsResponse].
extension SessionsResponsePatterns on SessionsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionsResponse value)  $default,){
final _that = this;
switch (_that) {
case _SessionsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SessionsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  List<AgentSessions> agents,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionsResponse() when $default != null:
return $default(_that.ok,_that.agents,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  List<AgentSessions> agents,  String? error)  $default,) {final _that = this;
switch (_that) {
case _SessionsResponse():
return $default(_that.ok,_that.agents,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  List<AgentSessions> agents,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _SessionsResponse() when $default != null:
return $default(_that.ok,_that.agents,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionsResponse implements SessionsResponse {
  const _SessionsResponse({required this.ok, final  List<AgentSessions> agents = const [], this.error}): _agents = agents;
  factory _SessionsResponse.fromJson(Map<String, dynamic> json) => _$SessionsResponseFromJson(json);

@override final  bool ok;
 final  List<AgentSessions> _agents;
@override@JsonKey() List<AgentSessions> get agents {
  if (_agents is EqualUnmodifiableListView) return _agents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_agents);
}

@override final  String? error;

/// Create a copy of SessionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionsResponseCopyWith<_SessionsResponse> get copyWith => __$SessionsResponseCopyWithImpl<_SessionsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionsResponse&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other._agents, _agents)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(_agents),error);

@override
String toString() {
  return 'SessionsResponse(ok: $ok, agents: $agents, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SessionsResponseCopyWith<$Res> implements $SessionsResponseCopyWith<$Res> {
  factory _$SessionsResponseCopyWith(_SessionsResponse value, $Res Function(_SessionsResponse) _then) = __$SessionsResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, List<AgentSessions> agents, String? error
});




}
/// @nodoc
class __$SessionsResponseCopyWithImpl<$Res>
    implements _$SessionsResponseCopyWith<$Res> {
  __$SessionsResponseCopyWithImpl(this._self, this._then);

  final _SessionsResponse _self;
  final $Res Function(_SessionsResponse) _then;

/// Create a copy of SessionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? agents = null,Object? error = freezed,}) {
  return _then(_SessionsResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,agents: null == agents ? _self._agents : agents // ignore: cast_nullable_to_non_nullable
as List<AgentSessions>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ResumeSessionRequest {

 String get path; String get agent; String get sessionId;/// Distinguishes the new multiplexer session from the project's primary
/// one, so resuming doesn't disturb whatever is already running there.
 String get suffix;
/// Create a copy of ResumeSessionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResumeSessionRequestCopyWith<ResumeSessionRequest> get copyWith => _$ResumeSessionRequestCopyWithImpl<ResumeSessionRequest>(this as ResumeSessionRequest, _$identity);

  /// Serializes this ResumeSessionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumeSessionRequest&&(identical(other.path, path) || other.path == path)&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.suffix, suffix) || other.suffix == suffix));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,agent,sessionId,suffix);

@override
String toString() {
  return 'ResumeSessionRequest(path: $path, agent: $agent, sessionId: $sessionId, suffix: $suffix)';
}


}

/// @nodoc
abstract mixin class $ResumeSessionRequestCopyWith<$Res>  {
  factory $ResumeSessionRequestCopyWith(ResumeSessionRequest value, $Res Function(ResumeSessionRequest) _then) = _$ResumeSessionRequestCopyWithImpl;
@useResult
$Res call({
 String path, String agent, String sessionId, String suffix
});




}
/// @nodoc
class _$ResumeSessionRequestCopyWithImpl<$Res>
    implements $ResumeSessionRequestCopyWith<$Res> {
  _$ResumeSessionRequestCopyWithImpl(this._self, this._then);

  final ResumeSessionRequest _self;
  final $Res Function(ResumeSessionRequest) _then;

/// Create a copy of ResumeSessionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? agent = null,Object? sessionId = null,Object? suffix = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,agent: null == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,suffix: null == suffix ? _self.suffix : suffix // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ResumeSessionRequest].
extension ResumeSessionRequestPatterns on ResumeSessionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResumeSessionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResumeSessionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResumeSessionRequest value)  $default,){
final _that = this;
switch (_that) {
case _ResumeSessionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResumeSessionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ResumeSessionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String agent,  String sessionId,  String suffix)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResumeSessionRequest() when $default != null:
return $default(_that.path,_that.agent,_that.sessionId,_that.suffix);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String agent,  String sessionId,  String suffix)  $default,) {final _that = this;
switch (_that) {
case _ResumeSessionRequest():
return $default(_that.path,_that.agent,_that.sessionId,_that.suffix);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String agent,  String sessionId,  String suffix)?  $default,) {final _that = this;
switch (_that) {
case _ResumeSessionRequest() when $default != null:
return $default(_that.path,_that.agent,_that.sessionId,_that.suffix);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResumeSessionRequest implements ResumeSessionRequest {
  const _ResumeSessionRequest({required this.path, required this.agent, required this.sessionId, required this.suffix});
  factory _ResumeSessionRequest.fromJson(Map<String, dynamic> json) => _$ResumeSessionRequestFromJson(json);

@override final  String path;
@override final  String agent;
@override final  String sessionId;
/// Distinguishes the new multiplexer session from the project's primary
/// one, so resuming doesn't disturb whatever is already running there.
@override final  String suffix;

/// Create a copy of ResumeSessionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResumeSessionRequestCopyWith<_ResumeSessionRequest> get copyWith => __$ResumeSessionRequestCopyWithImpl<_ResumeSessionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResumeSessionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResumeSessionRequest&&(identical(other.path, path) || other.path == path)&&(identical(other.agent, agent) || other.agent == agent)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.suffix, suffix) || other.suffix == suffix));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,agent,sessionId,suffix);

@override
String toString() {
  return 'ResumeSessionRequest(path: $path, agent: $agent, sessionId: $sessionId, suffix: $suffix)';
}


}

/// @nodoc
abstract mixin class _$ResumeSessionRequestCopyWith<$Res> implements $ResumeSessionRequestCopyWith<$Res> {
  factory _$ResumeSessionRequestCopyWith(_ResumeSessionRequest value, $Res Function(_ResumeSessionRequest) _then) = __$ResumeSessionRequestCopyWithImpl;
@override @useResult
$Res call({
 String path, String agent, String sessionId, String suffix
});




}
/// @nodoc
class __$ResumeSessionRequestCopyWithImpl<$Res>
    implements _$ResumeSessionRequestCopyWith<$Res> {
  __$ResumeSessionRequestCopyWithImpl(this._self, this._then);

  final _ResumeSessionRequest _self;
  final $Res Function(_ResumeSessionRequest) _then;

/// Create a copy of ResumeSessionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? agent = null,Object? sessionId = null,Object? suffix = null,}) {
  return _then(_ResumeSessionRequest(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,agent: null == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,suffix: null == suffix ? _self.suffix : suffix // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ResumeSessionResponse {

 bool get ok;/// Name of the multiplexer session now running the conversation.
 String? get session; String? get error;
/// Create a copy of ResumeSessionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResumeSessionResponseCopyWith<ResumeSessionResponse> get copyWith => _$ResumeSessionResponseCopyWithImpl<ResumeSessionResponse>(this as ResumeSessionResponse, _$identity);

  /// Serializes this ResumeSessionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumeSessionResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.session, session) || other.session == session)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,session,error);

@override
String toString() {
  return 'ResumeSessionResponse(ok: $ok, session: $session, error: $error)';
}


}

/// @nodoc
abstract mixin class $ResumeSessionResponseCopyWith<$Res>  {
  factory $ResumeSessionResponseCopyWith(ResumeSessionResponse value, $Res Function(ResumeSessionResponse) _then) = _$ResumeSessionResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, String? session, String? error
});




}
/// @nodoc
class _$ResumeSessionResponseCopyWithImpl<$Res>
    implements $ResumeSessionResponseCopyWith<$Res> {
  _$ResumeSessionResponseCopyWithImpl(this._self, this._then);

  final ResumeSessionResponse _self;
  final $Res Function(ResumeSessionResponse) _then;

/// Create a copy of ResumeSessionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? session = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResumeSessionResponse].
extension ResumeSessionResponsePatterns on ResumeSessionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResumeSessionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResumeSessionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResumeSessionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ResumeSessionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResumeSessionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ResumeSessionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String? session,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResumeSessionResponse() when $default != null:
return $default(_that.ok,_that.session,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String? session,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ResumeSessionResponse():
return $default(_that.ok,_that.session,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String? session,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ResumeSessionResponse() when $default != null:
return $default(_that.ok,_that.session,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResumeSessionResponse implements ResumeSessionResponse {
  const _ResumeSessionResponse({required this.ok, this.session, this.error});
  factory _ResumeSessionResponse.fromJson(Map<String, dynamic> json) => _$ResumeSessionResponseFromJson(json);

@override final  bool ok;
/// Name of the multiplexer session now running the conversation.
@override final  String? session;
@override final  String? error;

/// Create a copy of ResumeSessionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResumeSessionResponseCopyWith<_ResumeSessionResponse> get copyWith => __$ResumeSessionResponseCopyWithImpl<_ResumeSessionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResumeSessionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResumeSessionResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.session, session) || other.session == session)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,session,error);

@override
String toString() {
  return 'ResumeSessionResponse(ok: $ok, session: $session, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ResumeSessionResponseCopyWith<$Res> implements $ResumeSessionResponseCopyWith<$Res> {
  factory _$ResumeSessionResponseCopyWith(_ResumeSessionResponse value, $Res Function(_ResumeSessionResponse) _then) = __$ResumeSessionResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String? session, String? error
});




}
/// @nodoc
class __$ResumeSessionResponseCopyWithImpl<$Res>
    implements _$ResumeSessionResponseCopyWith<$Res> {
  __$ResumeSessionResponseCopyWithImpl(this._self, this._then);

  final _ResumeSessionResponse _self;
  final $Res Function(_ResumeSessionResponse) _then;

/// Create a copy of ResumeSessionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? session = freezed,Object? error = freezed,}) {
  return _then(_ResumeSessionResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
