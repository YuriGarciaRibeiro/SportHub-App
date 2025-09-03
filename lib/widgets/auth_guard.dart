import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../ui/screens/login_screen/login_screen.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  
  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    return FutureBuilder<bool>(
      future: authService.checkAuthStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasData && snapshot.data == true) {
          return child;
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
