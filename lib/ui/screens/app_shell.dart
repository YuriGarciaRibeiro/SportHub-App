import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_export.dart';
import '../../widgets/app_navigation_bar.dart';
import '../../core/routes/app_router.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int get _currentIndex {
    final route = GoRouterState.of(context).fullPath;
    switch (route) {
      case AppRouter.home:
        return 0;
      case AppRouter.search:
        return 1;
      case AppRouter.reservations:
        return 2;
      case AppRouter.profile:
        return 3;
      default:
        return 0;
    }
  }

  void _onTabTapped(int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.home);
        break;
      case 1:
        context.go(AppRouter.search);
        break;
      case 2:
        context.go(AppRouter.reservations);
        break;
      case 3:
        context.go(AppRouter.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: AppNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
