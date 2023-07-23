import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:laundry_management_system/admin/admin_dashboard.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'admin/widgets/uploadproductimages.dart';
import 'exports.dart';
import 'firebase_options.dart';
import 'provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      child: const LaundryApp(),
    ),
  );
}

class LaundryApp extends StatefulWidget {
  const LaundryApp({super.key});
  @override
  State<LaundryApp> createState() => _LaundryAppState();
}

class _LaundryAppState extends State<LaundryApp> {
  //const LaundryApp({super.key});
  late StreamSubscription<User?> user;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? OnboardingPage.id
            : LoginPage.id,
        routes: {
          OnboardingPage.id: (context) => const OnboardingPage(),
          LoginPage.id: (context) => const LoginPage(),
        },
        home: const OnboardingPage(),
      );
    });
  }
}
