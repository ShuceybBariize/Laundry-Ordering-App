// import 'package:laundry_order_app/exports.dart';
// ignore_for_file: constant_identifier_names

import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import '../exports.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  static const IconData person_3_outlined =
      IconData(0xf08af, fontFamily: 'MaterialIcons');
  // ignore: unused_field
  static const IconData message_rounded =
      IconData(0xf8b8, fontFamily: 'MaterialIcons');
  // ignore: unused_field
  static const IconData home_outlined =
      IconData(0xf107, fontFamily: 'MaterialIcons');
  int currentIndex = 0;
  int btn1 = 0;
  final screens = [
    const Home(),

    const HistoryPage(),
    ProfilePage()
    // proImage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: WaterDropNavBar(
            backgroundColor: currentIndex == btn1 ? Colors.white : Colors.blue,
            waterDropColor: currentIndex == btn1 ? Colors.blue : Colors.white,
            inactiveIconColor: Colors.black,
            iconSize: 40,
            onItemSelected: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            selectedIndex: currentIndex,
            barItems: [
              BarItem(
                filledIcon: Icons.home,
                outlinedIcon: Icons.home_outlined,
              ),
              BarItem(filledIcon: Icons.history, outlinedIcon: Icons.history),
              BarItem(filledIcon: Icons.person, outlinedIcon: Icons.person),
            ]));
  }
}
