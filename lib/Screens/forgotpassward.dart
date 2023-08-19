import 'package:firebase_auth/firebase_auth.dart';

import '../exports.dart';

// ignore: depend_on_referenced_packages
export 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  // ignore: unused_field
  final bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  void sendpasswordresetemail(String email) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xffC72c41),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Text('The password rest link was sent'),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 10),
        ),
      );
      // ignore: invalid_return_type_for_catch_error
    }).catchError((onError) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xffC72c41),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const Text('Error in Email Reset'),
                  Text(onError.toString()),
                ],
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
            duration: const Duration(seconds: 10),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                // color: Colors.orangeAccent[700],
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.70,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Reset",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 40,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: emailController,
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
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email cannot be empty";
                              }
                              bool emailvalidator = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$&'*+-/=?^_`{|}~]+@a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value);
                              if (emailvalidator) {
                                return ("Please enter a valid email");
                              }
                              return null;
                            },
                            onSaved: (value) {
                              emailController.text = value!;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Center(
                              child: custombtn(
                            colorbtn: Kactivecolor,
                            colortxt: Colors.white,
                            txtbtn: "Reset Password",
                            onpress: () {
                              sendpasswordresetemail(emailController.text);
                            },
                          )),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: visible,
                              child: Center(
                                child: Container(
                                    child: const CircularProgressIndicator(
                                  color: Colors.black,
                                )),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
