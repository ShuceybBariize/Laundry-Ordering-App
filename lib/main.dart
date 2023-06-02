import 'package:firebase_core/firebase_core.dart';
import 'package:laundry_management_system/exports.dart';
import 'package:laundry_management_system/pages/order_list.dart';
import 'package:laundry_management_system/utility/middle_auth.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LaundryApp());
}

class LaundryApp extends StatelessWidget {
  const LaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderList(),
    );
  }
}
