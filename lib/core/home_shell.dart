import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_glass_navbar/native_glass_navbar.dart';

import '../features/cron/cron_page.dart';
import '../features/monitor/monitor_page.dart';
import '../features/settings/settings_view.dart';
import '../features/xianyu/xianyu_search_page.dart';
import '../services/api_provider.dart';

/// Root tab shell: 首页 / 电脑 / 定时 / 闲鱼 / 设置.
///
/// The 定时 tab only appears when the host reports CronBox installed
/// (`GET /api/capabilities`), so the app never offers a screen that would just
/// fail. Capabilities load asynchronously; until they arrive the tab is
/// absent, which is the same as the host not having it.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasCron =
        ref.watch(capabilitiesProvider).valueOrNull?.cronbox ?? false;

    final pages = <Widget>[
      const MonitorPage(),
      const DevicesPage(),
      if (hasCron) const CronPage(),
      const XianyuSearchPage(),
      const SettingsView(),
    ];
    final glassTabs = <NativeGlassNavBarItem>[
      const NativeGlassNavBarItem(label: '首页', symbol: 'square.grid.2x2'),
      const NativeGlassNavBarItem(label: '电脑', symbol: 'laptopcomputer'),
      if (hasCron)
        const NativeGlassNavBarItem(label: '定时', symbol: 'clock'),
      const NativeGlassNavBarItem(label: '闲鱼', symbol: 'storefront'),
      const NativeGlassNavBarItem(label: '设置', symbol: 'gearshape'),
    ];
    final destinations = <NavigationDestination>[
      const NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: '首页',
      ),
      const NavigationDestination(
        icon: Icon(Icons.computer_outlined),
        selectedIcon: Icon(Icons.computer),
        label: '电脑',
      ),
      if (hasCron)
        const NavigationDestination(
          icon: Icon(Icons.schedule_outlined),
          selectedIcon: Icon(Icons.schedule),
          label: '定时',
        ),
      const NavigationDestination(
        icon: Icon(Icons.storefront_outlined),
        selectedIcon: Icon(Icons.storefront),
        label: '闲鱼',
      ),
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: '设置',
      ),
    ];

    // The tab count changes when capabilities arrive; clamp so a selection made
    // before that can't point past the end of the list.
    final index = _index.clamp(0, pages.length - 1);

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NativeGlassNavBar(
        currentIndex: index,
        onTap: _select,
        tintColor: theme.colorScheme.primary,
        tabs: glassTabs,
        fallback: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: _select,
          destinations: destinations,
        ),
      ),
    );
  }
}
