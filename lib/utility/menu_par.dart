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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Expanded(
          child: Row(
            children: [
              Icon(
                icon,
                size: 35,
                color: Kactivecolor,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(text,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Kactivecolor,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
