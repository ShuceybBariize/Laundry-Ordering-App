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
  // List<String>   collNames = [
  //   'cart_iron_orders',
  //   'cart_wash_iron_orders',
  //   'cart_wash_orders',
  //   'cart_suit_orders'
  // ];
  var collNames = "Washing Clothes Order";

  // final List<String> collectionNames = [
  //   'cart_iron_orders',
  //   'cart_wash_iron_orders',
  //   'cart_wash_orders',
  //   'cart_suit_orders'
  //   // Add more collection names as needed
  // ];

  // late StreamController<String> _collectionController;
  // late Timer _timer;
  // int _currentIndex = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   _collectionController = StreamController<String>();
  //   _timer = Timer.periodic(Duration(milliseconds: 3000), (timer) {
  //     updateCollectionName();
  //   });
  // }

  // @override
  // void dispose() {
  //   _collectionController.close();
  //   _timer.cancel();
  //   super.dispose();
  // }

  // void updateCollectionName() {
  //   final nextCollectionName = collectionNames[_currentIndex];
  //   _collectionController.add(nextCollectionName);

  //   _currentIndex = (_currentIndex + 1) % collectionNames.length;
  // }

  @override
  Widget build(BuildContext context) {
    String? email = FirebaseAuth.instance.currentUser!.email;

// ignore: unused_local_variable
    const IconData check = IconData(0xe156, fontFamily: 'MaterialIcons');

    // var today = DateTime.now();

    // var dateFormat = DateFormat('dd-MM-yyyy');

    // String currentDate = dateFormat.format(today);

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

                // int documentCount = snapshot.data!.docs.length;

                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        // width: 375,
                        // height: 65,
                        // margin: EdgeInsets.only(left: 10),
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
            height: 130,
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
                      title: const Text('Your order'),
                      subtitle: Container(
                        color: Colors.green,
                        child: Row(
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 3),
                                Expanded(
                                    child: Text(
                                  'Date:',
                                )),
                                Expanded(
                                  child: Text('Price:'),
                                ),
                                SizedBox(height: 3),
                                Expanded(child: Text('Quantity: ')),
                                SizedBox(height: 3),
                                Expanded(
                                  child: Icon(
                                    Icons.check,
                                    size: 30,
                                    color: Colors.red,
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
                                const SizedBox(height: 3),
                                Expanded(child: Text(date)),
                                const SizedBox(height: 3),
                                Expanded(
                                  child: Text(
                                      '\$${double.parse(clothPrice.toStringAsFixed(2))}'),
                                ),
                                const SizedBox(height: 3),
                                Expanded(child: Text('$quantity')),
                                const SizedBox(height: 3),
                                const Expanded(
                                  child: Text(''),
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
                color: Colors.amber,
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 24,
                    spreadRadius: -6,
                  )
                ]),
            height: 125,
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Card(
                  color: Colors.amber,
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
                      title: const Text('Your order'),
                      subtitle: Container(
                        color: Colors.amber,
                        child: Row(
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Date:',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Expanded(
                                  child: Text(
                                    'Price:',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Expanded(
                                    child: Text(
                                  'Quantity: ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )),
                                SizedBox(height: 3),
                                Expanded(
                                  child: Text(
                                    'OrderStatus:',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    date,
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Expanded(
                                  child: Text(
                                    '\$${double.parse(clothPrice.toStringAsFixed(2))}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Expanded(
                                    child: Text(
                                  '$quantity',
                                  style: const TextStyle(fontSize: 13),
                                )),
                                const SizedBox(height: 3),
                                Expanded(
                                  child: Text(
                                    orderstatus,
                                    style: const TextStyle(fontSize: 13),
                                  ),
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
