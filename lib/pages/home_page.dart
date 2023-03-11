import 'package:laundry_management_system/exports.dart';

class HomePageSreen extends StatelessWidget {
  const HomePageSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
      scrollDirection: Axis.vertical,
      children: [
        Column(children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Location",
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w800,
                        color: Kinactivetextcolor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Row(
                      children: [
                        const Icon(FontAwesomeIcons.locationDot,
                            color: Kactivecolor, size: 18),
                        const SizedBox(width: 6),
                        Text("Somalia , Mogadishu",
                            style: GoogleFonts.inter(
                                fontSize: 14,
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
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage())),
                  child: const CardItems(
                    imgpath: "assets/laundry.jpeg",
                    laundryname: "Happy Laundry",
                    location: "300 m",
                    price: "40",
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                const CardItems(
                  imgpath: "assets/happylaundry.jpeg",
                  laundryname: "Rouman Laundry",
                  location: "400 m",
                  price: "99",
                ),
              ],
            ),
          ),
        ]),
      ],
    );
  }
}

class CardItems extends StatelessWidget {
  const CardItems({
    required this.imgpath,
    required this.laundryname,
    required this.location,
    required this.price,
    super.key,
  });
  final String imgpath;
  final String laundryname;
  final String price;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 290,
      width: 255,
      margin: const EdgeInsets.only(bottom: 100, right: 10),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 6),
          color: Colors.white10,
          borderRadius: BorderRadius.circular(18)),
      child: Column(children: [
        Container(
          height: 145,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 12,
                spreadRadius: 0.1,
                blurStyle: BlurStyle.normal,
                offset: Offset(3, 7), // Shadow position
              ),
            ],
            borderRadius: BorderRadius.circular(17),
            image: DecorationImage(
                image: AssetImage(imgpath),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
          child: Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      laundryname,
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 0.5,
                          fontSize: 24),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.locationDot,
                            color: Kactivecolor, size: 18),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(location,
                            style: GoogleFonts.inter(
                                color: Kinactivetextcolor,
                                fontSize: 18,
                                wordSpacing: 1)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(price,
                            style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 1)),
                        Text("/PCS",
                            style: GoogleFonts.inter(
                              color: Kinactivetextcolor,
                              fontSize: 15,
                            ))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
