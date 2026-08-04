// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'xianyu_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$XianyuItem {

 String get itemId; String get title; String get price; String? get area; String? get wantCnt; String? get picUrl;
/// Create a copy of XianyuItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XianyuItemCopyWith<XianyuItem> get copyWith => _$XianyuItemCopyWithImpl<XianyuItem>(this as XianyuItem, _$identity);

  /// Serializes this XianyuItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XianyuItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.price, price) || other.price == price)&&(identical(other.area, area) || other.area == area)&&(identical(other.wantCnt, wantCnt) || other.wantCnt == wantCnt)&&(identical(other.picUrl, picUrl) || other.picUrl == picUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,title,price,area,wantCnt,picUrl);

@override
String toString() {
  return 'XianyuItem(itemId: $itemId, title: $title, price: $price, area: $area, wantCnt: $wantCnt, picUrl: $picUrl)';
}


}

/// @nodoc
abstract mixin class $XianyuItemCopyWith<$Res>  {
  factory $XianyuItemCopyWith(XianyuItem value, $Res Function(XianyuItem) _then) = _$XianyuItemCopyWithImpl;
@useResult
$Res call({
 String itemId, String title, String price, String? area, String? wantCnt, String? picUrl
});




}
/// @nodoc
class _$XianyuItemCopyWithImpl<$Res>
    implements $XianyuItemCopyWith<$Res> {
  _$XianyuItemCopyWithImpl(this._self, this._then);

  final XianyuItem _self;
  final $Res Function(XianyuItem) _then;

/// Create a copy of XianyuItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? title = null,Object? price = null,Object? area = freezed,Object? wantCnt = freezed,Object? picUrl = freezed,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,wantCnt: freezed == wantCnt ? _self.wantCnt : wantCnt // ignore: cast_nullable_to_non_nullable
as String?,picUrl: freezed == picUrl ? _self.picUrl : picUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [XianyuItem].
extension XianyuItemPatterns on XianyuItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XianyuItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XianyuItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XianyuItem value)  $default,){
final _that = this;
switch (_that) {
case _XianyuItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XianyuItem value)?  $default,){
final _that = this;
switch (_that) {
case _XianyuItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String title,  String price,  String? area,  String? wantCnt,  String? picUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _XianyuItem() when $default != null:
return $default(_that.itemId,_that.title,_that.price,_that.area,_that.wantCnt,_that.picUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String title,  String price,  String? area,  String? wantCnt,  String? picUrl)  $default,) {final _that = this;
switch (_that) {
case _XianyuItem():
return $default(_that.itemId,_that.title,_that.price,_that.area,_that.wantCnt,_that.picUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String title,  String price,  String? area,  String? wantCnt,  String? picUrl)?  $default,) {final _that = this;
switch (_that) {
case _XianyuItem() when $default != null:
return $default(_that.itemId,_that.title,_that.price,_that.area,_that.wantCnt,_that.picUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _XianyuItem implements XianyuItem {
  const _XianyuItem({required this.itemId, required this.title, required this.price, this.area, this.wantCnt, this.picUrl});
  factory _XianyuItem.fromJson(Map<String, dynamic> json) => _$XianyuItemFromJson(json);

@override final  String itemId;
@override final  String title;
@override final  String price;
@override final  String? area;
@override final  String? wantCnt;
@override final  String? picUrl;

/// Create a copy of XianyuItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XianyuItemCopyWith<_XianyuItem> get copyWith => __$XianyuItemCopyWithImpl<_XianyuItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$XianyuItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _XianyuItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.price, price) || other.price == price)&&(identical(other.area, area) || other.area == area)&&(identical(other.wantCnt, wantCnt) || other.wantCnt == wantCnt)&&(identical(other.picUrl, picUrl) || other.picUrl == picUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,title,price,area,wantCnt,picUrl);

@override
String toString() {
  return 'XianyuItem(itemId: $itemId, title: $title, price: $price, area: $area, wantCnt: $wantCnt, picUrl: $picUrl)';
}


}

/// @nodoc
abstract mixin class _$XianyuItemCopyWith<$Res> implements $XianyuItemCopyWith<$Res> {
  factory _$XianyuItemCopyWith(_XianyuItem value, $Res Function(_XianyuItem) _then) = __$XianyuItemCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String title, String price, String? area, String? wantCnt, String? picUrl
});




}
/// @nodoc
class __$XianyuItemCopyWithImpl<$Res>
    implements _$XianyuItemCopyWith<$Res> {
  __$XianyuItemCopyWithImpl(this._self, this._then);

  final _XianyuItem _self;
  final $Res Function(_XianyuItem) _then;

/// Create a copy of XianyuItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? title = null,Object? price = null,Object? area = freezed,Object? wantCnt = freezed,Object? picUrl = freezed,}) {
  return _then(_XianyuItem(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,wantCnt: freezed == wantCnt ? _self.wantCnt : wantCnt // ignore: cast_nullable_to_non_nullable
as String?,picUrl: freezed == picUrl ? _self.picUrl : picUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
