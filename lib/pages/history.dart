import 'package:laundry_management_system/exports.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.withOpacity(0.0),
          elevation: 0,
        ),
        backgroundColor: Colors.grey.withOpacity(0.1),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "History",
              style: TextStyle(
                  color: Kactivetextcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14)),
                  height: 170,
                  width: 370,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Roumah Laundry",
                          style: GoogleFonts.inter(fontSize: 23),
                        ),
                        const Text("20.11.2020/06:34"),
                      ]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14)),
                  height: 170,
                  width: 370,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Roumah Laundry",
                          style: GoogleFonts.inter(fontSize: 23),
                        ),
                        const Text("20.11.2020/06:34"),
                      ]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
