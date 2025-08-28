import 'sport.dart';

class Court {
  final String id;
  final String establishmentId;
  final String name;
  final int slotDurationMinutes;
  final int minBookingSlots;
  final int maxBookingSlots;
  final String openingTime; // Formato "HH:mm"
  final String closingTime; // Formato "HH:mm"
  final String timeZone;
  final List<Sport> sports;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Court({
    required this.id,
    required this.establishmentId,
    required this.name,
    this.slotDurationMinutes = 30,
    this.minBookingSlots = 1,
    this.maxBookingSlots = 4,
    this.openingTime = "08:00",
    this.closingTime = "22:00",
    this.timeZone = "America/Maceio",
    required this.sports,
    this.createdAt,
    this.updatedAt,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'] ?? '',
      establishmentId: json['establishmentId'] ?? '',
      name: json['name'] ?? '',
      slotDurationMinutes: json['slotDurationMinutes'] ?? 30,
      minBookingSlots: json['minBookingSlots'] ?? 1,
      maxBookingSlots: json['maxBookingSlots'] ?? 4,
      openingTime: json['openingTime'] ?? "08:00",
      closingTime: json['closingTime'] ?? "22:00",
      timeZone: json['timeZone'] ?? "America/Maceio",
      sports: (json['sports'] as List<dynamic>?)
          ?.map((sport) => Sport.fromJson(sport))
          .toList() ?? [],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'establishmentId': establishmentId,
      'name': name,
      'slotDurationMinutes': slotDurationMinutes,
      'minBookingSlots': minBookingSlots,
      'maxBookingSlots': maxBookingSlots,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'timeZone': timeZone,
      'sports': sports.map((sport) => sport.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get workingHours {
    return '$openingTime - $closingTime';
  }
}
