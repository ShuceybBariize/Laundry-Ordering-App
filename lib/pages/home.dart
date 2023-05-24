import 'package:laundry_management_system/exports.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const IconData person_3_outlined =
      IconData(0xf08af, fontFamily: 'MaterialIcons');
  static const IconData message_rounded =
      IconData(0xf8b8, fontFamily: 'MaterialIcons');
  static const IconData home_outlined =
      IconData(0xf107, fontFamily: 'MaterialIcons');
  int currentIndex = 0;
  final screens = [
    const Home(),
    const ChatPage(),
    const HistoryPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 2,
          ),
          selectedIconTheme: const IconThemeData(
            color: Kactivecolor,
          ),
          iconSize: 28,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                home_outlined,
                size: 30,
              ),
              label: "HOME",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  message_rounded,
                  size: 30,
                ),
                label: "CHAT"),
            BottomNavigationBarItem(
                icon: Icon(
                  MdiIcons.history,
                  size: 30,
                ),
                label: "HISTORY"),
            BottomNavigationBarItem(
                icon: Icon(
                  person_3_outlined,
                  size: 30,
                ),
                label: "PROFILE"),
          ],
        ));
  }
}
