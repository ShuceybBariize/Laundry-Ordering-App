import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart' show Consumer;

import '../../exports.dart';
import '../../provider.dart';

class OgoingOrders extends StatefulWidget {
  const OgoingOrders({super.key});

  @override
  State<OgoingOrders> createState() => _OgoingOrdersState();
}

class _OgoingOrdersState extends State<OgoingOrders> {
  final docUser = FirebaseFirestore.instance.collection('customers').doc();

  FirebaseAuth auth = FirebaseAuth.instance;
  // here is function to get docid
  String? documentid;
  Future<void> getcompltedorder(String name) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('cart_orders');
      QuerySnapshot querySnapshot =
          await collectionRef.where('orderstatus', isEqualTo: name).get();
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

//get field name
  Future<void> editField() async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "Edit Order Status",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter new Order Status",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              )),

          //Save button
          TextButton(
              onPressed: () => Navigator.of(context).pop(newValue),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );

    // update  in firestore
    if (newValue.trim().isNotEmpty) {
      // await custCollection.doc(currentUser.uid).update({field: newValue});
      CollectionReference ref =
          FirebaseFirestore.instance.collection('cart_orders');

      ref.doc(documentid).update({'orderstatus': newValue});
    }
  }

//
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String? uid = docUser.id;

    return SafeArea(
      child: Consumer<CartProvider>(builder: (context, value, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Ongiong Screen Orders"),
            centerTitle: true,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream:
                //  FirebaseFirestore.instance
                //     .collection("cart_orders")
                //     .where('orderstatus', isEqualTo: 'complete')
                //     .orderBy('name')
                //     .snapshots(),
                FirebaseFirestore.instance
                    .collection("cart_orders")
                    //  .orderBy('userId')
                    .where('orderstatus', whereIn: [
              'ongoing',
              'Ongoing',
              'ong',
              'Ong',
              'on',
              'On',
              'O',
              'o'
            ]).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("ERROR OCCURED"),
                );
              }

              if (snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data!;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                List<Map> items =
                    documents.map((e) => e.data() as Map).toList();
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          // print(index);
                          // getcompltedorder(items[index]['name'].toString());
                        });
                      },
                      child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(left: 5.5),
                          color: Colors.amber,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(items[index]['name'].toString()),
                              // Text('$fields!'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: items[index]['imageUrl'],
                                    width: 80,
                                    height: 80,
                                  ),
                                  const SizedBox(height: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(items[index]['clothName']),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Quantity: ${items[index]['quantity']}'),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Price: ${items[index]['clothPrice']}'),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Total Money: ${items[index]['Total']}'),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Taking date: ${items[index]['date']}'),
                                      const SizedBox(height: 20),
                                      Text(
                                          'Orderstatus: ${items[index]['orderstatus']}'),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                  const SizedBox(width: 50),
                                  IconButton(
                                    onPressed: () {
                                      editField();
                                      setState(() {});
                                      getcompltedorder(items[index]
                                              ['orderstatus']
                                          .toString());
                                    },
                                    icon: const Icon(
                                      Icons.settings,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      }),
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