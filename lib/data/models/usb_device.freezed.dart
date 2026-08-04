// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usb_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsbDevice {

 String get product;/// e.g. "Xiaomi", "Apple Inc."
 String get vendor;/// USB serial; absent when the device doesn't report one.
 String? get serial;
/// Create a copy of UsbDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsbDeviceCopyWith<UsbDevice> get copyWith => _$UsbDeviceCopyWithImpl<UsbDevice>(this as UsbDevice, _$identity);

  /// Serializes this UsbDevice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsbDevice&&(identical(other.product, product) || other.product == product)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.serial, serial) || other.serial == serial));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,product,vendor,serial);

@override
String toString() {
  return 'UsbDevice(product: $product, vendor: $vendor, serial: $serial)';
}


}

/// @nodoc
abstract mixin class $UsbDeviceCopyWith<$Res>  {
  factory $UsbDeviceCopyWith(UsbDevice value, $Res Function(UsbDevice) _then) = _$UsbDeviceCopyWithImpl;
@useResult
$Res call({
 String product, String vendor, String? serial
});




}
/// @nodoc
class _$UsbDeviceCopyWithImpl<$Res>
    implements $UsbDeviceCopyWith<$Res> {
  _$UsbDeviceCopyWithImpl(this._self, this._then);

  final UsbDevice _self;
  final $Res Function(UsbDevice) _then;

/// Create a copy of UsbDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,Object? vendor = null,Object? serial = freezed,}) {
  return _then(_self.copyWith(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as String,vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String,serial: freezed == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UsbDevice].
extension UsbDevicePatterns on UsbDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsbDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsbDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsbDevice value)  $default,){
final _that = this;
switch (_that) {
case _UsbDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsbDevice value)?  $default,){
final _that = this;
switch (_that) {
case _UsbDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String product,  String vendor,  String? serial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsbDevice() when $default != null:
return $default(_that.product,_that.vendor,_that.serial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String product,  String vendor,  String? serial)  $default,) {final _that = this;
switch (_that) {
case _UsbDevice():
return $default(_that.product,_that.vendor,_that.serial);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String product,  String vendor,  String? serial)?  $default,) {final _that = this;
switch (_that) {
case _UsbDevice() when $default != null:
return $default(_that.product,_that.vendor,_that.serial);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UsbDevice implements UsbDevice {
  const _UsbDevice({required this.product, this.vendor = '', this.serial});
  factory _UsbDevice.fromJson(Map<String, dynamic> json) => _$UsbDeviceFromJson(json);

@override final  String product;
/// e.g. "Xiaomi", "Apple Inc."
@override@JsonKey() final  String vendor;
/// USB serial; absent when the device doesn't report one.
@override final  String? serial;

/// Create a copy of UsbDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsbDeviceCopyWith<_UsbDevice> get copyWith => __$UsbDeviceCopyWithImpl<_UsbDevice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsbDeviceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsbDevice&&(identical(other.product, product) || other.product == product)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.serial, serial) || other.serial == serial));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,product,vendor,serial);

@override
String toString() {
  return 'UsbDevice(product: $product, vendor: $vendor, serial: $serial)';
}


}

/// @nodoc
abstract mixin class _$UsbDeviceCopyWith<$Res> implements $UsbDeviceCopyWith<$Res> {
  factory _$UsbDeviceCopyWith(_UsbDevice value, $Res Function(_UsbDevice) _then) = __$UsbDeviceCopyWithImpl;
@override @useResult
$Res call({
 String product, String vendor, String? serial
});




}
/// @nodoc
class __$UsbDeviceCopyWithImpl<$Res>
    implements _$UsbDeviceCopyWith<$Res> {
  __$UsbDeviceCopyWithImpl(this._self, this._then);

  final _UsbDevice _self;
  final $Res Function(_UsbDevice) _then;

/// Create a copy of UsbDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,Object? vendor = null,Object? serial = freezed,}) {
  return _then(_UsbDevice(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as String,vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String,serial: freezed == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UsbDevicesResponse {

 bool get ok;/// Always false on non-macOS hosts — `ioreg` only exists there.
 bool get available; List<UsbDevice> get devices;
/// Create a copy of UsbDevicesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsbDevicesResponseCopyWith<UsbDevicesResponse> get copyWith => _$UsbDevicesResponseCopyWithImpl<UsbDevicesResponse>(this as UsbDevicesResponse, _$identity);

  /// Serializes this UsbDevicesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsbDevicesResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.available, available) || other.available == available)&&const DeepCollectionEquality().equals(other.devices, devices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,available,const DeepCollectionEquality().hash(devices));

@override
String toString() {
  return 'UsbDevicesResponse(ok: $ok, available: $available, devices: $devices)';
}


}

/// @nodoc
abstract mixin class $UsbDevicesResponseCopyWith<$Res>  {
  factory $UsbDevicesResponseCopyWith(UsbDevicesResponse value, $Res Function(UsbDevicesResponse) _then) = _$UsbDevicesResponseCopyWithImpl;
@useResult
$Res call({
 bool ok, bool available, List<UsbDevice> devices
});




}
/// @nodoc
class _$UsbDevicesResponseCopyWithImpl<$Res>
    implements $UsbDevicesResponseCopyWith<$Res> {
  _$UsbDevicesResponseCopyWithImpl(this._self, this._then);

  final UsbDevicesResponse _self;
  final $Res Function(UsbDevicesResponse) _then;

/// Create a copy of UsbDevicesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? available = null,Object? devices = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<UsbDevice>,
  ));
}

}


/// Adds pattern-matching-related methods to [UsbDevicesResponse].
extension UsbDevicesResponsePatterns on UsbDevicesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsbDevicesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsbDevicesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsbDevicesResponse value)  $default,){
final _that = this;
switch (_that) {
case _UsbDevicesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsbDevicesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UsbDevicesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  bool available,  List<UsbDevice> devices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsbDevicesResponse() when $default != null:
return $default(_that.ok,_that.available,_that.devices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  bool available,  List<UsbDevice> devices)  $default,) {final _that = this;
switch (_that) {
case _UsbDevicesResponse():
return $default(_that.ok,_that.available,_that.devices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  bool available,  List<UsbDevice> devices)?  $default,) {final _that = this;
switch (_that) {
case _UsbDevicesResponse() when $default != null:
return $default(_that.ok,_that.available,_that.devices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UsbDevicesResponse implements UsbDevicesResponse {
  const _UsbDevicesResponse({required this.ok, this.available = false, final  List<UsbDevice> devices = const []}): _devices = devices;
  factory _UsbDevicesResponse.fromJson(Map<String, dynamic> json) => _$UsbDevicesResponseFromJson(json);

@override final  bool ok;
/// Always false on non-macOS hosts — `ioreg` only exists there.
@override@JsonKey() final  bool available;
 final  List<UsbDevice> _devices;
@override@JsonKey() List<UsbDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}


/// Create a copy of UsbDevicesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsbDevicesResponseCopyWith<_UsbDevicesResponse> get copyWith => __$UsbDevicesResponseCopyWithImpl<_UsbDevicesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsbDevicesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsbDevicesResponse&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.available, available) || other.available == available)&&const DeepCollectionEquality().equals(other._devices, _devices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,available,const DeepCollectionEquality().hash(_devices));

@override
String toString() {
  return 'UsbDevicesResponse(ok: $ok, available: $available, devices: $devices)';
}


}

/// @nodoc
abstract mixin class _$UsbDevicesResponseCopyWith<$Res> implements $UsbDevicesResponseCopyWith<$Res> {
  factory _$UsbDevicesResponseCopyWith(_UsbDevicesResponse value, $Res Function(_UsbDevicesResponse) _then) = __$UsbDevicesResponseCopyWithImpl;
@override @useResult
$Res call({
 bool ok, bool available, List<UsbDevice> devices
});




}
/// @nodoc
class __$UsbDevicesResponseCopyWithImpl<$Res>
    implements _$UsbDevicesResponseCopyWith<$Res> {
  __$UsbDevicesResponseCopyWithImpl(this._self, this._then);

  final _UsbDevicesResponse _self;
  final $Res Function(_UsbDevicesResponse) _then;

/// Create a copy of UsbDevicesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? available = null,Object? devices = null,}) {
  return _then(_UsbDevicesResponse(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<UsbDevice>,
  ));
}


}

// dart format on
