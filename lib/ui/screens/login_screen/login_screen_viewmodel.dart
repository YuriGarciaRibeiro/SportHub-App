import 'package:sporthub/core/app_export.dart';

import '../../../core/base_view_model.dart';
import '../../../services/auth_service.dart';

class LoginScreenViewModel extends BaseViewModel {
  final _authService = AuthService();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    
    try {
      final result = await _authService.login(email.trim(), password);
      
      if (result.success) {
        return true;
      } else {
        setError(result.message);
        return false;
      }
    } catch (e) {
      setError('Erro inesperado. Tente novamente.');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> forgotPassword() async {
    setError('Funcionalidade em desenvolvimento');
  }
}
