import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  // Mock data for reservations
  final List<Map<String, dynamic>> _reservations = [
    {
      "id": 1,
      "establishment": "Arena Sports Center",
      "sport": "Futebol",
      "date": "Hoje",
      "time": "18:00",
      "price": "R\$ 120,00",
      "status": "Confirmada",
    },
    {
      "id": 2,
      "establishment": "Club Tennis Elite",
      "sport": "Tênis",
      "date": "Amanhã",
      "time": "09:30",
      "price": "R\$ 80,00",
      "status": "Pendente",
    },
    {
      "id": 3,
      "establishment": "Quadra do Bairro",
      "sport": "Basquete",
      "date": "Sex, 29/08",
      "time": "20:00",
      "price": "R\$ 60,00",
      "status": "Confirmada",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Minhas Reservas'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _reservations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Nenhuma reserva encontrada',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Suas reservas aparecerão aqui',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(4.w),
              itemCount: _reservations.length,
              itemBuilder: (context, index) {
                final reservation = _reservations[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
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
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                reservation['establishment'],
                                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: reservation['status'] == 'Confirmada'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                reservation['status'],
                                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                  color: reservation['status'] == 'Confirmada'
                                      ? Colors.green[700]
                                      : Colors.orange[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          reservation['sport'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              color: AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.6),
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${reservation['date']} às ${reservation['time']}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              reservation['price'],
                              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Implementar ação da reserva
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.lightTheme.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                              ),
                              child: Text(
                                'Detalhes',
                                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
