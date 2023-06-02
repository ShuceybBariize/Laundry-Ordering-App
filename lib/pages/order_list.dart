import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            size: 21,
          ),
          // FontAwesomeIcons.arrowLeft,
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          "Happy Laundry",
          style: GoogleFonts.inter(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("laundry").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR OCCURED"),
            );
          }

          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            List<Map> items = documents.map((e) => e.data() as Map).toList();
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  Map thisItem = items[index];
                  // QueryDocumentSnapshot document =
                  //     listQueryDocumentSnapshot[index];

                  return Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        child: CachedNetworkImage(
                                            imageUrl: thisItem['imageUrl']),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              thisItem['clothName'].toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              r'$' +
                                                  thisItem['clothPrice']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  height: 45,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: Colors.green),
                                                  child: Center(
                                                      child: Text(
                                                    "Add to cart",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ])
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );

                  // ListTile(
                  //   title: Text('${thisItem['clothName']}'),
                  //   subtitle: Text('${thisItem['quantity']}'),
                  //   leading: Container(
                  //       height: 100,
                  //       width: 100,
                  //       child: CachedNetworkImage(
                  //         imageUrl: (thisItem['imageUrl']),
                  //       )),
                  // );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}














        // body: Consumer<ProductProvider>(
        //   builder: (context, value, _) {
        //     return Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         Container(
        //           margin: const EdgeInsets.all(8),
        //           height: 20.h,
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
        //             borderRadius: BorderRadius.circular(8),
        //             image: const DecorationImage(
        //                 image: AssetImage("assets/laundry.jpeg"),
        //                 alignment: Alignment.center,
        //                 fit: BoxFit.fill),
        //           ),
        //         ),
        //         const SizedBox(
        //           height: 12,
        //         ),
        //         Container(
        //           // padding: const EdgeInsets.only(top: 10),
        //           width: double.infinity,
        //           decoration: BoxDecoration(
        //               // color: Colors.grey[300],
        //               borderRadius: const BorderRadius.only(
        //                   topLeft: Radius.circular(20),
        //                   topRight: Radius.circular(20))),
        //           child: Column(
        //             children: [
        //               Container(
        //                 padding: EdgeInsets.symmetric(horizontal: 5),
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     Text(
        //                       'Categories',
        //                       style: GoogleFonts.poppins(
        //                         fontWeight: FontWeight.w500,
        //                         fontSize: 20,
        //                       ),
        //                     ),
        //                     TextButton(
        //                       onPressed: () =>
        //                           Navigator.pushNamed(context, ProductScreen.id),
        //                       child: Text(
        //                         'View all',
        //                         style: GoogleFonts.poppins(),
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //               ),
        //               Container(
        //                 height: 55.h,
        //                 child: ListView.builder(
        //                   scrollDirection: Axis.vertical,
        //                   itemCount: value.products.length,
        //                   itemBuilder: (context, index) => Padding(
        //                       padding: const EdgeInsets.symmetric(horizontal: 6),
        //                       child: ProductCard(product: value.products[index])),
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //         // const SizedBox(
        //         //   height: 66,
        //         // ),
        //         // Expanded(
        //         //   child: Container(
        //         //     decoration: const BoxDecoration(
        //         //         // color: Colors.black,
        //         //         ),
        //         //     child: Container(
        //         //       padding: const EdgeInsets.all(12),
        //         //       decoration: const BoxDecoration(
        //         //           color: Colors.white,
        //         //           borderRadius: BorderRadius.only(
        //         //               topLeft: Radius.circular(20),
        //         //               topRight: Radius.circular(20))),
        //         //       child: Expanded(
        //         //         child: Column(
        //         //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         //             children: [
        //         //               Row(
        //         //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         //                 children: [
        //         //                   Container(
        //         //                     margin: const EdgeInsets.only(right: 8),
        //         //                     padding: const EdgeInsets.all(8),
        //         //                     height: 60,
        //         //                     width: 60,
        //         //                     decoration: const BoxDecoration(
        //         //                         color: Color.fromARGB(255, 207, 206, 206),
        //         //                         borderRadius: BorderRadius.all(
        //         //                             Radius.circular(50))),
        //         //                     child: const Image(
        //         //                       alignment: Alignment.center,
        //         //                       image: AssetImage(
        //         //                           "assets/washing-machine.png"),
        //         //                     ),
        //         //                   ),
        //         //                   Column(
        //         //                     mainAxisAlignment:
        //         //                         MainAxisAlignment.spaceBetween,
        //         //                     crossAxisAlignment: CrossAxisAlignment.start,
        //         //                     children: [
        //         //                       Text(
        //         //                         "Total Items",
        //         //                         style: GoogleFonts.inter(
        //         //                             color: Kinactivetextcolor,
        //         //                             fontSize: 18,
        //         //                             fontWeight: FontWeight.bold),
        //         //                       ),
        //         //                       Text(
        //         //                         "4 Items",
        //         //                         style: GoogleFonts.inter(
        //         //                             fontWeight: FontWeight.bold,
        //         //                             fontSize: 18),
        //         //                       )
        //         //                     ],
        //         //                   ),
        //         //                   const SizedBox(
        //         //                     width: 110,
        //         //                   ),
        //         //                   Column(
        //         //                     crossAxisAlignment: CrossAxisAlignment.start,
        //         //                     mainAxisAlignment:
        //         //                         MainAxisAlignment.spaceBetween,
        //         //                     children: [
        //         //                       Text("Cost",
        //         //                           style: GoogleFonts.inter(
        //         //                               color: Kinactivetextcolor,
        //         //                               fontSize: 18,
        //         //                               fontWeight: FontWeight.bold)),
        //         //                       Text(
        //         //                         "\$ 4 ",
        //         //                         style: GoogleFonts.inter(
        //         //                             fontWeight: FontWeight.bold,
        //         //                             fontSize: 18),
        //         //                       )
        //         //                     ],
        //         //                   )
        //         //                 ],
        //         //               ),
        //         //               custombtn(
        //         //                   txtbtn: "CheckOut",
        //         //                   onpress: () => Navigator.push(
        //         //                       context,
        //         //                       MaterialPageRoute(
        //         //                           builder: (context) =>
        //         //                               const LoginPage())),
        //         //                   colorbtn: Kactivecolor,
        //         //                   colortxt: Colors.white)
        //         //             ]),
        //         //       ),
        //         //     ),
        //         //   ),
        //         // )
        //       ],
        //     );
        //   },
        // ),

        //