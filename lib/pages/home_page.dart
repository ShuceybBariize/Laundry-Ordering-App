import 'package:laundry_management_system/exports.dart';

class HomePageSreen extends StatelessWidget {
  const HomePageSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.withOpacity(0.0),
          elevation: 0,
        ),
        backgroundColor: Colors.grey.withOpacity(0.0),
        body: ListView(
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
                                  color: Kactivecolor, size: 16),
                              SizedBox(width: 6),
                              Text("Somalia , Mogadishu",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
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
                      height: 40,
                      width: 40,
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
                TextField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1)),
                        hintText: "Search",
                        prefixIconColor: Kinactivetextcolor,
                        prefixIcon: const Icon(FontAwesomeIcons.search))),
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
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Your Clothes Will Finished 1 day",
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 20,
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
                        flex: 1,
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
                Row(
                  children: [
                    Container(
                      height: 198,
                      width: 230,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Image(
                        image: AssetImage("assets/laundry.jpeg"),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 80,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
