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

  Future<void> getcompltedorder1(String name) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('cart_orders');
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
            .collection('cart_orders')
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
            title: const Text("Delivered Orders"),
            centerTitle: true,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("cart_orders")
                .where('orderstatus', whereIn: [
              'delivered',
              'deliver',
              'del',
              'd',
              'D',
              'Deliver'
            ])
                // .orderBy('id')
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
                List<Map> items =
                    documents.map((e) => e.data() as Map).toList();
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomerOrderWidget(
                      customerName: items[index]['name'],
                      clothImage: items[index]['imageUrl'],
                      clothPrice: items[index]['clothPrice'],
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

                    //  InkWell(
                    //   onTap: () {
                    //     setState(() {
                    //       // print(index);
                    //       getcompltedorder(items[index]['name'].toString());
                    //     });
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.all(10),
                    //     padding: EdgeInsets.only(left: 5.5),
                    //     color: Colors.amber,
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.end,
                    //       children: [
                    //         Text(
                    //           '\n      Name:  ${items[index]['name'].toString()}',
                    //         ),
                    //         // Text('$fields!'),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             CachedNetworkImage(
                    //               imageUrl: items[index]['imageUrl'],
                    //               width: 100,
                    //               height: 100,
                    //             ),
                    //             const SizedBox(height: 10),
                    //             Column(
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                     'Cloth:  ${items[index]['clothName']}'),
                    //                 SizedBox(height: 10),
                    //                 Text(
                    //                     'Quantity:  ${items[index]['quantity']}'),
                    //                 SizedBox(height: 10),
                    //                 Text(
                    //                     'Price:  ${items[index]['clothPrice']}'),
                    //                 SizedBox(height: 10),
                    //                 Text(
                    //                     'Total:      ${items[index]['Total']}'),
                    //                 SizedBox(height: 10),
                    //                 Text(
                    //                     'Taking date: ${items[index]['date']}'),
                    //                 const SizedBox(height: 20),
                    //                 Text(
                    //                     'Orderstatus: ${items[index]['orderstatus']}'),
                    //                 const SizedBox(height: 20),
                    //                 IconButton(
                    //                     onPressed: () {
                    // setState(() {
                    //   getcompltedorder1(items[index]
                    //           ['clothName']
                    //       .toString());
                    //   deleteCompletedOrders(
                    //       documentid.toString());
                    // });
                    //                     },
                    //                     icon: Icon(
                    //                       Icons.delete,
                    //                       color: Colors.red,
                    //                     ))
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // );
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
    return Card(
      color: Colors.amber,
      elevation: 2.0,
      semanticContainer: true,
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: ListTile(
          leading: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(clothImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            customerName,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
