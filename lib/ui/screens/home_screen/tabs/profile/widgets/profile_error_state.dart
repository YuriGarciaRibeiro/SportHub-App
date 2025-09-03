import 'package:sizer/sizer.dart';
import '../../../../../../core/app_export.dart';
import '../profile_view_model.dart';

class ProfileErrorState extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileErrorState({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 2.h),
          Text(
            'Erro ao carregar perfil',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            viewModel.errorMessage ?? 'Erro desconhecido',
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).hintColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () => viewModel.refreshProfile(),
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
