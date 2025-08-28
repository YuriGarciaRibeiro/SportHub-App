class Address {
  final String street;
  final String? number;
  final String? complement;
  final String? neighborhood;
  final String city;
  final String state;
  final String zipCode;
  final String? country;
  final double? latitude;
  final double? longitude;

  Address({
    required this.street,
    this.number,
    this.complement,
    this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
    this.country,
    this.latitude,
    this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      number: json['number'],
      complement: json['complement'],
      neighborhood: json['neighborhood'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  factory Address.empty() {
    return Address(
      street: '',
      city: '',
      state: '',
      zipCode: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get fullAddress {
    List<String> parts = [];
    
    if (street.isNotEmpty) {
      String streetPart = street;
      if (number != null && number!.isNotEmpty) {
        streetPart += ', $number';
      }
      if (complement != null && complement!.isNotEmpty) {
        streetPart += ' - $complement';
      }
      parts.add(streetPart);
    }
    
    if (neighborhood != null && neighborhood!.isNotEmpty) {
      parts.add(neighborhood!);
    }
    
    if (city.isNotEmpty) {
      parts.add(city);
    }
    
    if (state.isNotEmpty) {
      parts.add(state);
    }
    
    if (zipCode.isNotEmpty) {
      parts.add(zipCode);
    }
    
    return parts.join(', ');
  }

  String get shortAddress {
    List<String> parts = [];
    
    if (neighborhood != null && neighborhood!.isNotEmpty) {
      parts.add(neighborhood!);
    }
    
    if (city.isNotEmpty) {
      parts.add(city);
    }
    
    if (state.isNotEmpty) {
      parts.add(state);
    }
    
    return parts.join(', ');
  }
}
