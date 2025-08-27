import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_config.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Keys para SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';

  String? _currentToken;
  String? _currentUserEmail;
  String? _currentUserId;
  String? _currentUserName;
  bool _isLoggedIn = false;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserEmail => _currentUserEmail;
  String? get currentUserId => _currentUserId;
  String? get currentUserName => _currentUserName;
  String? get currentToken => _currentToken;

  // Inicializar serviço (verificar se há token salvo)
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentToken = prefs.getString(_tokenKey);
    _currentUserEmail = prefs.getString(_userEmailKey);
    _currentUserId = prefs.getString(_userIdKey);
    _currentUserName = prefs.getString(_userNameKey);
    
    if (_currentToken != null) {
      _isLoggedIn = true;
    }
  }

  // Método de login baseado no Swagger
  Future<AuthResult> login(String email, String password) async {
    try {
      // Validar campos vazios
      if (email.isEmpty || password.isEmpty) {
        return AuthResult(
          success: false,
          message: 'Por favor, preencha todos os campos',
        );
      }

      // Validar formato de email
      if (!_isValidEmail(email)) {
        return AuthResult(
          success: false,
          message: 'Por favor, insira um email válido',
        );
      }

      // Fazer requisição para a API conforme Swagger
      final response = await http.post(
        Uri.parse(ApiConfig.loginEndpoint),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(ApiConfig.defaultTimeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _currentToken = responseData['token'];
        _currentUserEmail = responseData['email'];
        _currentUserId = responseData['userId'];
        _currentUserName = responseData['fullName'];
        _isLoggedIn = true;

        await _saveToLocal();

        return AuthResult(
          success: true,
          message: 'Login realizado com sucesso!',
          token: _currentToken,
          user: UserData(
            id: _currentUserId,
            email: _currentUserEmail,
            name: _currentUserName,
          ),
        );
      } else {
        // Erro no login - tratamento baseado no ProblemDetails do Swagger
        String errorMessage = 'Email ou senha incorretos';
        
        if (responseData['title'] != null) {
          errorMessage = responseData['title'];
        } else if (responseData['detail'] != null) {
          errorMessage = responseData['detail'];
        }

        return AuthResult(
          success: false,
          message: errorMessage,
        );
      }
    } catch (e) {
      // Erro de conexão ou timeout
      String errorMessage = 'Erro de conexão. Verifique sua internet.';
      
      if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Timeout na conexão. Tente novamente.';
      }

      return AuthResult(
        success: false,
        message: errorMessage,
      );
    }
  }

  // Método de logout simples
  Future<AuthResult> logout() async {
    await _clearLocalData();
    
    return AuthResult(
      success: true,
      message: 'Logout realizado com sucesso',
    );
  }

  // Verificar status de autenticação
  Future<bool> checkAuthStatus() async {
    return _isLoggedIn && _currentToken != null;
  }

  // Salvar dados localmente
  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentToken != null) {
      await prefs.setString(_tokenKey, _currentToken!);
    }
    if (_currentUserEmail != null) {
      await prefs.setString(_userEmailKey, _currentUserEmail!);
    }
    if (_currentUserId != null) {
      await prefs.setString(_userIdKey, _currentUserId!);
    }
    if (_currentUserName != null) {
      await prefs.setString(_userNameKey, _currentUserName!);
    }
  }

  // Limpar dados locais
  Future<void> _clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    
    _currentToken = null;
    _currentUserEmail = null;
    _currentUserId = null;
    _currentUserName = null;
    _isLoggedIn = false;
  }

  // Validar formato de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

// Classe para resultado da autenticação
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

// Classe para dados do usuário - baseada no AuthResponse do Swagger
class UserData {
  final String? id;
  final String? email;
  final String? name;

  UserData({
    this.id,
    this.email,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['userId']?.toString(),
      email: json['email'],
      name: json['fullName'],
    );
  }
}
