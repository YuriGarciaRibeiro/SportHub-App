# 🏟️ SportHub App

Uma plataforma moderna e intuitiva para reserva de quadras esportivas, conectando usuários a estabelecimentos esportivos com facilidade e eficiência.

## 📱 Sobre o Projeto

O SportHub é um aplicativo Flutter que permite aos usuários encontrar, visualizar e reservar quadras esportivas em estabelecimentos próximos. Com uma interface elegante e funcionalidades abrangentes, o app oferece uma experiência completa para entusiastas do esporte.

### ✨ Principais Funcionalidades

- **🔍 Busca Inteligente**: Encontre estabelecimentos por localização, esporte ou nome
- **📍 Geolocalização**: Descubra quadras próximas com base na sua localização atual
- **🏆 Avaliações**: Sistema completo de avaliações e comentários
- **📅 Reservas**: Agendamento fácil e intuitivo de horários
- **⭐ Favoritos**: Salve seus estabelecimentos preferidos
- **🌤️ Clima**: Informações meteorológicas integradas
- **🎯 Filtros Avançados**: Filtre por esporte, distância, preço e avaliação
- **📊 Dashboard**: Visão geral das suas reservas e atividades
- **🔒 Autenticação Segura**: Sistema de login seguro com Flutter Secure Storage

## 🏗️ Arquitetura

O projeto segue uma arquitetura limpa e bem organizada:

```
lib/
├── core/                 # Configurações centrais
│   ├── constants/        # Constantes da aplicação
│   ├── http/            # Cliente HTTP
│   ├── routes/          # Roteamento
│   ├── theme/           # Temas e estilos
│   └── utils/           # Utilitários
├── models/              # Modelos de dados
│   ├── address.dart
│   ├── court.dart
│   ├── establishment.dart
│   ├── reservation.dart
│   ├── review.dart
│   └── sport.dart
├── providers/           # Gerenciamento de estado
├── services/            # Serviços e APIs
│   ├── auth_service.dart
│   ├── establishment_service.dart
│   ├── reservation_service.dart
│   └── location_weather_service.dart
├── ui/                  # Interface do usuário
│   ├── screens/         # Telas da aplicação
│   └── widgets/         # Componentes reutilizáveis
└── main.dart           # Ponto de entrada
```

## 🛠️ Tecnologias Utilizadas

### Framework e Linguagem
- **Flutter 3.24.0+** - Framework de desenvolvimento multiplataforma
- **Dart 3.9.0+** - Linguagem de programação

### Gerenciamento de Estado
- **Provider 6.1.1** - Gerenciamento de estado reativo

### Navegação
- **GoRouter 14.2.7** - Roteamento declarativo moderno

### HTTP e APIs
- **HTTP 1.1.0** - Cliente HTTP para comunicação com APIs

### Localização e Mapas
- **Geolocator 11.0.0** - Serviços de geolocalização
- **Geocoding 3.0.0** - Conversão de coordenadas em endereços

### Interface do Usuário
- **Sizer 2.0.15** - Design responsivo
- **Cupertino Icons 1.0.8** - Ícones iOS

### Armazenamento e Segurança
- **Shared Preferences 2.2.2** - Armazenamento local
- **Flutter Secure Storage 9.2.4** - Armazenamento seguro

### Utilitários
- **URL Launcher 6.2.6** - Abertura de URLs externas

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK 3.24.0 ou superior
- Dart SDK 3.9.0 ou superior
- Android Studio / VS Code
- Xcode (para iOS)
- Device ou emulador configurado

### Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/YuriGarciaRibeiro/SportHub-App.git
   cd SportHub-App
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o projeto**
   ```bash
   flutter run
   ```

### Configuração de Ambiente

1. **Permissões de Localização**
   - Android: Verificar permissões no `android/app/src/main/AndroidManifest.xml`
   - iOS: Configurar no `ios/Runner/Info.plist`

2. **API Configuration**
   - Configure as URLs da API em `lib/core/constants/api_config.dart`

## 📱 Plataformas Suportadas

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12.0+)
- ✅ **Web** (Em desenvolvimento)
- ⏳ **Desktop** (Planejado)

## 🔧 Scripts Úteis

```bash
# Executar testes
flutter test

# Gerar build para Android
flutter build apk --release

# Gerar build para iOS
flutter build ios --release

# Analisar código
flutter analyze

# Formatar código
dart format .
```

## 📂 Estrutura de Dados

### Modelos Principais

- **Establishment**: Representa um estabelecimento esportivo
- **Court**: Quadra específica dentro de um estabelecimento
- **Sport**: Modalidade esportiva
- **Reservation**: Reserva de quadra
- **Review**: Avaliação de estabelecimento
- **Address**: Endereço com geolocalização

## � Telas Pendentes de Implementação

### 🔐 **Autenticação**
- [ ] **Tela de Registro/Cadastro** 
  - Formulário de criação de conta
  - Validação de dados de usuário
  - Integração com backend de autenticação

- [ ] **Tela de Recuperação de Senha**
  - Formulário para solicitar reset de senha
  - Validação de email
  - Feedback de envio de email

### 🏟️ **Sistema de Reservas (Core)**
- [ ] **Tela de Agendamento/Booking**
  - Calendário interativo para seleção de data
  - Grade de horários disponíveis
  - Seleção de duração da reserva
  - Confirmação de agendamento
  - Integração com sistema de pagamento

- [ ] **Tela de Confirmação de Reserva**
  - Detalhes da reserva criada
  - Informações de pagamento
  - Opções de compartilhamento
  - QR Code para check-in

