import '../exports.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return const Drawer(
      width: 250,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          side: BorderSide(color: Kactivecolor, width: 2.5)),
      child: Text("fddf"),
    );
  }
}
