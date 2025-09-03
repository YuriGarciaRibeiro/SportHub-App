import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../../models/establishment.dart';

class EstablishmentListItem extends StatelessWidget {
  final Establishment establishment;
  final VoidCallback onTap;
  final bool isIOSStyle;

  const EstablishmentListItem({
    super.key,
    required this.establishment,
    required this.onTap,
    this.isIOSStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isIOSStyle) {
      return _buildIOSStyle(context);
    }
    return _buildMaterialStyle(context);
  }

  Widget _buildMaterialStyle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
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
      child: ListTile(
        contentPadding: EdgeInsets.all(3.w),
        leading: _buildImage(context),
        title: Text(
          establishment.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: _buildSubtitle(context),
        onTap: onTap,
      ),
    );
  }

  Widget _buildIOSStyle(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.2.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    establishment.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 0.6.h),
                  _buildSubtitle(context),
                ],
              ),
            ),
            const Icon(CupertinoIcons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 12.w,
        height: 12.w,
        color: cs.surfaceContainerHighest,
        child: establishment.imageUrl.isNotEmpty
            ? Image.network(
                establishment.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  isIOSStyle ? CupertinoIcons.building_2_fill : Icons.business,
                ),
              )
            : Icon(
                isIOSStyle ? CupertinoIcons.building_2_fill : Icons.business,
              ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          establishment.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(0.6),
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (establishment.sports.isNotEmpty) ...[
          SizedBox(height: isIOSStyle ? 0.8.h : 1.h),
          Wrap(
            spacing: 1.w,
            children: establishment.sports.take(2).map((sport) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  sport.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.primary,
                        fontSize: 10,
                      ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