- [ ] **Tela de Detalhes da Reserva**
  - Visualização completa da reserva
  - Opções de cancelamento/modificação
  - Status da reserva em tempo real

### 👤 **Perfil e Configurações**
- [ ] **Tela de Edição de Perfil**
  - Formulário de edição de dados pessoais
  - Upload de foto de perfil
  - Validação de campos
  - Preferências de esporte

- [ ] **Tela de Configurações**
  - Configurações de notificações
  - Preferências de idioma
  - Configurações de privacidade
  - Opções de tema

- [ ] **Tela de Histórico de Atividades**
  - Histórico completo de reservas
  - Estatísticas de uso
  - Relatórios de atividades

### ⭐ **Favoritos**
- [ ] **Tela de Favoritos**
  - Lista de estabelecimentos favoritos
  - Filtros e ordenação
  - Remoção de favoritos
  - Compartilhamento de listas

### 🔍 **Busca Avançada**
- [ ] **Tela de Filtros Avançados**
  - Filtros por localização/raio
  - Filtros por faixa de preço
  - Filtros por avaliação
  - Filtros por horário de funcionamento
  - Filtros por modalidades esportivas

- [ ] **Tela de Resultados no Mapa**
  - Visualização dos estabelecimentos em mapa
  - Marcadores interativos
  - Informações rápidas em pop-ups

### � **Pagamentos**
- [ ] **Tela de Métodos de Pagamento**
  - Cadastro de cartões
  - Métodos de pagamento disponíveis
  - Histórico de transações

- [ ] **Tela de Checkout**
  - Resumo da reserva
  - Seleção de método de pagamento
  - Aplicação de cupons/desconto
  - Confirmação de pagamento

### 🔔 **Notificações**
- [ ] **Tela de Notificações**
  - Central de notificações
  - Notificações de reservas
  - Promoções e ofertas
  - Configurações de notificação

### 🎯 **Funcionalidades Extras**
- [ ] **Tela de Avaliações do Usuário**
  - Histórico de avaliações feitas
  - Edição de avaliações
  - Ranking e badges

- [ ] **Tela de Suporte/Ajuda**
  - FAQ
  - Chat de suporte
  - Formulário de contato
  - Tutoriais de uso

- [ ] **Tela de Promoções**
  - Ofertas especiais
  - Cupons disponíveis
  - Programas de fidelidade

### 🏢 **Para Estabelecimentos (Futuro)**
- [ ] **Dashboard do Estabelecimento**
- [ ] **Gestão de Quadras e Horários**
- [ ] **Relatórios de Reservas**
- [ ] **Gestão de Avaliações**

## 🎯 **Prioridade de Implementação**

### **📍 Fase 1 - Essencial (2-3 meses)**
1. **Tela de Registro/Cadastro** - Fundamental para onboarding
2. **Tela de Recuperação de Senha** - Essencial para UX
3. **Tela de Agendamento/Booking** - Core do negócio
4. **Tela de Confirmação de Reserva** - Complementa o booking

### **📍 Fase 2 - Importante (1-2 meses)**
5. **Tela de Edição de Perfil** - Experiência do usuário
6. **Tela de Detalhes da Reserva** - Gestão de reservas
7. **Tela de Favoritos** - Funcionalidade popular
8. **Tela de Filtros Avançados** - Melhora busca

### **📍 Fase 3 - Complementar (1-2 meses)**
9. **Tela de Configurações** - Personalização
10. **Tela de Métodos de Pagamento** - Monetização
11. **Tela de Checkout** - Processo de compra
12. **Tela de Notificações** - Engajamento

### **📍 Fase 4 - Expansão (2+ meses)**
13. **Telas de Suporte e Ajuda** - Atendimento
14. **Telas de Promoções** - Marketing
15. **Funcionalidades para Estabelecimentos** - B2B

## 📊 **Status Atual das Telas**

### ✅ **Implementadas**
- ✅ Splash Screen
- ✅ Login Screen  
- ✅ Dashboard/Home
- ✅ Search Screen
- ✅ Reservations Screen
- ✅ Profile Screen
- ✅ Establishment Detail Screen

### ⚠️ **Parcialmente Implementadas**
- ⚠️ Profile Screen (falta edição)
- ⚠️ Search Screen (falta filtros avançados)
- ⚠️ Establishment Detail (falta booking)

### ❌ **Não Implementadas**
- ❌ 15+ telas listadas acima

## 🚀 **Recomendações**

1. **Priorizar Core Features**: Focar primeiro nas telas de reserva/agendamento
2. **UX Sequence**: Implementar fluxos completos (registro → busca → reserva → confirmação)
3. **MVP Approach**: Versões simples primeiro, depois melhorias
4. **User Testing**: Testar cada tela antes de partir para a próxima

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Convenções de Código

- Siga as [Dart Style Guidelines](https://dart.dev/guides/language/effective-dart/style)
- Use nomes descritivos para variáveis e funções
- Documente funções públicas
- Mantenha arquivos organizados por responsabilidade

## 🐛 Reportar Bugs

Encontrou um bug? Abra uma [issue](https://github.com/YuriGarciaRibeiro/SportHub-App/issues) descrevendo:

- Passos para reproduzir
- Comportamento esperado vs atual
- Screenshots (se aplicável)
- Informações do dispositivo

## 📄 Licença

Este projeto está sob a licença [MIT](LICENSE).

## 👨‍💻 Autor

**Yuri Garcia Ribeiro**
- GitHub: [@YuriGarciaRibeiro](https://github.com/YuriGarciaRibeiro)

---

<div align="center">
  <p>Feito com ❤️ e Flutter</p>
  <p>⭐ Deixe uma estrela se este projeto te ajudou!</p>
</div>
