import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ServiceState { idle, starting, running, failed }

/// Manages the Rust agent-monitor-service subprocess.
/// Supported hosts: macOS and Windows (the app bundles both `amux` and `rmux`).
/// On other platforms all operations are no-ops — the app works as a
/// remote-only client, which is the intended use for Android/Web/Linux.
class HostService extends ChangeNotifier {
  Process? _process;
  Timer? _healthTimer;
  bool _autoRestart = true;
  bool _isReachable = false;
  ServiceState _state = ServiceState.idle;
  String _lastMessage = '';
  String? _lanUrl;
  String? _tailscaleUrl;

  static const _port = '8797';

  /// Platforms where the app can host the Rust service (bundles amux + rmux).
  static bool get _canHost => Platform.isMacOS || Platform.isWindows;

  ServiceState get state => _state;
  bool get isReachable => _isReachable;
  String get lastMessage => _lastMessage;
  String get serviceUrl => 'http://127.0.0.1:$_port';
  String? get lanUrl => _lanUrl;

  /// The Tailscale (100.64.0.0/10 CGNAT) address, when this Mac is on a
  /// tailnet. Preferred over [lanUrl] for the connect QR because it works
  /// across networks, not just the same LAN.
  String? get tailscaleUrl => _tailscaleUrl;
  bool get isRunning => _process != null;

  // --- Public API ---

  Future<void> startService() async {
    if (!_canHost) return;
    if (_state == ServiceState.running || _state == ServiceState.starting) return;
    _setState(ServiceState.starting);

    final binary = await _resolveBinaryPath();
    if (binary == null) {
      _lastMessage = '找不到 Rust 服务二进制';
      _setState(ServiceState.failed);
      return;
    }

    try {
      final env = Map<String, String>.from(Platform.environment);
      if (Platform.isMacOS) {
        env['PATH'] =
            '/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin';
      }
      // Drive the bundled rmux so hosting is self-contained (no separate
      // install). amux's mux_bin() reads AMUX_MUX.
      final mux = _resolveMuxPath(binary);
      if (mux != null) {
        env['AMUX_MUX'] = mux;
      }
      // Read .env from the project root — the service picks up APNS_* (push),
      // AGENT_MONITOR_CC/CX_COMMAND, DeepSeek, etc. from the environment.
      env.addAll(await _readDotEnv());
      env['AGENT_MONITOR_HOST'] = '0.0.0.0';
      env['AGENT_MONITOR_PORT'] = _port;
      env.remove('AGENT_MONITOR_TOKEN');
      // Serve the bundled web client (sibling of the binary) when present, so
      // any browser can reach a zero-install client at the service URL.
      final webDir = '${File(binary).parent.path}/web';
      if (await Directory(webDir).exists()) {
        env['AGENT_MONITOR_WEB_DIR'] = webDir;
      }

      // The service is `amux serve` (built with --features full). It is
      // flag-driven and would launch a TUI with no args, so pass the subcommand
      // + port explicitly and run it in the foreground under our supervision.
      _process = await Process.start(
        binary,
        ['serve', '--foreground', '--port', _port],
        environment: env,
      );

      _process!.stdout.listen(
        (d) => _lastMessage = String.fromCharCodes(d).trim(),
      );
      _process!.stderr.listen(
        (d) => _lastMessage = String.fromCharCodes(d).trim(),
      );
      _process!.exitCode.then(_onExit);

      // Give the service a moment to bind, then probe.
      await Future<void>.delayed(const Duration(seconds: 2));
      await _refreshReachable();
      if (_isReachable) {
        _setState(ServiceState.running);
      }
      _lanUrl = await _detectLanUrl();
      _tailscaleUrl = await _detectTailscaleUrl();
      _startHealthLoop();
    } catch (e) {
      _lastMessage = '$e';
      _setState(ServiceState.failed);
    }
  }

  Future<void> stopService() async {
    if (!_canHost) return;
    _healthTimer?.cancel();
    _healthTimer = null;
    _autoRestart = false;
    // SIGTERM is unix-only; on Windows the default kill() terminates.
    if (Platform.isWindows) {
      _process?.kill();
    } else {
      _process?.kill(ProcessSignal.sigterm);
    }
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _process = null;
    _isReachable = false;
    _autoRestart = true;
    _setState(ServiceState.idle);
  }

  Future<void> restartService() async {
    await stopService();
    await Future<void>.delayed(const Duration(milliseconds: 400));
    await startService();
  }

  // --- Internals ---

  void _onExit(int code) {
    _process = null;
    _healthTimer?.cancel();
    _isReachable = false;
    if (code == 0) {
      _setState(ServiceState.idle);
    } else {
      _lastMessage = '进程退出 (code $code)';
      _setState(ServiceState.failed);
      if (_autoRestart) {
        Future<void>.delayed(const Duration(seconds: 3), () {
          if (_state == ServiceState.failed) startService();
        });
      }
    }
  }

