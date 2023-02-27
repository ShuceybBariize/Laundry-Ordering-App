import '../exports.dart';

class CustomTitles extends StatelessWidget {
  final String title;
  final String subtitle;

  const CustomTitles({
    super.key,
    required this.subtitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 32),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 54),
            child: Text(
              subtitle,
              style: GoogleFonts.inter(
                  color: Kinactivetextcolor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
