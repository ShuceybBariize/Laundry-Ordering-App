import 'package:firebase_auth/firebase_auth.dart';
import 'package:laundry_management_system/exports.dart';

class middleAuth extends StatelessWidget {
  const middleAuth({super.key});

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
