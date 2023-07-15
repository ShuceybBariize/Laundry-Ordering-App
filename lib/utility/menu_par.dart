import '../exports.dart';

class drawerList extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback ontap;
  const drawerList({
    super.key,
    required this.icon,
    required this.text,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: ontap,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Kactivecolor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Expanded(
          child: Row(
            children: [
              Icon(
                icon,
                size: 35,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                text,
                style: const TextStyle(
                    color: Color.fromARGB(255, 71, 95, 106), fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
