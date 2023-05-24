import 'package:laundry_management_system/exports.dart';

class Customtxt extends StatelessWidget {
  final String txtfieldname;
  final String hinttxt;
  final IconData? sufficon;
  final Color? suffclor;

  const Customtxt({
    super.key,
    this.suffclor,
    this.sufficon,
    required this.hinttxt,
    required this.txtfieldname,
    required TextEditingController controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Text(txtfieldname,
            style: GoogleFonts.inter(
                color: Kactivetextcolor,
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 9,
        ),
        TextField(
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(18),
                fillColor: Colors.black,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Kinactivetextcolor, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Kinactivetextcolor, width: 1)),
                hintText: hinttxt,
                suffixIcon: Icon(sufficon),
                suffixIconColor: suffclor)),
      ],
    );
  }
}
