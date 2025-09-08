import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BottomActionBarWidget extends StatelessWidget {
  final VoidCallback onCheckAvailability;
  final VoidCallback onCall;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final bool isFavorite;
  final String phoneNumber;

  const BottomActionBarWidget({
    super.key,
    required this.onCheckAvailability,
    required this.onCall,
    required this.onFavorite,
    required this.onShare,
    required this.isFavorite,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.outline.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _IconButton(
            icon: Icons.call,
            onTap: onCall,
            tooltip: phoneNumber.isNotEmpty ? phoneNumber : 'Sem telefone',
          ),
          SizedBox(width: 2.w),
          _IconButton(
            icon: isFavorite ? Icons.favorite : Icons.favorite_border,
            onTap: onFavorite,
          ),
          SizedBox(width: 2.w),
          _IconButton(
            icon: Icons.share_outlined,
            onTap: onShare,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: SizedBox(
              height: 6.h,
              child: ElevatedButton.icon(
                onPressed: onCheckAvailability,
                icon: const Icon(Icons.event_available),
                label: const Text('Ver disponibilidade'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  const _IconButton({required this.icon, required this.onTap, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Tooltip(
            message: tooltip ?? '',
            child: Icon(icon, size: 22),
          ),
        ),
      ),
    );
  }
}
