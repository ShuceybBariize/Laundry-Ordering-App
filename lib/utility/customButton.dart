import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_management_system/constans/colors.dart';
import 'package:laundry_management_system/pages/login.dart';

class custombtn extends StatelessWidget {
  final Color colorbtn;
  final Color colortxt;
  final String txtbtn;
  final Function() onpress;

  custombtn(
      {super.key,
      required this.txtbtn,
      required this.onpress,
      required this.colorbtn,
      required this.colortxt});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 100,
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(375, 60),
              elevation: 0,
              primary: colorbtn,
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
          ),
        ),
      ],
    );
  }
}
