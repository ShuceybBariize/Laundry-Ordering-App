import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:laundry_management_system/exports.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageSreen extends StatelessWidget {
  const HomePageSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(26, 136, 134, 134),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Location",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Kinactivetextcolor),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.locationDot, color: Kactivecolor ,size: 16),
                        const SizedBox(width: 6),
                        Text("Somalia , Mogadishu",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Kactivetextcolor)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 33,
              ),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.bell,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          TextField(
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white, width: 1)),
                  hintText: "Search",
                  prefixIconColor: Kinactivetextcolor,
                  prefixIcon: Icon(FontAwesomeIcons.search))),
        ]),
      ),
    );
  }
}
