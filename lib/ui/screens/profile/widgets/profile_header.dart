import 'package:sizer/sizer.dart';
import '../../../../../../core/app_export.dart';
import '../profile_view_model.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileHeader({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final user = viewModel.userProfile;
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40.sp,
            backgroundColor: Colors.white,
            backgroundImage: user?.profileImageUrl != null 
                ? NetworkImage(user!.profileImageUrl!)
                : null,
            child: user?.profileImageUrl == null
                ? Icon(
                    Icons.person,
                    size: 40.sp,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
          ),
          
          SizedBox(height: 2.h),
          
          Text(
            user?.name ?? 'Usuário',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          Text(
            user?.email ?? 'email@exemplo.com',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          
          SizedBox(height: 1.h),
          
          if (user?.preferredSport != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user!.preferredSport!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
