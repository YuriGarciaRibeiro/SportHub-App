import 'package:sizer/sizer.dart';
import '../../../../../../core/app_export.dart';

class NoReservationCard extends StatelessWidget {
  const NoReservationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_note,
                  size: 80,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Nenhuma reserva encontrada',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Suas reservas aparecerão aqui',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            );
  }
}