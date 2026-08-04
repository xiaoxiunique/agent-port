import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/xianyu_api.dart';
import '../data/models/xianyu_item.dart';

/// 闲鱼 API 实例.
final xianyuApiProvider = Provider<XianyuApi>((ref) => XianyuApi());

/// 内置预设关键词.
const defaultXianyuKeywords = ['mimo', 'glm', 'kimi'];

/// 闲鱼搜索状态.
class XianyuSearchState {
  const XianyuSearchState({
    this.items = const [],
    this.loading = false,
    this.keyword,
    this.error,
  });

  final List<XianyuItem> items;
  final bool loading;
  final String? keyword;
  final String? error;

  XianyuSearchState copyWith({
    List<XianyuItem>? items,
    bool? loading,
    String? keyword,
    String? error,
  }) =>
      XianyuSearchState(
        items: items ?? this.items,
        loading: loading ?? this.loading,
        keyword: keyword ?? this.keyword,
        error: error,
      );
}

/// 闲鱼搜索 notifier.
class XianyuSearchNotifier extends StateNotifier<XianyuSearchState> {
  XianyuSearchNotifier(this._api) : super(const XianyuSearchState());

  final XianyuApi _api;

  Future<void> search(String keyword) async {
    state = state.copyWith(loading: true, keyword: keyword, error: null);
    try {
      final items = await _api.search(keyword);
      state = state.copyWith(loading: false, items: items);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final xianyuSearchProvider =
    StateNotifierProvider<XianyuSearchNotifier, XianyuSearchState>(
  (ref) => XianyuSearchNotifier(ref.read(xianyuApiProvider)),
);
