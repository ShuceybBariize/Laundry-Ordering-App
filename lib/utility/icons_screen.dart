import 'package:laundry_management_system/exports.dart';

class Back_Screen extends StatelessWidget {
  final String? screenname;
  const Back_Screen({super.key, this.screenname});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(FontAwesomeIcons.arrowLeft),
        Text(screenname!),
        const Icon(FontAwesomeIcons.ellipsis)
      ],
    );
  }
}
