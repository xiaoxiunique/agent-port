import 'package:flutter/material.dart';
import 'package:native_glass_navbar/native_glass_navbar.dart';

import '../features/monitor/monitor_page.dart';
import '../features/settings/settings_view.dart';

/// Root tab shell: 首页 / 电脑 / 设置.
///
/// On iOS this renders the native Liquid-Glass `UITabBar` via
/// [NativeGlassNavBar]; on Android / web / unsupported platforms it falls back
/// to a Material [NavigationBar].
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _pages = [
    MonitorPage(),
    DevicesPage(),
    SettingsView(),
  ];

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NativeGlassNavBar(
        currentIndex: _index,
        onTap: _select,
        tintColor: theme.colorScheme.primary,
        tabs: const [
          NativeGlassNavBarItem(label: '首页', symbol: 'square.grid.2x2'),
          NativeGlassNavBarItem(label: '电脑', symbol: 'laptopcomputer'),
          NativeGlassNavBarItem(label: '设置', symbol: 'gearshape'),
        ],
        fallback: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _select,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: '首页',
            ),
            NavigationDestination(
              icon: Icon(Icons.computer_outlined),
              selectedIcon: Icon(Icons.computer),
              label: '电脑',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: '设置',
            ),
          ],
        ),
      ),
    );
  }
}
