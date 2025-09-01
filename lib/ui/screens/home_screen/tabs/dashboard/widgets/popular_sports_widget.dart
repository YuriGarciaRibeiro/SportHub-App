import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PopularSportsWidget extends StatelessWidget {
  final List<dynamic> sports;
  final VoidCallback? onSeeAllPressed;
  final Function(String)? onSportSelected;

  const PopularSportsWidget({
    super.key,
    required this.sports,
    this.onSeeAllPressed,
    this.onSportSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (sports.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Esportes Populares',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 2.w,
              childAspectRatio: 1.2,
            ),
            itemCount: sports.length > 6 ? 6 : sports.length,
            itemBuilder: (context, index) {
              final sport = sports[index];
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(2.w),
                  child: GestureDetector(
                    onTap: () => onSportSelected?.call(sport.name),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sports_soccer,
                          size: 24.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          sport.name,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
