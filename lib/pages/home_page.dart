// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart' as badges;

import 'package:provider/provider.dart';
import '../exports.dart';
import '../provider.dart';
import '../utility/menu_par.dart';
import 'suits_list.dart';
import 'wash_and_iron.dart';

class Home extends StatefulWidget {
  static String id = 'homepage';
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
  final currentUser = FirebaseAuth.instance.currentUser!;
  final custCollection = FirebaseFirestore.instance.collection("customers");

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

  @override
  Widget build(BuildContext context) {
    //slider
    int activeIndex = 0;

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Consumer<CartProvider>(builder: (context, value, _) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => CartScreen())),
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //       builder: (ctx) => CartScreen(),
                //     ),
                //     (route) => false),
                icon: badges.Badge(
                  badgeContent: Text(
                    value.items.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: const Icon(Icons.shopping_basket),
                ),
              ),
            ],
            title: const Text("Laundry Ordering"),
            titleTextStyle: GoogleFonts.inter(
                fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
            centerTitle: true,
          ),
          drawer: Drawer(
            width: 250,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40),
              ),
            ),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('customers')
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final customerData = snapshot.data!;
                  final imageUrl = customerData['image'];
                  final customerName = customerData['name'];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ProfilePage()));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 265,
                          decoration: const BoxDecoration(
                            color: Kactivecolor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80),
                                  // shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          CachedNetworkImageProvider(imageUrl)),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                customerName,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                    letterSpacing: 2),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                currentUser.email!,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      drawerList(
                          icon: Icons.history,
                          text: 'History',
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HistoryPage()));
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      drawerList(
                          icon: Icons.support_agent_sharp,
                          text: 'Help center',
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ContactPage()));
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      drawerList(
                          icon: FontAwesomeIcons.whatsapp,
                          text: 'Contact Us',
                          ontap: () {
                            openWhatsapp();
                          }),
                      const Spacer(),
                      drawerList(
                          icon: Icons.logout,
                          text: 'Logout',
                          ontap: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                            } catch (e) {
                              print('Signout Erro$e');
                            }
                            //   Navigator.push(context,
                            //       MaterialPageRoute(builder: (_) => const LoginPage()));
                            // },
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => const LoginPage(),
                                ),
                                (route) => false);
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  );
                }),
          ),
          body: Column(
            children: [
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
                        items: Catagory.Catagories.map((category) =>
                            HeroCrouselCard(category: category)).toList(),
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
                            color: Colors.black,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const OrderList()));
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const IronOrder()));
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
                              child: MyCard(item: items[1]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Wash_IronOrder()));
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
                              child: MyCard(item: items[2]),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const SuitOrder()));
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
                              child: MyCard(item: items[3]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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

void openWhatsapp() async {
  String Number = '78889786';
  var urlNumber = 'https://wa.me/252615470677';
  await launch(urlNumber);
}

void openGmail() {
  Uri uri = Uri(
    scheme: 'mailto',
    path: 'dalkey8955@gmail.com',
  );
  launchUrl(uri);
}

void openCall() {
  Uri uri = Uri(
    scheme: 'tel',
    path: '+252618098110',
  );
  launchUrl(uri);
}
