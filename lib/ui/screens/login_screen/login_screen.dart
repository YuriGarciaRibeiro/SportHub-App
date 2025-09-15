
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:sporthub/ui/screens/login_screen/widgets/email_form_field.dart';
import 'package:sporthub/ui/screens/login_screen/widgets/login_button.dart';
import 'package:sporthub/ui/screens/login_screen/widgets/password_form_field.dart';
import '../../../widgets/app_logo.dart';
import '../../../core/routes/app_router.dart';
import 'login_screen_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Login screen não precisa de inicialização especial
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = Provider.of<LoginScreenViewModel>(context, listen: false);
    final success = await viewModel.login(
      viewModel.emailController.text.trim(),
      viewModel.passwordController.text,
    );

    if (mounted) {
      if (success) {
        // Login bem-sucedido
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login realizado com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
        context.go(AppRouter.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage ?? 'Erro no login'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    // TODO: [Facilidade: 3, Prioridade: 4] - Implementar funcionalidade "Esqueci minha senha"
    // TODO: [Facilidade: 2, Prioridade: 4] - Adicionar validação de email antes de enviar reset
    final viewModel = Provider.of<LoginScreenViewModel>(context, listen: false);
    await viewModel.forgotPassword();
    
    if (mounted && viewModel.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage!),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Consumer<LoginScreenViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  
                  // Logo e título
                  Center(
                    child: Column(
                      children: [
                        const AppLogo(size: 100, borderRadius: 20),

                        SizedBox(height: 2.h),

                        Text(
                          'SportHub',
                          style: theme.textTheme.headlineLarge,
                        ),

                        SizedBox(height: 5.h),

                        Text(
                          'Entre na sua conta',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),

                        SizedBox(height: 1.h),
                      ],
                    ),
                  ),

                  // Formulário de login
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        EmailFormField(emailController: viewModel.emailController),

                        SizedBox(height: 1.8.h),

                        PasswordFormField(viewModel: viewModel),

                        SizedBox(height: 0.5.h),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _handleForgotPassword,
                            style: TextButton.styleFrom(
                              foregroundColor: theme.primaryColor,
                            ),
                            child: const Text('Esqueci minha senha'),
                          ),
                        ),

                        SizedBox(height: 0.5.h),

                        // Botão de login
                        LoginButton(
                          viewModel: viewModel,
                          handleLogin: _handleLogin,
                        ),

                        const SizedBox(height: 24),
                        
                        // TODO: [Facilidade: 4, Prioridade: 4] - Implementar tela de registro de usuário
                        // TODO: [Facilidade: 4, Prioridade: 3] - Implementar login social (Google, Facebook, Apple)
                        
                        // usuarios de teste
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Contas de teste:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• admin@sporthub.com - Admin@124365\n',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
