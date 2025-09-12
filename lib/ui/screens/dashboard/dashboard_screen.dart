import 'package:sizer/sizer.dart';
import 'dashboard_view_model.dart';
import 'widgets/nearby_establishments_widget.dart';
import '../../../core/app_export.dart';
import 'widgets/greeting_header_widget.dart';
import 'widgets/upcoming_reservations_widget.dart';
import 'widgets/quick_actions_widget.dart';
import 'widgets/quick_search_widget.dart';
import 'widgets/popular_sports_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

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


  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: viewModel.isLoading 
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Carregando...',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () => viewModel.refreshDashboard(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GreetingHeaderWidget(
                        userName: viewModel.userName,
                        location: viewModel.currentLocation,
                        weather: viewModel.currentWeather,
                      ),
                      
                      SizedBox(height: 0.5.h),

                      QuickSearchWidget(),
                      
                      SizedBox(height: 2.h),
                      
                      UpcomingReservationsWidget(
                        reservations: viewModel.upcomingReservations,
                      ),

                      SizedBox(height: 1.5.h),

                      NearbyEstablishmentsWidget(
                        establishments: viewModel.nearbyEstablishments,
                      ),

                      SizedBox(height: 1.5.h),

                      PopularSportsWidget(
                        sports: viewModel.popularSports,
                        onSportSelected: (sportName) {
                          // TODO: [Facilidade: 2, Prioridade: 3] - Implementar navegação para busca filtrada por esporte específico
                        },
                      ),

                      SizedBox(height: 1.5.h),

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
