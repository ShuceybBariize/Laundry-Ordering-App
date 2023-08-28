import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, FirebaseFirestore;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../exports.dart';
import 'email_verification_page.dart';

// import 'adminverifcation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showProgress = false;
  bool visible = false;

  bool _isObscure1 = true;
  bool _isObscure2 = true;

  late String txtname = '',
      txtphone = '',
      txtemail = '',
      txtpassword = '',
      txtconifirmpassword = '',
      image = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  bool isloading = false;
  final databaseReference =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.reference().child("Users");
  final _auth = FirebaseAuth.instance;
  void _clear() {
    _name.clear();
    _phone.clear();
    _email.clear();
    _password.clear();
    _confirmpassword.clear();
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String name,
      required String phone,
      required String role,
      required String image,
      required BuildContext context}) async {
    try {
      isloading = true;
      setState(() {});
      if (_formKey.currentState!.validate()) {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // Send email verification to the user
        if (auth.currentUser != null && !auth.currentUser!.emailVerified) {
          await auth.currentUser!.sendEmailVerification();
        }

        // Get the device token
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        String? deviceToken = await messaging.getToken();

        postDetailsToFirestore(
            name, email, password, phone, image, role, deviceToken);

        // Navigate to EmailVerificationScreen on successful signup
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => EmailVerificationScreen(
                    email: email,
                    password: password,
                    name: name,
                    phone: phone,
                    image: image,
                    role: role,
                    deviceToken: deviceToken,
                  )),
        );
      } else {
        var snackbar = const SnackBar(content: Text('something went wrong '));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        var snackbar =
            const SnackBar(content: Text('The password provided is too weak'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else if (e.code == 'email-already-in-use') {
        var snackbar = SnackBar(
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xffC72c41),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Text('The account already exists for that email'),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 2),
        );
        // SnackBar(
        //     content: Text(
        //         'The account already exists for that email..  ${e.toString()}'));

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
    isloading = false;
    setState(() {});
  }

  postDetailsToFirestore(String email, String password, String name,
      String phone, String image, String role, String? deviceToken) async {
    // ignore: unused_local_variable
    if (auth.currentUser != null && !auth.currentUser!.emailVerified) {
      await auth.currentUser!.sendEmailVerification();
    }
    // ignore: unused_local_variable
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({
      'name': txtname,
      'email': txtemail,
      'password': txtpassword,
      'phone': txtphone,
      'role': role,
      'image': image,
      'deviceToken': deviceToken,
    });
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  var role = "Staff";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.grey.withOpacity(0.0),
              elevation: 0,
              leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomTitles(
                          subtitle: "Create New Account For You",
                          title: "Register"),
                      TextFormField(
                        controller: _name,
                        keyboardType: TextInputType.emailAddress,
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
                                color: Kinactivetextcolor, width: 1),
                          ),
                          hintText: "Enter Username",
                        ),
                        onSaved: (value) {
                          txtname = value!;
                        },
                        validator: validatename,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixText:
                              '+252 ', // Add the Somalia dial code as a prefix
                          prefixIcon: const Icon(
                            MdiIcons.phone,
                            color: Kactivecolor,
                            size: 22,
                          ),
                          contentPadding: const EdgeInsets.all(18),
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Kactivecolor, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Kactivecolor, width: 1),
                          ),
                          hintText: "Phone",
                        ),
                        onSaved: (value) {
                          // Remove whitespace and any non-numeric characters from the input
                          final phoneNumber =
                              value?.replaceAll(RegExp(r'\D'), '');

                          if (phoneNumber != null &&
                              phoneNumber.isNotEmpty &&
                              !phoneNumber.startsWith('252')) {
                            txtphone = '252$phoneNumber';
                          } else {
                            txtphone = phoneNumber ?? '';
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid phone number';
                          }

                          // Remove whitespace and any non-numeric characters from the input
                          final phoneNumber =
                              value.replaceAll(RegExp(r'\D'), '');

                          if (phoneNumber.startsWith('252')) {
                            // Phone number with country code (+252) should be exactly 12 digits
                            if (phoneNumber.length != 12) {
                              return 'Invalid phone number. Please enter 12 digits including the country code.';
                            }
                          } else {
                            // Phone number without country code should be exactly 9 digits
                            if (phoneNumber.length != 9) {
                              return 'Invalid phone number. Please enter 9 digits.';
                            }
                          }

                          return null; // Return null to indicate that the input is valid
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
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
                        ),
                        onSaved: (value) {
                          txtemail = value!;
                        },
                        validator: validateEmail,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: _isObscure1,
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
                          suffix: InkWell(
                            child: Icon(_isObscure1
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onTap: () {
                              setState(() {
                                _isObscure1 = !_isObscure1;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Kinactivetextcolor, width: 1)),
                          hintText: "Enter Your Password",
                        ),
                        onSaved: (value) {
                          txtpassword = value!;
                        },
                        validator: validatePassword,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: _isObscure2,
                        controller: _confirmpassword,
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
                          suffix: InkWell(
                            child: Icon(_isObscure2
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onTap: () {
                              setState(() {
                                _isObscure2 = !_isObscure2;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Kinactivetextcolor, width: 1)),
                          hintText: "Confirm Your Password",
                        ),
                        onSaved: (value) {
                          txtconifirmpassword = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Empty';
                          }
                          if (txtconifirmpassword != txtpassword) {
                            return 'Not Match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            gapPadding: 1.0,
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          labelText: 'Select the Role',
                          labelStyle: TextStyle(
                            fontSize: 25,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        dropdownColor: Colors.white,
                        isExpanded: false,
                        isDense: false,
                        value: role.isEmpty ? role : null,
                        items: <String>['staff', 'admin']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            role = value!;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          showProgress
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(120, 50),
                                    backgroundColor: Colors.blue,
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    shadowColor: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      showProgress = true;
                                      await signUp(
                                        email: _email.text.trim(),
                                        password: _password.text.trim(),
                                        name: txtname,
                                        phone: txtphone,
                                        role: role,
                                        image: '',
                                        context: context,
                                      );
                                      if (auth.currentUser != null) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (ctx) => const LoginPage(),
                                          ),
                                          // (route) => false);
                                        );
                                      }
                                      if (mounted) {
                                        setState(() {
                                          showProgress = false;
                                        });
                                      }
                                    }
                                    // ignore: use_build_context_synchronously
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  child: Text(
                                    'Register now',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
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
              ),
            ],
          )),
    );
  }
}

String? validatename(String? user) {
  if (user!.isEmpty) {
    return 'Enter your name';
  } else {
    return null;
  }
}

String? validatePhone(String? phone) {
  if (phone!.isEmpty) {
    return 'Enter your phone';
  } else {
    return null;
  }
}

String? validateEmail(String? email) {
  if (email!.isEmpty) {
    return 'Enter email address';
  } else {
    return null;
  }
}

String? validatePassword(String? password) {
  if (password!.isEmpty) {
    return 'Enter the password';
  } else {
    return null;
  }
}

String? validateConfirmPassword(String? cpassword) {
  if (cpassword!.isEmpty) {
    return 'confirm the password';
  } else {
    return null;
  }
}
