import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/home_screen.dart';
import 'services/auth_service.dart';

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
    return MaterialApp(
      title: 'SportHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}


