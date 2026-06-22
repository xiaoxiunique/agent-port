// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cc_switch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CcSwitchProvider {

 String get id; String get appType; String get name; bool get isCurrent; String? get baseUrl; bool get hasApiKey;
/// Create a copy of CcSwitchProvider
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CcSwitchProviderCopyWith<CcSwitchProvider> get copyWith => _$CcSwitchProviderCopyWithImpl<CcSwitchProvider>(this as CcSwitchProvider, _$identity);

  /// Serializes this CcSwitchProvider to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CcSwitchProvider&&(identical(other.id, id) || other.id == id)&&(identical(other.appType, appType) || other.appType == appType)&&(identical(other.name, name) || other.name == name)&&(identical(other.isCurrent, isCurrent) || other.isCurrent == isCurrent)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.hasApiKey, hasApiKey) || other.hasApiKey == hasApiKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,appType,name,isCurrent,baseUrl,hasApiKey);

@override
String toString() {
  return 'CcSwitchProvider(id: $id, appType: $appType, name: $name, isCurrent: $isCurrent, baseUrl: $baseUrl, hasApiKey: $hasApiKey)';
}


}

/// @nodoc
abstract mixin class $CcSwitchProviderCopyWith<$Res>  {
  factory $CcSwitchProviderCopyWith(CcSwitchProvider value, $Res Function(CcSwitchProvider) _then) = _$CcSwitchProviderCopyWithImpl;
@useResult
$Res call({
 String id, String appType, String name, bool isCurrent, String? baseUrl, bool hasApiKey
});




}
/// @nodoc
class _$CcSwitchProviderCopyWithImpl<$Res>
    implements $CcSwitchProviderCopyWith<$Res> {
  _$CcSwitchProviderCopyWithImpl(this._self, this._then);

  final CcSwitchProvider _self;
  final $Res Function(CcSwitchProvider) _then;

/// Create a copy of CcSwitchProvider
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? appType = null,Object? name = null,Object? isCurrent = null,Object? baseUrl = freezed,Object? hasApiKey = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,appType: null == appType ? _self.appType : appType // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isCurrent: null == isCurrent ? _self.isCurrent : isCurrent // ignore: cast_nullable_to_non_nullable
as bool,baseUrl: freezed == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String?,hasApiKey: null == hasApiKey ? _self.hasApiKey : hasApiKey // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CcSwitchProvider].
extension CcSwitchProviderPatterns on CcSwitchProvider {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CcSwitchProvider value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CcSwitchProvider() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CcSwitchProvider value)  $default,){
final _that = this;
switch (_that) {
case _CcSwitchProvider():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CcSwitchProvider value)?  $default,){
final _that = this;
switch (_that) {
case _CcSwitchProvider() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String appType,  String name,  bool isCurrent,  String? baseUrl,  bool hasApiKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CcSwitchProvider() when $default != null:
return $default(_that.id,_that.appType,_that.name,_that.isCurrent,_that.baseUrl,_that.hasApiKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String appType,  String name,  bool isCurrent,  String? baseUrl,  bool hasApiKey)  $default,) {final _that = this;
switch (_that) {
case _CcSwitchProvider():
return $default(_that.id,_that.appType,_that.name,_that.isCurrent,_that.baseUrl,_that.hasApiKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String appType,  String name,  bool isCurrent,  String? baseUrl,  bool hasApiKey)?  $default,) {final _that = this;
switch (_that) {
case _CcSwitchProvider() when $default != null:
return $default(_that.id,_that.appType,_that.name,_that.isCurrent,_that.baseUrl,_that.hasApiKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CcSwitchProvider implements CcSwitchProvider {
  const _CcSwitchProvider({required this.id, required this.appType, required this.name, required this.isCurrent, this.baseUrl, required this.hasApiKey});
  factory _CcSwitchProvider.fromJson(Map<String, dynamic> json) => _$CcSwitchProviderFromJson(json);

@override final  String id;
@override final  String appType;
@override final  String name;
@override final  bool isCurrent;
@override final  String? baseUrl;
@override final  bool hasApiKey;

/// Create a copy of CcSwitchProvider
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CcSwitchProviderCopyWith<_CcSwitchProvider> get copyWith => __$CcSwitchProviderCopyWithImpl<_CcSwitchProvider>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CcSwitchProviderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CcSwitchProvider&&(identical(other.id, id) || other.id == id)&&(identical(other.appType, appType) || other.appType == appType)&&(identical(other.name, name) || other.name == name)&&(identical(other.isCurrent, isCurrent) || other.isCurrent == isCurrent)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.hasApiKey, hasApiKey) || other.hasApiKey == hasApiKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,appType,name,isCurrent,baseUrl,hasApiKey);

@override
String toString() {
  return 'CcSwitchProvider(id: $id, appType: $appType, name: $name, isCurrent: $isCurrent, baseUrl: $baseUrl, hasApiKey: $hasApiKey)';
}


}

/// @nodoc
abstract mixin class _$CcSwitchProviderCopyWith<$Res> implements $CcSwitchProviderCopyWith<$Res> {
  factory _$CcSwitchProviderCopyWith(_CcSwitchProvider value, $Res Function(_CcSwitchProvider) _then) = __$CcSwitchProviderCopyWithImpl;
@override @useResult
$Res call({
 String id, String appType, String name, bool isCurrent, String? baseUrl, bool hasApiKey
});




}
/// @nodoc
class __$CcSwitchProviderCopyWithImpl<$Res>
    implements _$CcSwitchProviderCopyWith<$Res> {
  __$CcSwitchProviderCopyWithImpl(this._self, this._then);

  final _CcSwitchProvider _self;
  final $Res Function(_CcSwitchProvider) _then;

/// Create a copy of CcSwitchProvider
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? appType = null,Object? name = null,Object? isCurrent = null,Object? baseUrl = freezed,Object? hasApiKey = null,}) {
  return _then(_CcSwitchProvider(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,appType: null == appType ? _self.appType : appType // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isCurrent: null == isCurrent ? _self.isCurrent : isCurrent // ignore: cast_nullable_to_non_nullable
as bool,baseUrl: freezed == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String?,hasApiKey: null == hasApiKey ? _self.hasApiKey : hasApiKey // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CcSwitchApp {

 String get appType; String get title; String? get activeProviderId; List<CcSwitchProvider> get providers;
/// Create a copy of CcSwitchApp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CcSwitchAppCopyWith<CcSwitchApp> get copyWith => _$CcSwitchAppCopyWithImpl<CcSwitchApp>(this as CcSwitchApp, _$identity);

  /// Serializes this CcSwitchApp to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CcSwitchApp&&(identical(other.appType, appType) || other.appType == appType)&&(identical(other.title, title) || other.title == title)&&(identical(other.activeProviderId, activeProviderId) || other.activeProviderId == activeProviderId)&&const DeepCollectionEquality().equals(other.providers, providers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appType,title,activeProviderId,const DeepCollectionEquality().hash(providers));

@override
String toString() {
  return 'CcSwitchApp(appType: $appType, title: $title, activeProviderId: $activeProviderId, providers: $providers)';
}


}

/// @nodoc
abstract mixin class $CcSwitchAppCopyWith<$Res>  {
  factory $CcSwitchAppCopyWith(CcSwitchApp value, $Res Function(CcSwitchApp) _then) = _$CcSwitchAppCopyWithImpl;
@useResult
$Res call({
 String appType, String title, String? activeProviderId, List<CcSwitchProvider> providers
});




}
/// @nodoc
class _$CcSwitchAppCopyWithImpl<$Res>
    implements $CcSwitchAppCopyWith<$Res> {
  _$CcSwitchAppCopyWithImpl(this._self, this._then);

  final CcSwitchApp _self;
  final $Res Function(CcSwitchApp) _then;

/// Create a copy of CcSwitchApp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appType = null,Object? title = null,Object? activeProviderId = freezed,Object? providers = null,}) {
  return _then(_self.copyWith(
appType: null == appType ? _self.appType : appType // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,activeProviderId: freezed == activeProviderId ? _self.activeProviderId : activeProviderId // ignore: cast_nullable_to_non_nullable
as String?,providers: null == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as List<CcSwitchProvider>,
  ));
}

}


/// Adds pattern-matching-related methods to [CcSwitchApp].
extension CcSwitchAppPatterns on CcSwitchApp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CcSwitchApp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CcSwitchApp() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CcSwitchApp value)  $default,){
final _that = this;
switch (_that) {
case _CcSwitchApp():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CcSwitchApp value)?  $default,){
final _that = this;
switch (_that) {
case _CcSwitchApp() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appType,  String title,  String? activeProviderId,  List<CcSwitchProvider> providers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CcSwitchApp() when $default != null:
return $default(_that.appType,_that.title,_that.activeProviderId,_that.providers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appType,  String title,  String? activeProviderId,  List<CcSwitchProvider> providers)  $default,) {final _that = this;
switch (_that) {
case _CcSwitchApp():
return $default(_that.appType,_that.title,_that.activeProviderId,_that.providers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appType,  String title,  String? activeProviderId,  List<CcSwitchProvider> providers)?  $default,) {final _that = this;
switch (_that) {
case _CcSwitchApp() when $default != null:
return $default(_that.appType,_that.title,_that.activeProviderId,_that.providers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CcSwitchApp implements CcSwitchApp {
  const _CcSwitchApp({required this.appType, required this.title, this.activeProviderId, final  List<CcSwitchProvider> providers = const []}): _providers = providers;
  factory _CcSwitchApp.fromJson(Map<String, dynamic> json) => _$CcSwitchAppFromJson(json);

@override final  String appType;
@override final  String title;
@override final  String? activeProviderId;
 final  List<CcSwitchProvider> _providers;
@override@JsonKey() List<CcSwitchProvider> get providers {
  if (_providers is EqualUnmodifiableListView) return _providers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_providers);
}


/// Create a copy of CcSwitchApp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CcSwitchAppCopyWith<_CcSwitchApp> get copyWith => __$CcSwitchAppCopyWithImpl<_CcSwitchApp>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CcSwitchAppToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CcSwitchApp&&(identical(other.appType, appType) || other.appType == appType)&&(identical(other.title, title) || other.title == title)&&(identical(other.activeProviderId, activeProviderId) || other.activeProviderId == activeProviderId)&&const DeepCollectionEquality().equals(other._providers, _providers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appType,title,activeProviderId,const DeepCollectionEquality().hash(_providers));

@override
String toString() {
  return 'CcSwitchApp(appType: $appType, title: $title, activeProviderId: $activeProviderId, providers: $providers)';
}


}

/// @nodoc
abstract mixin class _$CcSwitchAppCopyWith<$Res> implements $CcSwitchAppCopyWith<$Res> {
  factory _$CcSwitchAppCopyWith(_CcSwitchApp value, $Res Function(_CcSwitchApp) _then) = __$CcSwitchAppCopyWithImpl;
@override @useResult
$Res call({
 String appType, String title, String? activeProviderId, List<CcSwitchProvider> providers
});




}
/// @nodoc
class __$CcSwitchAppCopyWithImpl<$Res>
    implements _$CcSwitchAppCopyWith<$Res> {
  __$CcSwitchAppCopyWithImpl(this._self, this._then);

  final _CcSwitchApp _self;
  final $Res Function(_CcSwitchApp) _then;

/// Create a copy of CcSwitchApp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appType = null,Object? title = null,Object? activeProviderId = freezed,Object? providers = null,}) {
  return _then(_CcSwitchApp(
appType: null == appType ? _self.appType : appType // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,activeProviderId: freezed == activeProviderId ? _self.activeProviderId : activeProviderId // ignore: cast_nullable_to_non_nullable
as String?,providers: null == providers ? _self._providers : providers // ignore: cast_nullable_to_non_nullable
as List<CcSwitchProvider>,
  ));
}


}


/// @nodoc
mixin _$CcSwitchStatusResponse {

 bool get ok; List<CcSwitchApp> get apps;
/// Create a copy of CcSwitchStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CcSwitchStatusResponseCopyWith<CcSwitchStatusResponse> get copyWith => _$CcSwitchStatusResponseCopyWithImpl<CcSwitchStatusResponse>(this as CcSwitchStatusResponse, _$identity);

  /// Serializes this CcSwitchStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CcSwitchStatusResponse&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other.apps, apps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(apps));

@override
String toString() {
  return 'CcSwitchStatusResponse(ok: $ok, apps: $apps)';
}


}

/// @nodoc
abstract mixin class $CcSwitchStatusResponseCopyWith<$Res>  {
  factory $CcSwitchStatusResponseCopyWith(CcSwitchStatusResponse value, $Res Function(CcSwitchStatusResponse) _then) = _$CcSwitchStatusResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, List<CcSwitchApp> apps
});




}
/// @nodoc
class _$CcSwitchStatusResponseCopyWithImpl<$Res>
    implements $CcSwitchStatusResponseCopyWith<$Res> {
  _$CcSwitchStatusResponseCopyWithImpl(this._self, this._then);

  final CcSwitchStatusResponse _self;
  final $Res Function(CcSwitchStatusResponse) _then;

/// Create a copy of CcSwitchStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? apps = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,apps: null == apps ? _self.apps : apps // ignore: cast_nullable_to_non_nullable
as List<CcSwitchApp>,
  ));
}

}


