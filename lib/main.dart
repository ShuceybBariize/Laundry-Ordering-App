import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:laundry_management_system/admin/admin_dashboard.dart';

import 'package:provider/provider.dart';
import 'admin/widgets/uploadproductimages.dart';
import 'exports.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CartProvider()),
        ChangeNotifierProvider.value(value: ProductProvider()),
        ChangeNotifierProvider.value(value: ImageProfile()),
        ChangeNotifierProvider.value(value: UserProfile()),
        ChangeNotifierProvider.value(value: UploadImages()),
        ChangeNotifierProvider.value(value: AdminUser()),
        ChangeNotifierProvider.value(value: StaffUser()),
        ChangeNotifierProvider.value(value: UserProfileAdmin()),
      ],
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Main({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            // User not logged in, navigate to OnboardingScreen for new users
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: OnboardingPage(),
            );
          } else {
            // User logged in, navigate to appropriate screens based on role
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Loading data from Firestore
                  return const MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: Scaffold(
                        body: Center(child: CircularProgressIndicator())),
                  );
                } else {
                  // Data retrieved, check the role and navigate accordingly
                  final data = snapshot.data?.data();
                  final role = data?['role'] ?? '';
                  if (role == 'customer') {
                    // Navigate to HomePage for customers
                    return const MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: HomePage(),
                    );
                  } else if (role == 'staff') {
                    // Navigate to StaffDashboard for staff members
                    return const MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: StaffDashboard(),
                    );
                  } else if (role == 'admin') {
                    // Navigate to AdminDashboard for administrators
                    return const MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: AdminDashboard(),
                    );
                  } else {
                    // Unknown role, handle this case accordingly
                    return const MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: LoginPage(),
                    );
                  }
                }
              },
            );
          }
        } else {
          // Connection state not active, show loading or splash screen
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }
}
