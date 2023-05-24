import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:laundry_management_system/exports.dart';

class RegistorPage extends StatefulWidget {
  const RegistorPage({super.key});

  @override
  State<RegistorPage> createState() => _RegistorPageState();
}

class _RegistorPageState extends State<RegistorPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isloading = false;

  SignUp() async {
    try {
      isloading = true;
      setState(() {});
      var response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);
      print("SECCESS");
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
            backgroundColor: Colors.grey.withOpacity(0.0),
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
                        subtitle: "Create New Account For You",
                        title: "Register"),
                    Text("Name",
                        style: GoogleFonts.inter(
                            color: Kactivetextcolor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 9,
                    ),
                    TextField(
                        controller: _name,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(MdiIcons.account,
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
                          hintText: "Enter Username",
                        )),
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
                          prefixIcon: const Icon(MdiIcons.email,
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
                        obscureText: true,
                        controller: _password,
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
                        SignUp();
                      },
                      child: isloading
                          ? const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: Kactivecolor,
                            )
                          : Text(
                              "Register",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account ?",
                          style: TextStyle(
                              color: Kinactivetextcolor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage())),
                          child: const Text("Login",
                              style: TextStyle(
                                  color: Kactivecolor,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
