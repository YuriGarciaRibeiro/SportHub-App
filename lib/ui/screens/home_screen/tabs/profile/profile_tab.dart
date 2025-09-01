import 'package:sizer/sizer.dart';
import 'package:sporthub/services/auth_service.dart';
import 'widgets/user_configs_card.dart';
import 'widgets/user_icon_area.dart';

import '../../../../../core/app_export.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          UserIconArea(
            userName: _authService.currentUserName ?? 'Usuário',
            userEmail: _authService.currentUserEmail ?? 'usuario@email.com',
          ),
           SizedBox(height: 2.h),
          Text(
            'Configurações',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),
          
          UserConfigsCard(),
          
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
