import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/core/routes/app_router.dart';
import 'package:sporthub/models/establishment.dart';
import 'package:sporthub/ui/screens/dashboard/widgets/establishments_generic_list_widget.dart';
import 'dashboard_view_model.dart';
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
        if (viewModel.isLoading) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(
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
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final sections = _buildSections(context, viewModel);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: RefreshIndicator(
            onRefresh: () => viewModel.refreshDashboard(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 2.h),
              itemCount: sections.length,
              itemBuilder: (_, i) => sections[i].child,
              separatorBuilder: (_, i) =>
                  SizedBox(height: sections[i].gapAfter ?? 1.5.h),
            ),
          ),
        );
      },
    );
  }

  List<_Section> _buildSections(BuildContext context, DashboardViewModel vm) {
    return [
      _Section(
        GreetingHeaderWidget(
          userName: vm.userName,
          location: vm.currentLocation,
          weather: vm.currentWeather,
        ),
        gapAfter: 0.5.h,
      ),
      _Section(
        const QuickSearchWidget(),
        gapAfter: 2.h,
      ),
      _Section(
        UpcomingReservationsWidget(reservations: vm.upcomingReservations),
        gapAfter: 1.5.h,
      ),
      _Section(
        EstablishmentsGenericListWidget(
          establishments: vm.topFiveRatedEstablishments,
          title: 'Melhores Avaliados',
          onSeeAllPressed: () {
            context.pushNamed(
              'all-establishments',
              pathParameters: {
                'title': 'Melhores Avaliados',
                'establishments': Establishment.listToJsonString(vm.topRatedEstablishments),
              },
            );
          },
        ),
        gapAfter: 1.5.h,
      ),
      _Section(
        EstablishmentsGenericListWidget(
          establishments: vm.topFiveNearbyEstablishments,
          title: 'Estabelecimentos Próximos',
          onSeeAllPressed: () {
            context.pushNamed(
              'all-establishments',
              pathParameters: {
                'title': 'Estabelecimentos Próximos',
                'establishments': Establishment.listToJsonString(vm.nearbyEstablishments),
              },
            );
          },
        ),
        gapAfter: 1.5.h,
      ),
      _Section(
        PopularSportsWidget(
          sports: vm.popularSports,
          onSportSelected: (sportName) {
            // TODO: navegação filtrada por esporte
          },
        ),
        gapAfter: 1.5.h,
      ),
      _Section(
        const QuickActionsWidget(),
        gapAfter: 2.h,
      ),
    ];
  }
}

class _Section {
  final Widget child;
  final double? gapAfter;
  const _Section(this.child, {this.gapAfter});
}
