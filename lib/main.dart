import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/core/routes/app_poutes.dart';
import 'ui/screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'ui/screens/home_screen/tabs/dashboard/dashboard_view_model.dart';
import 'ui/screens/home_screen/tabs/search/search_view_model.dart';
import 'ui/screens/home_screen/tabs/reservations/reservations_view_model.dart';
import 'ui/screens/home_screen/tabs/profile/profile_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar o AuthService
  await AuthService().initialize();
  
  runApp(const SportHubApp());
}

class SportHubApp extends StatelessWidget {
  const SportHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        
        // ViewModels
        ChangeNotifierProvider(create: (context) => DashboardViewModel()),
        ChangeNotifierProvider(create: (context) => SearchViewModel()),
        ChangeNotifierProvider(create: (context) => ReservationsViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Sizer(
            builder: (context, orientation, deviceType) {
              return MaterialApp(
                title: 'SportHub',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode,
                home: const SplashScreen(),
                routes: AppRoutes().routes,
              );
            },
          );
        },
      ),
    );
  }
}


