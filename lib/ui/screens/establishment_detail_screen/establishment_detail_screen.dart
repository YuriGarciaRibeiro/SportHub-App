import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

import '../../../models/establishment.dart';
import '../../../core/utils/notification_helper.dart';
import 'establishment_detail_view_model.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<EstablishmentDetailViewModel>(context, listen: false);
      viewModel.initialize(
        establishmentId: widget.establishmentId,
        initial: widget.establishment,
      );
    });
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
    NotificationHelper.showWarning(context, 'Funcionalidade de ver disponibilidade em desenvolvimento');
  }

  Future<void> _onCall() async {
    final viewModel = Provider.of<EstablishmentDetailViewModel>(context, listen: false);
    final error = await viewModel.makePhoneCall();
    if (error != null && mounted) {
      NotificationHelper.showError(context, error);
    }
  }

  Future<void> _onFavorite() async {
    final viewModel = Provider.of<EstablishmentDetailViewModel>(context, listen: false);
    await viewModel.toggleFavorite(entityType: 1);
    if (!mounted) return;
    final message = viewModel.isFavorite
        ? 'Adicionado aos favoritos'
        : 'Removido dos favoritos';
    NotificationHelper.showInfo(context, message);
  }

  Future<void> _onWriteReview() async {
    final viewModel = Provider.of<EstablishmentDetailViewModel>(context, listen: false);
    await showPlatformReviewSheet(
      context,
      establishmentId: viewModel.establishment?.id,
    );
  }

  Future<void> _onGetDirections() async {
    final viewModel = Provider.of<EstablishmentDetailViewModel>(context, listen: false);
    final error = await viewModel.openDirectionsOnMaps();
    if (error != null && mounted) {
      NotificationHelper.showError(context, error);
    }
  }

  Future<void> _onEmail() async {
    final viewModel = Provider.of<EstablishmentDetailViewModel>(context, listen: false);
    final error = await viewModel.sendEmail();
    if (error != null && mounted) {
      NotificationHelper.showError(context, error);
    }
  }

  Future<void> _onWebsite() async {
    final viewModel = Provider.of<EstablishmentDetailViewModel>(context, listen: false);
    final error = await viewModel.openWebsite();
    if (error != null && mounted) {
      NotificationHelper.showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EstablishmentDetailViewModel>(
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
                  : est == null
                      ? const Center(child: Text('Estabelecimento não encontrado'))
                      : Column(
                          children: [
                            EstablishmentHeaderWidget(
                              name: est.name,
                              heroImageUrl: est.imageUrl,
                              rating: est.averageRating ?? 0.0,
                              distanceText: est.address.city.isNotEmpty ? est.address.city : 'Local',
                              onBackPressed: _onBack,
                              onSharePressed: _onShare,
                            ),
                            Expanded(
                              child: EstablishmentTabsWidget(
                                establishment: est,
                                onCheckAvailability: _onCheckAvailability,
                                onWriteReview: _onWriteReview,
                                onGetDirections: _onGetDirections,
                                onCall: _onCall,
                                onEmail: _onEmail,
                                onWebsite: _onWebsite,
                              ),
                            ),
                          ],
                        ),
          floatingActionButton: FloatingActionButton(
            onPressed: _onFavorite,
            child: Icon(vm.isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
        );
      },
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
