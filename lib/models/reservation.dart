class ReservationEstablishment {
  final String establishmentId;
  final String name;
  final ReservationCourt court;

  ReservationEstablishment({
    required this.establishmentId,
    required this.name,
    required this.court,
  });

  factory ReservationEstablishment.fromJson(Map<String, dynamic> json) {
    return ReservationEstablishment(
      establishmentId: json['establishmentId'] ?? '',
      name: json['name'] ?? '',
      court: ReservationCourt.fromJson(json['court'] ?? {}),
    );
  }
}

class ReservationCourt {
  final String courtId;
  final String name;

  ReservationCourt({
    required this.courtId,
    required this.name,
  });

  factory ReservationCourt.fromJson(Map<String, dynamic> json) {
    return ReservationCourt(
      courtId: json['courtId'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Reservation {
  final String reservationId;
  final DateTime startTimeUtc;
  final DateTime endTimeUtc;
  final double totalPrice;
  final int slotsBooked;
  final ReservationEstablishment establishment;

  Reservation({
    required this.reservationId,
    required this.startTimeUtc,
    required this.endTimeUtc,
    required this.totalPrice,
    required this.slotsBooked,
    required this.establishment,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservationId: json['reservationId'] ?? '',
      startTimeUtc: DateTime.parse(json['startTimeUtc'] ?? DateTime.now().toIso8601String()),
      endTimeUtc: DateTime.parse(json['endTimeUtc'] ?? DateTime.now().toIso8601String()),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      slotsBooked: json['slotsBooked'] ?? 0,
      establishment: ReservationEstablishment.fromJson(json['establishment'] ?? {}),
    );
  }

  // Getters para manter compatibilidade com código existente
  String get id => reservationId;
  String get establishmentName => establishment.name;
  String get courtName => establishment.court.name;
  DateTime get startTime => startTimeUtc;
  DateTime get endTime => endTimeUtc;
  double get price => totalPrice;
}