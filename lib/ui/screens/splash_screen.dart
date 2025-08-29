import 'package:flutter/material.dart';
import '../../widgets/app_logo.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Configurar animações
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Iniciar animação
    _animationController.forward();

    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    final isLoggedIn = await AuthService().checkAuthStatus();
    if (!mounted) return;
    Navigator.of(context)
      .pushReplacementNamed(isLoggedIn ? '/home' : '/login');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo animado
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const AppLogo(
                        size: 120,
                        borderRadius: 25,
                        shadowOpacity: 0.3,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 30),
              
              // Nome do app
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'SportHub',
                  style: theme.textTheme.headlineLarge?.copyWith(
                        letterSpacing: 2,
                      ) ??
                      const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Subtítulo
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Seu hub esportivo completo',
                  style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        letterSpacing: 1,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ) ??
                      TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Indicador de carregamento
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onSurface),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
