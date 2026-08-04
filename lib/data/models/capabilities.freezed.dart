// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capabilities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HerdrCapability {

 bool get installed; bool get enabled;
/// Create a copy of HerdrCapability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HerdrCapabilityCopyWith<HerdrCapability> get copyWith => _$HerdrCapabilityCopyWithImpl<HerdrCapability>(this as HerdrCapability, _$identity);

  /// Serializes this HerdrCapability to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HerdrCapability&&(identical(other.installed, installed) || other.installed == installed)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,installed,enabled);

@override
String toString() {
  return 'HerdrCapability(installed: $installed, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $HerdrCapabilityCopyWith<$Res>  {
  factory $HerdrCapabilityCopyWith(HerdrCapability value, $Res Function(HerdrCapability) _then) = _$HerdrCapabilityCopyWithImpl;
@useResult
$Res call({
 bool installed, bool enabled
});




}
/// @nodoc
class _$HerdrCapabilityCopyWithImpl<$Res>
    implements $HerdrCapabilityCopyWith<$Res> {
  _$HerdrCapabilityCopyWithImpl(this._self, this._then);

  final HerdrCapability _self;
  final $Res Function(HerdrCapability) _then;

/// Create a copy of HerdrCapability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? installed = null,Object? enabled = null,}) {
  return _then(_self.copyWith(
installed: null == installed ? _self.installed : installed // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HerdrCapability].
extension HerdrCapabilityPatterns on HerdrCapability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HerdrCapability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HerdrCapability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HerdrCapability value)  $default,){
final _that = this;
switch (_that) {
case _HerdrCapability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HerdrCapability value)?  $default,){
final _that = this;
switch (_that) {
case _HerdrCapability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool installed,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HerdrCapability() when $default != null:
return $default(_that.installed,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool installed,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _HerdrCapability():
return $default(_that.installed,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool installed,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _HerdrCapability() when $default != null:
return $default(_that.installed,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HerdrCapability implements HerdrCapability {
  const _HerdrCapability({this.installed = false, this.enabled = false});
  factory _HerdrCapability.fromJson(Map<String, dynamic> json) => _$HerdrCapabilityFromJson(json);

@override@JsonKey() final  bool installed;
@override@JsonKey() final  bool enabled;

/// Create a copy of HerdrCapability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HerdrCapabilityCopyWith<_HerdrCapability> get copyWith => __$HerdrCapabilityCopyWithImpl<_HerdrCapability>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HerdrCapabilityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HerdrCapability&&(identical(other.installed, installed) || other.installed == installed)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,installed,enabled);

@override
String toString() {
  return 'HerdrCapability(installed: $installed, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$HerdrCapabilityCopyWith<$Res> implements $HerdrCapabilityCopyWith<$Res> {
  factory _$HerdrCapabilityCopyWith(_HerdrCapability value, $Res Function(_HerdrCapability) _then) = __$HerdrCapabilityCopyWithImpl;
@override @useResult
$Res call({
 bool installed, bool enabled
});




}
/// @nodoc
class __$HerdrCapabilityCopyWithImpl<$Res>
    implements _$HerdrCapabilityCopyWith<$Res> {
  __$HerdrCapabilityCopyWithImpl(this._self, this._then);

  final _HerdrCapability _self;
  final $Res Function(_HerdrCapability) _then;

/// Create a copy of HerdrCapability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? installed = null,Object? enabled = null,}) {
  return _then(_HerdrCapability(
installed: null == installed ? _self.installed : installed // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Capabilities {

/// CronBox is installed — the scheduled-jobs screen has something to show.
 bool get cronbox;/// CC Switch is installed — provider switching is available.
 bool get ccSwitch; HerdrCapability get herdr;/// The service was built with `--features full`: control center,
/// screenshots, app list and push endpoints exist.
 bool get full;/// Host OS (`macos`, `linux`, `windows`).
 String get platform;
/// Create a copy of Capabilities
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CapabilitiesCopyWith<Capabilities> get copyWith => _$CapabilitiesCopyWithImpl<Capabilities>(this as Capabilities, _$identity);

  /// Serializes this Capabilities to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Capabilities&&(identical(other.cronbox, cronbox) || other.cronbox == cronbox)&&(identical(other.ccSwitch, ccSwitch) || other.ccSwitch == ccSwitch)&&(identical(other.herdr, herdr) || other.herdr == herdr)&&(identical(other.full, full) || other.full == full)&&(identical(other.platform, platform) || other.platform == platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cronbox,ccSwitch,herdr,full,platform);

@override
String toString() {
  return 'Capabilities(cronbox: $cronbox, ccSwitch: $ccSwitch, herdr: $herdr, full: $full, platform: $platform)';
}


}

/// @nodoc
abstract mixin class $CapabilitiesCopyWith<$Res>  {
  factory $CapabilitiesCopyWith(Capabilities value, $Res Function(Capabilities) _then) = _$CapabilitiesCopyWithImpl;
@useResult
$Res call({
 bool cronbox, bool ccSwitch, HerdrCapability herdr, bool full, String platform
});


$HerdrCapabilityCopyWith<$Res> get herdr;

}
/// @nodoc
class _$CapabilitiesCopyWithImpl<$Res>
    implements $CapabilitiesCopyWith<$Res> {
  _$CapabilitiesCopyWithImpl(this._self, this._then);

  final Capabilities _self;
  final $Res Function(Capabilities) _then;

/// Create a copy of Capabilities
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cronbox = null,Object? ccSwitch = null,Object? herdr = null,Object? full = null,Object? platform = null,}) {
  return _then(_self.copyWith(
cronbox: null == cronbox ? _self.cronbox : cronbox // ignore: cast_nullable_to_non_nullable
as bool,ccSwitch: null == ccSwitch ? _self.ccSwitch : ccSwitch // ignore: cast_nullable_to_non_nullable
as bool,herdr: null == herdr ? _self.herdr : herdr // ignore: cast_nullable_to_non_nullable
as HerdrCapability,full: null == full ? _self.full : full // ignore: cast_nullable_to_non_nullable
as bool,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Capabilities
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HerdrCapabilityCopyWith<$Res> get herdr {
  
  return $HerdrCapabilityCopyWith<$Res>(_self.herdr, (value) {
    return _then(_self.copyWith(herdr: value));
  });
}
}


/// Adds pattern-matching-related methods to [Capabilities].
extension CapabilitiesPatterns on Capabilities {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Capabilities value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Capabilities() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Capabilities value)  $default,){
final _that = this;
switch (_that) {
case _Capabilities():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Capabilities value)?  $default,){
final _that = this;
switch (_that) {
case _Capabilities() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool cronbox,  bool ccSwitch,  HerdrCapability herdr,  bool full,  String platform)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Capabilities() when $default != null:
return $default(_that.cronbox,_that.ccSwitch,_that.herdr,_that.full,_that.platform);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool cronbox,  bool ccSwitch,  HerdrCapability herdr,  bool full,  String platform)  $default,) {final _that = this;
switch (_that) {
case _Capabilities():
return $default(_that.cronbox,_that.ccSwitch,_that.herdr,_that.full,_that.platform);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool cronbox,  bool ccSwitch,  HerdrCapability herdr,  bool full,  String platform)?  $default,) {final _that = this;
switch (_that) {
case _Capabilities() when $default != null:
return $default(_that.cronbox,_that.ccSwitch,_that.herdr,_that.full,_that.platform);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Capabilities implements Capabilities {
  const _Capabilities({this.cronbox = false, this.ccSwitch = false, this.herdr = const HerdrCapability(), this.full = false, this.platform = ''});
  factory _Capabilities.fromJson(Map<String, dynamic> json) => _$CapabilitiesFromJson(json);

/// CronBox is installed — the scheduled-jobs screen has something to show.
@override@JsonKey() final  bool cronbox;
/// CC Switch is installed — provider switching is available.
@override@JsonKey() final  bool ccSwitch;
@override@JsonKey() final  HerdrCapability herdr;
/// The service was built with `--features full`: control center,
/// screenshots, app list and push endpoints exist.
@override@JsonKey() final  bool full;
/// Host OS (`macos`, `linux`, `windows`).
@override@JsonKey() final  String platform;

/// Create a copy of Capabilities
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CapabilitiesCopyWith<_Capabilities> get copyWith => __$CapabilitiesCopyWithImpl<_Capabilities>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CapabilitiesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Capabilities&&(identical(other.cronbox, cronbox) || other.cronbox == cronbox)&&(identical(other.ccSwitch, ccSwitch) || other.ccSwitch == ccSwitch)&&(identical(other.herdr, herdr) || other.herdr == herdr)&&(identical(other.full, full) || other.full == full)&&(identical(other.platform, platform) || other.platform == platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cronbox,ccSwitch,herdr,full,platform);

@override
String toString() {
  return 'Capabilities(cronbox: $cronbox, ccSwitch: $ccSwitch, herdr: $herdr, full: $full, platform: $platform)';
}


}

/// @nodoc
abstract mixin class _$CapabilitiesCopyWith<$Res> implements $CapabilitiesCopyWith<$Res> {
  factory _$CapabilitiesCopyWith(_Capabilities value, $Res Function(_Capabilities) _then) = __$CapabilitiesCopyWithImpl;
@override @useResult
$Res call({
 bool cronbox, bool ccSwitch, HerdrCapability herdr, bool full, String platform
});


@override $HerdrCapabilityCopyWith<$Res> get herdr;

}
/// @nodoc
class __$CapabilitiesCopyWithImpl<$Res>
    implements _$CapabilitiesCopyWith<$Res> {
  __$CapabilitiesCopyWithImpl(this._self, this._then);

  final _Capabilities _self;
  final $Res Function(_Capabilities) _then;

/// Create a copy of Capabilities
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cronbox = null,Object? ccSwitch = null,Object? herdr = null,Object? full = null,Object? platform = null,}) {
  return _then(_Capabilities(
cronbox: null == cronbox ? _self.cronbox : cronbox // ignore: cast_nullable_to_non_nullable
as bool,ccSwitch: null == ccSwitch ? _self.ccSwitch : ccSwitch // ignore: cast_nullable_to_non_nullable
as bool,herdr: null == herdr ? _self.herdr : herdr // ignore: cast_nullable_to_non_nullable
as HerdrCapability,full: null == full ? _self.full : full // ignore: cast_nullable_to_non_nullable
as bool,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Capabilities
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HerdrCapabilityCopyWith<$Res> get herdr {
  
  return $HerdrCapabilityCopyWith<$Res>(_self.herdr, (value) {
    return _then(_self.copyWith(herdr: value));
  });
}
}


/// @nodoc
mixin _$CapabilitiesResponse {

 bool get ok; Capabilities get capabilities;
/// Create a copy of CapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CapabilitiesResponseCopyWith<CapabilitiesResponse> get copyWith => _$CapabilitiesResponseCopyWithImpl<CapabilitiesResponse>(this as CapabilitiesResponse, _$identity);

  /// Serializes this CapabilitiesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CapabilitiesResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.capabilities, capabilities) || other.capabilities == capabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,capabilities);

@override
String toString() {
  return 'CapabilitiesResponse(ok: $ok, capabilities: $capabilities)';
}


}

/// @nodoc
abstract mixin class $CapabilitiesResponseCopyWith<$Res>  {
  factory $CapabilitiesResponseCopyWith(CapabilitiesResponse value, $Res Function(CapabilitiesResponse) _then) = _$CapabilitiesResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, Capabilities capabilities
});


$CapabilitiesCopyWith<$Res> get capabilities;

}
/// @nodoc
class _$CapabilitiesResponseCopyWithImpl<$Res>
    implements $CapabilitiesResponseCopyWith<$Res> {
  _$CapabilitiesResponseCopyWithImpl(this._self, this._then);

  final CapabilitiesResponse _self;
  final $Res Function(CapabilitiesResponse) _then;

/// Create a copy of CapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? capabilities = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as Capabilities,
  ));
}
/// Create a copy of CapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CapabilitiesCopyWith<$Res> get capabilities {
  
  return $CapabilitiesCopyWith<$Res>(_self.capabilities, (value) {
    return _then(_self.copyWith(capabilities: value));
  });
}
}


/// Adds pattern-matching-related methods to [CapabilitiesResponse].
extension CapabilitiesResponsePatterns on CapabilitiesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CapabilitiesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CapabilitiesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CapabilitiesResponse value)  $default,){
final _that = this;
switch (_that) {
case _CapabilitiesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CapabilitiesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CapabilitiesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  Capabilities capabilities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CapabilitiesResponse() when $default != null:
return $default(_that.ok,_that.capabilities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  Capabilities capabilities)  $default,) {final _that = this;
switch (_that) {
case _CapabilitiesResponse():
return $default(_that.ok,_that.capabilities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  Capabilities capabilities)?  $default,) {final _that = this;
switch (_that) {
case _CapabilitiesResponse() when $default != null:
return $default(_that.ok,_that.capabilities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CapabilitiesResponse implements CapabilitiesResponse {
  const _CapabilitiesResponse({required this.ok, this.capabilities = const Capabilities()});
  factory _CapabilitiesResponse.fromJson(Map<String, dynamic> json) => _$CapabilitiesResponseFromJson(json);

@override final  bool ok;
@override@JsonKey() final  Capabilities capabilities;

/// Create a copy of CapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CapabilitiesResponseCopyWith<_CapabilitiesResponse> get copyWith => __$CapabilitiesResponseCopyWithImpl<_CapabilitiesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CapabilitiesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CapabilitiesResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.capabilities, capabilities) || other.capabilities == capabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,capabilities);

@override
String toString() {
  return 'CapabilitiesResponse(ok: $ok, capabilities: $capabilities)';
}


}

/// @nodoc
abstract mixin class _$CapabilitiesResponseCopyWith<$Res> implements $CapabilitiesResponseCopyWith<$Res> {
  factory _$CapabilitiesResponseCopyWith(_CapabilitiesResponse value, $Res Function(_CapabilitiesResponse) _then) = __$CapabilitiesResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, Capabilities capabilities
});


@override $CapabilitiesCopyWith<$Res> get capabilities;

}
/// @nodoc
class __$CapabilitiesResponseCopyWithImpl<$Res>
    implements _$CapabilitiesResponseCopyWith<$Res> {
  __$CapabilitiesResponseCopyWithImpl(this._self, this._then);

  final _CapabilitiesResponse _self;
  final $Res Function(_CapabilitiesResponse) _then;

/// Create a copy of CapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? capabilities = null,}) {
  return _then(_CapabilitiesResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as Capabilities,
  ));
}

/// Create a copy of CapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CapabilitiesCopyWith<$Res> get capabilities {
  
  return $CapabilitiesCopyWith<$Res>(_self.capabilities, (value) {
    return _then(_self.copyWith(capabilities: value));
  });
}
}

// dart format on
