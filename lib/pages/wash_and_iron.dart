// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../exports.dart';
import '../provider.dart';
import '../utility/card.dart';

class Wash_IronOrder extends StatelessWidget {
  const Wash_IronOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, value, _) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
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
                  child: const Icon(
                    CupertinoIcons.cart,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                FontAwesomeIcons.arrowLeft,
                size: 21,
                color: Kactivecolor,
              ),
              // FontAwesomeIcons.arrowLeft,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              "Happy Wash & Iron",
              style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("washIronOrder")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("ERROR OCCURED"),
                  );
                }
                if (snapshot.hasData) {
                  QuerySnapshot querySnapshot = snapshot.data!;
                  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                  List items = documents.map((e) => e.data() as Map).toList();
                  // return Text("${items[0]}");
                  return Consumer<ProductProvider>(
                      builder: (context, value, _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          height: 175,
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
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                                image: AssetImage("assets/washiron.jpeg"),
                                alignment: Alignment.center,
                                fit: BoxFit.fill),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          // padding: const EdgeInsets.only(top: 10),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              // color: Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Categories',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                          context, ProductScreen.id),
                                      child: Text(
                                        'View all',
                                        style: GoogleFonts.poppins(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: 445,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: items.length,
                                    itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child:
                                            // Text("${items[0]}")

                                            ProductCard(product: items[index])),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    );
                  });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }));
    });
  }
}
