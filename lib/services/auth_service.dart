// lib/services/auth_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/api_config.dart';
import '../core/http/http_client_manager.dart';

// Secure store genérico + implementação com flutter_secure_storage
import '../core/secure/secure_store.dart';
import '../core/secure/flutter_secure_store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // --- Singleton ---
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  AuthService._internal()
      : _vault = FlutterSecureStore(
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
          ),
        ).namespace('auth');

  final SecureStore _vault;
  static const String _kAccess = 'access';

  static const String _userEmailKey = 'user_email';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';

  String? _currentToken;
  String? _currentUserEmail;
  String? _currentUserId;
  String? _currentUserName;
  bool _isLoggedIn = false;
  bool _initialized = false;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserEmail => _currentUserEmail;
  String? get currentUserId => _currentUserId;
  String? get currentUserName => _currentUserName;
  String? get currentToken => _currentToken;

  Map<String, String> get authHeader =>
      _currentToken != null ? {'Authorization': 'Bearer $_currentToken'} : const {};

  Future<void> initialize() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();

    await _migrateOldTokenIfAny(prefs);

    _currentToken     = await _vault.getString(_kAccess);
    _currentUserEmail = prefs.getString(_userEmailKey);
    _currentUserId    = prefs.getString(_userIdKey);
    _currentUserName  = prefs.getString(_userNameKey);

    _isLoggedIn = _currentToken != null && !_isJwtExpired(_currentToken!);
    _initialized = true;
  }

  Future<AuthResult> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return AuthResult(success: false, message: 'Por favor, preencha todos os campos');
      }
      if (!_isValidEmail(email)) {
        return AuthResult(success: false, message: 'Por favor, insira um email válido');
      }

      final response = await http
          .post(
            Uri.parse(ApiConfig.loginEndpoint),
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(ApiConfig.defaultTimeout);

      final Map<String, dynamic> data = _parseJsonSafe(response.body);

      if (response.statusCode == 200) {
        _currentToken     = data['token'] as String?;
        _currentUserEmail = (data['email'] ?? data['userEmail']) as String?;
        _currentUserId    = (data['userId'] ?? data['id'])?.toString();
        _currentUserName  = (data['fullName'] ?? data['name']) as String?;
        _isLoggedIn       = _currentToken != null;

        await _saveToLocal();

        return AuthResult(
          success: true,
          message: 'Login realizado com sucesso!',
          token: _currentToken,
          user: UserData(id: _currentUserId, email: _currentUserEmail, name: _currentUserName),
        );
      } else {
        String msg = 'Email ou senha incorretos';
        if (data['title'] != null) msg = data['title'].toString();
        else if (data['detail'] != null) msg = data['detail'].toString();
        return AuthResult(success: false, message: msg);
      }
    } on TimeoutException {
      return AuthResult(success: false, message: 'Timeout na conexão. Tente novamente.');
    } catch (_) {
      return AuthResult(success: false, message: 'Erro de conexão. Verifique sua internet.');
    }
  }

  Future<AuthResult> logout() async {
    await _clearLocalData();
    return AuthResult(success: true, message: 'Logout realizado com sucesso');
  }

  Future<bool> checkAuthStatus() async {
    if (!_initialized) await initialize();
    if (_currentToken == null) return false;

    if (_isJwtExpired(_currentToken!)) {
      await _clearLocalData();
      return false;
    }

    return true;
  }

  Future<UserData?> getUserProfile() async {
    if (!isLoggedIn) return null;
    
    try {
      final httpClient = HttpClientManager().client;
      final response = await httpClient.get(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/user/profile'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserData.fromJson(data);
      }
    } catch (e) {
      print('Erro ao buscar perfil do usuário: $e');
    }
    return null;
  }

  Future<bool> updateUserProfile(Map<String, dynamic> profileData) async {
    if (!isLoggedIn) return false;
    
    try {
      final httpClient = HttpClientManager().client;
      final response = await httpClient.put(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/user/profile'),
        body: profileData,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao atualizar perfil do usuário: $e');
      return false;
    }
  }

  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();

    if (_currentToken != null) {
      await _vault.setString(_kAccess, _currentToken!);
    }
    if (_currentUserEmail != null) await prefs.setString(_userEmailKey, _currentUserEmail!);
    if (_currentUserId != null)    await prefs.setString(_userIdKey, _currentUserId!);
    if (_currentUserName != null)  await prefs.setString(_userNameKey, _currentUserName!);
  }

  Future<void> _clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await _vault.clear();
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);

    _currentToken = null;
    _currentUserEmail = null;
    _currentUserId = null;
    _currentUserName = null;
    _isLoggedIn = false;
    _initialized = false;
  }

  Future<void> _migrateOldTokenIfAny(SharedPreferences prefs) async {
    const oldTokenKey = 'auth_token'; // caso você tenha usado essa key antes
    final old = prefs.getString(oldTokenKey);
    if (old != null && old.isNotEmpty) {
      await _vault.setString(_kAccess, old);
      await prefs.remove(oldTokenKey);
    }
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(email);

  Map<String, dynamic> _parseJsonSafe(String body) {
    try {
      final d = jsonDecode(body);
      if (d is Map<String, dynamic>) return d;
      return <String, dynamic>{'data': d};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  bool _isJwtExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      ) as Map<String, dynamic>;
      final exp = payload['exp'];
      if (exp is int) {
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        return now >= exp;
      }
      return false;
    } catch (_) {
      // se não for JWT, não expiramos localmente
      return false;
    }
  }
}

class AuthResult {
  final bool success;
  final String message;
  final String? token;
  final UserData? user;

  AuthResult({
    required this.success,
    required this.message,
    this.token,
    this.user,
  });
}

class UserData {
  final String? id;
  final String? email;
  final String? name;

  UserData({this.id, this.email, this.name});

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name};

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: (json['userId'] ?? json['id'])?.toString(),
        email: json['email'] as String?,
        name: (json['fullName'] ?? json['name']) as String?,
      );
}
