import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:laundry_management_system/exports.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();

  final _password = TextEditingController();

  bool isloading = false;

  Future SignIn() async {
    try {
      isloading = true;
      setState(() {});
      var respose = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);

      print("Seccess");
    } catch (e) {
      log(e.toString());
    }
    isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomTitles(
                      subtitle: "Login into your account",
                      title: "Lets get started"),
                  Text("Email",
                      style: GoogleFonts.inter(
                          color: Kactivetextcolor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 9,
                  ),
                  TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          MdiIcons.email,
                          color: Kactivecolor,
                          size: 22,
                        ),
                        contentPadding: const EdgeInsets.all(18),
                        fillColor: Colors.black,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Kinactivetextcolor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Kinactivetextcolor, width: 1)),
                        hintText: "Enter Your Email",
                      )),
                  Text("Password",
                      style: GoogleFonts.inter(
                          color: Kactivetextcolor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 9,
                  ),
                  TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(MdiIcons.lock,
                            color: Kactivecolor, size: 22),
                        contentPadding: const EdgeInsets.all(18),
                        fillColor: Colors.black,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Kinactivetextcolor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Kinactivetextcolor, width: 1)),
                        hintText: "Enter Your Password",
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text("Forget Password?",
                        style: GoogleFonts.inter(
                            color: Kactivecolor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15))
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(390, 62),
                      backgroundColor: Kactivecolor,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      SignIn();
                    },
                    child: isloading
                        ? const CircularProgressIndicator(
                            backgroundColor: Kactivecolor,
                            color: Colors.white,
                          )
                        : Text(
                            "Login",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
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
                  SizedBox(
                    height: 40,
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account ?",
                          style: GoogleFonts.inter(
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
                                  builder: (context) => const RegistorPage())),
                          child: Text("Register",
                              style: GoogleFonts.inter(
                                  color: Kactivecolor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
