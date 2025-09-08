import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

import '../../../models/establishment.dart';
import 'establishment_detail_view_model.dart';
import 'widgets/bottom_action_bar_widget.dart';
import 'widgets/establishment_header_widget.dart';
import 'widgets/establishment_tabs_widget.dart';
import 'widgets/review_bottom_sheet.dart';

class EstablishmentDetailScreen extends StatefulWidget {
  final String? establishmentId;
  final Establishment? establishment;

  const EstablishmentDetailScreen({
    super.key,
    this.establishmentId,
    this.establishment,
  }) : assert(establishmentId != null || establishment != null,
            'Provide either establishmentId or establishment');

  @override
  State<EstablishmentDetailScreen> createState() => _EstablishmentDetailScreenState();
}

class _EstablishmentDetailScreenState extends State<EstablishmentDetailScreen> {
  late final EstablishmentDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EstablishmentDetailViewModel();
    _viewModel.initialize(
      establishmentId: widget.establishmentId,
      initial: widget.establishment,
    );
  }

  void _onBack() => Navigator.pop(context);

  void _onShare() {
    // TODO: [Facilidade: 2, Prioridade: 2] - Implementar compartilhamento via Share API nativa
    // TODO: [Facilidade: 3, Prioridade: 2] - Adicionar deep linking para estabelecimentos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Compartilhamento em desenvolvimento',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _onCheckAvailability() {
    // TODO: [Facilidade: 5, Prioridade: 5] - Implementar backend do sistema de reservas e disponibilidade
    // TODO: [Facilidade: 4, Prioridade: 4] - Criar tela de reserva/agendamento com calendário
    // TODO: [Facilidade: 3, Prioridade: 3] - Implementar slots de horário dinâmicos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sistema de reservas em desenvolvimento',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _onCall() async {
    final error = await _viewModel.makePhoneCall();
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _onFavorite() async {
    await _viewModel.toggleFavorite(entityType: 1); // 1 para estabelecimento
  }

  Future<void> _onWriteReview() async {
  await showPlatformReviewSheet(
    context,
    establishmentId: _viewModel.establishment?.id,
  );
}

  Future<void> _onGetDirections() async {
    final error = await _viewModel.openDirectionsOnMaps();
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
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
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<EstablishmentDetailViewModel>(
        builder: (context, vm, _) {
          final est = vm.establishment;
          return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: vm.isLoading && est == null
          ? const Center(child: CircularProgressIndicator())
          : vm.hasError && est == null
              ? _ErrorView(
                  message: vm.errorMessage ?? 'Não foi possível carregar o estabelecimento',
                  onRetry: () => vm.initialize(
                    establishmentId: widget.establishmentId,
                    initial: widget.establishment,
                  ),
                )
              : Column(
                  children: [
                    EstablishmentHeaderWidget(
                      name: est?.name ?? 'Estabelecimento',
                      heroImageUrl: est?.imageUrl ?? '',
                      rating: est?.averageRating ?? 0.0,
                      distanceText: est != null
                          ? est.address.city.isNotEmpty ? est.address.city : 'Local'
                          : '',
                      onBackPressed: _onBack,
                      onSharePressed: _onShare,
                    ),

                    Expanded(
                      child: EstablishmentTabsWidget(
                        establishment: est!,
                        onCheckAvailability: _onCheckAvailability,
                        onWriteReview: _onWriteReview,
                        onGetDirections: _onGetDirections,
                      ),
                    ),
                  ],
                ),

      bottomNavigationBar: BottomActionBarWidget(
        phoneNumber: est?.phoneNumber ?? '',
        isFavorite: vm.isFavorite,
        onCheckAvailability: _onCheckAvailability,
        onCall: _onCall,
        onFavorite: _onFavorite,
        onShare: _onShare,
      ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 56,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            SizedBox(height: 1.5.h),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 1.5.h),
            ElevatedButton(onPressed: onRetry, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    );
  }
}
