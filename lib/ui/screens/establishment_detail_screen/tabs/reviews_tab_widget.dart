import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../models/review.dart';

class ReviewsTabWidget extends StatefulWidget {
  final Future<void> Function() onWriteReview;
  final String? establishmentId;
  
  const ReviewsTabWidget({
    super.key, 
    required this.onWriteReview,
    this.establishmentId,
  });

  @override
  State<ReviewsTabWidget> createState() => _ReviewsTabWidgetState();
}

class _ReviewsTabWidgetState extends State<ReviewsTabWidget> {
  bool _isLoading = false;
  List<Review> _reviews = [];
  double _averageRating = 0.0;
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    if (_hasLoadedData) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Simular dados de reviews para demonstração
      await Future.delayed(const Duration(milliseconds: 800));
      
      final mockReviews = [
        Review(
          id: '1',
          userId: 'user1',
          userName: 'João Silva',
          establishmentId: widget.establishmentId ?? '',
          rating: 5,
          comment: 'Excelente estabelecimento! Quadras bem cuidadas e ótimo atendimento. Recomendo!',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Review(
          id: '2',
          userId: 'user2',
          userName: 'Maria Santos',
          establishmentId: widget.establishmentId ?? '',
          rating: 4,
          comment: 'Muito bom lugar para praticar esportes. As instalações são modernas e bem mantidas.',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Review(
          id: '3',
          userId: 'user3',
          userName: 'Pedro Costa',
          establishmentId: widget.establishmentId ?? '',
          rating: 5,
          comment: 'Adorei o local! Staff muito atencioso e quadras de excelente qualidade.',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        Review(
          id: '4',
          userId: 'user4',
          userName: 'Ana Oliveira',
          establishmentId: widget.establishmentId ?? '',
          rating: 4,
          comment: 'Bom lugar, preços justos e ambiente agradável. Voltarei com certeza.',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        Review(
          id: '5',
          userId: 'user5',
          userName: 'Carlos Ferreira',
          establishmentId: widget.establishmentId ?? '',
          rating: 3,
          comment: 'Estabelecimento ok, mas pode melhorar o estacionamento.',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ];

      _reviews = mockReviews;
      _averageRating = _reviews.isEmpty 
          ? 0.0 
          : _reviews.map((r) => r.rating).reduce((a, b) => a + b) / _reviews.length;
      _hasLoadedData = true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao carregar avaliações: $e',
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleWriteReview() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      await widget.onWriteReview();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir avaliação: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isLoading && !_hasLoadedData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        // Header com estatísticas das avaliações
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avaliações',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${_reviews.length} avaliação${_reviews.length != 1 ? 'ões' : ''}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_reviews.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber[700],
                            size: 20,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _averageRating.toStringAsFixed(1),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.amber[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleWriteReview,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.6.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: _isLoading 
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : const Icon(Icons.rate_review_outlined),
                  label: Text(
                    _isLoading ? 'Abrindo...' : 'Escrever Avaliação',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Lista de avaliações
        Expanded(
          child: _reviews.isEmpty 
              ? _buildEmptyState(theme)
              : ListView.builder(
                  padding: EdgeInsets.all(4.w),
                  itemCount: _reviews.length,
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    return _buildReviewCard(review, theme);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.reviews_outlined,
                color: theme.colorScheme.primary,
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Nenhuma avaliação ainda',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Seja o primeiro a avaliar este estabelecimento',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(Review review, ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header do review
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  review.userName.isNotEmpty 
                      ? review.userName[0].toUpperCase()
                      : 'U',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getTimeAgo(review.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber[700],
                      size: 14,
                    ),
                    SizedBox(width: 0.5.w),
                    Text(
                      review.rating.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.amber[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Comentário
          if (review.comment.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              review.comment,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
