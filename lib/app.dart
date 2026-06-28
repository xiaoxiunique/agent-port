import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'services/api_provider.dart';
import 'services/host_service.dart';
import 'services/push_service.dart';
import 'services/settings_service.dart';
import 'services/tray_service.dart';

class AgentPortApp extends ConsumerStatefulWidget {
  const AgentPortApp({super.key});

  @override
  ConsumerState<AgentPortApp> createState() => _AgentPortAppState();
}

class _AgentPortAppState extends ConsumerState<AgentPortApp> {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb && Platform.isMacOS) {
      // Defer until after the first frame — the Flutter engine must be fully
      // ready before TrayManager talks to AppKit.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final host = ref.read(hostServiceProvider);
        TrayService.instance.init(appNavigatorKey, host);
        // Host app supervises its own Rust service — start it on launch.
        host.startService();
      });
    }
    if (!kIsWeb && Platform.isIOS) {
      // Request push permission + register the APNs token with the server.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(pushServiceProvider).init();
      });
      // Re-register the token whenever the active server profile changes.
      ref.listenManual(apiProvider, (_, _) {
        ref.read(pushServiceProvider).reregister();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Keep-screen-awake toggle (mobile only; no-op elsewhere).
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      final keepAwake =
          ref.watch(settingsProvider.select((s) => s.valueOrNull?.keepScreenAwake ?? false));
      WakelockPlus.toggle(enable: keepAwake);
    }
    return MaterialApp.router(
      title: 'Agent Port',
      themeMode: ThemeMode.system,
      theme: AgentPortTheme.light,
      darkTheme: AgentPortTheme.dark,
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}
