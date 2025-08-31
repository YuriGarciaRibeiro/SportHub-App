import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/app_export.dart';
import '../../../../services/establishment_service.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/location_weather_service.dart';
import '../../../../models/establishment.dart';
import '../widgets/greeting_header_widget.dart';
import '../widgets/nearby_establishments_widget.dart';
import '../widgets/upcoming_reservations_widget.dart';
import '../widgets/no_upcoming_reservations_widget.dart';
import '../widgets/popular_sports_widget.dart';
import '../widgets/quick_actions_widget.dart';
import '../widgets/quick_search_widget.dart';

class DashboardTab extends StatefulWidget {
  final VoidCallback? onNavigateToSearch;
  
  const DashboardTab({super.key, this.onNavigateToSearch});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  final EstablishmentService _establishmentService = EstablishmentService();
  final AuthService _authService = AuthService();
  final LocationWeatherService _locationWeatherService = LocationWeatherService();
  
  List<Establishment> _establishments = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _currentLocation = "São Paulo, SP";
  String _currentWeather = "25°C";

  
  final List<Map<String, dynamic>> _upcomingReservations = [
    // {
    //   "id": 1,
    //   "establishment": "Arena Sports Center", 
    //   "sport": "Futebol",
    //   "date": "Hoje",
    //   "time": "18:00",
    //   "price": "R\$ 120,00",
    //   "status": "Confirmada",
    // },
  ];

  bool _isEstablishmentOpen(Establishment establishment) {
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final openingMinutes = establishment.openingTime.hour * 60 + establishment.openingTime.minute;
    final closingMinutes = establishment.closingTime.hour * 60 + establishment.closingTime.minute;
    return currentMinutes >= openingMinutes && currentMinutes <= closingMinutes;
  }

  @override
  void initState() {
    super.initState();
    _initializeAuth();
    _loadData();
  }

  Future<void> _initializeAuth() async {
    await _authService.initialize();
  }

  Future<void> _loadData() async {
    try {
      if (!mounted) return;
      
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Carrega dados em paralelo
      final futures = await Future.wait([
        _establishmentService.getAllEstablishments(),
        _locationWeatherService.getCurrentLocationAndWeather(),
      ]);

      if (!mounted) return;

      final establishments = futures[0] as List<Establishment>;
      final locationWeather = futures[1] as Map<String, String>;
      
      setState(() {
        _establishments = establishments;
        _currentLocation = locationWeather['location'] ?? "São Paulo, SP";
        _currentWeather = locationWeather['weather'] ?? "25°C";
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _errorMessage = 'Erro ao carregar dados: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _convertEstablishmentsToMap() {
    return _establishments.take(5).map((establishment) {
      return {
        "id": establishment.id,
        "name": establishment.name,
        "distance": "- km", // TODO: Backend - implementar cálculo de distância baseado em geolocalização
        "rating": 0.0, // TODO: Backend - implementar sistema de avaliações
        "reviews": 0, // TODO: Backend - implementar contagem de reviews
        "startingPrice": establishment.startingPrice ?? "Consultar",
        "isOpen": _isEstablishmentOpen(establishment),
        "image": establishment.imageUrl.isNotEmpty ? establishment.imageUrl : null,
        "sports": establishment.sports.map((sport) => sport.name).toList(),
      };
    }).toList();
  }

  Future<void> _handleRefresh() async {
    await _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dados atualizados!'),
          backgroundColor: Theme.of(context).primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _onSportSelected(String sportName) {
    // Navigate to search tab with sport filter
    widget.onNavigateToSearch?.call();
    
    // Show feedback that sport was selected
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Buscando estabelecimentos de $sportName'),
          backgroundColor: Theme.of(context).primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onBookNow() {
    // Navega para a tab de pesquisa
    widget.onNavigateToSearch?.call();
  }

  void _onFindNearby() {
    // Navega para a tab de pesquisa (mesma ação por enquanto)
    widget.onNavigateToSearch?.call();
  }

  void _onViewFavorites() {
    // TODO: Backend - implementar sistema de favoritos (modelo, API endpoints)
    // TODO: Frontend - criar tela de favoritos
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sistema de favoritos em desenvolvimento'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onViewHistory() {
    // TODO: Backend - implementar histórico de reservas (modelo, API endpoints)
    // TODO: Frontend - criar tela de histórico
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sistema de histórico em desenvolvimento'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            SizedBox(height: 2.h),
            Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final nearbyEstablishments = _convertEstablishmentsToMap();
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Theme.of(context).primaryColor,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GreetingHeaderWidget(
              userName: _authService.currentUserName ?? "Usuário",
              location: _currentLocation,
              weather: _currentWeather,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 1.h),
          ),
          SliverToBoxAdapter(
            child: QuickSearchWidget(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 1.h),
          ),
          SliverToBoxAdapter(
            child: QuickActionsWidget(
              onBookNow: _onBookNow,
              onFindNearby: _onFindNearby,
              onViewFavorites: _onViewFavorites,
              onViewHistory: _onViewHistory,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 1.h),
          ),
          if (_upcomingReservations.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: UpcomingReservationsWidget(
                reservations: _upcomingReservations,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 4.h),
            ),
          ] else ...[
            SliverToBoxAdapter(
              child: NoUpcomingReservationsWidget(
                onBookNow: () {
                  widget.onNavigateToSearch?.call();
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 3.h),
            ),
          ],
          SliverToBoxAdapter(
            child: PopularSportsWidget(
              onSportSelected: _onSportSelected,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 1.h),
          ),
          SliverToBoxAdapter(
            child: NearbyEstablishmentsWidget(
              establishments: nearbyEstablishments,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 4.h),
          ),
          
        ],
      ),
    );
  }
}
