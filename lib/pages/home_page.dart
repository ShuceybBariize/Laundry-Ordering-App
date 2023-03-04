import 'package:laundry_management_system/exports.dart';

class HomePageSreen extends StatelessWidget {
  const HomePageSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Location",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Kinactivetextcolor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Row(
                        children: const [
                          Icon(FontAwesomeIcons.locationDot,
                              color: Kactivecolor, size: 18),
                          SizedBox(width: 6),
                          Text("Somalia , Mogadishu",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Kactivetextcolor)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 33,
                ),
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                      color: Kinactivetextcolor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FontAwesomeIcons.bell,
                        size: 23,
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            const Search(),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: 170,
              width: 700,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Kactivecolor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Text("Roman Laundry",
                            style: GoogleFonts.inter(
                                color: Colors.white60,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Your Clothes Will Finished 1 day",
                            style: GoogleFonts.inter(
                                height: 1.5,
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          "View Details",
                          style: GoogleFonts.inter(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/washingmachine.png",
                          cacheHeight: 110,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(" Nearest Laundry",
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                Text(
                  "See More",
                  style: GoogleFonts.inter(
                      color: Kactivecolor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  CardItems(),
                  SizedBox(
                    width: 20,
                  ),
                  CardItems(),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class CardItems extends StatelessWidget {
  const CardItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 250,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(20)),
      child: const Padding(
        padding: EdgeInsets.all(6),
        child: Image(
          repeat: ImageRepeat.noRepeat,
          image: AssetImage("assets/laundry.jpeg"),
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
