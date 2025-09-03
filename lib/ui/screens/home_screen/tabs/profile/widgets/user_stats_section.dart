import 'package:sizer/sizer.dart';
import '../../../../../../core/app_export.dart';
import '../profile_view_model.dart';

class UserStatsSection extends StatelessWidget {
  final ProfileViewModel viewModel;

  const UserStatsSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final stats = viewModel.getUserStats();
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem(context, 'Reservas', stats['totalReservations'].toString())),
          Expanded(child: _buildStatItem(context, 'Favoritos', stats['favoriteEstablishments'].toString())),
          Expanded(child: _buildStatItem(context, 'Pontos', stats['points'].toString())),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }
}
