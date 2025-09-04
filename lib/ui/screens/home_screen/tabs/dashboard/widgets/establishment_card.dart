import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/core/app_export.dart';
import 'package:sporthub/models/establishment.dart';
import 'package:sporthub/ui/screens/establishment_detail_screen/establishment_detail_screen.dart';

class EstablishmentCard extends StatelessWidget {
  const EstablishmentCard({super.key, required this.establishment, required this.isEstablishmentOpen});

  final Establishment establishment;
  final bool Function(Establishment) isEstablishmentOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            onTap: () {
              final id = establishment.id.toString();
              if (id.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EstablishmentDetailScreen(
                      establishmentId: id,
                    ),
                  ),
                );
              }
            },
            child: Container(
              width: 75.w,
              margin: EdgeInsets.only(right: 3.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      height: 12.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                      child: establishment.imageUrl.isNotEmpty
                          ? Image.network(
                              establishment.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    size: 40,
                                  ),
                                );
                              },
                            )
                          : Icon(
                              Icons.image_not_supported,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              size: 40,
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                establishment.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                              decoration: BoxDecoration(
                                color: isEstablishmentOpen(establishment)
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isEstablishmentOpen(establishment) ? 'Aberto' : 'Fechado',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isEstablishmentOpen(establishment)
                                      ? Colors.green[700]
                                      : Colors.red[700],
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          "${establishment.distanceKm} km",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        // Mostrar os esportes disponíveis
                        if (establishment.sports.isNotEmpty) ...[
                          Text(
                            'Esportes:',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Wrap(
                            spacing: 1.w,
                            runSpacing: 0.5.h,
                            children: establishment.sports.take(3).map((sport) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.3.h),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  sport.name,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 1.h),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  establishment.averageRating != null
                                      ? establishment.averageRating!.toStringAsFixed(1)
                                      : 'N/A',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              establishment.startingPrice != null ? 'A partir de R\$ ${establishment.startingPrice!.toStringAsFixed(0)}' : 'Consultar',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        
  }
}