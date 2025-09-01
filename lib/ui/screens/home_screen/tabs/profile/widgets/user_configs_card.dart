import 'package:flutter/material.dart';
import 'package:sporthub/widgets/theme_mode_dropdown.dart';

class UserConfigsCard extends StatelessWidget {
  const UserConfigsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ThemeModeDropdown(),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Idioma'),
            trailing: Text('Português'),
          ),
          const ListTile(
            leading: Icon(Icons.help),
            title: Text('Ajuda'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Sobre'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}