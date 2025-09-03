import 'package:sporthub/core/app_export.dart';

import 'address.dart';
import 'court.dart';
import 'sport.dart';

class Establishment {
  static TimeOfDay parseTime(String timeString) {
    final parts = timeString.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
  final String id;
  final String name;
  final String description;
  final String phoneNumber;
  final String email;
  final String website;
  final String imageUrl;
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;
  final double? startingPrice;
  final Address address;
  final List<Court> courts;
  final List<Sport> sports;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isFavorite;

  Establishment({
    required this.id,
    required this.name,
    required this.description,
    required this.phoneNumber,
    required this.email,
    required this.website,
    required this.imageUrl,
    required this.openingTime,
    required this.closingTime,
    required this.startingPrice,
    required this.address,
    required this.courts,
    required this.sports,
    this.createdAt,
    this.updatedAt,
    this.isFavorite,
  });

  factory Establishment.fromJson(Map<String, dynamic> json) {
  return Establishment(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    phoneNumber: json['phoneNumber'] ?? '',
    email: json['email'] ?? '',
    website: json['website'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    openingTime: json['openingTime'] != null
      ? parseTime(json['openingTime'].toString())
      : TimeOfDay.now(),
    closingTime: json['closingTime'] != null
      ? parseTime(json['closingTime'].toString())
      : TimeOfDay.now(),
    startingPrice: (json['startingPrice'] as num?)?.toDouble() ?? 0.0,
    address: json['address'] != null
      ? Address.fromJson(json['address'])
      : Address.empty(),
    courts: (json['courts'] as List<dynamic>?)
      ?.map((court) => Court.fromJson(court))
      .toList() ?? [],
    sports: (json['sports'] as List<dynamic>?)
      ?.map((sport) => Sport.fromJson(sport))
      .toList() ?? [],
    createdAt: json['createdAt'] != null 
      ? DateTime.parse(json['createdAt']) 
      : null,
    updatedAt: json['updatedAt'] != null 
      ? DateTime.parse(json['updatedAt']) 
      : null,
    isFavorite: json['isFavorite'] ?? false,
  );
  }

  // Factory para criar a partir do DTO da API
  factory Establishment.fromDto(Map<String, dynamic> dto) {
  return Establishment(
    id: dto['id'] ?? '',
    name: dto['name'] ?? '',
    description: dto['description'] ?? '',
    phoneNumber: dto['phoneNumber'] ?? '',
    email: dto['email'] ?? '',
    website: dto['website'] ?? '',
    imageUrl: dto['imageUrl'] ?? '',
    openingTime: dto['openingTime'] != null
      ? Establishment.parseTime(dto['openingTime'])
      : const TimeOfDay(hour: 9, minute: 0),
    closingTime: dto['closingTime'] != null
      ? Establishment.parseTime(dto['closingTime'])
      : const TimeOfDay(hour: 18, minute: 0),
    startingPrice: (dto['startingPrice'] as num?)?.toDouble() ?? 0.0,
    address: dto['address'] != null 
      ? Address.fromJson(dto['address']) 
      : Address.empty(),
    courts: (dto['courts'] as List<dynamic>?)
      ?.map((court) => Court.fromJson(court))
      .toList() ?? [],
    sports: (dto['sports'] as List<dynamic>?)
      ?.map((sport) => Sport.fromJson(sport))
      .toList() ?? [],
    isFavorite: dto['isFavorite'] ?? false,
  );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'phoneNumber': phoneNumber,
      'email': email,
      'website': website,
      'imageUrl': imageUrl,
      'openingTime': '${openingTime.hour.toString().padLeft(2, '0')}:${openingTime.minute.toString().padLeft(2, '0')}:00',
      'closingTime': '${closingTime.hour.toString().padLeft(2, '0')}:${closingTime.minute.toString().padLeft(2, '0')}:00',
      'address': address.toJson(),
      'courts': courts.map((court) => court.toJson()).toList(),
      'sports': sports.map((sport) => sport.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }
}
