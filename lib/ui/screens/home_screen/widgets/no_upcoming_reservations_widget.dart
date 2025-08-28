import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/app_export.dart';

class NoUpcomingReservationsWidget extends StatelessWidget {
  final VoidCallback? onBookNow;

  const NoUpcomingReservationsWidget({
    Key? key,
    this.onBookNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.primaryColor.withOpacity(0.1),
            AppTheme.lightTheme.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Ícone
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available_outlined,
              size: 8.w,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          
          SizedBox(height: 3.h),
          
          // Título
          Text(
            'Nenhuma reserva próxima',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 1.h),
          
          // Descrição
          Text(
            'Que tal reservar uma quadra e começar a jogar? Encontre os melhores estabelecimentos perto de você!',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
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
                // Navegar para a tab de busca/explorar (índice 1)
                // Esta funcionalidade será implementada quando necessário
                Navigator.pushNamed(context, '/search');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
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
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
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
