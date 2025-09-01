import 'package:sizer/sizer.dart';
import 'package:sporthub/ui/screens/home_screen/tabs/profile/profile_view_model.dart';
import '../../../../../core/app_export.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
      viewModel.initializeProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: viewModel.isLoading && viewModel.userProfile == null
              ? const Center(child: CircularProgressIndicator())
              : viewModel.hasError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Erro ao carregar perfil',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            viewModel.errorMessage ?? 'Erro desconhecido',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Theme.of(context).hintColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                          ElevatedButton(
                            onPressed: () => viewModel.refreshProfile(),
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => viewModel.refreshProfile(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            children: [
                              _buildProfileHeader(viewModel),
                              
                              SizedBox(height: 3.h),
                              
                              _buildUserStats(viewModel),
                              
                              SizedBox(height: 3.h),
                              _buildProfileSection(
                                'Configurações da Conta',
                                [
                                  _buildMenuItem(
                                    icon: Icons.person,
                                    title: 'Editar Perfil',
                                    subtitle: 'Nome, telefone, esporte favorito',
                                    onTap: () => viewModel.navigateToEditProfile(),
                                  ),
                                  _buildMenuItem(
                                    icon: Icons.notifications,
                                    title: 'Notificações',
                                    subtitle: viewModel.notificationsEnabled 
                                        ? 'Ativadas' 
                                        : 'Desativadas',
                                    trailing: Switch(
                                      value: viewModel.notificationsEnabled,
                                      onChanged: (value) => viewModel.updateNotificationSettings(value),
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 2.h),
                              
                              _buildProfileSection(
                                'Aparência',
                                [
                                  ListTile(
                                    leading: Icon(Icons.palette, color: Theme.of(context).primaryColor),
                                    title: Text(
                                      'Tema',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: const ThemeModeDropdown(
                                      dense: true,
                                      padding: EdgeInsets.only(top: 8),
                                    ),
                                  ),
                                  _buildMenuItem(
                                    icon: Icons.language,
                                    title: 'Idioma',
                                    subtitle: _getLanguageLabel(viewModel.selectedLanguage),
                                    trailing: DropdownButton<String>(
                                      value: viewModel.selectedLanguage,
                                      underline: Container(),
                                      items: const [
                                        DropdownMenuItem(value: 'pt', child: Text('Português')),
                                        DropdownMenuItem(value: 'en', child: Text('English')),
                                        DropdownMenuItem(value: 'es', child: Text('Español')),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) viewModel.updateLanguage(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 2.h),
                              
                              _buildProfileSection(
                                'Atividade',
                                [
                                  _buildMenuItem(
                                    icon: Icons.history,
                                    title: 'Histórico de Reservas',
                                    subtitle: 'Ver todas as reservas',
                                    onTap: () => viewModel.navigateToReservationHistory(),
                                  ),
                                  _buildMenuItem(
                                    icon: Icons.favorite,
                                    title: 'Estabelecimentos Favoritos',
                                    subtitle: 'Seus locais preferidos',
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 2.h),
                              
                              _buildProfileSection(
                                'Suporte',
                                [
                                  _buildMenuItem(
                                    icon: Icons.help,
                                    title: 'Ajuda',
                                    subtitle: 'FAQ e suporte',
                                    onTap: () {},
                                  ),
                                  _buildMenuItem(
                                    icon: Icons.info,
                                    title: 'Sobre',
                                    subtitle: 'Versão do app e informações',
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 3.h),
                              
                              if (viewModel.isLoggedIn) ...[
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () => _showLogoutDialog(viewModel),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                    ),
                                    child: const Text('Sair da Conta'),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () => _showDeleteAccountDialog(viewModel),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red.withOpacity(0.7),
                                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                    ),
                                    child: const Text('Excluir Conta'),
                                  ),
                                ),
                              ],
                              
                              SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildProfileHeader(ProfileViewModel viewModel) {
    final user = viewModel.userProfile;
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40.sp,
            backgroundColor: Colors.white,
            backgroundImage: user?.profileImageUrl != null 
                ? NetworkImage(user!.profileImageUrl!)
                : null,
            child: user?.profileImageUrl == null
                ? Icon(
                    Icons.person,
                    size: 40.sp,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
          ),
          
          SizedBox(height: 2.h),
          
          Text(
            user?.name ?? 'Usuário',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          Text(
            user?.email ?? 'email@exemplo.com',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          
          SizedBox(height: 1.h),
          
          if (user?.preferredSport != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user!.preferredSport!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserStats(ProfileViewModel viewModel) {
    final stats = viewModel.getUserStats();
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem('Reservas', stats['totalReservations'].toString())),
          Expanded(child: _buildStatItem('Favoritos', stats['favoriteEstablishments'].toString())),
          Expanded(child: _buildStatItem('Pontos', stats['points'].toString())),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: Theme.of(context).hintColor,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  String _getLanguageLabel(String language) {
    switch (language) {
      case 'pt':
        return 'Português';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return 'Português';
    }
  }

  void _showLogoutDialog(ProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.logout();
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(ProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Conta'),
        content: const Text(
          'Esta ação é irreversível. Todos os seus dados serão permanentemente removidos. Tem certeza que deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.deleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
