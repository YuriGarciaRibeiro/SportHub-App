import 'package:sizer/sizer.dart';
import 'package:sporthub/models/establishment.dart';
import 'package:sporthub/ui/screens/home_screen/tabs/dashboard/widgets/establishment_card.dart';
import '../../../../../../core/app_export.dart';
import '../../../../establishment_detail_screen/establishment_detail_screen.dart';

class NearbyEstablishmentsWidget extends StatelessWidget {
  final List<Establishment> establishments;
  final bool Function(Establishment) isEstablishmentOpen;

  const NearbyEstablishmentsWidget({
    super.key,
    required this.establishments,
    required this.isEstablishmentOpen,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 29.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: establishments.length,
        itemBuilder: (context, index) {
          final establishment = establishments[index];
          return EstablishmentCard(establishment: establishment, isEstablishmentOpen: isEstablishmentOpen);
        },
      ),
    );
  }
}
