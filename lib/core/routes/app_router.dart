import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sporthub/models/establishment.dart';
import 'package:sporthub/ui/screens/all_establishments/all_establishments_screen.dart';
import 'package:sporthub/ui/screens/establishment_detail_screen/establishment_detail_screen.dart';
import 'package:sporthub/ui/screens/splash_screen.dart';
import 'package:sporthub/ui/screens/login_screen/login_screen.dart';
import 'package:sporthub/ui/screens/app_shell.dart';
import 'package:sporthub/ui/screens/dashboard/dashboard_screen.dart';
import 'package:sporthub/ui/screens/search/search_screen.dart';
import 'package:sporthub/ui/screens/reservations/reservations_screen.dart';
import 'package:sporthub/ui/screens/profile/profile_screen.dart';
import 'package:sporthub/services/auth_service.dart';

/// Helper function para criar páginas adaptáveis baseadas na plataforma
/// Automaticamente aplica SafeArea a menos que seja explicitamente desabilitado
Page<dynamic> createPlatformPage({
  required BuildContext context,
  required Widget child,
  LocalKey? key,
  bool useSafeArea = true,
}) {
  final platform = Theme.of(context).platform;
  
  // Aplica SafeArea automaticamente, exceto quando explicitamente desabilitado
  final wrappedChild = useSafeArea ? SafeArea(child: child) : child;
  
  if (platform == TargetPlatform.iOS) {
    return CupertinoPage(
      key: key,
      child: wrappedChild,
    );
  } else {
    return MaterialPage(
      key: key,
      child: wrappedChild,
    );
  }
}

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String reservations = '/reservations';
  static const String profile = '/profile';
  static const String establishmentDetail = '/establishment/:id';
  static const String allEstablishmentsScreen = '/all-establishments/:title/:establishments';

  static final GoRouter _router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final authService = AuthService();
      final isLoggedIn = authService.isLoggedIn;
      final isGoingToLogin = state.fullPath == login;
      final isOnSplash = state.fullPath == splash;

      // Se não está logado e não está indo para login ou splash, redireciona para login
      if (!isLoggedIn && !isGoingToLogin && !isOnSplash) {
        return login;
      }

      // Se está logado e está tentando acessar login, redireciona para home
      if (isLoggedIn && isGoingToLogin) {
        return home;
      }

      return null; // Não redireciona
    },
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Shell route para as telas principais com bottom navigation
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            pageBuilder: (context, state) => createPlatformPage(
              context: context,
              key: state.pageKey,
              child: const DashboardScreen(),
            ),
          ),
          GoRoute(
            path: search,
            name: 'search',
            pageBuilder: (context, state) => createPlatformPage(
              context: context,
              key: state.pageKey,
              child: const SearchScreen(),
            ),
          ),
          GoRoute(
            path: reservations,
            name: 'reservations',
            pageBuilder: (context, state) => createPlatformPage(
              context: context,
              key: state.pageKey,
              child: const ReservationsScreen(),
            ),
          ),
          GoRoute(
            path: profile,
            name: 'profile',
            pageBuilder: (context, state) => createPlatformPage(
              context: context,
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
          path: allEstablishmentsScreen,
          name: 'all-establishments',
          pageBuilder: (context, state) {
            final title = state.pathParameters['title'] ?? 'Estabelecimentos';
            final establishments = Establishment.listFromJsonString(
              state.pathParameters['establishments'] ?? '[]',
            );
            return createPlatformPage(
              context: context,
              key: state.pageKey,
              child: AllEstablishmentsScreen(
                title: title,
                establishments: establishments,
              ),
            );
          },
        ),
      
      GoRoute(
        path: establishmentDetail,
        name: 'establishment-detail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return createPlatformPage(
            context: context,
            key: state.pageKey,
            child: EstablishmentDetailScreen(establishmentId: id),
          );
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}