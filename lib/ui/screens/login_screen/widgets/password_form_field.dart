import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sporthub/widgets/platform_widget.dart';
import 'package:sporthub/ui/screens/login_screen/login_screen_viewmodel.dart';

class PasswordFormField extends StatefulWidget {
  final LoginScreenViewModel _viewModel;

  const PasswordFormField({
    super.key,
    required LoginScreenViewModel viewModel,
  }) : _viewModel = viewModel;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  String? _validate(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Por favor, insira sua senha';
    if (v.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PlatformWidget(
      android: TextFormField(
        controller: widget._viewModel.passwordController,
        obscureText: widget._viewModel.obscurePassword,
        textInputAction: TextInputAction.done,
        autofillHints: const [AutofillHints.password],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: 'Senha',
          hintText: 'Digite sua senha',
          prefixIcon: Icon(Icons.lock_outlined, color: cs.primary),
          suffixIcon: IconButton(
            icon: Icon(
              widget._viewModel.obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: cs.primary,
            ),
            onPressed: () {
              setState(() {
                widget._viewModel.togglePasswordVisibility();
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.error, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: _validate,
        enableSuggestions: false,
        autocorrect: false,
      ),

      ios: FormField<String>(
        initialValue: widget._viewModel.passwordController.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: _validate,
        builder: (state) {
          final bg = Theme.of(context).brightness == Brightness.dark
              ? cs.surfaceVariant.withOpacity(0.24)
              : cs.surfaceVariant;
          final borderColor = state.hasError ? cs.error : cs.outline;
          final baseTextColor = cs.onSurface;
          final placeholderColor = baseTextColor.withOpacity(0.6);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CupertinoTextField(
                controller: widget._viewModel.passwordController,
                obscureText: widget._viewModel.obscurePassword,
                placeholder: 'Digite sua senha',
                placeholderStyle: TextStyle(color: placeholderColor, fontSize: 16),
                style: TextStyle(color: baseTextColor, fontSize: 16),
                prefix: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(CupertinoIcons.lock, size: 20, color: cs.primary),
                ),
                suffix: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minSize: 0,
                  onPressed: () {
                    setState(() {
                      widget._viewModel.togglePasswordVisibility();
                    });
                  },
                  child: Icon(
                    widget._viewModel.obscurePassword ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                    size: 20,
                    color: cs.primary,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                cursorColor: cs.primary,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1.2),
                ),
                onChanged: state.didChange,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                enableSuggestions: false,
                autocorrect: false,
              ),
              if (state.hasError) const SizedBox(height: 4),
              if (state.hasError)
                Text(
                  state.errorText ?? '',
                  style: TextStyle(color: cs.error, fontSize: 12),
                ),
            ],
          );
        },
      ),
    );
  }
}