  Future<void> _refreshReachable() async {
    try {
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 1);
      final req =
          await client.getUrl(Uri.parse('http://127.0.0.1:$_port/api/snapshot'));
      final res = await req.close().timeout(const Duration(seconds: 2));
      _isReachable = res.statusCode == 200;
      client.close();
    } catch (_) {
      _isReachable = false;
    }
  }

  /// Detect the LAN address (en0/en1) so the control center can show a URL
  /// other devices on the same network can reach.
  Future<String?> _detectLanUrl() async {
    if (!Platform.isMacOS) return null;
    try {
      for (final iface in const ['en0', 'en1']) {
        final r = await Process.run('ipconfig', ['getifaddr', iface]);
        final ip = (r.stdout as String).trim();
        if (ip.isNotEmpty && ip.contains('.') && !ip.startsWith('169.254')) {
          return 'http://$ip:$_port';
        }
      }
    } catch (_) {}
    return null;
  }

  /// Detect this Mac's Tailscale address by scanning interfaces for an IPv4 in
  /// the 100.64.0.0/10 CGNAT range that Tailscale assigns (macOS puts it on a
  /// `utun*` interface). Dependency-free — no reliance on the `tailscale` CLI
  /// being on PATH.
  Future<String?> _detectTailscaleUrl() async {
    if (!Platform.isMacOS) return null;
    try {
      final ifaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      for (final iface in ifaces) {
        for (final addr in iface.addresses) {
          final octets = addr.address.split('.');
          if (octets.length != 4) continue;
          final a = int.tryParse(octets[0]);
          final b = int.tryParse(octets[1]);
          // 100.64.0.0/10 → first octet 100, second octet 64–127.
          if (a == 100 && b != null && b >= 64 && b <= 127) {
            return 'http://${addr.address}:$_port';
          }
        }
      }
    } catch (_) {}
    return null;
  }

  void _startHealthLoop() {
    _healthTimer?.cancel();
    _healthTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      await _refreshReachable();
      notifyListeners();
    });
  }

  void _setState(ServiceState s) {
    if (_state == s) return;
    _state = s;
    notifyListeners();
  }

  Future<String?> _resolveBinaryPath() async {
    if (Platform.isWindows) {
      // Production: amux.exe sits next to the Runner .exe (bundled by
      // windows/scripts/bundle_binaries.ps1).
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final bundled = '$exeDir\\amux.exe';
      if (await File(bundled).exists()) return bundled;
      // Development: the sibling amux repo.
      final root = _findProjectRoot();
      if (root != null) {
        final devPath = '$root\\..\\amux\\target\\release\\amux.exe';
        if (await File(devPath).exists()) return devPath;
      }
      return null;
    }

    // macOS —
    // 1. Production: inside the macOS .app bundle.
    final exe = Platform.resolvedExecutable;
    // Contents/MacOS/<app>  →  go up twice to .app
    final appDir = File(exe).parent.parent.parent;
    final bundlePath =
        '${appDir.path}/Contents/Resources/agent-monitor-service';
    if (await File(bundlePath).exists()) return bundlePath;

    // 2. Development: the amux binary in the sibling repo (built --features
    //    full). Primary path 1 already covers `flutter run` (the Xcode build
    //    phase bundles it), so this is a best-effort fallback.
    final root = _findProjectRoot();
    if (root != null) {
      final devPath = '$root/../amux/target/release/amux';
      if (await File(devPath).exists()) return devPath;
    }

    return null;
  }

  /// Path to the bundled rmux binary (sibling of the service binary), or null
  /// when not bundled — in which case amux falls back to rmux on PATH.
  String? _resolveMuxPath(String binaryPath) {
    final dir = File(binaryPath).parent.path;
    final mux = Platform.isWindows ? '$dir\\rmux.exe' : '$dir/rmux';
    return File(mux).existsSync() ? mux : null;
  }

  String? _findProjectRoot() {
    var dir = Directory.current;
    for (var i = 0; i < 10; i++) {
      if (File('${dir.path}/pubspec.yaml').existsSync()) {
        return dir.path;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) return null;
      dir = parent;
    }
    return null;
  }

  /// Read `.env` from the project root so the launched service sees the same
  /// variables as the LaunchAgent (`zsh -lc "source .env; exec …"`).
  Future<Map<String, String>> _readDotEnv() async {
    final root = _findProjectRoot();
    if (root == null) return {};
    final file = File('$root/.env');
    if (!await file.exists()) return {};
    final result = <String, String>{};
    for (final line in await file.readAsLines()) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      final i = trimmed.indexOf('=');
      if (i > 0) {
        result[trimmed.substring(0, i)] = trimmed.substring(i + 1);
      }
    }
    return result;
  }
}

/// Singleton for the host service. Always available; [HostService.startService]
/// is a no-op on platforms that can't host (non-macOS/Windows).
final hostServiceProvider = Provider<HostService>((ref) {
  return HostService();
});
