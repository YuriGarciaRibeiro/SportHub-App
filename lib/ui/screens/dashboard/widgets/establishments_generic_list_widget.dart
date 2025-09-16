import 'package:sizer/sizer.dart';
import 'package:sporthub/models/establishment.dart';
import 'establishment_card.dart';
import '../../../../../../core/app_export.dart';

class EstablishmentsGenericListWidget extends StatelessWidget {
  final List<Establishment> establishments;
  final String title;
  final VoidCallback? onSeeAllPressed;

  const EstablishmentsGenericListWidget({
    super.key,
    required this.establishments,
    required this.title,
    this.onSeeAllPressed,
  });

  bool _isEstablishmentOpen(Establishment e) {
    final now = TimeOfDay.now();

    int toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

    final cur   = toMinutes(now);
    final open  = toMinutes(e.openingTime);
    final close = toMinutes(e.closingTime);

    if (open == close) return true;

    if (open < close) {
      return cur >= open && cur < close;
    } else {
      return cur >= open || cur < close;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabeçalho da seção
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onSeeAllPressed ?? () {
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
        
        // Conteúdo dos estabelecimentos
        establishments.isEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Nenhum estabelecimento disponível no momento.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          )
        : SizedBox(
            height: 29.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: establishments.length,
              itemBuilder: (context, index) {
                final establishment = establishments[index];
                return EstablishmentCard(
                  establishment: establishment, 
                  isEstablishmentOpen: _isEstablishmentOpen
                );
              },
            ),
          ),
      ],
    );
  }
}
