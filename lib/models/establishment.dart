import 'address.dart';
import 'court.dart';
import 'sport.dart';

class Establishment {
  final String id;
  final String name;
  final String description;
  final String phoneNumber;
  final String email;
  final String website;
  final String imageUrl;
  final Address address;
  final List<Court> courts;
  final List<Sport> sports;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Establishment({
    required this.id,
    required this.name,
    required this.description,
    required this.phoneNumber,
    required this.email,
    required this.website,
    required this.imageUrl,
    required this.address,
    required this.courts,
    required this.sports,
    this.createdAt,
    this.updatedAt,
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
    );
  }

  // Factory para criar a partir do DTO da API
  factory Establishment.fromDto(Map<String, dynamic> dto) {
    return Establishment(
      id: dto['id'] ?? '',
      name: dto['name'] ?? '',
      description: dto['description'] ?? '',
      phoneNumber: '',
      email: '', 
      website: '',
      imageUrl: dto['imageUrl'] ?? '',
      address: dto['address'] != null 
          ? Address.fromJson(dto['address']) 
          : Address.empty(),
      courts: [], 
      sports: (dto['sports'] as List<dynamic>?)
          ?.map((sport) => Sport.fromJson(sport))
          .toList() ?? [],
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
      'address': address.toJson(),
      'courts': courts.map((court) => court.toJson()).toList(),
      'sports': sports.map((sport) => sport.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
