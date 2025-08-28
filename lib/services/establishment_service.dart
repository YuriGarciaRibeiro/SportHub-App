import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_config.dart';
import '../models/establishment.dart';
import '../models/address.dart';
import '../models/sport.dart';

class EstablishmentService {
  static final EstablishmentService _instance = EstablishmentService._internal();
  factory EstablishmentService() => _instance;
  EstablishmentService._internal();

  // Buscar todos os estabelecimentos
  Future<List<Establishment>> getAllEstablishments() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getEstablishmentsEndpoint),
        headers: ApiConfig.defaultHeaders,
      ).timeout(ApiConfig.defaultTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> items = responseData['items'] ?? [];
        return items.map((dto) => Establishment.fromDto(dto)).toList();
      } else {
        throw Exception('Falha ao carregar estabelecimentos: ${response.statusCode}');
      }
    } catch (e) {
      return _getMockEstablishments();
    }
  }

  // Buscar estabelecimento por ID
  Future<Establishment?> getEstablishmentById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/establishments/$id'),
        headers: ApiConfig.defaultHeaders,
      ).timeout(ApiConfig.defaultTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Establishment.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      // Se não conseguir conectar com a API, retorna null
      return null;
    }
  }

  // Buscar estabelecimentos por esporte
  Future<List<Establishment>> getEstablishmentsBySport(String sportId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/establishments?sportId=$sportId'),
        headers: ApiConfig.defaultHeaders,
      ).timeout(ApiConfig.defaultTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Establishment.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar estabelecimentos por esporte: ${response.statusCode}');
      }
    } catch (e) {
      // Se não conseguir conectar com a API, retorna lista vazia
      return [];
    }
  }

  // Dados mock para desenvolvimento/teste
  List<Establishment> _getMockEstablishments() {
    return [
      Establishment(
        id: 'e1111111-1111-1111-1111-111111111111',
        name: 'SportHub Central Arena',
        description: 'Complete sports complex in downtown with football, basketball and volleyball courts. Air-conditioned environment and state-of-the-art equipment.',
        phoneNumber: '(82) 99999-9999',
        email: 'contato@sporthubcentral.com',
        website: 'www.sporthubcentral.com',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=1000&auto=format&fit=crop',
        address: Address.fromJson({
          'street': '123 Palm Street',
          'number': '1000',
          'complement': 'Suite 101',
          'neighborhood': 'Downtown',
          'city': 'New York',
          'state': 'NY',
          'zipCode': '10001',
        }),
        courts: [],
        sports: [
          Sport(id: 'a1111111-1111-1111-1111-111111111111', name: 'Football', description: 'Sport played on a grass field with two teams of 11 players each, where the objective is to score goals in the opposing goal.'),
          Sport(id: 'a2222222-2222-2222-2222-222222222222', name: 'Basketball', description: 'Sport played on an indoor court by two teams of 5 players each, where the objective is to shoot the ball into the opposing basket.'),
          Sport(id: 'a3333333-3333-3333-3333-333333333333', name: 'Volleyball', description: 'Sport played on a court divided by a net, with two teams of 6 players each, where the objective is to make the ball touch the opponent\'s court floor.'),
        ],
      ),
      Establishment(
        id: 'e2222222-2222-2222-2222-222222222222',
        name: 'Premium Athletic Club',
        description: 'Premium club focused on tennis and padel. Professional courts, complete locker rooms and leisure area.',
        phoneNumber: '(82) 88888-8888',
        email: 'info@premiumathletic.com',
        website: 'www.premiumathletic.com',
        imageUrl: 'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?q=80&w=1000&auto=format&fit=crop',
        address: Address.fromJson({
          'street': '456 Broadway Avenue',
          'number': '2500',
          'neighborhood': 'Midtown',
          'city': 'New York',
          'state': 'NY',
          'zipCode': '10036',
        }),
        courts: [],
        sports: [
          Sport(id: 'a4444444-4444-4444-4444-444444444444', name: 'Tennis', description: 'Racquet sport played individually or in pairs, where the goal is to hit the ball to the opponent\'s side of the court.'),
          Sport(id: 'a7777777-7777-7777-7777-777777777777', name: 'Padel', description: 'Racquet sport played in doubles on an enclosed court, combining elements of tennis and squash.'),
        ],
      ),
      Establishment(
        id: 'e3333333-3333-3333-3333-333333333333',
        name: 'Futsal Mania Center',
        description: 'Specialized in futsal with 4 official courts. Ideal place for casual games, tournaments and training sessions.',
        phoneNumber: '(82) 77777-7777',
        email: 'contato@futsalmania.com',
        website: 'www.futsalmania.com',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=1000&auto=format&fit=crop',
        address: Address.fromJson({
          'street': '789 Sports Boulevard',
          'number': '500',
          'complement': 'Building A',
          'neighborhood': 'Sports District',
          'city': 'Los Angeles',
          'state': 'CA',
          'zipCode': '90210',
        }),
        courts: [],
        sports: [
          Sport(id: 'a5555555-5555-5555-5555-555555555555', name: 'Futsal', description: 'A variant of football played indoors, with two teams of 5 players each, including a goalkeeper.'),
        ],
      ),
    ];
  }
}
