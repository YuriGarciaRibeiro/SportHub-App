import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/services/review_service.dart';
import 'package:sporthub/widgets/platform_widget.dart';

/// Função para abrir o modal de avaliação seguindo os padrões do projeto
Future<void> showPlatformReviewSheet(
  BuildContext context, {
  String? establishmentId,
}) {
  if (defaultTargetPlatform == TargetPlatform.iOS || 
      defaultTargetPlatform == TargetPlatform.macOS) {
    return showCupertinoModalPopup(
      context: context,
      barrierColor: CupertinoColors.black.withOpacity(0.25),
      builder: (_) => ReviewBottomSheet(
        establishmentId: establishmentId,
      ),
    );
  }
  
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ReviewBottomSheet(
      establishmentId: establishmentId,
    ),
  );
}

class ReviewBottomSheet extends StatefulWidget {
  final String? establishmentId;
  final ReviewService _reviewService = ReviewService();

  ReviewBottomSheet({
    super.key,
    this.establishmentId,
  });

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      _showSnackBar('Por favor, selecione uma avaliação');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget._reviewService.submitEstablishmentReview(
        establishmentId: widget.establishmentId,
        rating: _rating,
        comment: _commentController.text.trim(),
      );
      
      if (mounted) {
        Navigator.pop(context);
        _showSnackBar('Avaliação enviada com sucesso!');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Erro ao enviar avaliação. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
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

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      android: _buildMaterialModal(context),
      ios: _buildCupertinoModal(context),
    );
  }

  Widget _buildMaterialModal(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: _buildMaterialContent(),
    );
  }

  Widget _buildCupertinoModal(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: _buildCupertinoContent(),
      ),
    );
  }

  Widget _buildMaterialContent() {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          width: 10.w,
          height: 0.5.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        
        // Header
        _buildMaterialHeader(theme),
        
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMaterialRatingSection(theme),
                SizedBox(height: 2.h),
                SizedBox(
                  height: 180, // Altura fixa para o campo de comentário
                  child: _buildMaterialCommentSection(theme),
                ),
                SizedBox(height: 4.h), // Espaço extra para o scroll
              ],
            ),
          ),
        ),
        
        // Submit button
        _buildMaterialSubmitButton(theme),
      ],
    );
  }

  Widget _buildCupertinoContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          width: 10.w,
          height: 0.5.h,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey3.resolveFrom(context),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        
        // Header
        _buildCupertinoHeader(),
        
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCupertinoRatingSection(),
                SizedBox(height: 2.h),
                Container(
                  height: 180, // Altura fixa para o campo de comentário
                  child: _buildCupertinoCommentSection(),
                ),
                SizedBox(height: 4.h), // Espaço extra para o scroll
              ],
            ),
          ),
        ),
        
        // Submit button
        _buildCupertinoSubmitButton(),
      ],
    );
  }

  Widget _buildMaterialHeader(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Avaliar Estabelecimento',
              style: theme.textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: 2.w),
          IconButton(
            constraints: BoxConstraints(minWidth: 30, minHeight: 30),
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCupertinoHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40), // Espaço para o botão
            child: Text(
              'Avaliar Estabelecimento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: CupertinoColors.label.resolveFrom(context),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            right: 0,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 30,
              onPressed: () => Navigator.pop(context),
              child: Icon(
                CupertinoIcons.xmark,
                size: 20,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialRatingSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sua avaliação',
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(5, (index) {
              final filled = index < _rating;
              return IconButton(
                constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                onPressed: () => setState(() => _rating = index + 1),
                icon: Icon(
                  filled ? Icons.star : Icons.star_border,
                  size: 32,
                  color: filled ? theme.colorScheme.secondary : theme.colorScheme.outline,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCupertinoRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sua avaliação',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label.resolveFrom(context),
          ),
        ),
        SizedBox(height: 2.h),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(5, (index) {
              final filled = index < _rating;
              return CupertinoButton(
                minSize: 40,
                padding: EdgeInsets.zero,
                onPressed: () => setState(() => _rating = index + 1),
                child: Icon(
                  filled ? CupertinoIcons.star_fill : CupertinoIcons.star,
                  size: 32,
                  color: filled 
                      ? CupertinoColors.systemYellow.resolveFrom(context) 
                      : CupertinoColors.systemGrey3.resolveFrom(context),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialCommentSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comentário (opcional)',
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Expanded(
          child: TextField(
            controller: _commentController,
            maxLines: null,
            expands: true,
            maxLength: 500,
            textAlignVertical: TextAlignVertical.top,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Conte-nos sobre sua experiência...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant,
              contentPadding: EdgeInsets.all(3.w),
              counterText: '', // Remove o contador de caracteres
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCupertinoCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comentário (opcional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label.resolveFrom(context),
          ),
        ),
        SizedBox(height: 1.h),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6.resolveFrom(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CupertinoColors.separator.resolveFrom(context),
                width: 0.5,
              ),
            ),
            child: CupertinoTextField(
              controller: _commentController,
              placeholder: 'Conte-nos sobre sua experiência...',
              maxLines: null,
              expands: true,
              maxLength: 500,
              textAlignVertical: TextAlignVertical.top,
              decoration: null,
              style: TextStyle(
                color: CupertinoColors.label.resolveFrom(context),
                fontSize: 14,
              ),
              placeholderStyle: TextStyle(
                color: CupertinoColors.placeholderText.resolveFrom(context),
                fontSize: 14,
              ),
              padding: EdgeInsets.all(3.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialSubmitButton(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitReview,
          child: _isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.onPrimary,
                    ),
                  ),
                )
              : Text(
                  'Publicar Avaliação',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCupertinoSubmitButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        border: Border(
          top: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
            width: 0.5,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: CupertinoButton.filled(
          onPressed: _isSubmitting ? null : _submitReview,
          borderRadius: BorderRadius.circular(12),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CupertinoActivityIndicator(
                    color: CupertinoColors.white,
                  ),
                )
              : const Text(
                  'Publicar Avaliação',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
