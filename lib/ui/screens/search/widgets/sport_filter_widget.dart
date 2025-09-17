import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../search_view_model.dart';

class SportFilterWidget extends StatelessWidget {
  final SearchViewModel viewModel;
  
  const SportFilterWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: Chip(
        label: Text(viewModel.selectedSport?.name ?? 'Todos os esportes'),
        avatar: Icon(
          viewModel.selectedSport != null ? Icons.sports : Icons.filter_list,
          size: 16.sp,
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'all',
          child: Text('Todos os esportes'),
        ),
        ...viewModel.availableSports.map(
          (sport) => PopupMenuItem<String>(
            value: sport.id,
            child: Text(sport.name),
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'all') {
          viewModel.updateSportFilter(null);
        } else {
          try {
            final sport = viewModel.availableSports.firstWhere(
              (sport) => sport.id == value,
            );
            viewModel.updateSportFilter(sport);
          } catch (e) {
            // Se não encontrar o esporte, não faz nada
          }
        }
      },
    );
  }
}