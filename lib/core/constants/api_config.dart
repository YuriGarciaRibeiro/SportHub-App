import 'dart:io';

class ApiConfig {
  static String get _devBaseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5001'; // Para emulador Android
    } else {
      return 'http://localhost:5001'; // Para iOS, macOS, Web, Windows
    }
  }
  
  // Ambiente de produção
  static const String _prodBaseUrl = 'https://sua-api-producao.com';
  
  // Ambiente de staging/teste
  static const String _stagingBaseUrl = 'https://staging-api.com';
  
  // Determinar qual ambiente usar
  static const Environment currentEnvironment = Environment.development;
  
  // URL base baseada no ambiente
  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return _devBaseUrl;
      case Environment.staging:
        return _stagingBaseUrl;
      case Environment.production:
        return _prodBaseUrl;
    }
  }
  
  // Endpoints da API - baseado no seu Swagger
  static String get loginEndpoint => '$baseUrl/api/v1/auth/login';
  static String get getEstablishmentsEndpoint => '$baseUrl/api/v1/establishments';
  static String get getSportsEndpoint => '$baseUrl/api/v1/api/sports';
  static String get favoritesEndpoint => '$baseUrl/api/v1/favorites';

  // TODO: [Facilidade: 2, Prioridade: 4] - Adicionar endpoints de registro de usuário
  // TODO: [Facilidade: 2, Prioridade: 3] - Adicionar endpoints de favoritos
  // TODO: [Facilidade: 3, Prioridade: 5] - Adicionar endpoints de reservas
  // TODO: [Facilidade: 2, Prioridade: 3] - Adicionar endpoints de avaliações
  // TODO: [Facilidade: 3, Prioridade: 3] - Implementar configuração de ambiente via variáveis de ambiente
  // TODO: [Facilidade: 2, Prioridade: 2] - Adicionar versionamento automático da API

  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  
  // Headers padrão
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // TODO: [Facilidade: 2, Prioridade: 4] - Adicionar header de autorização automático quando logado
    // TODO: [Facilidade: 2, Prioridade: 2] - Implementar headers de versionamento da API
  };
}

enum Environment {
  development,
  staging,
  production,
}
