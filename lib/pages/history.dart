import 'package:laundry_management_system/exports.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 65, left: 8, right: 8),
      children: [
        Text("History",
            style:
                GoogleFonts.inter(fontSize: 27, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 18,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Histrory_Laundry(),
            SizedBox(
              height: 10,
            ),
            Histrory_Laundry(),
            SizedBox(
              height: 10,
            ),
            Histrory_Laundry(),
            SizedBox(
              height: 10,
            ),
            Histrory_Laundry(),
            SizedBox(
              height: 10,
            ),
            Histrory_Laundry(),
            SizedBox(
              height: 10,
            ),
            Histrory_Laundry(),
          ],
        ),
      ],
    );
  }
}

class Histrory_Laundry extends StatelessWidget {
  const Histrory_Laundry({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(14)),
      height: 210,
      width: double.maxFinite,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Roumah Laundry",
              style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              "20.11.2020/06:34",
              style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
            ),
          ]),
    );
  }
}
