import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/app_export.dart';
import '../../../../models/sport.dart';
import '../../../../services/sports_service.dart';

class PopularSportsWidget extends StatefulWidget {
  final Function(String)? onSportSelected;

  const PopularSportsWidget({
    super.key,
    this.onSportSelected,
  });

  @override
  State<PopularSportsWidget> createState() => _PopularSportsWidgetState();
}

class _PopularSportsWidgetState extends State<PopularSportsWidget> {
  final SportsService _sportsService = SportsService();
  List<Sport> _sports = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSports();
  }

  Future<void> _loadSports() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final sports = await _sportsService.getAllSports();

      setState(() {
        _sports = sports.take(6).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar esportes: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 15.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        height: 15.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_soccer,
                size: 32,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
              SizedBox(height: 1.h),
              Text(
                'Esportes em breve!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Esportes Populares',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navegar para tela de todos os esportes
                },
                child: Text(
                  'Ver todos',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 12.h, // Altura para acomodar cards quadrados
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _sports.length,
            itemBuilder: (context, index) {
              final sport = _sports[index];
              return _buildSportCard(context, sport);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSportCard(BuildContext context, Sport sport) {
    return Container(
      width: 18.w, // Largura do card
      margin: EdgeInsets.only(right: 3.w),
      child: GestureDetector(
        onTap: () {
          widget.onSportSelected?.call(sport.name);
        },
        child: Column(
          children: [
            Container(
              width: 16.w, // Largura quadrada
              height: 16.w, // Altura igual à largura = QUADRADO
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: sport.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        sport.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.sports,
                            color: Theme.of(context).primaryColor,
                            size: 36, // Ícone ainda maior
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.sports,
                      color: Theme.of(context).primaryColor,
                      size: 36, // Ícone ainda maior
                    ),
            ),
            SizedBox(height: 1.h),
            Text(
              sport.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
