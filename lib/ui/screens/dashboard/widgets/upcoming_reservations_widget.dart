import 'package:sizer/sizer.dart';
import 'package:sporthub/models/reservation.dart';
import '../../../../../../core/app_export.dart';

class UpcomingReservationsWidget extends StatelessWidget {
  final List<Reservation> reservations;

  const UpcomingReservationsWidget({
    super.key,
    required this.reservations,
  });

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Próximas Reservas',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navegar para a tab de reservas (índice 2)
                  // Esta funcionalidade será implementada quando necessário
                },
                child: Text(
                  'Ver todas',
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
        SizedBox(
          height: 20.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return Container(
                width: 70.w,
                margin: EdgeInsets.only(right: 3.w),
                child: Card(
                  elevation: 6,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: Theme.of(context).cardTheme.shape is RoundedRectangleBorder
                        ? (Theme.of(context).cardTheme.shape as RoundedRectangleBorder).borderRadius
                        : BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              reservation.establishmentName,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        reservation.courtName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'access_time',
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${reservation.startTime.hour.toString().padLeft(2, '0')}:${reservation.startTime.minute.toString().padLeft(2, '0')} - ${reservation.endTime.hour.toString().padLeft(2, '0')}:${reservation.endTime.minute.toString().padLeft(2, '0')}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'R\$ ${reservation.totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomIconWidget(
                            iconName: 'arrow_forward',
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
            },
          ),
        ),
      ],
    );
  }
}
