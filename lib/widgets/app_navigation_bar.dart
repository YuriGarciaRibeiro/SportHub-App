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
      backgroundColor: Colors.transparent,
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        NavigationDestination(
          icon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomIconWidget(
              iconName: 'home_outlined',
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
          ),
          selectedIcon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomIconWidget(
              iconName: 'home',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomIconWidget(
              iconName: 'search',
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
          ),
          selectedIcon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomIconWidget(
              iconName: 'search',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          label: 'Pesquisar',
        ),
        NavigationDestination(
          icon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomIconWidget(
              iconName: 'event_outlined',
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
          ),
          selectedIcon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomIconWidget(
              iconName: 'event',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          label: 'Reservas',
        ),
        NavigationDestination(
          icon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomIconWidget(
              iconName: 'person_outline',
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
          ),
          selectedIcon: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomIconWidget(
              iconName: 'person',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
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
        child: buildMaterial(
          context: context,
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }
}
