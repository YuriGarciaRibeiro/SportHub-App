import 'package:sizer/sizer.dart';
import 'package:sporthub/ui/screens/home_screen/tabs/dashboard/dashboard_view_model.dart';
import 'package:sporthub/ui/screens/home_screen/tabs/dashboard/widgets/nearby_establishments_widget.dart';
import '../../../../../core/app_export.dart';
import '../../../../../models/establishment.dart';
import 'widgets/greeting_header_widget.dart';
import 'widgets/upcoming_reservations_widget.dart';
import 'widgets/quick_actions_widget.dart';
import 'widgets/quick_search_widget.dart';
import 'widgets/popular_sports_widget.dart';

class DashboardTab extends StatefulWidget {
  final VoidCallback? onNavigateToSearch;
  
  const DashboardTab({super.key, this.onNavigateToSearch});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
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
            child: viewModel.isLoading && viewModel.nearbyEstablishments.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
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
                              'Erro ao carregar dados',
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
                              onPressed: () => viewModel.refreshDashboard(),
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            GreetingHeaderWidget(
                              userName: viewModel.userName,
                              location: viewModel.currentLocation,
                              weather: viewModel.currentWeather,
                            ),
                            
                            SizedBox(height: 2.h),
                            
                            const QuickSearchWidget(),
                            
                            SizedBox(height: 0.5.h),
                            
                            UpcomingReservationsWidget(
                              reservations: const [],
                            ),
                            
                            SizedBox(height: 3.h),
                            
                            if (viewModel.nearbyEstablishments.isNotEmpty) ...[
                              NearbyEstablishmentsWidget(
                                      establishments: viewModel.nearbyEstablishments,
                                      isEstablishmentOpen: _isEstablishmentOpen,
                              ),
                              SizedBox(height: 3.h),
                            ],
                            
                            PopularSportsWidget(
                              sports: viewModel.popularSports,
                              onSportSelected: (sportName) {
                                // TODO: Implementar navegação para busca por esporte
                              },
                            ),
                            SizedBox(height: 3.h),
                            
                            const QuickActionsWidget(),
                            
                            SizedBox(height: 3.h),
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }
}
