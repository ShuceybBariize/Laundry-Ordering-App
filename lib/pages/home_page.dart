// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:laundry_management_system/exports.dart';
// import 'package:laundry_management_system/pages/order_list.dart';

// class HomePageSreen extends StatelessWidget {
//   const HomePageSreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
//       scrollDirection: Axis.vertical,
//       children: [
//         Column(children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Current Location",
//                     style: GoogleFonts.inter(
//                         fontSize: 14,
//                         letterSpacing: 0.3,
//                         fontWeight: FontWeight.w800,
//                         color: Kinactivetextcolor),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 3),
//                     child: Row(
//                       children: [
//                         const Icon(FontAwesomeIcons.locationDot,
//                             color: Kactivecolor, size: 18),
//                         const SizedBox(width: 6),
//                         Text("Somalia , Mogadishu",
//                             style: GoogleFonts.inter(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w800,
//                                 color: Kactivetextcolor)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 width: 33,
//               ),
//               Container(
//                 height: 45,
//                 width: 45,
//                 decoration: BoxDecoration(
//                     // color: Kinactivetextcolor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.grey)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(
//                       FontAwesomeIcons.bell,
//                       size: 23,
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 14,
//           ),
//           const Search(),
//           const SizedBox(
//             height: 10,
//           ),
//           Container(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             height: 170,
//             width: 700,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Kactivecolor,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(
//                         height: 12,
//                       ),
//                       Text("Roman Laundry",
//                           style: GoogleFonts.inter(
//                               color: Colors.white60,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold)),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text("Your Clothes Will Finished 1 day",
//                           style: GoogleFonts.inter(
//                               height: 1.5,
//                               color: Colors.white,
//                               fontSize: 21,
//                               fontWeight: FontWeight.bold)),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       Text(
//                         "View Details",
//                         style: GoogleFonts.inter(
//                             decoration: TextDecoration.underline,
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500),
//                       )
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         "assets/washingmachine.png",
//                         cacheHeight: 110,
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(" Nearest Laundry",
//                   style: GoogleFonts.inter(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600)),
//               Text(
//                 "See More",
//                 style: GoogleFonts.inter(
//                     color: Kactivecolor,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 18,
//           ),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const OrderList())),
//                   child: const CardItems(
//                     imgpath: "assets/laundry.jpeg",
//                     laundryname: "Happy Laundry",
//                     location: "300 m",
//                     price: "40",
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 6,
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const OrderList())),
//                   child: const CardItems(
//                     imgpath: "assets/happylaundry.jpeg",
//                     laundryname: "Rouman Laundry",
//                     location: "400 m",
//                     price: "99",
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 6,
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const OrderList())),
//                   child: const CardItems(
//                     imgpath: "assets/happylaundry.jpeg",
//                     laundryname: "Rouman Laundry",
//                     location: "400 m",
//                     price: "99",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ]),
//       ],
//     );
//   }
// }

// class CardItems extends StatelessWidget {
//   const CardItems({
//     required this.imgpath,
//     required this.laundryname,
//     required this.location,
//     required this.price,
//     super.key,
//   });
//   final String imgpath;
//   final String laundryname;
//   final String price;
//   final String location;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       height: 290,
//       width: 255,
//       padding: const EdgeInsets.all(3),
//       decoration: BoxDecoration(
//           border: Border.all(color: Colors.white, width: 6),
//           color: Colors.white60,
//           borderRadius: BorderRadius.circular(18)),
//       child: Column(children: [
//         Container(
//           height: 145,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.grey,
//                 blurRadius: 12,
//                 spreadRadius: 0.1,
//                 blurStyle: BlurStyle.normal,
//                 offset: Offset(3, 7), // Shadow position
//               ),
//             ],
//             borderRadius: BorderRadius.circular(17),
//             image: DecorationImage(
//                 image: AssetImage(imgpath),
//                 alignment: Alignment.topCenter,
//                 fit: BoxFit.fitWidth),
//           ),
//           child: const RatingBuilder(),
//         ),
//         const SizedBox(
//           height: 12,
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     laundryname,
//                     style: GoogleFonts.inter(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         wordSpacing: 0.5,
//                         fontSize: 24),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 35,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(FontAwesomeIcons.locationDot,
//                           color: Kactivecolor, size: 18),
//                       const SizedBox(
//                         width: 4,
//                       ),
//                       Text(location,
//                           style: GoogleFonts.inter(
//                               color: Kinactivetextcolor,
//                               fontSize: 18,
//                               wordSpacing: 0.5)),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Text(
//                         "\$",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(price,
//                           style: GoogleFonts.inter(
//                               color: Colors.black,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               wordSpacing: 1)),
//                       Text("SHILIN",
//                           style: GoogleFonts.inter(
//                             color: Kinactivetextcolor,
//                             fontSize: 15,
//                           ))
//                     ],
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ]),
//     );
//   }
// }

