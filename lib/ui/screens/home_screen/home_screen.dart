import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/search_tab.dart';
import 'tabs/reservations_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const DashboardTab();
      case 1:
        return const SearchTab();
      case 2:
        return const ReservationsTab();
      case 3:
        return const ProfileTab();
      default:
        return const DashboardTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _getCurrentScreen(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor:
            AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.6),
        selectedLabelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.bodySmall,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _currentIndex == 0 ? 'home' : 'home_outlined',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withOpacity(0.6),
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _currentIndex == 1 ? 'search' : 'search',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withOpacity(0.6),
              size: 24,
            ),
            label: 'Pesquisar',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _currentIndex == 2 ? 'event' : 'event_outlined',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withOpacity(0.6),
              size: 24,
            ),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _currentIndex == 3 ? 'person' : 'person_outline',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withOpacity(0.6),
              size: 24,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
