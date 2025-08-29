import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../models/establishment.dart';
import '../../../services/establishment_service.dart';
import 'widgets/bottom_action_bar_widget.dart';
import 'widgets/establishment_header_widget.dart';
import 'widgets/establishment_tabs_widget.dart';

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
  final _service = EstablishmentService();
  Establishment? _est;
  bool _loading = false;
  String? _error;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _est = widget.establishment;
    if (_est == null) {
      _fetch();
    }
  }

  Future<void> _fetch() async {
    if (widget.establishmentId == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final est = await _service.getEstablishmentById(widget.establishmentId!);
      setState(() {
        _est = est;
      });
    } catch (e) {
      setState(() {
        _error = 'Não foi possível carregar o estabelecimento';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _onBack() => Navigator.pop(context);

  void _onShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compartilhar estabelecimento em breve')),
    );
  }

  void _onCheckAvailability() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fluxo de reserva em breve')),
    );
  }

  void _onCall() {
    final phone = _est?.phoneNumber ?? '';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(phone.isEmpty ? 'Telefone não disponível' : 'Ligando para $phone...')),
    );
  }

  void _onFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isFavorite ? 'Adicionado aos favoritos' : 'Removido dos favoritos')),
    );
  }

  void _onWriteReview() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Avaliações em breve')),
    );
  }

  void _onGetDirections() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abrindo mapas em breve')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final est = _est;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _loading && est == null
          ? const Center(child: CircularProgressIndicator())
          : _error != null && est == null
              ? _ErrorView(message: _error!, onRetry: _fetch)
              : Column(
                  children: [
                    EstablishmentHeaderWidget(
                      name: est?.name ?? 'Estabelecimento',
                      heroImageUrl: est?.imageUrl ?? '',
                      rating: 0.0,
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
        isFavorite: _isFavorite,
        onCheckAvailability: _onCheckAvailability,
        onCall: _onCall,
        onFavorite: _onFavorite,
        onShare: _onShare,
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
