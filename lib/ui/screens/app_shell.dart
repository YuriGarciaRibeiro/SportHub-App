import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_navigation_bar.dart';
import 'dashboard/dashboard_screen.dart';
import 'search/search_screen.dart';
import 'reservations/reservations_screen.dart';
import 'profile/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _NavigationObserver extends NavigatorObserver {
  final VoidCallback onRouteChanged;
  
  _NavigationObserver(this.onRouteChanged);
  
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    onRouteChanged();
  }
  
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    onRouteChanged();
  }
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  bool _showBottomNav = true;
  
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const SearchScreen(),
    const ReservationsScreen(),
    const ProfileScreen(),
  ];

  late List<_NavigationObserver> _observers;

  @override
  void initState() {
    super.initState();
    _observers = List.generate(4, (index) => _NavigationObserver(_onRouteChanged));
  }

  void _onRouteChanged() {
    // Verifica se há rotas empilhadas na tab atual
    final currentNavigator = _navigatorKeys[_currentIndex].currentState;
    final hasStackedRoutes = currentNavigator?.canPop() ?? false;
    
    if (_showBottomNav == hasStackedRoutes) {
      setState(() {
        _showBottomNav = !hasStackedRoutes;
      });
    }
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) {
      // Se já estiver na mesma aba, volta ao root
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
    // Verifica se deve mostrar bottom nav após mudança de tab
    _onRouteChanged();
  }

  Widget _buildNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      observers: [_observers[index]], // Adiciona o observer
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => _screens[index],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: List.generate(4, (index) => _buildNavigator(index)),
        ),
      ),
      bottomNavigationBar: _showBottomNav 
        ? AppNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
          )
        : null, // Esconde a bottom navigation quando há rotas empilhadas
    );
  }
}
