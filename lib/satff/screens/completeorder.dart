import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart' show Consumer;

import '../../exports.dart';
import '../../provider.dart';

class CompleteOrders extends StatefulWidget {
  const CompleteOrders({super.key});

  @override
  State<CompleteOrders> createState() => _CompleteOrdersState();
}

class _CompleteOrdersState extends State<CompleteOrders> {
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
              'Com',
              'com',
              'completed',
              'complete',
              'Completed',
              'Complete',
              'c',
              'C',
              'Comp',
              'comp',
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
                    return CustomerOrderWidget(
                      customerName: items[index]['name'],
                      clothImage: items[index]['imageUrl'],
                      clothPrice: items[index]['clothPrice'],
                      clothName: items[index]['clothName'],
                      quantity: items[index]['quantity'],
                      date: items[index]['date'],
                      onpress: () {
                        setState(() {
                          editField();
                          setState(() {});
                          getcompltedorder(
                              items[index]['orderstatus'].toString());
                        });
                      },
                      totalPrice: items[index]['Total'],
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

class CustomerOrderWidget extends StatelessWidget {
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
                    Icons.settings,
                    size: 33,
                    color: Colors.black,
                  ),
                  onPressed: onpress,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
