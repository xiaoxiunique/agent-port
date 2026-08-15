import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/agent_event.dart';
import '../models/api.dart';
import '../models/capabilities.dart';
import '../models/cc_switch.dart';
import '../models/cron.dart';
import '../models/files.dart';
import '../models/notify_config.dart';
import '../models/pending.dart';
import '../models/project_history.dart';
import '../models/running_app.dart';
import '../models/sessions.dart';
import '../models/snapshot.dart';
import '../models/token_usage.dart';
import '../models/usb_device.dart';
import '../models/usage_daily.dart';

/// The platform this client runs on, sent as `x-agent-port-source` so the
/// server can tell phone-initiated sends from desktop ones (for push policy).
String _platformSource() {
  if (kIsWeb) return 'web';
  if (Platform.isIOS) return 'ios';
  if (Platform.isAndroid) return 'android';
  if (Platform.isMacOS) return 'macos';
  return 'desktop';
}

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
      ..receiveTimeout = const Duration(seconds: 20)
      ..headers['x-agent-port-source'] = _platformSource();
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

  /// `POST /api/send`. Returns [SendResult]: when the target is a busy Claude
  /// pane the server holds the message (`queued == true`) instead of sending.
  Future<SendResult> send(SendRequest req) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/send',
      data: req.toJson(),
    );
    return SendResult.fromJson(r.data!);
  }

  /// `GET /api/pending?paneId=` — the pane's pending-message queue.
  Future<PendingList> pendingList(String paneId) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/api/pending',
      queryParameters: {'paneId': paneId},
    );
    return PendingList.fromJson(r.data!);
  }

  /// `POST /api/pending/update` — edit a queued message's text.
  Future<PendingList> pendingUpdate(String paneId, String id, String text) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/pending/update',
      data: {'paneId': paneId, 'id': id, 'text': text},
    );
    return PendingList.fromJson(r.data!);
  }

  /// `POST /api/pending/delete` — remove one queued message.
  Future<PendingList> pendingDelete(String paneId, String id) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/pending/delete',
      data: {'paneId': paneId, 'id': id},
    );
    return PendingList.fromJson(r.data!);
  }

  /// `POST /api/pending/clear?paneId=` — drop the whole queue.
  Future<PendingList> pendingClear(String paneId) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/pending/clear',
      queryParameters: {'paneId': paneId},
    );
    return PendingList.fromJson(r.data!);
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

  // --- File browsing (read-only) ---

  /// `GET /api/files/roots` — directories the host allows browsing.
  Future<List<FileRoot>> fileRoots() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/files/roots');
    return FileRootsResponse.fromJson(r.data!).roots;
  }

  /// `GET /api/files/list` — one directory's contents.
  ///
  /// [showAll] includes dotfiles and build/vendor directories, which are hidden
  /// by default because a single project can otherwise list tens of thousands
  /// of files.
  Future<FileListing> fileList(String path, {bool showAll = false}) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/api/files/list',
      queryParameters: {'path': path, if (showAll) 'all': 'true'},
    );
    return FileListResponse.fromJson(r.data!).listing;
  }

  /// `GET /api/files/read` — inline text preview.
  Future<FilePreview> fileRead(String path) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/api/files/read',
      queryParameters: {'path': path},
    );
    return FilePreview.fromJson(r.data!);
  }

  /// `GET /api/sessions` — past Claude/Codex conversations for a project.
  Future<List<AgentSessions>> projectSessions(String path, {int? limit}) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/api/sessions',
      queryParameters: {'path': path, 'limit': ?limit},
    );
    return SessionsResponse.fromJson(r.data!).agents;
  }

  /// `POST /api/sessions/resume` — reopen a past conversation in its own
  /// session. Returns the multiplexer session name it now runs in.
  Future<String> resumeSession({
    required String path,
    required String agent,
    required String sessionId,
    required String suffix,
  }) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/sessions/resume',
      data: ResumeSessionRequest(
        path: path,
        agent: agent,
        sessionId: sessionId,
        suffix: suffix,
      ).toJson(),
    );
    final res = ResumeSessionResponse.fromJson(r.data!);
    if (!res.ok) throw Exception(res.error ?? '恢复会话失败');
    return res.session ?? '';
  }

  /// Absolute URL for downloading a file, with the auth token appended when
  /// set. Handed to the system browser rather than fetched in-process, so
  /// large artefacts stream straight to the OS downloader.
  String fileDownloadUrl(String path) {
    final base = Uri.parse(_dio.options.baseUrl);
    final uri = base.resolve('/api/files/download').replace(
      queryParameters: {
        'path': path,
        if (_token != null && _token.isNotEmpty) 'token': _token,
      },
    );
    return uri.toString();
  }

  // --- Capabilities ---

  /// The same payload, unparsed.
  ///
  /// For fields the `Capabilities` model doesn't carry yet — adding one there
  /// requires a codegen run, and the toolchain currently can't do one.
  Future<Map<String, dynamic>> rawCapabilities() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/capabilities');
    final caps = r.data?['capabilities'];
    return caps is Map<String, dynamic> ? caps : <String, dynamic>{};
  }

  /// `GET /api/capabilities` — which optional tools the host has.
  ///
  /// Returns all-false when the service predates this endpoint, so an older
  /// host degrades to "no optional features" instead of erroring.
  Future<Capabilities> capabilities() async {
    try {
      final r = await _dio.get<Map<String, dynamic>>('/api/capabilities');
      return CapabilitiesResponse.fromJson(r.data!).capabilities;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return const Capabilities();
      rethrow;
    }
  }

  // --- CronBox scheduled jobs ---

  /// `GET /api/cron/schedules`
  Future<List<CronSchedule>> cronSchedules() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/cron/schedules');
    return CronSchedulesResponse.fromJson(r.data!).schedules;
  }

  /// `GET /api/cron/jobs` — recent runs, newest first.
  Future<List<CronJob>> cronJobs({
    int? limit,
    String? status,
    String? scheduleId,
  }) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/api/cron/jobs',
      queryParameters: {
        'limit': ?limit,
        'status': ?status,
        'scheduleId': ?scheduleId,
      },
    );
    return CronJobsResponse.fromJson(r.data!).jobs;
  }

  /// `GET /api/cron/jobs/running`
  Future<List<CronJob>> cronRunningJobs() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/cron/jobs/running');
    return CronJobsResponse.fromJson(r.data!).jobs;
  }

  /// `GET /api/cron/log?id=` — one job's captured output.
  Future<CronLogResponse> cronLog(String jobId) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/api/cron/log',
      queryParameters: {'id': jobId},
    );
    return CronLogResponse.fromJson(r.data!);
  }

  /// `POST /api/cron/action` — `enable`, `disable`, `cancel` or `trigger`.
  ///
  /// `enable`/`disable`/`trigger` take a schedule id; `cancel` takes a job id.
  Future<void> cronAction({
    required String action,
    required String id,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/cron/action',
      data: {'action': action, 'id': id},
    );
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

  // --- USB devices (macOS host) ---

  /// `GET /api/usb/devices` — phones and other USB devices on the host.
  ///
  /// Only available on macOS (uses `ioreg`); returns an empty list on other
  /// platforms with `available: false`.
  Future<UsbDevicesResponse> usbDevices() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/usb/devices');
    return UsbDevicesResponse.fromJson(r.data!);
  }

  /// Absolute URL for a USB device screenshot, with the auth token appended
  /// when set. The client renders this directly — it returns raw PNG bytes.
  String usbScreenshotUrl(String serial) {
    final base = Uri.parse(_dio.options.baseUrl);
    return base.resolve('/api/usb/screenshot').replace(
      queryParameters: {
        'serial': serial,
        if (_token != null && _token.isNotEmpty) 'token': _token,
      },
    ).toString();
  }

  // --- Machine monitor (macOS host) ---

  /// `GET /api/usage` — total Claude Code + Codex token usage (via ccusage).
  Future<TokenUsage> usage() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/usage');
    return TokenUsage.fromJson(r.data!);
  }

  /// `GET /api/usage/daily` — totals + per-day Claude + Codex spend.
  Future<UsageDaily> usageDaily() async {
    final r = await _dio.get<Map<String, dynamic>>('/api/usage/daily');
    return UsageDaily.fromJson(r.data!);
  }

  /// `POST /api/push/register` — register this device's APNs token so the
  /// server can deliver push notifications.
  Future<void> registerPushToken(String deviceToken) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/push/register',
      data: {'deviceToken': deviceToken},
    );
  }

  /// `GET /api/pane/notify-config?key=` — a session's notification config.
  Future<NotifyConfig> getNotifyConfig(String key) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/api/pane/notify-config',
      queryParameters: {'key': key},
    );
    return NotifyConfig.fromJson(r.data!);
  }

  /// `POST /api/pane/notify-config` — save a session's notification config.
  Future<NotifyConfig> setNotifyConfig(
      String key, bool enabled, List<String> events) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/api/pane/notify-config',
      data: {'key': key, 'enabled': enabled, 'events': events},
    );
    return NotifyConfig.fromJson(r.data!);
  }

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
