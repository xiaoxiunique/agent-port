import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../models/xianyu_item.dart';

/// 闲鱼微信小程序 mtop 纯 HTTP 采集 API.
///
/// 签名逻辑: `sign = md5(token + '&' + t + '&' + appKey + '&' + data)`.
/// token 由服务端首次请求自动下发（自举），无需登录/抓包。
class XianyuApi {
  XianyuApi({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  static const _appKey = '12574478';
  static const _utdid = 'bTugIlJnFgABASQJimKkhRaQ';
  static const _miniVer = '0.3.79';
  static const _host = 'acs.m.goofish.com';

  static const _headers = {
    'Host': _host,
    'accept': 'application/json',
    'content-type': 'application/x-www-form-urlencoded',
    'x-tap': 'wx',
    'referer':
        'https://servicewechat.com/wx9882f2a891880616/77/page-frame.html',
    'user-agent':
        'Mozilla/5.0 (Linux; Android 13; 22041216C) MicroMessenger/8.0.71 MiniProgramEnv/android',
  };

  String _token = '';

  String _md5(String s) {
    return md5.convert(utf8.encode(s)).toString();
  }

  /// 调用 mtop 接口，自动处理 token 自举。
  Future<Map<String, dynamic>> _call(
    String api,
    Map<String, dynamic> dataObj,
  ) async {
    final data = jsonEncode(dataObj);
    final token = _token.split('_').first;
    final t = DateTime.now().millisecondsSinceEpoch.toString();
    final sign = _md5('$token&$t&$_appKey&$data');

    final query = Uri(
      path: '/h5/$api/1.0/2.0/',
      queryParameters: {
        'jsv': '2.4.12',
        'appKey': _appKey,
        't': t,
        'sign': sign,
        'c': _token,
        'v': '1.0',
        'type': 'originaljson',
        'accountSite': 'xianyu',
        'dataType': 'json',
        'timeout': '20000',
        'api': api,
        '_bx-m': '1',
      },
    ).toString();

    final response = await _dio.post<String>(
      'https://$_host$query',
      data: 'data=${Uri.encodeComponent(data)}',
      options: Options(headers: _headers),
    );

    final json = jsonDecode(response.data!) as Map<String, dynamic>;
    if (json['c'] != null) _token = json['c'] as String;
    return json;
  }

  /// 调用接口，TOKEN 错误时自动用新 token 重试一次。
  Future<Map<String, dynamic>> _callRetry(
    String api,
    Map<String, dynamic> data,
  ) async {
    var result = await _call(api, data);
    final ret = result['ret'];
    if (ret is List && ret.isNotEmpty) {
      final retStr = ret.first.toString();
      if (retStr.contains('TOKEN_')) {
        result = await _call(api, data);
      }
    }
    return result;
  }

  bool _isOk(Map<String, dynamic> r) {
    final ret = r['ret'];
    return ret is List && ret.isNotEmpty && ret.first == 'SUCCESS::调用成功';
  }

  /// 搜索闲鱼商品.
  Future<List<XianyuItem>> search(
    String keyword, {
    int page = 1,
    int rows = 30,
  }) async {
    final data = {
      'utdid': _utdid,
      'platform': 'android',
      'miniAppVersion': _miniVer,
      'keyword': keyword,
      'clientModifiedCpvNavigatorJson':
          '{"fromClient":false,"tabList":[]}',
      'propValueStr': '{"searchFilter":""}',
      'extraFilterValue':
          '{"divisionList":[],"excludeMultiPlacesSellers":0}',
      'customGps': '',
      'customDistance': null,
      'sortField': '',
      'sortValue': '',
      'userPositionJson': 'null',
      'fromFilter': false,
      'pageNumber': page,
      'rowsPerPage': rows,
      'bizFrom': 'miniHome',
      'searchReqFromPage': 'xyMiniHome',
      'searchTabType': 'SEARCH_TAB_MAIN',
      'searchReqFromActivatePagePart': 'recommendItem',
      'source': '',
      'activeSearch': true,
      'fromCombo': false,
      'forceUseInputKeyword': false,
      'forceUseTppRepair': false,
      'supportFlexFilter': true,
      'suggestBucketNum': -1,
      'suggestRn': '',
      'shadeBucketNum': -1,
      'shadeRn': '',
      'fromKits': false,
      'fromLeaf': false,
      'gps': '',
    };

    final result = await _callRetry(
      'mtop.taobao.idlemtopsearch.wx.search',
      data,
    );
    if (!_isOk(result)) return [];

    final items = <XianyuItem>[];
    final resultList =
        (result['data']?['resultList'] as List?) ?? [];
    for (final it in resultList) {
      try {
        final main = it['data']?['item']?['main'];
        final ex = main?['exContent'] as Map<String, dynamic>? ?? {};
        final args =
            (main?['clickParam']?['args'] as Map<String, dynamic>?) ?? {};
        items.add(XianyuItem(
          itemId: args['id']?.toString() ?? '',
          title: (ex['title'] ?? args['title'] ?? '').toString(),
          price: (args['price'] ?? '').toString(),
          area: ex['area']?.toString(),
          wantCnt: args['wantNum']?.toString(),
          picUrl: ex['picUrl']?.toString(),
        ));
      } catch (_) {
        // skip unparseable items
      }
    }
    return items;
  }
}
