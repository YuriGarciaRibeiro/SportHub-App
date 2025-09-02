// home_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:sporthub/widgets/platform_widget.dart';
import '../../../core/app_export.dart';
import '../../../widgets/app_navigation_bar.dart';
import 'tabs/dashboard/dashboard_tab.dart';
import 'tabs/search/search_tab.dart';
import 'tabs/reservations/reservations_tab.dart';
import 'tabs/profile/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _cupertinoController = CupertinoTabController();

  @override
  void initState() {
    super.initState();
    _cupertinoController.index = _currentIndex;
    _cupertinoController.addListener(() {
      if (_currentIndex != _cupertinoController.index) {
        setState(() => _currentIndex = _cupertinoController.index);
      }
    });
  }

  Widget _screenFor(int index) {
    switch (index) {
      case 0:
        return DashboardTab(onNavigateToSearch: () => _onBottomNavTap(1));
      case 1:
        return const SearchTab();
      case 2:
        return const ReservationsTab();
      case 3:
        return const ProfileTab();
      default:
        return DashboardTab(onNavigateToSearch: () => _onBottomNavTap(1));
    }
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);
    _cupertinoController.index = index; // mantém iOS e Android em sincronia
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      android: Scaffold(
        body: SafeArea(child: _screenFor(_currentIndex)),
        bottomNavigationBar: AppNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTap,
        ),
      ),

      ios: CupertinoTabScaffold(
        controller: _cupertinoController,
        tabBar: AppNavigationBar.buildCupertino(context: context, currentIndex: _currentIndex, onTap: _onBottomNavTap),
        tabBuilder: (context, index) {
          return SafeArea(
            child: CupertinoTabView(
              builder: (context) => _screenFor(index),
            ),
          );
        },
      ),
    );
  }
}
