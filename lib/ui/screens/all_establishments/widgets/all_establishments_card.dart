import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/models/establishment.dart';

class AllEstablishmentsCard extends StatelessWidget {
  final Establishment establishment;
  final bool Function(Establishment) isEstablishmentOpen;

  const AllEstablishmentsCard({
    super.key,
    required this.establishment,
    required this.isEstablishmentOpen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final id = establishment.id.toString();
        if (id.isNotEmpty) {
          context.pushNamed(
            'establishment-detail',
            pathParameters: {'id': id},
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do estabelecimento
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: establishment.imageUrl.isNotEmpty
                      ? Image.network(
                          establishment.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder(context);
                          },
                        )
                      : _buildImagePlaceholder(context),
                ),
              ),
            ),
            // Conteúdo do card
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nome e status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                establishment.name,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            _buildStatusBadge(context),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        // Distância
                        Text(
                          "${establishment.distanceKm} km",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    // Rating e preço
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
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
                        if (establishment.startingPrice != null)
                          Text(
                            'R\$ ${establishment.startingPrice}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isOpen = isEstablishmentOpen(establishment);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
      decoration: BoxDecoration(
        color: isOpen 
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isOpen ? 'Aberto' : 'Fechado',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isOpen ? Colors.green[700] : Colors.red[700],
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}