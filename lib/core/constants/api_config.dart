class ApiConfig {
  // Ambiente de desenvolvimento - baseado no seu Swagger
  static const String _devBaseUrl = 'http://localhost:5001';
  
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
  
  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  
  // Headers padrão
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

enum Environment {
  development,
  staging,
  production,
}
