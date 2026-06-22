// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendRequest {

 String get paneId; String get text; bool? get enter; String? get submitKey;// 'Enter' | 'Tab'
 bool? get vimMode;
/// Create a copy of SendRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendRequestCopyWith<SendRequest> get copyWith => _$SendRequestCopyWithImpl<SendRequest>(this as SendRequest, _$identity);

  /// Serializes this SendRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendRequest&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.text, text) || other.text == text)&&(identical(other.enter, enter) || other.enter == enter)&&(identical(other.submitKey, submitKey) || other.submitKey == submitKey)&&(identical(other.vimMode, vimMode) || other.vimMode == vimMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,paneId,text,enter,submitKey,vimMode);

@override
String toString() {
  return 'SendRequest(paneId: $paneId, text: $text, enter: $enter, submitKey: $submitKey, vimMode: $vimMode)';
}


}

/// @nodoc
abstract mixin class $SendRequestCopyWith<$Res>  {
  factory $SendRequestCopyWith(SendRequest value, $Res Function(SendRequest) _then) = _$SendRequestCopyWithImpl;
@useResult
$Res call({
 String paneId, String text, bool? enter, String? submitKey, bool? vimMode
});




}
/// @nodoc
class _$SendRequestCopyWithImpl<$Res>
    implements $SendRequestCopyWith<$Res> {
  _$SendRequestCopyWithImpl(this._self, this._then);

  final SendRequest _self;
  final $Res Function(SendRequest) _then;

/// Create a copy of SendRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paneId = null,Object? text = null,Object? enter = freezed,Object? submitKey = freezed,Object? vimMode = freezed,}) {
  return _then(_self.copyWith(
paneId: null == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,enter: freezed == enter ? _self.enter : enter // ignore: cast_nullable_to_non_nullable
as bool?,submitKey: freezed == submitKey ? _self.submitKey : submitKey // ignore: cast_nullable_to_non_nullable
as String?,vimMode: freezed == vimMode ? _self.vimMode : vimMode // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [SendRequest].
extension SendRequestPatterns on SendRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendRequest value)  $default,){
final _that = this;
switch (_that) {
case _SendRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SendRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String paneId,  String text,  bool? enter,  String? submitKey,  bool? vimMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendRequest() when $default != null:
return $default(_that.paneId,_that.text,_that.enter,_that.submitKey,_that.vimMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String paneId,  String text,  bool? enter,  String? submitKey,  bool? vimMode)  $default,) {final _that = this;
switch (_that) {
case _SendRequest():
return $default(_that.paneId,_that.text,_that.enter,_that.submitKey,_that.vimMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String paneId,  String text,  bool? enter,  String? submitKey,  bool? vimMode)?  $default,) {final _that = this;
switch (_that) {
case _SendRequest() when $default != null:
return $default(_that.paneId,_that.text,_that.enter,_that.submitKey,_that.vimMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendRequest implements SendRequest {
  const _SendRequest({required this.paneId, required this.text, this.enter, this.submitKey, this.vimMode});
  factory _SendRequest.fromJson(Map<String, dynamic> json) => _$SendRequestFromJson(json);

@override final  String paneId;
@override final  String text;
@override final  bool? enter;
@override final  String? submitKey;
// 'Enter' | 'Tab'
@override final  bool? vimMode;

/// Create a copy of SendRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendRequestCopyWith<_SendRequest> get copyWith => __$SendRequestCopyWithImpl<_SendRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendRequest&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.text, text) || other.text == text)&&(identical(other.enter, enter) || other.enter == enter)&&(identical(other.submitKey, submitKey) || other.submitKey == submitKey)&&(identical(other.vimMode, vimMode) || other.vimMode == vimMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,paneId,text,enter,submitKey,vimMode);

@override
String toString() {
  return 'SendRequest(paneId: $paneId, text: $text, enter: $enter, submitKey: $submitKey, vimMode: $vimMode)';
}


}

/// @nodoc
abstract mixin class _$SendRequestCopyWith<$Res> implements $SendRequestCopyWith<$Res> {
  factory _$SendRequestCopyWith(_SendRequest value, $Res Function(_SendRequest) _then) = __$SendRequestCopyWithImpl;
@override @useResult
$Res call({
 String paneId, String text, bool? enter, String? submitKey, bool? vimMode
});




}
/// @nodoc
class __$SendRequestCopyWithImpl<$Res>
    implements _$SendRequestCopyWith<$Res> {
  __$SendRequestCopyWithImpl(this._self, this._then);

  final _SendRequest _self;
  final $Res Function(_SendRequest) _then;

/// Create a copy of SendRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paneId = null,Object? text = null,Object? enter = freezed,Object? submitKey = freezed,Object? vimMode = freezed,}) {
  return _then(_SendRequest(
paneId: null == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,enter: freezed == enter ? _self.enter : enter // ignore: cast_nullable_to_non_nullable
as bool?,submitKey: freezed == submitKey ? _self.submitKey : submitKey // ignore: cast_nullable_to_non_nullable
as String?,vimMode: freezed == vimMode ? _self.vimMode : vimMode // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$PaneCommandResponse {

 bool get ok; String? get paneId; String? get tail; String? get capturedAt;
/// Create a copy of PaneCommandResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaneCommandResponseCopyWith<PaneCommandResponse> get copyWith => _$PaneCommandResponseCopyWithImpl<PaneCommandResponse>(this as PaneCommandResponse, _$identity);

  /// Serializes this PaneCommandResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaneCommandResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.tail, tail) || other.tail == tail)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,paneId,tail,capturedAt);

@override
String toString() {
  return 'PaneCommandResponse(ok: $ok, paneId: $paneId, tail: $tail, capturedAt: $capturedAt)';
}


}

/// @nodoc
abstract mixin class $PaneCommandResponseCopyWith<$Res>  {
  factory $PaneCommandResponseCopyWith(PaneCommandResponse value, $Res Function(PaneCommandResponse) _then) = _$PaneCommandResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, String? paneId, String? tail, String? capturedAt
});




}
/// @nodoc
class _$PaneCommandResponseCopyWithImpl<$Res>
    implements $PaneCommandResponseCopyWith<$Res> {
  _$PaneCommandResponseCopyWithImpl(this._self, this._then);

  final PaneCommandResponse _self;
  final $Res Function(PaneCommandResponse) _then;

/// Create a copy of PaneCommandResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? paneId = freezed,Object? tail = freezed,Object? capturedAt = freezed,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,paneId: freezed == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String?,tail: freezed == tail ? _self.tail : tail // ignore: cast_nullable_to_non_nullable
as String?,capturedAt: freezed == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaneCommandResponse].
extension PaneCommandResponsePatterns on PaneCommandResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaneCommandResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaneCommandResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaneCommandResponse value)  $default,){
final _that = this;
switch (_that) {
case _PaneCommandResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaneCommandResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PaneCommandResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String? paneId,  String? tail,  String? capturedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaneCommandResponse() when $default != null:
return $default(_that.ok,_that.paneId,_that.tail,_that.capturedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String? paneId,  String? tail,  String? capturedAt)  $default,) {final _that = this;
switch (_that) {
case _PaneCommandResponse():
return $default(_that.ok,_that.paneId,_that.tail,_that.capturedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String? paneId,  String? tail,  String? capturedAt)?  $default,) {final _that = this;
switch (_that) {
case _PaneCommandResponse() when $default != null:
return $default(_that.ok,_that.paneId,_that.tail,_that.capturedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaneCommandResponse implements PaneCommandResponse {
  const _PaneCommandResponse({required this.ok, this.paneId, this.tail, this.capturedAt});
  factory _PaneCommandResponse.fromJson(Map<String, dynamic> json) => _$PaneCommandResponseFromJson(json);

@override final  bool ok;
@override final  String? paneId;
@override final  String? tail;
@override final  String? capturedAt;

/// Create a copy of PaneCommandResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaneCommandResponseCopyWith<_PaneCommandResponse> get copyWith => __$PaneCommandResponseCopyWithImpl<_PaneCommandResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaneCommandResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaneCommandResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.tail, tail) || other.tail == tail)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,paneId,tail,capturedAt);

@override
String toString() {
  return 'PaneCommandResponse(ok: $ok, paneId: $paneId, tail: $tail, capturedAt: $capturedAt)';
}


}

/// @nodoc
abstract mixin class _$PaneCommandResponseCopyWith<$Res> implements $PaneCommandResponseCopyWith<$Res> {
  factory _$PaneCommandResponseCopyWith(_PaneCommandResponse value, $Res Function(_PaneCommandResponse) _then) = __$PaneCommandResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String? paneId, String? tail, String? capturedAt
});




}
/// @nodoc
class __$PaneCommandResponseCopyWithImpl<$Res>
    implements _$PaneCommandResponseCopyWith<$Res> {
  __$PaneCommandResponseCopyWithImpl(this._self, this._then);

  final _PaneCommandResponse _self;
  final $Res Function(_PaneCommandResponse) _then;

/// Create a copy of PaneCommandResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? paneId = freezed,Object? tail = freezed,Object? capturedAt = freezed,}) {
  return _then(_PaneCommandResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,paneId: freezed == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String?,tail: freezed == tail ? _self.tail : tail // ignore: cast_nullable_to_non_nullable
as String?,capturedAt: freezed == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RefineTextResponse {

 bool get ok; String? get text; bool? get changed; bool? get fallback; String? get error;
/// Create a copy of RefineTextResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefineTextResponseCopyWith<RefineTextResponse> get copyWith => _$RefineTextResponseCopyWithImpl<RefineTextResponse>(this as RefineTextResponse, _$identity);

  /// Serializes this RefineTextResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefineTextResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.text, text) || other.text == text)&&(identical(other.changed, changed) || other.changed == changed)&&(identical(other.fallback, fallback) || other.fallback == fallback)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,text,changed,fallback,error);

@override
String toString() {
  return 'RefineTextResponse(ok: $ok, text: $text, changed: $changed, fallback: $fallback, error: $error)';
}


}

/// @nodoc
abstract mixin class $RefineTextResponseCopyWith<$Res>  {
  factory $RefineTextResponseCopyWith(RefineTextResponse value, $Res Function(RefineTextResponse) _then) = _$RefineTextResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, String? text, bool? changed, bool? fallback, String? error
});




}
/// @nodoc
class _$RefineTextResponseCopyWithImpl<$Res>
    implements $RefineTextResponseCopyWith<$Res> {
  _$RefineTextResponseCopyWithImpl(this._self, this._then);

  final RefineTextResponse _self;
  final $Res Function(RefineTextResponse) _then;

/// Create a copy of RefineTextResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? text = freezed,Object? changed = freezed,Object? fallback = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,changed: freezed == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as bool?,fallback: freezed == fallback ? _self.fallback : fallback // ignore: cast_nullable_to_non_nullable
as bool?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RefineTextResponse].
extension RefineTextResponsePatterns on RefineTextResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RefineTextResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RefineTextResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RefineTextResponse value)  $default,){
final _that = this;
switch (_that) {
case _RefineTextResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RefineTextResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RefineTextResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String? text,  bool? changed,  bool? fallback,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RefineTextResponse() when $default != null:
return $default(_that.ok,_that.text,_that.changed,_that.fallback,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String? text,  bool? changed,  bool? fallback,  String? error)  $default,) {final _that = this;
switch (_that) {
case _RefineTextResponse():
return $default(_that.ok,_that.text,_that.changed,_that.fallback,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String? text,  bool? changed,  bool? fallback,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _RefineTextResponse() when $default != null:
return $default(_that.ok,_that.text,_that.changed,_that.fallback,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RefineTextResponse implements RefineTextResponse {
  const _RefineTextResponse({required this.ok, this.text, this.changed, this.fallback, this.error});
  factory _RefineTextResponse.fromJson(Map<String, dynamic> json) => _$RefineTextResponseFromJson(json);

@override final  bool ok;
@override final  String? text;
@override final  bool? changed;
@override final  bool? fallback;
@override final  String? error;

/// Create a copy of RefineTextResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefineTextResponseCopyWith<_RefineTextResponse> get copyWith => __$RefineTextResponseCopyWithImpl<_RefineTextResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefineTextResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefineTextResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.text, text) || other.text == text)&&(identical(other.changed, changed) || other.changed == changed)&&(identical(other.fallback, fallback) || other.fallback == fallback)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,text,changed,fallback,error);

@override
String toString() {
  return 'RefineTextResponse(ok: $ok, text: $text, changed: $changed, fallback: $fallback, error: $error)';
}


}

/// @nodoc
abstract mixin class _$RefineTextResponseCopyWith<$Res> implements $RefineTextResponseCopyWith<$Res> {
  factory _$RefineTextResponseCopyWith(_RefineTextResponse value, $Res Function(_RefineTextResponse) _then) = __$RefineTextResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String? text, bool? changed, bool? fallback, String? error
});




}
/// @nodoc
class __$RefineTextResponseCopyWithImpl<$Res>
    implements _$RefineTextResponseCopyWith<$Res> {
  __$RefineTextResponseCopyWithImpl(this._self, this._then);

  final _RefineTextResponse _self;
  final $Res Function(_RefineTextResponse) _then;

/// Create a copy of RefineTextResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? text = freezed,Object? changed = freezed,Object? fallback = freezed,Object? error = freezed,}) {
  return _then(_RefineTextResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,changed: freezed == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as bool?,fallback: freezed == fallback ? _self.fallback : fallback // ignore: cast_nullable_to_non_nullable
as bool?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UploadedImageResponse {

 bool get ok; String? get path; int? get size; String? get contentType;
/// Create a copy of UploadedImageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadedImageResponseCopyWith<UploadedImageResponse> get copyWith => _$UploadedImageResponseCopyWithImpl<UploadedImageResponse>(this as UploadedImageResponse, _$identity);

  /// Serializes this UploadedImageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadedImageResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.path, path) || other.path == path)&&(identical(other.size, size) || other.size == size)&&(identical(other.contentType, contentType) || other.contentType == contentType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,path,size,contentType);

@override
String toString() {
  return 'UploadedImageResponse(ok: $ok, path: $path, size: $size, contentType: $contentType)';
}


}

/// @nodoc
abstract mixin class $UploadedImageResponseCopyWith<$Res>  {
  factory $UploadedImageResponseCopyWith(UploadedImageResponse value, $Res Function(UploadedImageResponse) _then) = _$UploadedImageResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, String? path, int? size, String? contentType
});




}
/// @nodoc
class _$UploadedImageResponseCopyWithImpl<$Res>
    implements $UploadedImageResponseCopyWith<$Res> {
  _$UploadedImageResponseCopyWithImpl(this._self, this._then);

  final UploadedImageResponse _self;
  final $Res Function(UploadedImageResponse) _then;

/// Create a copy of UploadedImageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? path = freezed,Object? size = freezed,Object? contentType = freezed,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadedImageResponse].
extension UploadedImageResponsePatterns on UploadedImageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadedImageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadedImageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadedImageResponse value)  $default,){
final _that = this;
switch (_that) {
case _UploadedImageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadedImageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UploadedImageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String? path,  int? size,  String? contentType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadedImageResponse() when $default != null:
return $default(_that.ok,_that.path,_that.size,_that.contentType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String? path,  int? size,  String? contentType)  $default,) {final _that = this;
switch (_that) {
case _UploadedImageResponse():
return $default(_that.ok,_that.path,_that.size,_that.contentType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String? path,  int? size,  String? contentType)?  $default,) {final _that = this;
switch (_that) {
case _UploadedImageResponse() when $default != null:
return $default(_that.ok,_that.path,_that.size,_that.contentType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UploadedImageResponse implements UploadedImageResponse {
  const _UploadedImageResponse({required this.ok, this.path, this.size, this.contentType});
  factory _UploadedImageResponse.fromJson(Map<String, dynamic> json) => _$UploadedImageResponseFromJson(json);

@override final  bool ok;
@override final  String? path;
@override final  int? size;
@override final  String? contentType;

/// Create a copy of UploadedImageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadedImageResponseCopyWith<_UploadedImageResponse> get copyWith => __$UploadedImageResponseCopyWithImpl<_UploadedImageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadedImageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadedImageResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.path, path) || other.path == path)&&(identical(other.size, size) || other.size == size)&&(identical(other.contentType, contentType) || other.contentType == contentType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,path,size,contentType);

@override
String toString() {
  return 'UploadedImageResponse(ok: $ok, path: $path, size: $size, contentType: $contentType)';
}


}

/// @nodoc
abstract mixin class _$UploadedImageResponseCopyWith<$Res> implements $UploadedImageResponseCopyWith<$Res> {
  factory _$UploadedImageResponseCopyWith(_UploadedImageResponse value, $Res Function(_UploadedImageResponse) _then) = __$UploadedImageResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String? path, int? size, String? contentType
});




}
/// @nodoc
class __$UploadedImageResponseCopyWithImpl<$Res>
    implements _$UploadedImageResponseCopyWith<$Res> {
  __$UploadedImageResponseCopyWithImpl(this._self, this._then);

  final _UploadedImageResponse _self;
  final $Res Function(_UploadedImageResponse) _then;

/// Create a copy of UploadedImageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? path = freezed,Object? size = freezed,Object? contentType = freezed,}) {
  return _then(_UploadedImageResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PaneContextResponse {

 bool get ok; String? get paneId; int? get lines; String? get tail; String? get capturedAt;
/// Create a copy of PaneContextResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaneContextResponseCopyWith<PaneContextResponse> get copyWith => _$PaneContextResponseCopyWithImpl<PaneContextResponse>(this as PaneContextResponse, _$identity);

  /// Serializes this PaneContextResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaneContextResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.lines, lines) || other.lines == lines)&&(identical(other.tail, tail) || other.tail == tail)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,paneId,lines,tail,capturedAt);

@override
String toString() {
  return 'PaneContextResponse(ok: $ok, paneId: $paneId, lines: $lines, tail: $tail, capturedAt: $capturedAt)';
}


}

/// @nodoc
abstract mixin class $PaneContextResponseCopyWith<$Res>  {
  factory $PaneContextResponseCopyWith(PaneContextResponse value, $Res Function(PaneContextResponse) _then) = _$PaneContextResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, String? paneId, int? lines, String? tail, String? capturedAt
});




}
/// @nodoc
class _$PaneContextResponseCopyWithImpl<$Res>
    implements $PaneContextResponseCopyWith<$Res> {
  _$PaneContextResponseCopyWithImpl(this._self, this._then);

  final PaneContextResponse _self;
  final $Res Function(PaneContextResponse) _then;

/// Create a copy of PaneContextResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? paneId = freezed,Object? lines = freezed,Object? tail = freezed,Object? capturedAt = freezed,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,paneId: freezed == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String?,lines: freezed == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as int?,tail: freezed == tail ? _self.tail : tail // ignore: cast_nullable_to_non_nullable
as String?,capturedAt: freezed == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaneContextResponse].
extension PaneContextResponsePatterns on PaneContextResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaneContextResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaneContextResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaneContextResponse value)  $default,){
final _that = this;
switch (_that) {
case _PaneContextResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaneContextResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PaneContextResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String? paneId,  int? lines,  String? tail,  String? capturedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaneContextResponse() when $default != null:
return $default(_that.ok,_that.paneId,_that.lines,_that.tail,_that.capturedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String? paneId,  int? lines,  String? tail,  String? capturedAt)  $default,) {final _that = this;
switch (_that) {
case _PaneContextResponse():
return $default(_that.ok,_that.paneId,_that.lines,_that.tail,_that.capturedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String? paneId,  int? lines,  String? tail,  String? capturedAt)?  $default,) {final _that = this;
switch (_that) {
case _PaneContextResponse() when $default != null:
return $default(_that.ok,_that.paneId,_that.lines,_that.tail,_that.capturedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaneContextResponse implements PaneContextResponse {
  const _PaneContextResponse({required this.ok, this.paneId, this.lines, this.tail, this.capturedAt});
  factory _PaneContextResponse.fromJson(Map<String, dynamic> json) => _$PaneContextResponseFromJson(json);

@override final  bool ok;
@override final  String? paneId;
@override final  int? lines;
@override final  String? tail;
@override final  String? capturedAt;

/// Create a copy of PaneContextResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaneContextResponseCopyWith<_PaneContextResponse> get copyWith => __$PaneContextResponseCopyWithImpl<_PaneContextResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaneContextResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaneContextResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.lines, lines) || other.lines == lines)&&(identical(other.tail, tail) || other.tail == tail)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,paneId,lines,tail,capturedAt);

@override
String toString() {
  return 'PaneContextResponse(ok: $ok, paneId: $paneId, lines: $lines, tail: $tail, capturedAt: $capturedAt)';
}


}

/// @nodoc
abstract mixin class _$PaneContextResponseCopyWith<$Res> implements $PaneContextResponseCopyWith<$Res> {
  factory _$PaneContextResponseCopyWith(_PaneContextResponse value, $Res Function(_PaneContextResponse) _then) = __$PaneContextResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String? paneId, int? lines, String? tail, String? capturedAt
});




}
/// @nodoc
class __$PaneContextResponseCopyWithImpl<$Res>
    implements _$PaneContextResponseCopyWith<$Res> {
  __$PaneContextResponseCopyWithImpl(this._self, this._then);

  final _PaneContextResponse _self;
  final $Res Function(_PaneContextResponse) _then;

/// Create a copy of PaneContextResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? paneId = freezed,Object? lines = freezed,Object? tail = freezed,Object? capturedAt = freezed,}) {
  return _then(_PaneContextResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,paneId: freezed == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String?,lines: freezed == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as int?,tail: freezed == tail ? _self.tail : tail // ignore: cast_nullable_to_non_nullable
as String?,capturedAt: freezed == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$KillSessionRequest {

 String? get paneId; String? get session;
/// Create a copy of KillSessionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KillSessionRequestCopyWith<KillSessionRequest> get copyWith => _$KillSessionRequestCopyWithImpl<KillSessionRequest>(this as KillSessionRequest, _$identity);

  /// Serializes this KillSessionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KillSessionRequest&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.session, session) || other.session == session));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,paneId,session);

@override
String toString() {
  return 'KillSessionRequest(paneId: $paneId, session: $session)';
}


}

/// @nodoc
abstract mixin class $KillSessionRequestCopyWith<$Res>  {
  factory $KillSessionRequestCopyWith(KillSessionRequest value, $Res Function(KillSessionRequest) _then) = _$KillSessionRequestCopyWithImpl;
@useResult
$Res call({
 String? paneId, String? session
});




}
/// @nodoc
class _$KillSessionRequestCopyWithImpl<$Res>
    implements $KillSessionRequestCopyWith<$Res> {
  _$KillSessionRequestCopyWithImpl(this._self, this._then);

  final KillSessionRequest _self;
  final $Res Function(KillSessionRequest) _then;

/// Create a copy of KillSessionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paneId = freezed,Object? session = freezed,}) {
  return _then(_self.copyWith(
paneId: freezed == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String?,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KillSessionRequest].
extension KillSessionRequestPatterns on KillSessionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KillSessionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KillSessionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KillSessionRequest value)  $default,){
final _that = this;
switch (_that) {
case _KillSessionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KillSessionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _KillSessionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? paneId,  String? session)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KillSessionRequest() when $default != null:
return $default(_that.paneId,_that.session);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? paneId,  String? session)  $default,) {final _that = this;
switch (_that) {
case _KillSessionRequest():
return $default(_that.paneId,_that.session);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? paneId,  String? session)?  $default,) {final _that = this;
switch (_that) {
case _KillSessionRequest() when $default != null:
return $default(_that.paneId,_that.session);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KillSessionRequest implements KillSessionRequest {
  const _KillSessionRequest({this.paneId, this.session});
  factory _KillSessionRequest.fromJson(Map<String, dynamic> json) => _$KillSessionRequestFromJson(json);

@override final  String? paneId;
@override final  String? session;

/// Create a copy of KillSessionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KillSessionRequestCopyWith<_KillSessionRequest> get copyWith => __$KillSessionRequestCopyWithImpl<_KillSessionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KillSessionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KillSessionRequest&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.session, session) || other.session == session));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,paneId,session);

@override
String toString() {
  return 'KillSessionRequest(paneId: $paneId, session: $session)';
}


}

/// @nodoc
abstract mixin class _$KillSessionRequestCopyWith<$Res> implements $KillSessionRequestCopyWith<$Res> {
  factory _$KillSessionRequestCopyWith(_KillSessionRequest value, $Res Function(_KillSessionRequest) _then) = __$KillSessionRequestCopyWithImpl;
@override @useResult
$Res call({
 String? paneId, String? session
});




}
/// @nodoc
class __$KillSessionRequestCopyWithImpl<$Res>
    implements _$KillSessionRequestCopyWith<$Res> {
  __$KillSessionRequestCopyWithImpl(this._self, this._then);

  final _KillSessionRequest _self;
  final $Res Function(_KillSessionRequest) _then;

/// Create a copy of KillSessionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paneId = freezed,Object? session = freezed,}) {
  return _then(_KillSessionRequest(
paneId: freezed == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String?,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LaunchProjectRequest {

 String get path; String get agent;
/// Create a copy of LaunchProjectRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LaunchProjectRequestCopyWith<LaunchProjectRequest> get copyWith => _$LaunchProjectRequestCopyWithImpl<LaunchProjectRequest>(this as LaunchProjectRequest, _$identity);

  /// Serializes this LaunchProjectRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LaunchProjectRequest&&(identical(other.path, path) || other.path == path)&&(identical(other.agent, agent) || other.agent == agent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,agent);

@override
String toString() {
  return 'LaunchProjectRequest(path: $path, agent: $agent)';
}


}

/// @nodoc
abstract mixin class $LaunchProjectRequestCopyWith<$Res>  {
  factory $LaunchProjectRequestCopyWith(LaunchProjectRequest value, $Res Function(LaunchProjectRequest) _then) = _$LaunchProjectRequestCopyWithImpl;
@useResult
$Res call({
 String path, String agent
});




}
/// @nodoc
class _$LaunchProjectRequestCopyWithImpl<$Res>
    implements $LaunchProjectRequestCopyWith<$Res> {
  _$LaunchProjectRequestCopyWithImpl(this._self, this._then);

  final LaunchProjectRequest _self;
  final $Res Function(LaunchProjectRequest) _then;

/// Create a copy of LaunchProjectRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? agent = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,agent: null == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LaunchProjectRequest].
extension LaunchProjectRequestPatterns on LaunchProjectRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LaunchProjectRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LaunchProjectRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LaunchProjectRequest value)  $default,){
final _that = this;
switch (_that) {
case _LaunchProjectRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LaunchProjectRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LaunchProjectRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String agent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LaunchProjectRequest() when $default != null:
return $default(_that.path,_that.agent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String agent)  $default,) {final _that = this;
switch (_that) {
case _LaunchProjectRequest():
return $default(_that.path,_that.agent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String agent)?  $default,) {final _that = this;
switch (_that) {
case _LaunchProjectRequest() when $default != null:
return $default(_that.path,_that.agent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LaunchProjectRequest implements LaunchProjectRequest {
  const _LaunchProjectRequest({required this.path, required this.agent});
  factory _LaunchProjectRequest.fromJson(Map<String, dynamic> json) => _$LaunchProjectRequestFromJson(json);

@override final  String path;
@override final  String agent;

/// Create a copy of LaunchProjectRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LaunchProjectRequestCopyWith<_LaunchProjectRequest> get copyWith => __$LaunchProjectRequestCopyWithImpl<_LaunchProjectRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LaunchProjectRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LaunchProjectRequest&&(identical(other.path, path) || other.path == path)&&(identical(other.agent, agent) || other.agent == agent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,agent);

@override
String toString() {
  return 'LaunchProjectRequest(path: $path, agent: $agent)';
}


}

/// @nodoc
abstract mixin class _$LaunchProjectRequestCopyWith<$Res> implements $LaunchProjectRequestCopyWith<$Res> {
  factory _$LaunchProjectRequestCopyWith(_LaunchProjectRequest value, $Res Function(_LaunchProjectRequest) _then) = __$LaunchProjectRequestCopyWithImpl;
@override @useResult
$Res call({
 String path, String agent
});




}
/// @nodoc
class __$LaunchProjectRequestCopyWithImpl<$Res>
    implements _$LaunchProjectRequestCopyWith<$Res> {
  __$LaunchProjectRequestCopyWithImpl(this._self, this._then);

  final _LaunchProjectRequest _self;
  final $Res Function(_LaunchProjectRequest) _then;

/// Create a copy of LaunchProjectRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? agent = null,}) {
  return _then(_LaunchProjectRequest(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,agent: null == agent ? _self.agent : agent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CcSwitchSwitchRequest {

 String get appType; String get providerId;
/// Create a copy of CcSwitchSwitchRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CcSwitchSwitchRequestCopyWith<CcSwitchSwitchRequest> get copyWith => _$CcSwitchSwitchRequestCopyWithImpl<CcSwitchSwitchRequest>(this as CcSwitchSwitchRequest, _$identity);

  /// Serializes this CcSwitchSwitchRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CcSwitchSwitchRequest&&(identical(other.appType, appType) || other.appType == appType)&&(identical(other.providerId, providerId) || other.providerId == providerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appType,providerId);

@override
String toString() {
  return 'CcSwitchSwitchRequest(appType: $appType, providerId: $providerId)';
}


}

/// @nodoc
abstract mixin class $CcSwitchSwitchRequestCopyWith<$Res>  {
  factory $CcSwitchSwitchRequestCopyWith(CcSwitchSwitchRequest value, $Res Function(CcSwitchSwitchRequest) _then) = _$CcSwitchSwitchRequestCopyWithImpl;
@useResult
$Res call({
 String appType, String providerId
});




}
/// @nodoc
class _$CcSwitchSwitchRequestCopyWithImpl<$Res>
    implements $CcSwitchSwitchRequestCopyWith<$Res> {
  _$CcSwitchSwitchRequestCopyWithImpl(this._self, this._then);

  final CcSwitchSwitchRequest _self;
  final $Res Function(CcSwitchSwitchRequest) _then;

/// Create a copy of CcSwitchSwitchRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appType = null,Object? providerId = null,}) {
  return _then(_self.copyWith(
appType: null == appType ? _self.appType : appType // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CcSwitchSwitchRequest].
extension CcSwitchSwitchRequestPatterns on CcSwitchSwitchRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CcSwitchSwitchRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CcSwitchSwitchRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CcSwitchSwitchRequest value)  $default,){
final _that = this;
switch (_that) {
case _CcSwitchSwitchRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CcSwitchSwitchRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CcSwitchSwitchRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appType,  String providerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CcSwitchSwitchRequest() when $default != null:
return $default(_that.appType,_that.providerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appType,  String providerId)  $default,) {final _that = this;
switch (_that) {
case _CcSwitchSwitchRequest():
return $default(_that.appType,_that.providerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appType,  String providerId)?  $default,) {final _that = this;
switch (_that) {
case _CcSwitchSwitchRequest() when $default != null:
return $default(_that.appType,_that.providerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CcSwitchSwitchRequest implements CcSwitchSwitchRequest {
  const _CcSwitchSwitchRequest({required this.appType, required this.providerId});
  factory _CcSwitchSwitchRequest.fromJson(Map<String, dynamic> json) => _$CcSwitchSwitchRequestFromJson(json);

@override final  String appType;
@override final  String providerId;

/// Create a copy of CcSwitchSwitchRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CcSwitchSwitchRequestCopyWith<_CcSwitchSwitchRequest> get copyWith => __$CcSwitchSwitchRequestCopyWithImpl<_CcSwitchSwitchRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CcSwitchSwitchRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CcSwitchSwitchRequest&&(identical(other.appType, appType) || other.appType == appType)&&(identical(other.providerId, providerId) || other.providerId == providerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appType,providerId);

@override
String toString() {
  return 'CcSwitchSwitchRequest(appType: $appType, providerId: $providerId)';
}


}

/// @nodoc
abstract mixin class _$CcSwitchSwitchRequestCopyWith<$Res> implements $CcSwitchSwitchRequestCopyWith<$Res> {
  factory _$CcSwitchSwitchRequestCopyWith(_CcSwitchSwitchRequest value, $Res Function(_CcSwitchSwitchRequest) _then) = __$CcSwitchSwitchRequestCopyWithImpl;
@override @useResult
$Res call({
 String appType, String providerId
});




}
/// @nodoc
class __$CcSwitchSwitchRequestCopyWithImpl<$Res>
    implements _$CcSwitchSwitchRequestCopyWith<$Res> {
  __$CcSwitchSwitchRequestCopyWithImpl(this._self, this._then);

  final _CcSwitchSwitchRequest _self;
  final $Res Function(_CcSwitchSwitchRequest) _then;

/// Create a copy of CcSwitchSwitchRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appType = null,Object? providerId = null,}) {
  return _then(_CcSwitchSwitchRequest(
appType: null == appType ? _self.appType : appType // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
