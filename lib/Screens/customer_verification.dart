// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../exports.dart';
// // import 'package:laundry_management_system/exports.dart';

// class CustomerEmailVerificationScreen extends StatefulWidget {
//   final String email;
//   final String password;
//   final String name;
//   final String phone;
//   final String image;
//   // final String? deviceToken;

//   const CustomerEmailVerificationScreen({
//     required this.email,
//     required this.password,
//     required this.name,
//     required this.phone,
//     required this.image,
//     // required this.deviceToken,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<CustomerEmailVerificationScreen> createState() =>
//       _CustomerEmailVerificationScreenState();
// }

// class _CustomerEmailVerificationScreenState
//     extends State<CustomerEmailVerificationScreen> {
//   bool isEmailVerified = false;
//   bool isloading = true;

//   Timer? timer;
//   FirebaseAuth auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     FirebaseAuth.instance.currentUser?.sendEmailVerification();
//     timer =
//         Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   Future<void> checkEmailVerified() async {
//     isloading = true;

//     await FirebaseAuth.instance.currentUser?.reload();

//     setState(() {
//       isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//     });

//     if (isEmailVerified) {
//       // timer?.cancel(); // Stop checking if email is verified
//       await postDetailsToFirestore(
//         widget.name,
//         widget.email,
//         widget.password,
//         widget.phone,
//         widget.image,
//         // widget.deviceToken,
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Email Successfully Verified")));

//       timer?.cancel();
//       await Future.delayed(const Duration(seconds: 3));

//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (ctx) => const LoginPage(),
//         ),
//         (route) => false,
//       );
//     }

//     isloading = false;
//   }

//   Future<void> postDetailsToFirestore(
//     String name,
//     String email,
//     String password,
//     String phone,
//     String image,
//     // String? deviceToken,
//   ) async {
//     try {
//       // ignore: unused_local_variable
//       FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//       var user = FirebaseAuth.instance.currentUser;
//       CollectionReference ref = FirebaseFirestore.instance.collection('users');

//       await ref.doc(user!.uid).set({
//         'name': name,
//         'email': email,
//         'password': password,
//         'phone': phone,
//         'role': 'customer', // Set the role to "customer"
//         'image': image,
//         // 'deviceToken': deviceToken,
//       });

//       // Handle Firestore data saving success
//     } catch (e) {
//       // Handle Firestore data saving error
//       debugPrint("Firestore data saving error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 35),
//               const SizedBox(height: 30),
//               const Center(
//                 child: Text(
//                   'Check your \n Email',
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                 child: Center(
//                   child: Text(
//                     'We have sent you an Email to ${widget.email}',
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Center(
//                 child: isEmailVerified
//                     ? const Text("")
//                     : const CircularProgressIndicator(),
//               ),
//               const SizedBox(height: 8),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 32.0),
//                 child: Center(
//                   child: Text(
//                     'Verifying email....',
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 57),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                 child: ElevatedButton(
//                   child: const Text('Resend'),
//                   onPressed: () {
//                     try {
//                       FirebaseAuth.instance.currentUser
//                           ?.sendEmailVerification();
//                     } catch (e) {
//                       debugPrint('$e');
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import '../exports.dart';

class CustomerEmailVerificationScreen extends StatefulWidget {
  const CustomerEmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<CustomerEmailVerificationScreen> createState() =>
      _CustomerEmailVerificationScreenState();
}

class _CustomerEmailVerificationScreenState
    extends State<CustomerEmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // TODO: implement your code after email verification
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email Successfully Verified")));

      timer?.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Check your \n Email',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'We have sent you a Email on  ${auth.currentUser?.email}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'Verifying email....',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 57),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  child: const Text('Resend'),
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                    } catch (e) {
                      debugPrint('$e');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
