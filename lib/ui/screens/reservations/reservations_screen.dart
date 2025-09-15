import 'reservations_view_model.dart';
import '../../../core/app_export.dart';
import 'widgets/widgets.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
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
                child: viewModel.hasError
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
