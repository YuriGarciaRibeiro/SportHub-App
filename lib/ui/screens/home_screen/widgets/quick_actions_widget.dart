import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/ui/screens/home_screen/widgets/quick_action_button.dart';
import '../../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback? onBookNow;
  final VoidCallback? onFindNearby;
  final VoidCallback? onViewFavorites;
  final VoidCallback? onViewHistory;

  const QuickActionsWidget({
    super.key,
    this.onBookNow,
    this.onFindNearby,
    this.onViewFavorites,
    this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ações Rápidas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  onTap: onBookNow,
                  icon: Icons.calendar_today,
                  label: 'Agendar Agora',
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: QuickActionButton(
                  onTap: onFindNearby,
                  icon: Icons.location_on,
                  label: 'Encontrar Quadras',
                  color: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  onTap: onViewFavorites,
                  icon: Icons.favorite,
                  label: 'Meus Favoritos',
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: QuickActionButton(
                  onTap: onViewHistory,
                  icon: Icons.history,
                  label: 'Histórico',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
