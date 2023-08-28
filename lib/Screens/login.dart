// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../exports.dart';
import '../utility/middle_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<String?> getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission (iOS only)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Get the device token
    String? token = await messaging.getToken();
    print('Device token: $token');
    return token;
  }

  final _email = TextEditingController();
  final AuthService _authService = AuthService();
  final _password = TextEditingController();

  bool _isObscure = true;

  bool visible = false;
  bool isloading = false;

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  void _login(BuildContext context) async {
    String email = _email.text.trim();
    String password = _password.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please fill in all fields.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Fetch the user document from the "users" collection based on the email
    QuerySnapshot snapshot =
        await _usersCollection.where('email', isEqualTo: email).limit(1).get();

    // Check if the user with the provided email exists
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = snapshot.docs.first;
      String storedPassword = userDoc['password'];

      if (password == storedPassword) {
        // Password matches, perform login

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        String? deviceToken = await getDeviceToken();

        // Update the device token in Firestore
        _usersCollection.doc(userCredential.user!.uid).update({
          'deviceToken': deviceToken,
        });
        if (mounted) {
          setState(() {
            isloading = true;
          });
        }

        bool success =
            await _authService.signInWithEmailAndPassword(email, password);
        if (mounted) {
          setState(() {
            isloading = false;
          });
        }

        if (success) {
          await _authService.setLoggedIn(true);
          // ignore: use_build_context_synchronously
          //checking empty string
          // ignore: use_build_context_synchronously
          if (mounted) {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Login failed. Please try again.",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Handle incorrect password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Incorrect password.",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Handle user not found with the provided email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Email is not registered.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
                child: SizedBox(
                  // color: Colors.amber,
                  width: double.infinity,
                  height: 500,
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomTitles(
                          subtitle: "Login into your account",
                          title: "Lets get started",
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        // login lable

                        SizedBox(
                          height: 30,
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
                                  color: Kactivecolor, width: 1),
                            ),
                            hintText: "Enter Your Email",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email cannot be empty";
                            }
                            bool emailValid = RegExp(
                              r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
                            ).hasMatch(value);

                            if (!emailValid) {
                              return "Please enter a valid email";
                            }
                            return null;
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
                            prefixIcon: const Icon(
                              MdiIcons.lock,
                              color: Kactivecolor,
                              size: 22,
                            ),
                            suffix: InkWell(
                              child: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Kactivecolor),
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
                                  color: Kactivecolor, width: 1),
                            ),
                            hintText: "Enter Your Password",
                          ),
                          validator: (value) {
                            RegExp regex = RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return "Please enter a valid password (minimum 6 characters)";
                            }
                            return null;
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
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forget Password?",
                                style: GoogleFonts.inter(
                                  color: Kactivecolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
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
                            _login(context);
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

                        // login button
                        // SizedBox(
                        //   height: 30,
                        // ),

                        // GestureDetector(
                        //   onTap: () {
                        //     _login(context);
                        //   },
                        //   child: MaterialButton(
                        //     color: Color.fromARGB(227, 39, 94, 223),
                        //     minWidth: double.infinity,
                        //     height: 65,
                        //     onPressed: isloading ? null : null,
                        //     child: isloading
                        //         ? CircularProgressIndicator(
                        //             backgroundColor: Colors.white,
                        //           )
                        //         : Text('LOGIN'),
                        //   ),
                        // ),
                        // registor now
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: GoogleFonts.inter(
                                    color: Kinactivetextcolor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUpUsers(),
                                    ),
                                  ),
                                  child: Text(
                                    "Register",
                                    style: GoogleFonts.inter(
                                      color: Kactivecolor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
