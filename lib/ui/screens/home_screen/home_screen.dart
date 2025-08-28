import 'package:flutter/material.dart';
import 'package:sporthub/widgets/theme_toggle_widget.dart';

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
        return DashboardTab(
          onNavigateToSearch: () => _onBottomNavTap(1),
        );
      case 1:
        return SearchTab();
      case 2:
        return ReservationsTab();
      case 3:
        return ProfileTab();
      default:
        return DashboardTab(
          onNavigateToSearch: () => _onBottomNavTap(1),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _getCurrentScreen()
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        selectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _currentIndex == 0 ? 'home' : 'home_outlined',
              color: _currentIndex == 0
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onSurface
                      .withOpacity(0.6),
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _currentIndex == 1 ? 'search' : 'search',
              color: _currentIndex == 1
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onSurface
                      .withOpacity(0.6),
              size: 24,
            ),
            label: 'Pesquisar',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _currentIndex == 2 ? 'event' : 'event_outlined',
              color: _currentIndex == 2
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onSurface
                      .withOpacity(0.6),
              size: 24,
            ),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _currentIndex == 3 ? 'person' : 'person_outline',
              color: _currentIndex == 3
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onSurface
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