// class RatingBuilder extends StatefulWidget {
//   const RatingBuilder({super.key});

//   @override
//   State<RatingBuilder> createState() => _RatingBuilderState();
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:laundry_management_system/exports.dart';
import 'package:laundry_management_system/pages/order_list.dart';
import 'package:laundry_management_system/utility/menu_par.dart';

import 'slider_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class MymodalList {
  final String urlImage;
  final String title;
  MymodalList({
    required this.urlImage,
    required this.title,
  });
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  List<MymodalList> items = [
    MymodalList(
      title: 'Washing',
      urlImage: 'assets/images/washer.png',
    ),
    MymodalList(
      title: 'Ironing',
      urlImage: 'assets/images/formal.png',
    ),
    MymodalList(
      title: 'Wash & Iron',
      urlImage: 'assets/images/washer.png',
    ),
    MymodalList(
      title: "Suits",
      urlImage: "assets/images/suits.png",
    ),
  ];
  void SignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    //slider
    int activeIndex = 0;

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: SignOut, icon: const Icon(Icons.logout_outlined))
          ],
          title: const Text("Laundry Ordering"),
          titleTextStyle:
              GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22),
          centerTitle: true,
        ),
        drawer: const Menu(),
        body: Column(
          children: [
            // const SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     IconButton(
            //         hoverColor: Kactivecolor,
            //         onPressed: () {},
            //         // onPressed: () => Navigator.push(context,
            //         //     MaterialPageRoute(builder: (context) => const Menu())),
            //         icon: const Icon(FontAwesomeIcons.bars))
            //   ],
            // ),
            Container(
              child: Column(
                children: [
                  Container(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 1.5,
                        viewportFraction: 0.888,
                        initialPage: 2,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                      ),
                      items: Catagory.Catagories.map(
                              (category) => HeroCrouselCard(category: category))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                height: 500,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
                child: Column(
                  children: [
                    const Text("Laundry ordering service",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(244, 19, 1, 55),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const OrderList()));
                            });
                          },
                          child: Container(
                            height: 120,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                            ),
                            child: MyCard(item: items[0]),
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Container(
                          height: 120,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                          ),
                          child: MyCard(item: items[1]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                          ),
                          child: MyCard(item: items[2]),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Container(
                          height: 120,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                          ),
                          child: MyCard(item: items[3]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container laundryservice() {
    return Container(
      height: 120,
      width: 160,
      decoration: BoxDecoration(
        color: const Color.fromARGB(214, 222, 240, 1000),
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: MyCard(item: items[0]),
    );
  }
}

Widget buildImage(String urlImage, int index) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
    color: Colors.grey,
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
      child: Stack(
        children: [
          Image.asset(
            urlImage,
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
    ));

Widget MyCard({
  required MymodalList item,
}) {
  return Container(
    padding: const EdgeInsets.all(2),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(item.urlImage),
            fit: BoxFit.cover,
          ),
        ),
        Text(
          item.title,
          style: GoogleFonts.inter(
            color: Kactivetextcolor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

// slide class
class HeroCrouselCard extends StatelessWidget {
  final Catagory category;
  const HeroCrouselCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
      color: Colors.grey,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: [
            Image.asset(
              category.imageUrl,
              fit: BoxFit.cover,
              width: 1000.0,
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  category.name,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
