import 'package:sizer/sizer.dart';
import 'profile_view_model.dart';
import 'widgets/user_icon_area.dart';
import 'widgets/user_stats_section.dart';
import 'widgets/profile_section.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/account_actions_section.dart';
import 'widgets/profile_error_state.dart';
import 'widgets/profile_loading_state.dart';
import '../../../core/app_export.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              ? const ProfileLoadingState()
              : viewModel.hasError
                  ? ProfileErrorState(viewModel: viewModel)
                  : RefreshIndicator(
                      onRefresh: () => viewModel.refreshProfile(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            children: [
                              UserIconArea(
                                userEmail: viewModel.userProfile?.email ?? '',
                                userName: viewModel.userProfile?.name ?? '',
                              ),
                              
                              SizedBox(height: 3.h),
                              
                              UserStatsSection(viewModel: viewModel),
                              
                              SizedBox(height: 3.h),
                              
                              ProfileSection(
                                title: 'Configurações da Conta',
                                children: [
                                  ProfileMenuItem(
                                    icon: Icons.person,
                                    title: 'Editar Perfil',
                                    subtitle: 'Nome, telefone, esporte favorito',
                                    onTap: () => viewModel.navigateToEditProfile(),
                                  ),
                                  ProfileMenuItem(
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
                              
                              ProfileSection(
                                title: 'Aparência',
                                children: [
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
                                  ProfileMenuItem(
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
                              
                              ProfileSection(
                                title: 'Atividade',
                                children: [
                                  ProfileMenuItem(
                                    icon: Icons.history,
                                    title: 'Histórico de Reservas',
                                    subtitle: 'Ver todas as reservas',
                                    onTap: () => viewModel.navigateToReservationHistory(),
                                  ),
                                  ProfileMenuItem(
                                    icon: Icons.favorite,
                                    title: 'Estabelecimentos Favoritos',
                                    subtitle: 'Seus locais preferidos',
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 2.h),
                              
                              ProfileSection(
                                title: 'Suporte',
                                children: [
                                  ProfileMenuItem(
                                    icon: Icons.help,
                                    title: 'Ajuda',
                                    subtitle: 'FAQ e suporte',
                                    onTap: () {},
                                  ),
                                  ProfileMenuItem(
                                    icon: Icons.info,
                                    title: 'Sobre',
                                    subtitle: 'Versão do app e informações',
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 3.h),
                              
                              AccountActionsSection(viewModel: viewModel),
                              
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
}
