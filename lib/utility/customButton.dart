import '../exports.dart';

class custombtn extends StatelessWidget {
  final Color colorbtn;
  final Color colortxt;
  final String txtbtn;
  final Function() onpress;

  const custombtn(
      {super.key,
      required this.txtbtn,
      required this.onpress,
      required this.colorbtn,
      required this.colortxt});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(390, 62),
        backgroundColor: colorbtn,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      onPressed: onpress,
      child: Text(
        txtbtn,
        style: GoogleFonts.inter(
          color: colortxt,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
