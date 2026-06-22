import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'services/host_service.dart';
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
    if (Platform.isMacOS) {
      // Defer until after the first frame — the Flutter engine must be fully
      // ready before TrayManager talks to AppKit.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TrayService.instance.init(
          appNavigatorKey,
          ref.read(hostServiceProvider),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Agent Port',
      themeMode: ThemeMode.dark,
      theme: AgentPortTheme.dark,
      darkTheme: AgentPortTheme.dark,
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}
