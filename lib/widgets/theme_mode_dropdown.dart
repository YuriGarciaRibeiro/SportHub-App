import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sporthub/widgets/platform_widget.dart';
import '../providers/theme_provider.dart';

class ThemeModeDropdown extends StatelessWidget {
  final bool dense;
  final EdgeInsetsGeometry? padding;

  const ThemeModeDropdown({
    super.key,
    this.dense = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final items = <_ThemeOption>[
          _ThemeOption(ThemeMode.system, 'Sistema', Icons.settings_suggest_outlined),
          _ThemeOption(ThemeMode.light, 'Claro', Icons.light_mode_outlined),
          _ThemeOption(ThemeMode.dark, 'Escuro', Icons.dark_mode_outlined),
        ];

        return PlatformWidget(
          android: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: DropdownButtonFormField<ThemeMode>(
              value: themeProvider.themeMode,
              isDense: dense,
              decoration: InputDecoration(
                labelText: 'Tema',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: dense
                    ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                    : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: items
                  .map(
                    (opt) => DropdownMenuItem<ThemeMode>(
                      value: opt.mode,
                      child: Row(
                        children: [
                          Icon(opt.icon, size: 20),
                          const SizedBox(width: 8),
                          Text(opt.label),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (mode) {
                if (mode != null) themeProvider.setThemeMode(mode);
              },
            ),
          ),
          ios: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!dense)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      'Tema',
                      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            fontSize: 13,
                            color: CupertinoColors.secondaryLabel,
                          ),
                    ),
                  ),
                CupertinoSlidingSegmentedControl<ThemeMode>(
                  groupValue: themeProvider.themeMode,
                  children: {
                    ThemeMode.system: _seg('Sistema', CupertinoIcons.settings_solid),
                    ThemeMode.light: _seg('Claro', CupertinoIcons.sun_max),
                    ThemeMode.dark: _seg('Escuro', CupertinoIcons.moon),
                  },
                  onValueChanged: (mode) {
                    if (mode != null) themeProvider.setThemeMode(mode);
                  },
                ),
                if (dense) const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _seg(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

class _ThemeOption {
  final ThemeMode mode;
  final String label;
  final IconData icon;
  _ThemeOption(this.mode, this.label, this.icon);
}
