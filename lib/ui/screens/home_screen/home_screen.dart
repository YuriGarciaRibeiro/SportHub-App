import '../../../core/app_export.dart';
import 'tabs/dashboard/dashboard_tab.dart';
import 'tabs/search/search_tab.dart';
import 'tabs/reservations/reservations_tab.dart';
import 'tabs/profile/profile_tab.dart';

// TODO: [Facilidade: 3, Prioridade: 2] - Implementar estado persistente da aba selecionada
// TODO: [Facilidade: 3, Prioridade: 2] - Adicionar animações de transição entre abas
// TODO: [Facilidade: 2, Prioridade: 1] - Implementar badges de notificação nas abas

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
        return const SearchTab();
      case 2:
        return const ReservationsTab();
      case 3:
        return const ProfileTab();
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
    // TODO: [Facilidade: 3, Prioridade: 2] - Implementar navegação com gestos de swipe
    // TODO: [Facilidade: 4, Prioridade: 2] - Adicionar efeitos visuais de seleção personalizada
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
      child: NavigationBar(
        // TODO: [Facilidade: 2, Prioridade: 1] - Adicionar badges de notificação nas abas
        selectedIndex: _currentIndex,
        onDestinationSelected: _onBottomNavTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: CustomIconWidget(
              iconName: 'home_outlined',
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
            selectedIcon: CustomIconWidget(
              iconName: 'home',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: CustomIconWidget(
              iconName: 'search',
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
            selectedIcon: CustomIconWidget(
              iconName: 'search',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            label: 'Pesquisar',
          ),
          NavigationDestination(
            icon: CustomIconWidget(
              iconName: 'event_outlined',
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
            selectedIcon: CustomIconWidget(
              iconName: 'event',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            label: 'Reservas',
          ),
          NavigationDestination(
            icon: CustomIconWidget(
              iconName: 'person_outline',
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
            selectedIcon: CustomIconWidget(
              iconName: 'person',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    // TODO: [Facilidade: 3, Prioridade: 2] - Implementar persistência da aba selecionada
    // TODO: [Facilidade: 3, Prioridade: 2] - Adicionar animações de transição entre as abas
    setState(() {
      _currentIndex = index;
    });
  }
}
