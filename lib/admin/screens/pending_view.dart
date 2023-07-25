import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart' show Consumer;

import '../../exports.dart';
import '../../provider.dart';

class PendingView extends StatefulWidget {
  const PendingView({super.key});

  @override
  State<PendingView> createState() => _PendingViewState();
}

class _PendingViewState extends State<PendingView> {
  final docUser = FirebaseFirestore.instance.collection('customers').doc();
  var collectionName = "cart_wash_orders";

  FirebaseAuth auth = FirebaseAuth.instance;
  // here is function to get docid
  String? documentid;
  Future<void> getcompltedorder(String name) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(collectionName);
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
            title: Card(
              color: Colors.blue,
              surfaceTintColor: Colors.amber,
              child: Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                // margin: EdgeInsets.only(top: 10),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      gapPadding: 1.0,
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    labelText: 'Select the collection',
                    labelStyle: TextStyle(
                      fontSize: 15,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  dropdownColor: Colors.white,
                  isExpanded: false,
                  isDense: false,
                  value: collectionName.isEmpty ? collectionName : null,
                  items: <String>[
                    'cart_iron_orders',
                    'cart_wash_iron_orders',
                    'cart_wash_orders',
                    'cart_suit_orders'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        selectionColor: Colors.amber,
                        style: const TextStyle(fontSize: 20),
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
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream:
                //  FirebaseFirestore.instance
                //     .collection("cart_orders")
                //     .where('orderstatus', isEqualTo: 'complete')
                //     .orderBy('name')
                //     .snapshots(),
                FirebaseFirestore.instance
                    .collection(collectionName)
                    //  .orderBy('userId')
                    .where('orderstatus', isEqualTo: '')
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("ERROR OCCURED"),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text("There is no PENDING:  $collectionName"),
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
                      clothPrice: double.tryParse(
                              items[index]['clothPrice'].toString()) ??
                          0,
                      clothName: items[index]['clothName'],
                      quantity: items[index]['quantity'],
                      date: items[index]['date'],
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

  const CustomerOrderWidget({
    super.key,
    required this.customerName,
    required this.clothName,
    required this.date,
    required this.clothImage,
    required this.clothPrice,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber,
      elevation: 2.0,
      semanticContainer: true,
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        // color: Colors.amber,
        width: double.infinity,
        height: 120,
        child: ListTile(
          // splashColor: Colors.amber,
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
            ],
          ),
        ),
      ),
    );
  }
}
