import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/monitor/monitor_page.dart';
import '../features/pane_detail/pane_detail_page.dart';
import '../features/settings/settings_view.dart';

/// Shared navigator key so the [TrayService] can open the control-center
/// window without holding a BuildContext.
final appNavigatorKey = GlobalKey<NavigatorState>();

/// App router. Monitor list + pane detail + settings.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: appNavigatorKey,
    initialLocation: '/',
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('找不到页面')),
      body: Center(child: Text('路径无效:${state.uri.path}')),
    ),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MonitorPage(),
      ),
      GoRoute(
        path: '/pane/:paneId',
        builder: (context, state) =>
            PaneDetailPage(paneId: state.pathParameters['paneId']!),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
});
