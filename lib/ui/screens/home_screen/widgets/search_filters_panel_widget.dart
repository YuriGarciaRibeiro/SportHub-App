import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum SortType { name, rating, distance }

class SearchFiltersPanelWidget extends StatelessWidget {
  final String? selectedSport;
  final SortType currentSort;
  final double maxDistance;
  final List<String> availableSports;
  final Function(String?) onSportChanged;
  final Function(SortType) onSortChanged;
  final Function(double) onDistanceChanged;

  const SearchFiltersPanelWidget({
    super.key,
    required this.selectedSport,
    required this.currentSort,
    required this.maxDistance,
    required this.availableSports,
    required this.onSportChanged,
    required this.onSortChanged,
    required this.onDistanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtros',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          
          // Filtro por esporte
          Text(
            'Esporte',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          DropdownButtonFormField<String>(
            value: selectedSport,
            hint: const Text('Todos os esportes'),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            ),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Todos os esportes'),
              ),
              ...availableSports.map((sport) => DropdownMenuItem<String>(
                value: sport,
                child: Text(sport),
              )),
            ],
            onChanged: onSportChanged,
          ),
          
          SizedBox(height: 2.h),
          
          // Ordenação
          Text(
            'Ordenar por',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          DropdownButtonFormField<SortType>(
            value: currentSort,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            ),
            items: const [
              DropdownMenuItem<SortType>(
                value: SortType.name,
                child: Text('Nome'),
              ),
              DropdownMenuItem<SortType>(
                value: SortType.rating,
                child: Text('Avaliação'),
              ),
              DropdownMenuItem<SortType>(
                value: SortType.distance,
                child: Text('Distância'),
              ),
            ],
            onChanged: (value) => onSortChanged(value ?? SortType.name),
          ),
          
          SizedBox(height: 2.h),
          
          // Distância máxima
          Text(
            'Distância máxima: ${maxDistance.toInt()} km',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Slider(
            value: maxDistance,
            min: 1.0,
            max: 100.0,
            divisions: 99,
            label: '${maxDistance.toInt()} km',
            onChanged: onDistanceChanged,
          ),
        ],
      ),
    );
  }
}
