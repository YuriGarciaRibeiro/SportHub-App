# Configuração da API do OpenWeatherMap (Opcional)

Para obter informações meteorológicas em tempo real, você pode configurar uma API key do OpenWeatherMap:

## Passos para configurar:

1. **Criar conta gratuita no OpenWeatherMap:**
   - Acesse: https://openweathermap.org/api
   - Crie uma conta gratuita
   - Gere sua API key

2. **Configurar a API key:**
   - Abra o arquivo `lib/services/location_weather_service.dart`
   - Substitua `YOUR_OPENWEATHER_API_KEY` pela sua API key real
   - Exemplo: `static const String _weatherApiKey = 'sua_api_key_aqui';`

3. **Sem API key:**
   - O app funcionará normalmente, mostrando um valor padrão de 25°C
   - A localização ainda será obtida automaticamente via GPS

## Recursos implementados:

✅ **Localização automática via GPS**
- Solicita permissão de localização
- Obtém coordenadas do dispositivo
- Converte coordenadas em endereço (cidade, estado)
- Funciona em Android e iOS

✅ **Informações meteorológicas**
- API do OpenWeatherMap (opcional)
- Valor padrão quando API não configurada
- Tratamento de erros

✅ **Permissões configuradas**
- Android: ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION
- iOS: NSLocationWhenInUseUsageDescription

## Como funciona:

1. **Primeira vez:** O app solicita permissão de localização
2. **Autorizado:** Obtém coordenadas GPS e converte em endereço
3. **Clima:** Busca temperatura atual (se API configurada)
4. **Fallback:** Usa valores padrão em caso de erro ou permissão negada

## Testando:

- **Simulador iOS:** Use Simulator > Device > Location > Custom Location
- **Android Emulator:** Use Extended Controls > Location
- **Device real:** Permita acesso à localização quando solicitado
