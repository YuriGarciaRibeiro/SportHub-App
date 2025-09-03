import 'package:sporthub/core/app_export.dart';
import 'package:sporthub/ui/screens/home_screen/home_screen.dart';
import 'package:sporthub/ui/screens/login_screen/login_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String history = '/history';
  static const String login = '/login';

  Map<String, Widget Function(BuildContext)> get routes {
    return {
      AppRoutes.login: (context) => const LoginScreen(),
      AppRoutes.home: (context) => const HomeScreen(),
    };
  } 
}
