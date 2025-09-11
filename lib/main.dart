import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/core/routes/app_poutes.dart';
import 'ui/screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/global_notification_provider.dart';
import 'widgets/app_wrapper.dart';
import 'ui/screens/dashboard/dashboard_view_model.dart';
import 'ui/screens/search/search_view_model.dart';
import 'ui/screens/reservations/reservations_view_model.dart';
import 'ui/screens/profile/profile_view_model.dart';
import 'ui/screens/login_screen/login_screen_viewmodel.dart';
import 'ui/screens/establishment_detail_screen/establishment_detail_view_model.dart';

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
        // Global Notification Provider
        ChangeNotifierProvider(create: (context) => GlobalNotificationProvider()),
        
        // Theme Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        
        // ViewModels
        ChangeNotifierProvider(create: (context) => DashboardViewModel()),
        ChangeNotifierProvider(create: (context) => SearchViewModel()),
        ChangeNotifierProvider(create: (context) => ReservationsViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => LoginScreenViewModel()),
        ChangeNotifierProvider(create: (context) => EstablishmentDetailViewModel()),
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
                home: const AppWrapper(child: SplashScreen()),
                routes: AppRoutes().routes,
                builder: (context, child) {
                  return AppWrapper(child: child ?? const SizedBox.shrink());
                },
              );
            },
          );
        },
      ),
    );
  }
}


