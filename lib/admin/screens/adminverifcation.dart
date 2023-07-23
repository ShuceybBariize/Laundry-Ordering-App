// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:laundry_order_app/exports.dart';

// class EmailVerificationScreen extends StatefulWidget {
//   const EmailVerificationScreen({Key? key}) : super(key: key);

//   @override
//   State<EmailVerificationScreen> createState() =>
//       _EmailVerificationScreenState();
// }

// class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
//   bool isEmailVerified = false;
//   bool canResendEmail = false;
//   bool isloading = true;
//   late StreamSubscription<User?> user;
//   Timer? timer;
//   FirebaseAuth auth = FirebaseAuth.instance;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     user = FirebaseAuth.instance.authStateChanges().listen((user) {
//       if (user == null) {
//         print('User is currently signed out!');
//       } else {
//         isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//         if (!isEmailVerified) {
//           sendVerificationEmail();
//           timer = Timer.periodic(
//               const Duration(seconds: 3), (_) => checkEmailVerified());
//         }
//       }
//     });
//   }

//   Future sendVerificationEmail() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//       await user.sendEmailVerification();
//       setState(() => canResendEmail = false);
//       await Future.delayed(Duration(seconds: 5));
//       setState(() => canResendEmail = true);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   checkEmailVerified() async {
//     isloading = true;

//     await FirebaseAuth.instance.currentUser!.reload();
//     if (mounted) {
//       setState(() {
//         isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//       });
//     }

//     if (isEmailVerified) {
//       // ScaffoldMessenger.of(context)
//       //     .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));

//       timer?.cancel();
//       await Future.delayed(const Duration(seconds: 3));
//     }

//     isloading = false;
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => isEmailVerified
//       ? SafeArea(
//           child: Scaffold(
//             body: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 35),
//                   const SizedBox(height: 30),
//                   const Center(
//                     child: Text(
//                       'Check your \n Email',
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                     child: Center(
//                       child: Text(
//                         'We have sent you a Email on  ${auth.currentUser?.email}',
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Center(
//                     child: isEmailVerified
//                         ? Text("")
//                         : CircularProgressIndicator(),
//                   ),
//                   const SizedBox(height: 8),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 32.0),
//                     child: Center(
//                       child: Text(
//                         'Verifying email....',
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 57),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                     child: ElevatedButton(
//                       onPressed: canResendEmail ? sendVerificationEmail : null,
//                       child: const Text('Resend'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         )
//       : LoginPage();
// }

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import '../../exports.dart';
import 'admin_staffview.dart';

class AdminVerificationScreen extends StatefulWidget {
  const AdminVerificationScreen({Key? key}) : super(key: key);

  @override
  State<AdminVerificationScreen> createState() =>
      _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
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
          MaterialPageRoute(builder: (context) => const AdminStafsUserview()));
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
