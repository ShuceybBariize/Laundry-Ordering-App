// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, FirebaseFirestore;
import 'package:firebase_database/firebase_database.dart';

import '../exports.dart';
import 'email_verification_page.dart';
import 'login.dart';

class SignUpUsers extends StatefulWidget {
  static String id = 'signUpUsers';
  const SignUpUsers({super.key});

  @override
  State<SignUpUsers> createState() => _SignUpUsersState();
}

class _SignUpUsersState extends State<SignUpUsers> {
  bool showProgress = false;
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool visible = false;
  bool isloading = false;
  late String txtname = '',
      txtphone = '',
      txtemail = '',
      txtpassword = '',
      txtconifirmpassword = '',
      orderstatus = '',
      image = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final databaseReference =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.reference().child("Users");
  final _auth = FirebaseAuth.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  void _clear() {
    _name.clear();
    _phone.clear();
    _email.clear();
    _password.clear();
    _confirmpassword.clear();
  }

  Future<User?> signUp(
      {required String email,
      required String password,
      required String name,
      required String phone,
      required String orderstatus,
      required String image,
      required BuildContext context}) async {
    const CircularProgressIndicator();
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(
                    name, email, password, phone, orderstatus, image)
              })
          // ignore: body_might_complete_normally_catch_error
          .catchError((e) {
        if (e.code == 'weak-password') {
          print(e.toString());
          var snackbar = SnackBar(
              content:
                  Text('The password provided is too weak.  ${e.toString()}'));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        } else if (e.code == 'email-already-in-use') {
          var snackbar = SnackBar(
            content: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xffC72c41),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Text('email already exists '),
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
      });
    }
    return null;
  }

///// here is the signup method
  ///
  postDetailsToFirestore(String email, String password, String name,
      String phone, String orderstatus, String image) async {
    // ignore: unused_local_variable
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref =
        FirebaseFirestore.instance.collection('customers');
    ref.doc(user!.uid).set({
      'name': txtname,
      'email': txtemail,
      'password': txtpassword,
      'phone': txtphone,
      'orderstatus': orderstatus,
      'image': image,
    });
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const LoginPage()));
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Form(
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
                        hintText: "Enter fullname",
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
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(MdiIcons.phone,
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
                        hintText: "Phone",
                      ),
                      onSaved: (value) {
                        txtphone = value!;
                      },
                      validator: validatePhone,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        showProgress
                            ? const CircularProgressIndicator()
                            : custombtn(
                                colorbtn: Kactivecolor,
                                colortxt: Colors.white,
                                txtbtn: "SignUp",
                                onpress: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    showProgress = true;

                                    await signUp(
                                      email: _email.text.trim(),
                                      password: _password.text.trim(),
                                      name: txtname,
                                      phone: txtphone,
                                      orderstatus: orderstatus,
                                      image: image,
                                      context: context,
                                    );
                                  }

                                  if (auth.currentUser != null) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              const EmailVerificationScreen(),
                                        ),
                                        (route) => false);
                                  }
                                  setState(() {
                                    showProgress = false;
                                  });
                                  // ignore: use_build_context_synchronously
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                              ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
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
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const LoginPage(),
                              ),
                              (route) => false),
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

class BuildButton extends StatelessWidget {
  final IconData iconData;
  final Function() onPressed;
  final String title;
  const BuildButton({
    super.key,
    required this.iconData,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            primary: Colors.white,
            onPrimary: Colors.black,
            textStyle: const TextStyle(fontSize: 20)),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(
              iconData,
              size: 28,
            ),
            Text(title),
          ],
        ));
  }
}
