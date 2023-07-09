import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../admin/admin_dashboard.dart';
import '../exports.dart';
import '../satff/screens/staff_dashboard.dart';
import '../utility/middle_auth.dart';
import 'forgotpassward.dart';
import 'home.dart';
import 'registration.dart';

class LoginPage extends StatefulWidget {
  static String id = 'loginpage';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isObscure = true;
  bool visible = false;
  bool isloading = false;
  // final String emailcheck = "dalkey@gmail.com";
  var email = "tony123_90874.coder@yahoo.co.in";

  final _formkey = GlobalKey<FormState>();

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
                  const SizedBox(
                    height: 9,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Login",
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
                                  color: Kactivecolor, width: 2),
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
                            bool emailValid = RegExp(
                                    r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                .hasMatch(value);

                            if (!emailValid) {
                              return ("Please enter a valid email");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: _password,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(MdiIcons.lock,
                                color: Kactivecolor, size: 22),
                            suffix: InkWell(
                              child: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onTap: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.all(18),
                            fillColor: Colors.black,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Kactivecolor, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Kinactivetextcolor, width: 1)),
                            hintText: "Enter Your Password",
                          ),
                          validator: (value) {
                            RegExp regex = RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("please enter valid password min. 6 character");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            _password.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ForgotScreen()));
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Forget Password?",
                              style: GoogleFonts.inter(
                                  color: Kactivecolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15))
                        ]),
                  ),
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
                      signIn(context, _email.text, _password.text);
                      FocusScope.of(context).requestFocus(FocusNode());
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
                  const Row(
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
                                  builder: (context) => const SignUpUsers())),
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

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      try {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('role') == "admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminDashboard(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const StaffDashboard(),
              ),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      } catch (Error) {
        print(Error.toString());
      }
    });
  }

  void signIn(BuildContext context, String email, String password) async {
    User user;
    String errorMessage;
    if (_formkey.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          //     print('No user found for that email.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Kactivecolor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: const Text(
                  'email is not Register',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (e.code == 'wrong-password') {
          // print('Wrong password provided for that user.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Kactivecolor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: const Text(
                  'Password is Wrong',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
    isloading = false;
    setState(() {});
  }
  //forgot password

  void sendpasswordresetemail(String email) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (ctx) => const MiddleAuth(),
          ),
          (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xffC72c41),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Text('The reset passward link in sent'),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 10),
        ),
      );
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xffC72c41),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                const Text('Erro in Email Reset'),
                Text(onError.message),
              ],
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }
}
