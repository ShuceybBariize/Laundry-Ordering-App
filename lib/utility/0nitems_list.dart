import 'package:laundry_management_system/exports.dart';

class OnItems extends StatelessWidget {
  OnItems(
      {this.onPressed,
      super.key,
      required this.typecloth,
      required this.imgcloth,
      required this.pricecloth});
  final String typecloth;
  ImageProvider imgcloth;
  final String pricecloth;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  image: DecorationImage(image: imgcloth, fit: BoxFit.cover),
                  color: Colors.grey[300],
                  shape: BoxShape.circle),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typecloth,
                  style: GoogleFonts.inter(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  pricecloth,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 116,
            ),
            Container(
              height: 40,
              width: 35,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.fromBorderSide(
                      BorderSide(color: Colors.grey, strokeAlign: 1, width: 1))
                  // borderRadius: BorderRadius.circular(25),
                  ),
              child: IconButton(
                  onPressed: onPressed,
                  icon: const Icon(FontAwesomeIcons.minus)),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "1",
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 40,
              width: 35,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.fromBorderSide(
                      BorderSide(color: Colors.grey, strokeAlign: 1, width: 1))
                  // borderRadius: BorderRadius.circular(25),
                  ),
              child: IconButton(
                  onPressed: onPressed,
                  icon: const Icon(FontAwesomeIcons.plus)),
            ),
          ],
        ),
      ),
    );
  }
}
