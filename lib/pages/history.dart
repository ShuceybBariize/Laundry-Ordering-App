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
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Roumah Laundry",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          // wordSpacing: 0.5,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "20.11.2020/06:34 pm",
                        style: GoogleFonts.inter(
                          color: Kinactivetextcolor,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Ongoing",
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 1,
              height: 31,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
