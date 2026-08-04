import 'package:freezed_annotation/freezed_annotation.dart';

part 'xianyu_item.freezed.dart';
part 'xianyu_item.g.dart';

/// 闲鱼商品搜索结果 item.
@freezed
abstract class XianyuItem with _$XianyuItem {
  const factory XianyuItem({
    required String itemId,
    required String title,
    required String price,
    String? area,
    String? wantCnt,
    String? picUrl,
  }) = _XianyuItem;

  factory XianyuItem.fromJson(Map<String, dynamic> json) =>
      _$XianyuItemFromJson(json);
}
