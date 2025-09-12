import 'package:flutter/material.dart';
import 'package:sporthub/models/reservation.dart';
import '../reservations_view_model.dart';

class ReservationCancelDialog {
  static void show(
    BuildContext context,
    Reservation reservation,
    ReservationsViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Reserva'),
        content: Text(
          'Tem certeza que deseja cancelar a reserva em ${reservation.establishmentName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.cancelReservation(reservation.id);
            },
            child: const Text('Sim, cancelar'),
          ),
        ],
      ),
    );
  }
}
