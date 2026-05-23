import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/ha_bottom_nav.dart';
import '../../../../core/constants/app_routes.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.store)) return 1;
    if (location.startsWith(AppRoutes.orders)) return 2;
    if (location.startsWith(AppRoutes.support)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.store);
        break;
      case 2:
        context.go(AppRoutes.orders);
        break;
      case 3:
        context.go(AppRoutes.support);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: HaBottomNav(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
