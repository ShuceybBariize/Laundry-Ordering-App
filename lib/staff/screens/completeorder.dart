import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../exports.dart';
import '../../provider.dart';

class CompleteOrders extends StatefulWidget {
  const CompleteOrders({super.key});

  @override
  State<CompleteOrders> createState() => _CompleteOrdersState();
}

class _CompleteOrdersState extends State<CompleteOrders> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var collectionName = "Washing Clothes Order";

  // here is function to get docid
  String? documentid;
  Future<void> getDocIdByORderState(String name) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(collectionName);
      QuerySnapshot querySnapshot =
          await collectionRef.where('orderstatus', isEqualTo: name).get();
      for (var doc in querySnapshot.docs) {
        documentid = doc.id;

        if (mounted) {
          setState(() {});
        }
      }
    } on FirebaseAuthException catch (e) {
      print('The erro waa: ${e.toString()}');
    }
  }

//update function
  Future<void> updateorderstate() async {
    try {
      CollectionReference ref =
          FirebaseFirestore.instance.collection(collectionName);
      ref.doc(documentid).update({'orderstatus': 'Delivered'});
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('The error waa: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // String? uid = docUser.id;
    // print('this is the ducument id we want : $docid');
    var today = DateTime.now();
    var dateFormat = DateFormat('dd-MM-yyyy');
    // ignore: unused_local_variable
    String currentDate = dateFormat.format(today);

    return SafeArea(
      child: Consumer<CartProvider>(builder: (context, value, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Completed $collectionName"), centerTitle: true,

            //
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(collectionName)
                    .where('orderstatus', isEqualTo: 'Completed')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  int documentCount = snapshot.data!.docs.length;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
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
                                    labelText: 'Select The Collection name',
                                    labelStyle: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  isDense: true,
                                  value: collectionName.isEmpty
                                      ? collectionName
                                      : null,
                                  items: <String>[
                                    'Ironing Clothes Order',
                                    'Washing and Ironing Clothes Order',
                                    'Washing Clothes Order',
                                    'Suits Order',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
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
                                      collectionName = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('The Total Completed orders: $documentCount'),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(collectionName)
                      .where('orderstatus', isEqualTo: 'Completed')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("There is no pending  $collectionName"),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          // DocumentSnapshot document = snapshot.data!.docs[index];
                          QuerySnapshot querySnapshot = snapshot.data!;
                          List<QueryDocumentSnapshot> documents =
                              querySnapshot.docs;
                          List<Map> items =
                              documents.map((e) => e.data() as Map).toList();

                          getDocIdByORderState(
                              items[index]['orderstatus'].toString());

                          // Create your custom widget to display the document fields here
                          return CustomerOrderWidget(
                            // email: items[index]['email'].toString(),
                            email: items[index]['email'].toString(),
                            customerName: items[index]['name'],
                            clothImage: items[index]['imageUrl'],
                            clothPrice: double.tryParse(
                                    items[index]['clothPrice'].toString()) ??
                                0,
                            clothName: items[index]['clothName'],
                            quantity: items[index]['quantity'],
                            date: items[index]['date'],
                            onpress: () {
                              setState(() {
                                updateorderstate();

                                sendNotificationsToStaff(
                                    items[index]['email'].toString());
                              });
                            },
                            totalPrice: items[index]['Total'],
                          );
                          // ListTile(
                          //   title: Text(document['title']),
                          //   subtitle: Text(document['subtitle']),
                          // );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(""),
                      );
                    }
                  },
                ),
              ),
            ],
          ),

          //streamBule
        );
      }),
    );
  }

  //update cart orders
  Future<List<String>> cartOrdersupdate(String email) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('cartOrders')
        .where('email', isEqualTo: email)
        .get();

    List<String> fieldValues = [];

    if (querySnapshot.docs.isNotEmpty) {
      // for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      CollectionReference ref1 =
          FirebaseFirestore.instance.collection('cartOrders');
      ref1.doc(documentid).update({'orderstatus': 'Delivered'});
      // dynamic fieldValue = documentSnapshot.get('orderstatus');

      // fieldValues.add(fieldValue.toString());
      // }
    }
    //print('odersta is : $fieldValues');

    return fieldValues;
  }

  //get customer deviceToken
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<String>> getCustomerDeviceTokens(String gmail) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: gmail)
        .get();

    List<String> fieldValues = [];

    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        dynamic fieldValue = documentSnapshot.get('deviceToken');
        fieldValues.add(fieldValue.toString());
      }
    }
    return fieldValues;
  }

