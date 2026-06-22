// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InteractionAction {

 String get label; String get payload; InteractionActionStyle? get style;
/// Create a copy of InteractionAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InteractionActionCopyWith<InteractionAction> get copyWith => _$InteractionActionCopyWithImpl<InteractionAction>(this as InteractionAction, _$identity);

  /// Serializes this InteractionAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InteractionAction&&(identical(other.label, label) || other.label == label)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,payload,style);

@override
String toString() {
  return 'InteractionAction(label: $label, payload: $payload, style: $style)';
}


}

/// @nodoc
abstract mixin class $InteractionActionCopyWith<$Res>  {
  factory $InteractionActionCopyWith(InteractionAction value, $Res Function(InteractionAction) _then) = _$InteractionActionCopyWithImpl;
@useResult
$Res call({
 String label, String payload, InteractionActionStyle? style
});




}
/// @nodoc
class _$InteractionActionCopyWithImpl<$Res>
    implements $InteractionActionCopyWith<$Res> {
  _$InteractionActionCopyWithImpl(this._self, this._then);

  final InteractionAction _self;
  final $Res Function(InteractionAction) _then;

/// Create a copy of InteractionAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? payload = null,Object? style = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,style: freezed == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as InteractionActionStyle?,
  ));
}

}


/// Adds pattern-matching-related methods to [InteractionAction].
extension InteractionActionPatterns on InteractionAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InteractionAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InteractionAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InteractionAction value)  $default,){
final _that = this;
switch (_that) {
case _InteractionAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InteractionAction value)?  $default,){
final _that = this;
switch (_that) {
case _InteractionAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String payload,  InteractionActionStyle? style)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InteractionAction() when $default != null:
return $default(_that.label,_that.payload,_that.style);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String payload,  InteractionActionStyle? style)  $default,) {final _that = this;
switch (_that) {
case _InteractionAction():
return $default(_that.label,_that.payload,_that.style);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String payload,  InteractionActionStyle? style)?  $default,) {final _that = this;
switch (_that) {
case _InteractionAction() when $default != null:
return $default(_that.label,_that.payload,_that.style);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InteractionAction implements InteractionAction {
  const _InteractionAction({required this.label, required this.payload, this.style});
  factory _InteractionAction.fromJson(Map<String, dynamic> json) => _$InteractionActionFromJson(json);

@override final  String label;
@override final  String payload;
@override final  InteractionActionStyle? style;

/// Create a copy of InteractionAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InteractionActionCopyWith<_InteractionAction> get copyWith => __$InteractionActionCopyWithImpl<_InteractionAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InteractionActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InteractionAction&&(identical(other.label, label) || other.label == label)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,payload,style);

@override
String toString() {
  return 'InteractionAction(label: $label, payload: $payload, style: $style)';
}


}

/// @nodoc
abstract mixin class _$InteractionActionCopyWith<$Res> implements $InteractionActionCopyWith<$Res> {
  factory _$InteractionActionCopyWith(_InteractionAction value, $Res Function(_InteractionAction) _then) = __$InteractionActionCopyWithImpl;
@override @useResult
$Res call({
 String label, String payload, InteractionActionStyle? style
});




}
/// @nodoc
class __$InteractionActionCopyWithImpl<$Res>
    implements _$InteractionActionCopyWith<$Res> {
  __$InteractionActionCopyWithImpl(this._self, this._then);

  final _InteractionAction _self;
  final $Res Function(_InteractionAction) _then;

/// Create a copy of InteractionAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? payload = null,Object? style = freezed,}) {
  return _then(_InteractionAction(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,style: freezed == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as InteractionActionStyle?,
  ));
}


}


/// @nodoc
mixin _$InteractionSource {

 String get type; String get excerpt;
/// Create a copy of InteractionSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InteractionSourceCopyWith<InteractionSource> get copyWith => _$InteractionSourceCopyWithImpl<InteractionSource>(this as InteractionSource, _$identity);

  /// Serializes this InteractionSource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InteractionSource&&(identical(other.type, type) || other.type == type)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,excerpt);

@override
String toString() {
  return 'InteractionSource(type: $type, excerpt: $excerpt)';
}


}

/// @nodoc
abstract mixin class $InteractionSourceCopyWith<$Res>  {
  factory $InteractionSourceCopyWith(InteractionSource value, $Res Function(InteractionSource) _then) = _$InteractionSourceCopyWithImpl;
@useResult
$Res call({
 String type, String excerpt
});




}
/// @nodoc
class _$InteractionSourceCopyWithImpl<$Res>
    implements $InteractionSourceCopyWith<$Res> {
  _$InteractionSourceCopyWithImpl(this._self, this._then);

  final InteractionSource _self;
  final $Res Function(InteractionSource) _then;

/// Create a copy of InteractionSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? excerpt = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,excerpt: null == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InteractionSource].
extension InteractionSourcePatterns on InteractionSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InteractionSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InteractionSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InteractionSource value)  $default,){
final _that = this;
switch (_that) {
case _InteractionSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InteractionSource value)?  $default,){
final _that = this;
switch (_that) {
case _InteractionSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String excerpt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InteractionSource() when $default != null:
return $default(_that.type,_that.excerpt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String excerpt)  $default,) {final _that = this;
switch (_that) {
case _InteractionSource():
return $default(_that.type,_that.excerpt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String excerpt)?  $default,) {final _that = this;
switch (_that) {
case _InteractionSource() when $default != null:
return $default(_that.type,_that.excerpt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InteractionSource implements InteractionSource {
  const _InteractionSource({required this.type, required this.excerpt});
  factory _InteractionSource.fromJson(Map<String, dynamic> json) => _$InteractionSourceFromJson(json);

@override final  String type;
@override final  String excerpt;

/// Create a copy of InteractionSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InteractionSourceCopyWith<_InteractionSource> get copyWith => __$InteractionSourceCopyWithImpl<_InteractionSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InteractionSourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InteractionSource&&(identical(other.type, type) || other.type == type)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,excerpt);

@override
String toString() {
  return 'InteractionSource(type: $type, excerpt: $excerpt)';
}


}

/// @nodoc
abstract mixin class _$InteractionSourceCopyWith<$Res> implements $InteractionSourceCopyWith<$Res> {
  factory _$InteractionSourceCopyWith(_InteractionSource value, $Res Function(_InteractionSource) _then) = __$InteractionSourceCopyWithImpl;
@override @useResult
$Res call({
 String type, String excerpt
});




}
/// @nodoc
class __$InteractionSourceCopyWithImpl<$Res>
    implements _$InteractionSourceCopyWith<$Res> {
  __$InteractionSourceCopyWithImpl(this._self, this._then);

  final _InteractionSource _self;
  final $Res Function(_InteractionSource) _then;

/// Create a copy of InteractionSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? excerpt = null,}) {
  return _then(_InteractionSource(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,excerpt: null == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$InteractionMessage {

 String get id; String get paneId; InteractionRole get role; InteractionKind get kind; InteractionPriority get priority; String get title; String get body; List<InteractionAction> get actions; InteractionSource? get source; String get createdAt;
/// Create a copy of InteractionMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InteractionMessageCopyWith<InteractionMessage> get copyWith => _$InteractionMessageCopyWithImpl<InteractionMessage>(this as InteractionMessage, _$identity);

  /// Serializes this InteractionMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InteractionMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.role, role) || other.role == role)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.actions, actions)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,paneId,role,kind,priority,title,body,const DeepCollectionEquality().hash(actions),source,createdAt);

@override
String toString() {
  return 'InteractionMessage(id: $id, paneId: $paneId, role: $role, kind: $kind, priority: $priority, title: $title, body: $body, actions: $actions, source: $source, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $InteractionMessageCopyWith<$Res>  {
  factory $InteractionMessageCopyWith(InteractionMessage value, $Res Function(InteractionMessage) _then) = _$InteractionMessageCopyWithImpl;
@useResult
$Res call({
 String id, String paneId, InteractionRole role, InteractionKind kind, InteractionPriority priority, String title, String body, List<InteractionAction> actions, InteractionSource? source, String createdAt
});


$InteractionSourceCopyWith<$Res>? get source;

}
/// @nodoc
class _$InteractionMessageCopyWithImpl<$Res>
    implements $InteractionMessageCopyWith<$Res> {
  _$InteractionMessageCopyWithImpl(this._self, this._then);

  final InteractionMessage _self;
  final $Res Function(InteractionMessage) _then;

/// Create a copy of InteractionMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? paneId = null,Object? role = null,Object? kind = null,Object? priority = null,Object? title = null,Object? body = null,Object? actions = null,Object? source = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,paneId: null == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as InteractionRole,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as InteractionKind,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as InteractionPriority,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<InteractionAction>,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as InteractionSource?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of InteractionMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InteractionSourceCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $InteractionSourceCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}


/// Adds pattern-matching-related methods to [InteractionMessage].
extension InteractionMessagePatterns on InteractionMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InteractionMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InteractionMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InteractionMessage value)  $default,){
final _that = this;
switch (_that) {
case _InteractionMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InteractionMessage value)?  $default,){
final _that = this;
switch (_that) {
case _InteractionMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String paneId,  InteractionRole role,  InteractionKind kind,  InteractionPriority priority,  String title,  String body,  List<InteractionAction> actions,  InteractionSource? source,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InteractionMessage() when $default != null:
return $default(_that.id,_that.paneId,_that.role,_that.kind,_that.priority,_that.title,_that.body,_that.actions,_that.source,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String paneId,  InteractionRole role,  InteractionKind kind,  InteractionPriority priority,  String title,  String body,  List<InteractionAction> actions,  InteractionSource? source,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _InteractionMessage():
return $default(_that.id,_that.paneId,_that.role,_that.kind,_that.priority,_that.title,_that.body,_that.actions,_that.source,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String paneId,  InteractionRole role,  InteractionKind kind,  InteractionPriority priority,  String title,  String body,  List<InteractionAction> actions,  InteractionSource? source,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _InteractionMessage() when $default != null:
return $default(_that.id,_that.paneId,_that.role,_that.kind,_that.priority,_that.title,_that.body,_that.actions,_that.source,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InteractionMessage implements InteractionMessage {
  const _InteractionMessage({required this.id, required this.paneId, required this.role, required this.kind, required this.priority, required this.title, required this.body, final  List<InteractionAction> actions = const [], this.source, required this.createdAt}): _actions = actions;
  factory _InteractionMessage.fromJson(Map<String, dynamic> json) => _$InteractionMessageFromJson(json);

@override final  String id;
@override final  String paneId;
@override final  InteractionRole role;
@override final  InteractionKind kind;
@override final  InteractionPriority priority;
@override final  String title;
@override final  String body;
 final  List<InteractionAction> _actions;
@override@JsonKey() List<InteractionAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}

@override final  InteractionSource? source;
@override final  String createdAt;

/// Create a copy of InteractionMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InteractionMessageCopyWith<_InteractionMessage> get copyWith => __$InteractionMessageCopyWithImpl<_InteractionMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InteractionMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InteractionMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.paneId, paneId) || other.paneId == paneId)&&(identical(other.role, role) || other.role == role)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._actions, _actions)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,paneId,role,kind,priority,title,body,const DeepCollectionEquality().hash(_actions),source,createdAt);

@override
String toString() {
  return 'InteractionMessage(id: $id, paneId: $paneId, role: $role, kind: $kind, priority: $priority, title: $title, body: $body, actions: $actions, source: $source, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$InteractionMessageCopyWith<$Res> implements $InteractionMessageCopyWith<$Res> {
  factory _$InteractionMessageCopyWith(_InteractionMessage value, $Res Function(_InteractionMessage) _then) = __$InteractionMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String paneId, InteractionRole role, InteractionKind kind, InteractionPriority priority, String title, String body, List<InteractionAction> actions, InteractionSource? source, String createdAt
});


@override $InteractionSourceCopyWith<$Res>? get source;

}
/// @nodoc
class __$InteractionMessageCopyWithImpl<$Res>
    implements _$InteractionMessageCopyWith<$Res> {
  __$InteractionMessageCopyWithImpl(this._self, this._then);

  final _InteractionMessage _self;
  final $Res Function(_InteractionMessage) _then;

/// Create a copy of InteractionMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? paneId = null,Object? role = null,Object? kind = null,Object? priority = null,Object? title = null,Object? body = null,Object? actions = null,Object? source = freezed,Object? createdAt = null,}) {
  return _then(_InteractionMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,paneId: null == paneId ? _self.paneId : paneId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as InteractionRole,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as InteractionKind,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as InteractionPriority,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<InteractionAction>,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as InteractionSource?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of InteractionMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InteractionSourceCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $InteractionSourceCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}

// dart format on
