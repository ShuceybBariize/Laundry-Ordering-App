// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../exports.dart';
import '../../provider.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  // ignore: override_on_non_overriding_member
  var collectionName = "laundry";
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, value, _) {
      return Scaffold(
          appBar: AppBar(
            title: Card(
              color: Colors.blue,
              surfaceTintColor: Colors.amber,
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                // margin: EdgeInsets.only(top: 10),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
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
                    'laundry',
                    'ironOrders',
                    'washIronOrder',
                    'suitorder'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        selectionColor: Colors.amber,
                        style: TextStyle(fontSize: 20),
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
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.black,
                size: 21,
              ),
              // FontAwesomeIcons.arrowLeft,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(collectionName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("ERROR OCCURED"),
                  );
                }
                if (snapshot.hasData) {
                  QuerySnapshot querySnapshot = snapshot.data!;
                  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                  List items = documents.map((e) => e.data() as Map).toList();
                  // return Text("${items[0]}");
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            width: 140,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: CachedNetworkImage(
                                imageUrl: items[index]['imageUrl']),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            children: [
                              Text(
                                items[index]['clothName'].toString(),
                                style: GoogleFonts.poppins(fontSize: 22),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '\$${items[index]['initialPrice']}',
                                style: GoogleFonts.poppins(
                                    fontSize: 22, color: Colors.green),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }));
    });
  }
}
