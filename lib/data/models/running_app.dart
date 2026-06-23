/// A foreground GUI app running on the monitored Mac (`GET /api/apps`).
///
/// Hand-written (no codegen) so it doesn't depend on build_runner.
class RunningApp {
  const RunningApp({
    required this.name,
    required this.path,
    required this.pid,
    this.memoryBytes = 0,
    this.cpuPercent = 0,
  });

  final String name;
  final String path;
  final int pid;
  final int memoryBytes;
  final double cpuPercent;

  factory RunningApp.fromJson(Map<String, dynamic> json) => RunningApp(
        name: json['name'] as String? ?? '',
        path: json['path'] as String? ?? '',
        pid: (json['pid'] as num?)?.toInt() ?? 0,
        memoryBytes: (json['memoryBytes'] as num?)?.toInt() ?? 0,
        cpuPercent: (json['cpuPercent'] as num?)?.toDouble() ?? 0,
      );
}

class AppsResponse {
  const AppsResponse({required this.ok, this.apps = const [], this.error});

  final bool ok;
  final List<RunningApp> apps;
  final String? error;

  factory AppsResponse.fromJson(Map<String, dynamic> json) => AppsResponse(
        ok: json['ok'] as bool? ?? false,
        apps: ((json['apps'] as List<dynamic>?) ?? const [])
            .map((e) => RunningApp.fromJson(e as Map<String, dynamic>))
            .toList(),
        error: json['error'] as String?,
      );
}

/// An installed `.app` bundle on disk (`GET /api/apps/installed`).
class InstalledApp {
  const InstalledApp({required this.name, required this.path});

  final String name;
  final String path;

  factory InstalledApp.fromJson(Map<String, dynamic> json) => InstalledApp(
        name: json['name'] as String? ?? '',
        path: json['path'] as String? ?? '',
      );
}

class InstalledAppsResponse {
  const InstalledAppsResponse({required this.ok, this.apps = const []});

  final bool ok;
  final List<InstalledApp> apps;

  factory InstalledAppsResponse.fromJson(Map<String, dynamic> json) =>
      InstalledAppsResponse(
        ok: json['ok'] as bool? ?? false,
        apps: ((json['apps'] as List<dynamic>?) ?? const [])
            .map((e) => InstalledApp.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
