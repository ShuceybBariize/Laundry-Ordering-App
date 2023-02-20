import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_management_system/exports.dart';

class RegistorPage extends StatelessWidget {
  RegistorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Kinactivetextcolor,
          // elevation: 0,
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitles(
                    subtitle: "Create New Account For You", title: "Register"),
                Customtxt(hinttxt: "Enter Username", txtfieldname: "UserName"),
                Customtxt(hinttxt: "Enter Your Email", txtfieldname: "Email"),
                Customtxt(hinttxt: "Enter Password", txtfieldname: "Password"),
                custombtn(
                    txtbtn: "Register",
                    onpress: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage())),
                    colorbtn: Kactivecolor,
                    colortxt: Colors.white),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                          color: Kinactivetextcolor,
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage())),
                      child: Text("Login",
                          style: TextStyle(
                              color: Kactivecolor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
