import 'package:sporthub/ui/screens/home_screen/tabs/reservations/reservations_view_model.dart';
import '../../../../../core/app_export.dart';
import 'widgets/widgets.dart';

class ReservationsTab extends StatefulWidget {
  const ReservationsTab({super.key});

  @override
  State<ReservationsTab> createState() => _ReservationsTabState();
}

class _ReservationsTabState extends State<ReservationsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ReservationsViewModel>(context, listen: false);
      viewModel.initializeReservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              ReservationsHeader(viewModel: viewModel),
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.hasError
                        ? ReservationErrorState(
                            errorMessage: viewModel.errorMessage,
                            onRetry: () => viewModel.refreshReservations(),
                          )
                        : viewModel.filteredReservations.isEmpty
                            ? const NoUpcomingReservationsWidget()
                            : ReservationsList(viewModel: viewModel),
              ),
            ],
          ),
        );
      },
    );
  }
}
