import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../models/agent_event.dart';
import '../models/api.dart';
import '../models/cc_switch.dart';
import '../models/project_history.dart';
import '../models/running_app.dart';
import '../models/snapshot.dart';

/// Typed HTTP client for the Agent Monitor Rust service.
///
/// Token (when set) is sent as `Authorization: Bearer <token>`. The same token
/// is appended as `?token=` on WebSocket connections (handled in the service
/// layer). Non-2xx responses throw [DioException]; the server's `error` string
/// is in `error.response?.data['error']`.
class AgentMonitorApi {
  AgentMonitorApi({required String baseUrl, String? token, Dio? dio})
      : _dio = dio ?? Dio(),
        _token = token {
    _dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: 8)
      ..receiveTimeout = const Duration(seconds: 20);
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  final Dio _dio;
  final String? _token;

  /// WebSocket URI for a given path (e.g. `/ws`), with the token appended as
  /// `?token=` when set. HTTP base scheme is upgraded to `ws`/`wss`.
  Uri wsUri(String path) {
    final base = Uri.parse(_dio.options.baseUrl);
    final scheme = base.scheme == 'https' ? 'wss' : 'ws';
    var uri = base.replace(scheme: scheme).resolve(path);
    if (_token != null && _token.isNotEmpty) {
      uri = uri.replace(queryParameters: {'token': _token});
    }
    return uri;
  }

  // --- Snapshots & panes ---

  /// `GET /api/snapshot`
  Future<Snapshot> snapshot() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/snapshot');
    return Snapshot.fromJson(r.data!);
  }

  /// `GET /api/pane/context?paneId=&lines=`
  Future<PaneContextResponse> paneContext(String paneId, {int? lines}) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/api/pane/context',
      queryParameters: {
        'paneId': paneId,
        'lines': ?lines,
      },
    );
    return PaneContextResponse.fromJson(r.data!);
  }

  /// `GET /api/pane/events?paneId=&limit=`
  Future<AgentEventsResponse> paneEvents(String paneId, {int? limit}) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/api/pane/events',
      queryParameters: {
        'paneId': paneId,
        'limit': ?limit,
      },
    );
    return AgentEventsResponse.fromJson(r.data!);
  }

  // --- Input ---

  /// `POST /api/send`
  Future<PaneCommandResponse> send(SendRequest req) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/send',
      data: req.toJson(),
    );
    return PaneCommandResponse.fromJson(r.data!);
  }

  /// `POST /api/key?paneId=&key=` — no body; params in query.
  Future<PaneCommandResponse> sendKey(String paneId, String key) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/key',
      queryParameters: {'paneId': paneId, 'key': key},
    );
    return PaneCommandResponse.fromJson(r.data!);
  }

  /// `POST /api/refine-text`
  Future<RefineTextResponse> refineText(String text) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/refine-text',
      data: {'text': text},
    );
    return RefineTextResponse.fromJson(r.data!);
  }

  /// `POST /api/upload-image` — raw image bytes (not multipart).
  Future<UploadedImageResponse> uploadImage(
    Uint8List bytes,
    String contentType, {
    String? paneId,
  }) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/upload-image',
      data: bytes,
      queryParameters: {'paneId': ?paneId},
      options: Options(headers: {'Content-Type': contentType}),
    );
    return UploadedImageResponse.fromJson(r.data!);
  }

  /// `POST /api/session/kill` — pane-level kill only (session-level is disabled
  /// server-side and surfaces as an error response).
  Future<void> killSession({String? paneId}) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/session/kill',
      data: KillSessionRequest(paneId: paneId).toJson(),
    );
  }

  // --- Project history ---

  /// `GET /api/project-history`
  Future<ProjectHistoryResponse> projectHistory() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/project-history');
    return ProjectHistoryResponse.fromJson(r.data!);
  }

  /// `POST /api/project-history/launch`
  Future<ProjectHistoryResponse> launchProject({
    required String path,
    required String agent,
  }) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/project-history/launch',
      data: LaunchProjectRequest(path: path, agent: agent).toJson(),
    );
    return ProjectHistoryResponse.fromJson(r.data!);
  }

  // --- CC Switch ---

  /// `GET /api/cc-switch`
  Future<CcSwitchStatusResponse> ccSwitchStatus() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/cc-switch');
    return CcSwitchStatusResponse.fromJson(r.data!);
  }

  /// `POST /api/cc-switch/switch`
  Future<CcSwitchStatusResponse> switchCcProvider({
    required String appType,
    required String providerId,
  }) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/cc-switch/switch',
      data: CcSwitchSwitchRequest(appType: appType, providerId: providerId).toJson(),
    );
    return CcSwitchStatusResponse.fromJson(r.data!);
  }

  // --- Machine monitor (macOS host) ---

  /// `GET /api/apps` — foreground GUI apps on the host Mac.
  Future<AppsResponse> listApps() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/apps');
    return AppsResponse.fromJson(r.data!);
  }

  /// `GET /api/apps/installed` — all installed `.app` bundles.
  Future<InstalledAppsResponse> listInstalledApps() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/apps/installed');
    return InstalledAppsResponse.fromJson(r.data!);
  }

  /// `POST /api/apps/open` — launch an installed app by bundle path.
  Future<void> openApp(String path) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/apps/open',
      data: {'path': path},
    );
  }

  /// Absolute HTTP URL for an app's icon (`GET /api/apps/icon?path=`).
  String appIconUrl(String path) {
    final base = _dio.options.baseUrl;
    final token = (_token != null && _token.isNotEmpty) ? "&token=$_token" : "";
    return '$base/api/apps/icon?path=${Uri.encodeQueryComponent(path)}$token';
  }

  /// Absolute HTTP URL for a fresh screenshot of an app's main window
  /// (`GET /api/apps/screenshot?pid=`).
  String appScreenshotUrl(int pid, {int? bust}) {
    final base = _dio.options.baseUrl;
    final token = (_token != null && _token.isNotEmpty) ? "&token=$_token" : "";
    return '$base/api/apps/screenshot?pid=$pid&t=${bust ?? 0}$token';
  }

  /// `POST /api/apps/quit` — gracefully quit an app by name.
  Future<void> quitApp(String name) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/apps/quit',
      data: {'name': name},
    );
  }

  /// Absolute HTTP URL for an on-demand main-display screenshot
  /// (`GET /api/screen`). [bust] forces a fresh capture (cache-busting).
  String screenUrl({int? bust}) {
    final base = _dio.options.baseUrl;
    final token = (_token != null && _token.isNotEmpty) ? "&token=$_token" : "";
    return '$base/api/screen?t=${bust ?? 0}$token';
  }
}
