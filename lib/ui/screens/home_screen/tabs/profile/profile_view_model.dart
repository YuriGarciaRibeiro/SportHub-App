import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../services/auth_service.dart';
import '../../../../../core/base_view_model.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? preferredSport;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.phone,
    this.dateOfBirth,
    this.preferredSport,
  });
}

class ProfileViewModel extends BaseViewModel {
  final AuthService _authService = AuthService();

  UserProfile? _userProfile;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'pt';
  bool _isInitialized = false;

  UserProfile? get userProfile => _userProfile;
  bool get notificationsEnabled => _notificationsEnabled;
  String get selectedLanguage => _selectedLanguage;
  bool get isLoggedIn => _authService.isLoggedIn;

  Future<void> initializeProfile() async {
    // Se já foi inicializado e temos dados, não precisa recarregar
    if (_isInitialized && _userProfile != null) {
      return;
    }

    // Se não tem dados ainda, carrega com loading
    if (_userProfile == null) {
      await executeOperation(() async {
        await _loadUserProfile();
        await _loadUserPreferences();
        _isInitialized = true;
      });
    } else {
      // Se já tem dados, só atualiza sem loading
      await _loadUserProfile();
      await _loadUserPreferences();
      _isInitialized = true;
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      if (_authService.isLoggedIn) {
        // Carrega dados do usuário (removi o delay artificial)
        _userProfile = UserProfile(
          id: _authService.currentUserId ?? 'user123',
          name: _authService.currentUserName ?? 'João Silva',
          email: _authService.currentUserEmail ?? 'joao@example.com',
          profileImageUrl: null,
          phone: '+55 11 99999-9999',
          dateOfBirth: DateTime(1990, 5, 15),
          preferredSport: 'Futebol',
        );
      } else {
        _userProfile = null;
      }
    } catch (e) {
      _userProfile = null;
    }
    notifyListeners();
  }

  Future<void> _loadUserPreferences() async {
    try {
      // Carrega preferências do usuário (removi o delay artificial)
      _notificationsEnabled = true;
      _selectedLanguage = 'pt';
    } catch (e) {
      _notificationsEnabled = true;
      _selectedLanguage = 'pt';
    }
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    DateTime? dateOfBirth,
    String? preferredSport,
  }) async {
    await executeOperation(() async {
      if (_userProfile != null) {
        // Removi o delay artificial para tornar a atualização mais fluida
        _userProfile = UserProfile(
          id: _userProfile!.id,
          name: name ?? _userProfile!.name,
          email: _userProfile!.email,
          profileImageUrl: _userProfile!.profileImageUrl,
          phone: phone ?? _userProfile!.phone,
          dateOfBirth: dateOfBirth ?? _userProfile!.dateOfBirth,
          preferredSport: preferredSport ?? _userProfile!.preferredSport,
        );
      }
    });
  }

  void updateNotificationSettings(bool enabled) {
    // TODO: 42 [Facilidade: 2, Prioridade: 4] - Implementar notificações push com Firebase
    // TODO: 43 [Facilidade: 4, Prioridade: 3] - Salvar preferências no SharedPreferences
    // TODO: 44 [Facilidade: 3, Prioridade: 3] - Sincronizar configurações com o servidor
    _notificationsEnabled = enabled;
    notifyListeners();
    // Aqui você pode salvar a preferência usando SharedPreferences se necessário
  }

  void updateLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
    // Aqui você pode salvar a preferência usando SharedPreferences se necessário
  }

  Future<void> logout() async {
    await executeOperation(() async {
      await _authService.logout();
      _userProfile = null;
      _notificationsEnabled = true;
      _selectedLanguage = 'pt';
    });
  }

  Future<void> updateProfileImage(String imageUrl) async {
    await executeOperation(() async {
      if (_userProfile != null) {
        // Reduzido o delay para uma experiência mais fluida
        await Future.delayed(const Duration(milliseconds: 500));
        
        _userProfile = UserProfile(
          id: _userProfile!.id,
          name: _userProfile!.name,
          email: _userProfile!.email,
          profileImageUrl: imageUrl,
          phone: _userProfile!.phone,
          dateOfBirth: _userProfile!.dateOfBirth,
          preferredSport: _userProfile!.preferredSport,
        );
      }
    });
  }

  Future<void> deleteAccount() async {
    await executeOperation(() async {
      // Reduzido o delay para uma experiência mais fluida
      await Future.delayed(const Duration(milliseconds: 1000));
      
      await _authService.logout();
      _userProfile = null;
    });
  }

  Future<void> refreshProfile() async {
    _isInitialized = false; // Força a reinicialização
    await initializeProfile();
  }

  void navigateToEditProfile() {
    // TODO: 39 [Facilidade: 3, Prioridade: 4] - Implementar tela de edição de perfil completa
    // TODO: 40 [Facilidade: 4, Prioridade: 3] - Adicionar upload de foto de perfil
    // TODO: 41 [Facilidade: 3, Prioridade: 3] - Implementar validação de dados do perfil
    debugPrint('Navegando para edição de perfil');
  }

  void navigateToSettings() {
    debugPrint('Navegando para configurações');
  }

  void navigateToReservationHistory() {
    debugPrint('Navegando para histórico de reservas');
  }

  Map<String, dynamic> getUserStats() {
    return {
      'memberSince': _userProfile?.dateOfBirth != null 
          ? DateTime.now().difference(_userProfile!.dateOfBirth!).inDays 
          : 0,
      'totalReservations': 15,
      'favoriteEstablishments': 3,
      'points': 240,
    };
  }
}
