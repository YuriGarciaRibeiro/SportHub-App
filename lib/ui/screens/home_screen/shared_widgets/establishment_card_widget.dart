import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../models/establishment.dart';
import '../../establishment_detail_screen/establishment_detail_screen.dart';

class EstablishmentCardWidget extends StatelessWidget {
  final Establishment establishment;
  final String Function(Establishment) getEstablishmentDistance;
  final String Function(Establishment) getEstablishmentPrice;

  const EstablishmentCardWidget({
    super.key,
    required this.establishment,
    required this.getEstablishmentDistance,
    required this.getEstablishmentPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
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
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildEstablishmentImage(context),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildEstablishmentInfo(context),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildBottomRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEstablishmentImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 20.w,
        height: 15.w,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: establishment.imageUrl.isNotEmpty
            ? Image.network(
                establishment.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  );
                },
              )
            : Icon(
                Icons.business,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 30,
              ),
      ),
    );
  }

  Widget _buildEstablishmentInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                establishment.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        _buildRatingAndDistance(context),
        SizedBox(height: 1.h),
        Text(
          establishment.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 1.h),
        if (establishment.sports.isNotEmpty) _buildSportsTags(context),
      ],
    );
  }

  Widget _buildRatingAndDistance(BuildContext context) {
    return Row(
      children: [
        // Avaliação
        Container(
          padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star,
                size: 12,
                color: Colors.amber[700],
              ),
              SizedBox(width: 0.5.w),
              Text(
                '4.5', // TODO: [Facilidade: 3, Prioridade: 3] - Implementar sistema de avaliações real do backend
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[700],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        // Distância
        Container(
          padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: 12,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 0.5.w),
              Text(
                getEstablishmentDistance(establishment),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSportsTags(BuildContext context) {
    return Wrap(
      spacing: 1.w,
      runSpacing: 0.5.h,
      children: [
        ...establishment.sports.take(3).map((sport) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              sport.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 10,
              ),
            ),
          );
        }),
        if (establishment.sports.length > 3)
          Container(
            margin: EdgeInsets.only(top: 0.5.h),
            child: Text(
              '+${establishment.sports.length - 3} mais',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPriceAndCourts(context),
        _buildViewMoreButton(context),
      ],
    );
  }

  Widget _buildPriceAndCourts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (establishment.courts.isNotEmpty)
          Text(
            '${establishment.courts.length} quadra${establishment.courts.length != 1 ? 's' : ''}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        SizedBox(height: 0.5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            getEstablishmentPrice(establishment),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.green[700],
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewMoreButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EstablishmentDetailScreen(
                establishmentId: establishment.id,
              ),
            ),
          );
        } catch (e) {
          // Feedback visual em caso de erro
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao abrir detalhes: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
        elevation: 2,
      ),
      icon: const Icon(Icons.arrow_forward, size: 16),
      label: Text(
        'Ver mais',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
