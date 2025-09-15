import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sporthub/ui/screens/splash_screen.dart';
import 'package:sporthub/ui/screens/login_screen/login_screen.dart';
import 'package:sporthub/ui/screens/app_shell.dart';
import 'package:sporthub/ui/screens/dashboard/dashboard_screen.dart';
import 'package:sporthub/ui/screens/search/search_screen.dart';
import 'package:sporthub/ui/screens/reservations/reservations_screen.dart';
import 'package:sporthub/ui/screens/profile/profile_screen.dart';
import 'package:sporthub/services/auth_service.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String reservations = '/reservations';
  static const String profile = '/profile';
  static const String establishmentDetail = '/establishment/:id';

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
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const DashboardScreen(),
            ),
          ),
          GoRoute(
            path: search,
            name: 'search',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SearchScreen(),
            ),
          ),
          GoRoute(
            path: reservations,
            name: 'reservations',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ReservationsScreen(),
            ),
          ),
          GoRoute(
            path: profile,
            name: 'profile',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
      
      // Rotas adicionais fora do shell (sem bottom navigation)
      GoRoute(
        path: establishmentDetail,
        name: 'establishment-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          // Importar e usar EstablishmentDetailScreen quando necessário
          return Scaffold(
            appBar: AppBar(title: Text('Estabelecimento $id')),
            body: const Center(child: Text('Detalhes do estabelecimento')),
          );
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}