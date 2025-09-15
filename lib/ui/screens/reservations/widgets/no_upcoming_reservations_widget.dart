import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../core/app_export.dart';
import '../../../../core/routes/app_router.dart';

class NoUpcomingReservationsWidget extends StatelessWidget {
  final VoidCallback? onBookNow;

  const NoUpcomingReservationsWidget({
    super.key,
    this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(6.w),
      
      child: Column(
        children: [
          // Ícone
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available_outlined,
              size: 8.w,
              color: Theme.of(context).primaryColor,
            ),
          ),
          
          SizedBox(height: 3.h),
          
          Text(
            'Nenhuma reserva próxima',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 1.h),
          
          Text(
            'Que tal reservar uma quadra e começar a jogar? Encontre os melhores estabelecimentos perto de você!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 3.h),
          
          // Botão de ação
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onBookNow ?? () {
                context.go(AppRouter.search);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Encontrar Quadras',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
