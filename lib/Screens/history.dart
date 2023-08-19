// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:laundry_order_app/exports.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class HistoryPage extends StatefulWidget {
//   const HistoryPage({super.key});

//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   String uid = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   Widget build(BuildContext context) {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     Future<List<String>> getFieldValuesByEmail(String email) async {
//       QuerySnapshot querySnapshot = await firestore
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .get();

//       List<String> fieldValues = [];

//       if (querySnapshot.docs.isNotEmpty) {
//         for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
//           dynamic fieldValue = documentSnapshot.get('orderstatus');
//           fieldValues.add(fieldValue.toString());
//         }
//       }
//       return fieldValues;
//     }

//     // String email = 'your_email@example.com';

//     // ignore: unused_local_variable
//     String? email = FirebaseAuth.instance.currentUser!.email;
//     String? user = FirebaseAuth.instance.currentUser!.email;
//     String value = '';
//     Future<String> displayStatusOrder() async {
//       await Future.delayed(Duration(seconds: 2));
//       List<String> fieldValues = await getFieldValuesByEmail(user!);
//       if (fieldValues.isNotEmpty) {
//         print('Field Values:');
//         for (String fieldValue in fieldValues) {
//           print('the fieldvalue:  $fieldValue');
//           value = fieldValue;
//           print('the value: $value');
//           return fieldValue;
//         }
//       } else {
//         print('No matching documents found.');
//       }
//       return value;
//     }

//     var today = DateTime.now();

//     var dateFormat = DateFormat('dd-MM-yyyy');

//     String currentDate = dateFormat.format(today);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("History"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: FutureBuilder<String>(
//           future: displayStatusOrder(),
//           builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else {
//               return snapshot.data!.isEmpty
//                   ? Container() // here this container will retain if orderstatus is empty
//                   : Column(
//                       children: [
//                         Histrory_Laundry(
//                           orderStatus: snapshot.data,
//                           time: currentDate.toString(),
//                         ),
//                       ],
//                     );

