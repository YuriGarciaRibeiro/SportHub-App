import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/core/routes/app_poutes.dart';
import 'ui/screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';

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
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
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


