import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/app_export.dart';
import '../../../../services/establishment_service.dart';
import '../../../../services/auth_service.dart';
import '../../../../models/establishment.dart';
import '../widgets/greeting_header_widget.dart';
import '../widgets/nearby_establishments_widget.dart';
import '../widgets/upcoming_reservations_widget.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({Key? key}) : super(key: key);

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  final EstablishmentService _establishmentService = EstablishmentService();
  final AuthService _authService = AuthService();
  
  List<Establishment> _establishments = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Mock data for upcoming reservations (manter por enquanto)
  final List<Map<String, dynamic>> _upcomingReservations = [
    {
      "id": 1,
      "establishment": "Arena Sports Center",
      "sport": "Futebol",
      "date": "Hoje",
      "time": "18:00",
      "price": "R\$ 120,00",
      "status": "Confirmada",
    },
    {
      "id": 2,
      "establishment": "Club Tennis Elite",
      "sport": "Tênis",
      "date": "Amanhã",
      "time": "09:30",
      "price": "R\$ 80,00",
      "status": "Pendente",
    },
    {
      "id": 3,
      "establishment": "Quadra do Bairro",
      "sport": "Basquete",
      "date": "Sex, 29/08",
      "time": "20:00",
      "price": "R\$ 60,00",
      "status": "Confirmada",
    },
  ];

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
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final establishments = await _establishmentService.getAllEstablishments();
      
      setState(() {
        _establishments = establishments;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dados: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _convertEstablishmentsToMap() {
    return _establishments.take(5).map((establishment) {
      return {
        "id": establishment.id,
        "name": establishment.name,
        "distance": "1.2 km de distância", // TODO - implementar cálculo real depois
        "rating": 4.5, // TODO - implementar sistema de rating depois
        "reviews": 128, // TODO - implementar sistema de reviews depois
        "startingPrice": "R\$ 80/hora", // TODO - implementar preço real depois
        "isOpen": true, // TODO - implementar horário de funcionamento depois
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
          backgroundColor: AppTheme.lightTheme.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
              color: Colors.grey[400],
            ),
            SizedBox(height: 2.h),
            Text(
              _errorMessage!,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
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
      color: AppTheme.lightTheme.primaryColor,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GreetingHeaderWidget(
              userName: _authService.currentUserName ?? "Usuário",
              location: "São Paulo, SP",
              weather: "25°C",
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
          ],
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
