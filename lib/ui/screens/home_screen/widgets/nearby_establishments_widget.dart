import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/app_export.dart';

class NearbyEstablishmentsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> establishments;

  const NearbyEstablishmentsWidget({
    Key? key,
    required this.establishments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Perto de você',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navegar para a tab de pesquisa (índice 1)
                  // Esta funcionalidade será implementada quando necessário
                },
                child: Text(
                  'Ver todos',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 29.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: establishments.length,
            itemBuilder: (context, index) {
              final establishment = establishments[index];
              return Container(
                width: 75.w,
                margin: EdgeInsets.only(right: 3.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
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
                          color: Colors.grey[200],
                        ),
                        child: establishment['image'] != null
                            ? Image.network(
                                establishment['image'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[400],
                                      size: 40,
                                    ),
                                  );
                                },
                              )
                            : Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[400],
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
                                  establishment['name'],
                                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                                decoration: BoxDecoration(
                                  color: establishment['isOpen']
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  establishment['isOpen'] ? 'Aberto' : 'Fechado',
                                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                    color: establishment['isOpen']
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
                            establishment['distance'],
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          // Mostrar os esportes disponíveis
                          if (establishment['sports'] != null && establishment['sports'].isNotEmpty) ...[
                            Text(
                              'Esportes:',
                              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Wrap(
                              spacing: 1.w,
                              runSpacing: 0.5.h,
                              children: (establishment['sports'] as List<String>).take(3).map((sport) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.3.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightTheme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    sport,
                                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.lightTheme.primaryColor,
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
                                    '${establishment['rating']} (${establishment['reviews']})',
                                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                establishment['startingPrice'],
                                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.lightTheme.primaryColor,
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
              );
            },
          ),
        ),
      ],
    );
  }
}
