import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart' show Consumer;

import '../../exports.dart';
import '../../provider.dart';

class DeliveredView extends StatefulWidget {
  const DeliveredView({super.key});

  @override
  State<DeliveredView> createState() => _DeliveredViewState();
}

class _DeliveredViewState extends State<DeliveredView> {
  final docUser = FirebaseFirestore.instance.collection('users').doc();
  var collectionName = "Washing Clothes Order";

  FirebaseAuth auth = FirebaseAuth.instance;
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

  Future<void> getcompltedorder1(String name) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(collectionName);
      QuerySnapshot querySnapshot = await collectionRef
          .where('clothName', isEqualTo: name)
          .where('orderstatus', whereIn: [
        'delivered',
        'Delivered',
        'deliver',
        'Deliver',
        'del',
        'Del',
        'd',
        'D',
      ]).get();
      for (var doc in querySnapshot.docs) {
        documentid = doc.id;
        //print('Document ID: ${doc.id}');
        print('Documentid waa : $documentid');
        setState(() {});
      }
    } on FirebaseAuthException catch (e) {
      print('The erro waa: ${e.toString()}');
    }
  }
//Delete

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String? uid = docUser.id;
    // Function to delete a user document
    Future<void> deleteCompletedOrders(String userID) async {
      try {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentid)
            .delete();
        print('product deleted to cart_orders');
      } catch (e) {
        print('Error deleting user: $e');
      }
      setState(() {});
    }

    return SafeArea(
      child: Consumer<CartProvider>(builder: (context, value, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Delivered $collectionName"),
            centerTitle: true,
            //
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(collectionName)
                    .where('orderstatus', isEqualTo: 'Delivered')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text(""));
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
                            Text(
                                'The Total $collectionName are: $documentCount'),
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
                      .where('orderstatus', isEqualTo: 'Delivered')
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
                            // getdocid(items[index]['email'].toString());

                            getDocIdByORderState(
                                items[index]['orderstatus'].toString());
                            // Create your custom widget to display the document fields here
                            return CustomerOrderWidget(
                              customerName: items[index]['name'],
                              clothImage: items[index]['imageUrl'],
                              clothPrice: double.tryParse(
                                      items[index]['clothPrice'].toString()) ??
                                  0,
                              clothName: items[index]['clothName'],
                              quantity: items[index]['quantity'],
                              date: items[index]['date'],
                              onDelete: () {
                                setState(() {
                                  getcompltedorder1(
                                      items[index]['clothName'].toString());
                                  deleteCompletedOrders(documentid.toString());
                                });
                              },
                              totalPrice: items[index]['Total'],
                            );
                          });
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

          //end
        );
      }),
    );
  }
}

class CustomerOrderWidget extends StatelessWidget {
  final String customerName;
  final String clothName;
  final String clothImage;
  final double clothPrice;
  final int quantity;
  final double totalPrice;
  final String date;
  final VoidCallback onDelete;

  const CustomerOrderWidget({
    super.key,
    required this.customerName,
    required this.clothName,
    required this.date,
    required this.clothImage,
    required this.clothPrice,
    required this.quantity,
    required this.totalPrice,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
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
      child: Card(
        color: Colors.amber,
        elevation: 0.0,
        semanticContainer: true,
        margin: const EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          height: 120,
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
              customerName,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Cltoh: $clothName'),
                Text('Price: \$${clothPrice.toStringAsFixed(2)}'),
                Text('Quantity: $quantity'),
                Text('Date: $date'),
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
                Expanded(
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 33,
                      color: Colors.red,
                    ),
                    onPressed: onDelete,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//  Future<void> userSetupDone() async {
//     CollectionReference users = FirebaseFirestore.instance.collection('Users');

//     final docUser = FirebaseFirestore.instance.collection('Users').doc();

//     FirebaseAuth auth = FirebaseAuth.instance;

//     String? email = auth.currentUser?.email.toString();
//     String? phone = auth.currentUser?.phoneNumber.toString();
//     String? displayName = auth.currentUser?.displayName.toString();

//     DocumentReference reference= await users.add({'Uid': '', "Email": email, "Phone": phone, "Name": displayName});
//     await reference.update({"Uid": reference.id});
//     return;
// }
