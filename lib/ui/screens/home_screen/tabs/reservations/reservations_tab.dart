import 'package:sizer/sizer.dart';
import '../../../../../core/app_export.dart';
import 'widgets/no_reservation_card.dart';
import 'widgets/reservation_card.dart';
import 'widgets/reservation_details_sheet.dart';

class ReservationsTab extends StatefulWidget {
  const ReservationsTab({super.key});

  @override
  State<ReservationsTab> createState() => _ReservationsTabState();
}

class _ReservationsTabState extends State<ReservationsTab> {
  // TODO: Backend - implementar modelo Reservation e endpoints de API
  // TODO: Backend - endpoints: GET /reservations, POST /reservations, DELETE /reservations/{id}
  // TODO: Frontend - substituir por service real quando backend estiver pronto
  final List<Map<String, dynamic>> _reservations = [
    {
      'id': 1,
      'establishment': 'Quadra do Parque Central',
      'sport': 'Futebol Society',
      'date': '05/09/2025',
      'time': '18:30',
      'price': 'R\$ 80,00',
      'status': 'Confirmada',
    },
    {
      'id': 2,
      'establishment': 'Clube das Raquetes',
      'sport': 'Tênis (Quadra 2)',
      'date': '07/09/2025',
      'time': '09:00',
      'price': 'R\$ 40,00',
      'status': 'Pendente',
    },
    {
      'id': 3,
      'establishment': 'Ginásio Municipal',
      'sport': 'Basquete 5x5',
      'date': '10/09/2025',
      'time': '20:00',
      'price': 'R\$ 60,00',
      'status': 'Confirmada',
    },
    {
      'id': 4,
      'establishment': 'Centro Esportivo Norte',
      'sport': 'Futsal',
      'date': '12/09/2025',
      'time': '16:00',
      'price': 'R\$ 50,00',
      'status': 'Cancelada',
    },
    {
      'id': 5,
      'establishment': 'Quadra Areia Beach Club',
      'sport': 'Vôlei de Praia (2x2)',
      'date': '14/09/2025',
      'time': '15:30',
      'price': 'R\$ 70,00',
      'status': 'Pendente',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return _reservations.isEmpty
        ? Center(
            child: NoReservationCard()
          )
        : ListView.builder(
            padding: EdgeInsets.all(4.w),
            itemCount: _reservations.length,
            itemBuilder: (context, index) {
              final reservation = _reservations[index];
              return ReservationCard(
                reservation: reservation,
                onDetails: () => ReservationDetailsSheet.show(
                  context,
                  reservation,
                  onCancel: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cancelamento de reservas em desenvolvimento'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
