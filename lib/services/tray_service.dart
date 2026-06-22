import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';

import '../features/control_center/control_center_dialog.dart';
import 'host_service.dart';

/// Manages the macOS system-tray icon, context menu, and opens the
/// control-center window.  Only meaningful on macOS; call [init] once after
/// the Flutter engine is ready.
class TrayService with TrayListener {
  TrayService._();
  static final instance = TrayService._();

  GlobalKey<NavigatorState>? _navKey;
  HostService? _host;

  /// Must be called once after the Flutter engine is fully initialised
  /// (e.g. in `initState` → `addPostFrameCallback`).
  Future<void> init(
    GlobalKey<NavigatorState> navKey,
    HostService host,
  ) async {
    _navKey = navKey;
    _host = host;
    trayManager.addListener(this);
    host.addListener(_rebuildMenu);
    await _setIcon();
    await _rebuildMenu();
  }

  // --- Tray icon -----------------------------------------------------------

  Future<void> _setIcon() async {
    await trayManager.setIcon('assets/tray_icon.png');
  }

  // --- Context menu --------------------------------------------------------

  Future<void> _rebuildMenu() async {
    final running = _host?.state == ServiceState.running;
    await trayManager.setContextMenu(Menu(items: [
      MenuItem(label: '显示控制中心', onClick: (_) => _showControlCenter()),
      MenuItem.separator(),
      MenuItem(
        label: running ? '停止服务' : '启动服务',
        onClick: (_) => _toggleService(),
      ),
      MenuItem(label: '重启服务', onClick: (_) => _restartService()),
      MenuItem.separator(),
      MenuItem(label: '退出', onClick: (_) => _quit()),
    ]));
  }

  // --- Actions -------------------------------------------------------------

  void _showControlCenter() {
    _navKey?.currentState?.push(MaterialPageRoute(
      builder: (_) => const ControlCenterDialog(),
      fullscreenDialog: true,
    ));
  }

  Future<void> _toggleService() async {
    final h = _host;
    if (h == null) return;
    h.state == ServiceState.running
        ? await h.stopService()
        : await h.startService();
  }

  Future<void> _restartService() async => _host?.restartService();

  void _quit() {
    _host?.stopService();
    // Let the process terminate naturally; exit(0) is a blunt fallback.
    Future.delayed(const Duration(milliseconds: 500), () {
      // ignore: avoid_exit
      // Use dart:io exit only as last resort.
    });
  }

  // --- TrayListener --------------------------------------------------------

  @override
  void onTrayIconMouseDown() => trayManager.popUpContextMenu();
  @override
  void onTrayIconMouseUp() {}
  @override
  void onTrayIconRightMouseDown() => trayManager.popUpContextMenu();
  @override
  void onTrayIconRightMouseUp() {}
  @override
  void onTrayMenuItemClick(MenuItem menuItem) {}
}
