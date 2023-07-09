import 'package:firebase_auth/firebase_auth.dart';

import '../exports.dart';
import '../pages/home.dart';
import '../pages/login.dart';

class MiddleAuth extends StatelessWidget {
  const MiddleAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
