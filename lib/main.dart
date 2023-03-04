import 'package:laundry_management_system/exports.dart';

void main() {
  runApp(const LaundryApp());
}

class LaundryApp extends StatelessWidget {
  const LaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
              displayLarge: TextStyle(
                  fontSize: 22,
                  color: Kactivecolor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter'))),
      home: const OnboardingPage(),
    );
  }
}
