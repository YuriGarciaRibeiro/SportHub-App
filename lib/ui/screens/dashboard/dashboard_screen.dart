import 'package:sizer/sizer.dart';
import 'dashboard_view_model.dart';
import 'widgets/nearby_establishments_widget.dart';
import '../../../core/app_export.dart';
import '../../../models/establishment.dart';
import 'widgets/greeting_header_widget.dart';
import 'widgets/upcoming_reservations_widget.dart';
import 'widgets/quick_actions_widget.dart';
import 'widgets/quick_search_widget.dart';
import 'widgets/popular_sports_widget.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onNavigateToSearch;
  
  const DashboardScreen({super.key, this.onNavigateToSearch});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
      viewModel.initializeDashboard();
    });
  }

  bool _isEstablishmentOpen(Establishment establishment) {
    final now = TimeOfDay.now();
    final openingHour = establishment.openingTime.hour;
    final openingMinute = establishment.openingTime.minute;
    final closingHour = establishment.closingTime.hour;
    final closingMinute = establishment.closingTime.minute;
    
    final currentMinutes = now.hour * 60 + now.minute;
    final openingMinutes = openingHour * 60 + openingMinute;
    final closingMinutes = closingHour * 60 + closingMinute;
    
    return currentMinutes >= openingMinutes && currentMinutes <= closingMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: RefreshIndicator(
            onRefresh: () => viewModel.refreshDashboard(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  
                  // Cabeçalho com saudação
                  GreetingHeaderWidget(
                    userName: viewModel.userName,
                    location: viewModel.currentLocation,
                    weather: viewModel.currentWeather,
                  ),
                  
                  SizedBox(height: 2.h),
                  
                  // Busca rápida
                  QuickSearchWidget(),
                  
                  SizedBox(height: 3.h),
                  
                  // Reservas próximas
                  UpcomingReservationsWidget(
                    reservations: const [], // TODO: Implementar reservas no ViewModel
                  ),
                  
                  SizedBox(height: 3.h),
                  
                  // Estabelecimentos próximos
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Perto de você',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navegar para a tab de pesquisa (índice 1)
                            // Esta funcionalidade será implementada quando necessário
                          },
                          child: Text(
                            'Ver todos',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),

                  viewModel.nearbyEstablishments.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'Nenhum estabelecimento próximo encontrado.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    )
                  : NearbyEstablishmentsWidget(
                      establishments: viewModel.nearbyEstablishments,
                      isEstablishmentOpen: _isEstablishmentOpen,
                    ),
                  
                  SizedBox(height: 3.h),
                  
                  PopularSportsWidget(
                    sports: viewModel.popularSports,
                    onSportSelected: (sportName) {
                      // TODO: [Facilidade: 2, Prioridade: 3] - Implementar navegação para busca filtrada por esporte específico
                    },
                  ),
                  SizedBox(height: 0.5.h),

                  const QuickActionsWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
