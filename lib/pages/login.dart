import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:laundry_management_system/exports.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitles(
                    subtitle: "Login into your account",
                    title: "Lets get started"),
                Customtxt(hinttxt: "Enter Your email", txtfieldname: "Email"),
                Customtxt(hinttxt: "Enter Password", txtfieldname: "Password"),
                custombtn(
                    txtbtn: "Login",
                    onpress: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage())),
                    colorbtn: Kactivecolor,
                    colortxt: Colors.white),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(
                      color: Kinactivetextcolor,
                      thickness: 1,
                    ),
                    Text("Or Login With account"),
                    Divider(
                      color: Kinactivetextcolor,
                      thickness: 1,
                      endIndent: 12,
                      height: 12,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account ?",
                      style: TextStyle(
                          color: Kinactivetextcolor,
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistorPage())),
                      child: Text("Register",
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
