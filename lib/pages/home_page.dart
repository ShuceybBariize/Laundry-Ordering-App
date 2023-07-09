// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart' as badges;

import 'package:provider/provider.dart';

import '../exports.dart';
import '../provider.dart';
import '../utility/menu_par.dart';
import 'cart.dart';
import 'ironclothes.dart';
import 'login.dart';
import 'order_list.dart';
import 'slider_model.dart';

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
                icon: badges.Badge(
                  badgeContent: Text(
                    value.items.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: const Icon(Icons.shopping_basket),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                    } catch (e) {
                      print('Signout Erro$e');
                    }

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const LoginPage(),
                        ),
                        (route) => false);
                  },
                  icon: const Icon(Icons.logout_outlined))
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
                                // Navigator.pushAndRemoveUntil(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (ctx) => const OrderList(),
                                //     ),
                                //     (route) => false);
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const IronClothes()));
                                // Navigator.pushAndRemoveUntil(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (ctx) => const IronClothes(),
                                //     ),
                                //     (route) => false);
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
                              child: MyCard(item: items[1]),
                            ),
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