//               // return Text('Result: ${snapshot.data}');
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// class Histrory_Laundry extends StatelessWidget {
//   final String? orderStatus;
//   final String? time;
//   const Histrory_Laundry({
//     super.key,
//     required this.orderStatus,
//     required this.time,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//       child: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           children: [
//             Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Your order",
//                         style: GoogleFonts.inter(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           // wordSpacing: 0.5,
//                           fontSize: 22,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         time!,
//                         style: GoogleFonts.inter(
//                           color: Kinactivetextcolor,
//                           fontSize: 18,
//                         ),
//                       )
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                         height: 70,
//                         width: 200,
//                         decoration: BoxDecoration(
//                             color: Colors.green,
//                             borderRadius: BorderRadius.circular(30)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               orderStatus!,
//                               style: GoogleFonts.inter(
//                                   color: Colors.white,
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.w700),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ]),
//             const SizedBox(
//               height: 10,
//             ),
//             const Divider(
//               thickness: 1,
//               height: 31,
//               color: Colors.grey,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  var collNames = "Washing Clothes Order";

  @override
  Widget build(BuildContext context) {
    String? email = FirebaseAuth.instance.currentUser!.email;

// ignore: unused_local_variable
    const IconData check = IconData(0xe156, fontFamily: 'MaterialIcons');

    return Scaffold(
        appBar: AppBar(
          title: const Text("HISTORY"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(collNames)
                  .where('email', isEqualTo: email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text(''));
                }

                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Card(
                          color: Colors.blue,
                          surfaceTintColor: Colors.amber,
                          child: DropdownButtonFormField<String>(
                            elevation: 4,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                //<-- SEE HERE
                                //  gapPadding: 0.1,
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              labelText: 'Select The Order You Made',
                              labelStyle:
                                  TextStyle(fontSize: 18, color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            isDense: true,
                            value: collNames.isEmpty ? collNames : null,
                            items: <String>[
                              'Ironing Clothes Order',
                              'Washing and Ironing Clothes Order',
                              'Washing Clothes Order',
                              'Suits Order',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Expanded(
                                  child: Text(
                                    value,
                                    selectionColor: Colors.amber,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                //  _currentItemSelected = value!;
                                collNames = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(collNames)
                    .where('email', isEqualTo: email)
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("There is no order"),
                    );
                  }

                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot = snapshot.data!;
                    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                    List<Map> items =
                        documents.map((e) => e.data() as Map).toList();

                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      scrollDirection: Axis.vertical,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final orderstatus = items[index]['orderstatus'];

                        return HistoryWiget(
                          clothImage: items[index]['imageUrl'] ?? "N?A",
                          clothPrice: double.tryParse(
                                  items[index]['clothPrice'].toString()) ??
                              0,
                          quantity: items[index]['quantity'],
                          date: items[index]['date'],
                          totalPrice: double.tryParse(
                                  items[index]['clothPrice'].toString()) ??
                              0,
                          orderstatus: items[index]['orderstatus'],
                          condition: orderstatus == 'Delivered',
                          // icon: orderstatus =='Delivetred'?Icon(Icons.check_circle, color: Colors.green,): null;
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ));
  }
}

class HistoryWiget extends StatelessWidget {
  final String clothImage;
  final double clothPrice;

  final int quantity;
  final double totalPrice;
  final String orderstatus;
  final String date;

  final bool condition;

  const HistoryWiget({
    super.key,
    required this.date,
    required this.clothImage,
    required this.clothPrice,
    required this.orderstatus,
    required this.quantity,
    required this.totalPrice,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return condition
        ? Container(
            // color: Colors.amber,
            decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 24,
                    spreadRadius: -6,
                  )
                ]),
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Card(
                  color: Colors.green,
                  elevation: 0.0,
                  semanticContainer: true,
                  margin: const EdgeInsets.all(5),
                  child: SizedBox(
                    width: double.infinity,
                    height: 90,
                    child: ListTile(
                      leading: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: NetworkImage(clothImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        'Date: $date',
                        style: const TextStyle(
                          fontSize: 11.0,
                        ),
                      ),
                      subtitle: Container(
                        color: Colors.green,
                        child: Row(
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text('Price:'),
                                ),
                                SizedBox(height: 3),
                                Expanded(child: Text('Quantity: ')),
                                SizedBox(height: 3),
                                Expanded(
                                  child: Icon(Icons.check),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      '\$${double.parse(clothPrice.toStringAsFixed(2))}'),
                                ),
                                const SizedBox(height: 3),
                                Expanded(child: Text('$quantity')),
                                const SizedBox(height: 3),
                                Expanded(
                                  child: Text(orderstatus),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Total: \$${totalPrice.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 3.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            // color: Colors.amber,
            decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 24,
                    spreadRadius: -6,
                  )
                ]),
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Card(
                  color: Colors.green,
                  elevation: 0.0,
                  semanticContainer: true,
                  margin: const EdgeInsets.all(5),
                  child: SizedBox(
                    width: double.infinity,
                    height: 90,
                    child: ListTile(
                      leading: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: NetworkImage(clothImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        'Date: $date',
                        style: const TextStyle(
                          fontSize: 11.0,
                        ),
                      ),
                      subtitle: Container(
                        color: Colors.green,
                        child: Row(
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text('Price:'),
                                ),
                                SizedBox(height: 3),
                                Expanded(child: Text('Quantity: ')),
                                SizedBox(height: 3),
                                Expanded(
                                  child: Text(
                                    'OrderStatus:',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      '\$${double.parse(clothPrice.toStringAsFixed(2))}'),
                                ),
                                const SizedBox(height: 3),
                                Expanded(child: Text('$quantity')),
                                const SizedBox(height: 3),
                                Expanded(
                                  child: Text(orderstatus),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Total: \$${totalPrice.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 3.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
