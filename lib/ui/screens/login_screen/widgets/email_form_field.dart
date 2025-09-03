import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sporthub/widgets/platform_widget.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    String? validate(String? v) {
      final s = (v ?? '').trim();
      if (s.isEmpty) return 'Por favor, insira seu email';
      final re = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$');
      if (!re.hasMatch(s)) return 'Por favor, insira um email válido';
      return null;
    }

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return PlatformWidget(
      android: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.email],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'Digite seu email',
          prefixIcon: Icon(Icons.email_outlined, color: cs.primary),
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
        validator: validate,
        textCapitalization: TextCapitalization.none,
        enableSuggestions: false,
        autocorrect: false,
      ),

      ios: FormField<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validate,
        builder: (state) {
          final baseTextColor = cs.onSurface;
          final placeholderColor = baseTextColor.withOpacity(0.6);
          final bg = cs.surfaceVariant.withOpacity(theme.brightness == Brightness.dark ? 0.24 : 1.0);
          final borderColor = state.hasError ? cs.error : cs.outline;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CupertinoTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                placeholder: 'Digite seu email',
                placeholderStyle: TextStyle(color: placeholderColor, fontSize: 16),
                style: TextStyle(color: baseTextColor, fontSize: 16),
                prefix: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(CupertinoIcons.envelope, size: 20, color: cs.primary),
                ),
                clearButtonMode: OverlayVisibilityMode.editing,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                cursorColor: cs.primary,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1.2),
                ),
                onChanged: state.didChange,
                autofillHints: const [AutofillHints.email],
                textCapitalization: TextCapitalization.none,
                enableSuggestions: false,
                autocorrect: false,
              ),
              if (state.hasError) const SizedBox(height: 4),
              if (state.hasError)
                Text(
                  state.errorText ?? ' ',
                  style: TextStyle(color: cs.error, fontSize: 12),
                ),
            ],
          );
        },
      ),
    );
  }
}
