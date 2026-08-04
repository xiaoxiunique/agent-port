// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xianyu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_XianyuItem _$XianyuItemFromJson(Map<String, dynamic> json) => _XianyuItem(
  itemId: json['itemId'] as String,
  title: json['title'] as String,
  price: json['price'] as String,
  area: json['area'] as String?,
  wantCnt: json['wantCnt'] as String?,
  picUrl: json['picUrl'] as String?,
);

Map<String, dynamic> _$XianyuItemToJson(_XianyuItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'title': instance.title,
      'price': instance.price,
      'area': instance.area,
      'wantCnt': instance.wantCnt,
      'picUrl': instance.picUrl,
    };