/// Adds pattern-matching-related methods to [CcSwitchStatusResponse].
extension CcSwitchStatusResponsePatterns on CcSwitchStatusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CcSwitchStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CcSwitchStatusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CcSwitchStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _CcSwitchStatusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CcSwitchStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CcSwitchStatusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  List<CcSwitchApp> apps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CcSwitchStatusResponse() when $default != null:
return $default(_that.ok,_that.apps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  List<CcSwitchApp> apps)  $default,) {final _that = this;
switch (_that) {
case _CcSwitchStatusResponse():
return $default(_that.ok,_that.apps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  List<CcSwitchApp> apps)?  $default,) {final _that = this;
switch (_that) {
case _CcSwitchStatusResponse() when $default != null:
return $default(_that.ok,_that.apps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CcSwitchStatusResponse implements CcSwitchStatusResponse {
  const _CcSwitchStatusResponse({required this.ok, final  List<CcSwitchApp> apps = const []}): _apps = apps;
  factory _CcSwitchStatusResponse.fromJson(Map<String, dynamic> json) => _$CcSwitchStatusResponseFromJson(json);

@override final  bool ok;
 final  List<CcSwitchApp> _apps;
@override@JsonKey() List<CcSwitchApp> get apps {
  if (_apps is EqualUnmodifiableListView) return _apps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_apps);
}


/// Create a copy of CcSwitchStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CcSwitchStatusResponseCopyWith<_CcSwitchStatusResponse> get copyWith => __$CcSwitchStatusResponseCopyWithImpl<_CcSwitchStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CcSwitchStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CcSwitchStatusResponse&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other._apps, _apps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(_apps));

@override
String toString() {
  return 'CcSwitchStatusResponse(ok: $ok, apps: $apps)';
}


}

/// @nodoc
abstract mixin class _$CcSwitchStatusResponseCopyWith<$Res> implements $CcSwitchStatusResponseCopyWith<$Res> {
  factory _$CcSwitchStatusResponseCopyWith(_CcSwitchStatusResponse value, $Res Function(_CcSwitchStatusResponse) _then) = __$CcSwitchStatusResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, List<CcSwitchApp> apps
});




}
/// @nodoc
class __$CcSwitchStatusResponseCopyWithImpl<$Res>
    implements _$CcSwitchStatusResponseCopyWith<$Res> {
  __$CcSwitchStatusResponseCopyWithImpl(this._self, this._then);

  final _CcSwitchStatusResponse _self;
  final $Res Function(_CcSwitchStatusResponse) _then;

/// Create a copy of CcSwitchStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? apps = null,}) {
  return _then(_CcSwitchStatusResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,apps: null == apps ? _self._apps : apps // ignore: cast_nullable_to_non_nullable
as List<CcSwitchApp>,
  ));
}


}

// dart format on
