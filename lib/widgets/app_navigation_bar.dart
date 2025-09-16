// app_navigation_bar.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_icon_widget.dart';
import 'platform_widget.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap; // melhor que dynamic Function(int)

  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static CupertinoTabBar buildCupertino({
    required BuildContext context,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CupertinoTabBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      border: const Border(
        top: BorderSide(color: CupertinoColors.separator, width: 0.5),
      ),
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(currentIndex == 0 ? CupertinoIcons.house_fill : CupertinoIcons.house, size: 24),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(CupertinoIcons.search, size: 24),
          ),
          label: 'Pesquisar',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(currentIndex == 2 ? CupertinoIcons.calendar : CupertinoIcons.calendar_today, size: 24),
          ),
          label: 'Reservas',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(currentIndex == 3 ? CupertinoIcons.person_fill : CupertinoIcons.person, size: 24),
          ),
          label: 'Perfil',
        ),
      ],
    );
  }

  static NavigationBar buildMaterial({
    required BuildContext context,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      indicatorColor: Colors.transparent, // Remove o fundo colorido quando selecionado
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // Uso genérico (fora do CupertinoTabScaffold): segue como estava
    return PlatformWidget(
      ios: buildCupertino(
        context: context,
        currentIndex: currentIndex,
        onTap: onTap,
      ),
      android: Container(
        child: buildMaterial(
          context: context,
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }
}
