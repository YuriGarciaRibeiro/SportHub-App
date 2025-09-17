import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/models/establishment.dart';
import '../all_establishments_view_model.dart';
import 'establishments_loading_state.dart';
import 'establishments_empty_state.dart';
import 'all_establishments_card.dart';

class EstablishmentsList extends StatelessWidget {
  final AllEstablishmentsViewModel viewModel;
  final bool Function(Establishment) isEstablishmentOpen;

  const EstablishmentsList({
    super.key,
    required this.viewModel,
    required this.isEstablishmentOpen,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const EstablishmentsLoadingState();
    }

    if (viewModel.filteredEstablishments.isEmpty) {
      return EstablishmentsEmptyState(
        searchQuery: viewModel.searchQuery,
        onClearSearch: () => viewModel.clearSearch(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Implement your refresh logic here
      },
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
        ),
        itemCount: viewModel.filteredEstablishments.length,
        itemBuilder: (context, index) {
          final establishment = viewModel.filteredEstablishments[index];
          return AllEstablishmentsCard(
            establishment: establishment,
            isEstablishmentOpen: isEstablishmentOpen,
          );
        },
      ),
    );
  }
}