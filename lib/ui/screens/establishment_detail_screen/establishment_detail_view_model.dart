import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/base_view_model.dart';
import '../../../models/establishment.dart';
import '../../../services/establishment_service.dart';
import '../../../services/favorite_service.dart';

class EstablishmentDetailViewModel extends BaseViewModel {
  final EstablishmentService _establishmentService = EstablishmentService();
  final FavoriteService _favoriteService = FavoriteService();

  Establishment? _establishment;
  bool _isFavorite = false;

  Establishment? get establishment => _establishment;
  bool get isFavorite => _isFavorite;

  Future<void> initialize({String? establishmentId, Establishment? initial}) async {
    _establishment = initial;
    if (_establishment != null) {
      _isFavorite = _establishment?.isFavorite ?? false;
      notifyListeners();
      return;
    }

    if (establishmentId == null) return;

    await executeOperation(() async {
      final est = await _establishmentService.getEstablishmentById(establishmentId);
      _establishment = est;
      _isFavorite = est?.isFavorite ?? false;
      notifyListeners();
    });
  }

  Future<bool> toggleFavorite({required int entityType}) async {
    if (_establishment == null) return false;

    final current = _isFavorite;
    final estId = _establishment!.id;
    try {
      bool result;
      if (current) {
        result = await _favoriteService.removeFavorite(entityType, estId);
      } else {
        result = await _favoriteService.addFavorite(entityType, estId);
      }
      if (result) {
        _isFavorite = !_isFavorite;
        notifyListeners();
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<String?> makePhoneCall() async {
    final phone = _establishment?.phoneNumber ?? '';
    if (phone.isEmpty) {
      return 'Telefone não disponível';
    }

    final Uri phoneUri = Uri.parse('tel:$phone');
    try {
      final ok = await launchUrl(phoneUri);
      if (!ok) return 'Não foi possível fazer a ligação';
      return null;
    } catch (_) {
      return 'Não foi possível fazer a ligação';
    }
  }

  Future<String?> openDirectionsOnMaps() async {
    final address = _establishment?.address;
    if (address == null || address.fullAddress.isEmpty) {
      return 'Endereço não disponível';
    }

    final fullAddress = '${address.street}, ${address.number}, ${address.neighborhood}, ${address.city}, ${address.state}';
    final encodedAddress = Uri.encodeComponent(fullAddress);
    final Uri mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');

    try {
      final ok = await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      if (!ok) return 'Não foi possível abrir o mapa';
      return null;
    } catch (_) {
      return 'Não foi possível abrir o mapa';
    }
  }

  Future<String?> openWebsite() async {
    final website = _establishment?.website ?? '';
    if (website.isEmpty) {
      return 'Website não disponível';
    }

    Uri websiteUri;
    try {
      websiteUri = Uri.parse(website);
      if (!websiteUri.hasScheme) {
        websiteUri = Uri.parse('https://$website');
      }
    } catch (_) {
      return 'URL do website inválida';
    }

    try {
      final ok = await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
      if (!ok) return 'Não foi possível abrir o website';
      return null;
    } catch (_) {
      return 'Não foi possível abrir o website';
    }
  }

  Future<String?> sendEmail() async {
    final email = _establishment?.email ?? '';
    if (email.isEmpty) {
      return 'Email não disponível';
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    try {
      final ok = await launchUrl(emailUri);
      if (!ok) return 'Não foi possível abrir o email';
      return null;
    } catch (_) {
      return 'Não foi possível abrir o email';
    }
  }
}
