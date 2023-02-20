import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:laundry_management_system/constans/colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(26, 136, 134, 134),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFE2E1E4),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "History",
            style: TextStyle(
                color: Kactivetextcolor,
                fontWeight: FontWeight.bold,
                fontSize: 26),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // padding: EdgeInsets.only(left: 80),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: Kinactivetextcolor,
                    borderRadius: BorderRadius.circular(14)),
                height: 165,
                width: 370,
              )
            ],
          )
        ],
      ),
    );
  }
}
