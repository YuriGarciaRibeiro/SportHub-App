import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeToggleWidget extends StatelessWidget {
  const ThemeToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.light_mode,
              color: !themeProvider.isDarkMode 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Switch.adaptive(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeTrackColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.dark_mode,
              color: themeProvider.isDarkMode 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey,
              size: 20,
            ),
          ],
        );
      },
    );
  }
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          icon: Icon(
            themeProvider.isDarkMode 
                ? Icons.light_mode 
                : Icons.dark_mode,
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
          tooltip: themeProvider.isDarkMode 
              ? 'Mudar para tema claro' 
              : 'Mudar para tema escuro',
        );
      },
    );
  }
}

class ThemeToggleListTile extends StatelessWidget {
  const ThemeToggleListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          leading: Icon(
            themeProvider.isDarkMode 
                ? Icons.dark_mode 
                : Icons.light_mode,
          ),
          title: const Text('Modo Escuro'),
          subtitle: Text(
            themeProvider.isDarkMode 
                ? 'Ativado' 
                : 'Desativado',
          ),
          trailing: Switch.adaptive(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
          onTap: () {
            themeProvider.toggleTheme();
          },
        );
      },
    );
  }
}
