import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_management_system/exports.dart';

class Customtxt extends StatelessWidget {
  final String txtfieldname;
  final String hinttxt;

  const Customtxt({
    super.key,
    required this.hinttxt,
    required this.txtfieldname,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 14,
          ),
          Text(txtfieldname,
              style: GoogleFonts.inter(
                  color: Kactivetextcolor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 12,
          ),
          TextField(
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Kinactivetextcolor, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Kinactivetextcolor, width: 1)),
                  hintText: hinttxt)),
        ],
      ),
    );
  }
}
