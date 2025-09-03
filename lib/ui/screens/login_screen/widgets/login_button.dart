import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sporthub/widgets/platform_widget.dart';
import 'package:sporthub/ui/screens/login_screen/login_screen_viewmodel.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required LoginScreenViewModel viewModel,
    required VoidCallback handleLogin,
  })  : _viewModel = viewModel,
        _handleLogin = handleLogin;

  final LoginScreenViewModel _viewModel;
  final VoidCallback _handleLogin;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PlatformWidget(
      android: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _viewModel.isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            minimumSize: const Size.fromHeight(50),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: _viewModel.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Entrar'),
        ),
      ),
      ios: SizedBox(
        width: double.infinity,
        height: 50,
        child: CupertinoButton(
          onPressed: _viewModel.isLoading ? null : _handleLogin,
          padding: EdgeInsets.zero,
          color: cs.primary,
          disabledColor: cs.primary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          child: _viewModel.isLoading
              ? CupertinoActivityIndicator(radius: 10, color: cs.onPrimary)
              : Text(
                  'Entrar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onPrimary),
                ),
        ),
      ),
    );
  }
}
