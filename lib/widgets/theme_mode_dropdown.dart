import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Dropdown para escolher entre Sistema, Claro e Escuro
class ThemeModeDropdown extends StatelessWidget {
  final bool dense;
  final EdgeInsetsGeometry? padding;

  const ThemeModeDropdown({super.key, this.dense = false, this.padding});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final items = <_ThemeOption>[
          _ThemeOption(ThemeMode.system, 'Sistema', Icons.settings_suggest_outlined),
          _ThemeOption(ThemeMode.light, 'Claro', Icons.light_mode_outlined),
          _ThemeOption(ThemeMode.dark, 'Escuro', Icons.dark_mode_outlined),
        ];

        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: DropdownButtonFormField<ThemeMode>(
            value: themeProvider.themeMode,
            isDense: dense,
            decoration: InputDecoration(
              labelText: 'Tema',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: dense
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: items
                .map((opt) => DropdownMenuItem<ThemeMode>(
                      value: opt.mode,
                      child: Row(
                        children: [
                          Icon(opt.icon, size: 20),
                          const SizedBox(width: 8),
                          Text(opt.label),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (mode) {
              if (mode != null) themeProvider.setThemeMode(mode);
            },
          ),
        );
      },
    );
  }
}

class _ThemeOption {
  final ThemeMode mode;
  final String label;
  final IconData icon;
  _ThemeOption(this.mode, this.label, this.icon);
}
