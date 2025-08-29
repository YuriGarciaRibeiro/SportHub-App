import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EstablishmentHeaderWidget extends StatelessWidget {
  final String name;
  final String heroImageUrl;
  final double rating;
  final String distanceText;
  final VoidCallback onBackPressed;
  final VoidCallback onSharePressed;

  const EstablishmentHeaderWidget({
    super.key,
    required this.name,
    required this.heroImageUrl,
    required this.rating,
    required this.distanceText,
    required this.onBackPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: Stack(
        children: [
          // Hero Image
          SizedBox(
            width: double.infinity,
            height: 30.h,
            child: heroImageUrl.isNotEmpty
                ? Image.network(
                    heroImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _fallbackImage(context),
                  )
                : _fallbackImage(context),
          ),
          // Gradient overlay
          Container(
            width: double.infinity,
            height: 30.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          // Header controls
          Positioned(
            top: 6.h,
            left: 4.w,
            right: 4.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleButton(context, Icons.arrow_back, onBackPressed),
                _circleButton(context, Icons.share_outlined, onSharePressed),
              ],
            ),
          ),
          // Info bottom
          Positioned(
            bottom: 2.h,
            left: 4.w,
            right: 4.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 1.w),
                    Text(
                      rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.location_on, color: Colors.white, size: 16),
                    SizedBox(width: 1.w),
                    Text(
                      distanceText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackImage(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.white70, size: 40),
      ),
    );
  }

  Widget _circleButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