//send Noification to customer
  Future<void> sendNotificationsToStaff(String gmail) async {
    // Step 1: Get the device tokens of all staff members
    List<String> customerDeviceTokens = await getCustomerDeviceTokens(gmail);

    if (customerDeviceTokens.isEmpty) {
      print('No staff members found.');
      return;
    }

    // Step 2: Send notifications to each staff member
    String serverKey =
        'AAAA0fQfPAY:APA91bF8azi0edbZtBNuX8R-qrLhctwRxJaGFSNz2Wi7gTBQ57eQgvWL4j_T8vAh9QBCszI6prkahxMfWDxMJfqZq3KeEShZD9CIP5Wwdgi4OJs0d9YtWk4t0O718wfdRR6KrzquhtyZ'; // Replace with your FCM server key

    final Map<String, dynamic> notification = {
      'body': 'Your order was Delivered.',
      'title': 'Happy Laundry Ordering',
      'icon': 'logo',
      'sound': 'default',
    };

    final Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'payload': 'bending_order',
    };

    final Map<String, dynamic> fcmMessage = {
      'notification': notification,
      'data': data,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    try {
      // Send notifications to each staff member
      for (String deviceToken in customerDeviceTokens) {
        fcmMessage['to'] = deviceToken;
        final response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: headers,
          body: jsonEncode(fcmMessage),
        );

        if (response.statusCode == 200) {
          print(
              'Notification sent successfully to staff member with device token: $deviceToken');
        } else {
          print(
              'Failed to send notification to staff member with device token: $deviceToken. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error sending notifications to staff members: $e');
    }
  }
}

class CustomerOrderWidget extends StatelessWidget {
  final String? email;
  final String customerName;
  final String clothName;
  final String clothImage;
  final double clothPrice;

  final int quantity;
  final double totalPrice;
  final String date;
  final VoidCallback onpress;

  const CustomerOrderWidget({
    super.key,
    this.email,
    required this.customerName,
    required this.clothName,
    required this.date,
    required this.clothImage,
    required this.clothPrice,
    required this.quantity,
    required this.totalPrice,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      height: 220,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Card(
            color: Colors.amber,
            elevation: 0.0,
            semanticContainer: true,
            margin: const EdgeInsets.all(5),
            child: SizedBox(
              width: double.infinity,
              height: 130,
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
                  email ?? "N/A",
                  style: const TextStyle(
                    fontSize: 13.0,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('user: $customerName'),
                    const SizedBox(height: 5),
                    Text('Cloth: $clothName'),
                    const SizedBox(height: 5),
                    Text(
                        'Price: \$${double.parse(clothPrice.toStringAsFixed(2))}'),
                    const SizedBox(height: 5),
                    Text('Quantity: $quantity'),
                    const SizedBox(height: 5),
                    Text('Date: $date'),
                    const SizedBox(height: 5),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Total: \$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber),
              borderRadius: BorderRadius.circular(32),
            ),
            width: 250,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Material(
                //Wrap with Material
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                elevation: 18.0,
                color: Color(0xFF801E48),
                clipBehavior: Clip.antiAlias, // Add This
                child: MaterialButton(
                  minWidth: 250.0,
                  height: 35,
                  color: Color(0xFF33691E),
                  onPressed: onpress,
                  child: Text('Send Delivered Screen',
                      style: TextStyle(fontSize: 16.0, color: Colors.white)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
