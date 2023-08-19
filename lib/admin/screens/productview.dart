// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../exports.dart';
import '../../provider.dart';

class AdminProductView extends StatefulWidget {
  const AdminProductView({super.key});

  @override
  State<AdminProductView> createState() => _AdminProductViewState();
}

class _AdminProductViewState extends State<AdminProductView> {
  var collectionName = "laundry";
  // final CollectionReference _items =
  //     FirebaseFirestore.instance.collection('productdb');
  late double initialprice, clothprice;
  late String clothname = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clothnameController = TextEditingController();
  final TextEditingController _initialPriceController = TextEditingController();
  final TextEditingController _clothPriceController = TextEditingController();
  // final TextEditingController _Controller = TextEditingController();
  String? documentid;
  Future<void> getcustomerdocid(String name) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(collectionName);
      QuerySnapshot querySnapshot =
          await collectionRef.where('clothName', isEqualTo: name).get();
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
    collectionName;
    // Function to delete a user document
    Future<void> deleteProduct(String userID) async {
      try {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentid)
            .delete();
        print('product deleted to $collectionName');
      } catch (e) {
        print('Error deleting user: $e');
      }
      setState(() {});
    }

    return Consumer<CartProvider>(builder: (context, value, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Product View'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.white,
              size: 21,
            ),
            // FontAwesomeIcons.arrowLeft,
          ),
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(collectionName)
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
                                  'laundry',
                                  'ironclothes',
                                  'wash_and_irondb',
                                  'suitorder'
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
                          Text('The Total $collectionName are: $documentCount'),
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

                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      scrollDirection: Axis.vertical,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            // SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.only(
                                top: 30,
                              ),
                              height: 120,
                              width: 75,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: items[index]['imageUrl'] ??
                                      "https://t3.ftcdn.net/jpg/05/61/20/60/360_F_561206028_IwPcDNIHTRPa8r89L0SIXSx5JUEI32dU.jpg"),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  items[index]['clothName'].toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '\$${items[index]['initialPrice']}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 24, color: Kactivecolor),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      getcustomerdocid(
                                          items[index]['clothName'].toString());
                                      if (items[index] != null) {
                                        _clothnameController.text =
                                            items[index]['clothName'];
                                        _clothPriceController.text =
                                            items[index]['clothPrice']
                                                .toString();
                                        _initialPriceController.text =
                                            items[index]['initialPrice']
                                                .toString();
                                      }
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                top: 20,
                                                right: 20,
                                                left: 20,
                                                bottom: MediaQuery.of(ctx)
                                                        .viewInsets
                                                        .bottom +
                                                    20),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Center(
                                                  child: Text(
                                                    "Update the clothname",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Form(
                                                  key: _formKey,
                                                  child: TextFormField(
                                                    controller:
                                                        _clothnameController,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                'Cloth Name',
                                                            hintText:
                                                                'e.g: shirt'),
                                                    onSaved: (value) {
                                                      clothname = value!;
                                                    },
                                                    validator: validatename,
                                                  ),
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      _initialPriceController,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText:
                                                              'Initial Price',
                                                          hintText:
                                                              'e.g: \$0.0'),
                                                  onSaved: (value) {
                                                    initialprice = double.parse(
                                                        value!.toString());
                                                  },
                                                  validator:
                                                      validateInitalPrice,
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      _clothPriceController,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText:
                                                              'Cloth Price',
                                                          hintText:
                                                              'e.g: \$0.0'),
                                                  onSaved: (value) {
                                                    clothprice = double.parse(
                                                        value!.toString());
                                                  },
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Empty';
                                                    }
                                                    if (clothprice !=
                                                        initialprice) {
                                                      return 'Not Match';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      final String name =
                                                          _clothnameController
                                                              .text;
                                                      final double?
                                                          initialPrice =
                                                          double.tryParse(
                                                              _clothPriceController
                                                                  .text);
                                                      final double? clothPrice =
                                                          double.tryParse(
                                                              _clothPriceController
                                                                  .text);
                                                      // final int? number =
                                                      //     int.tryParse(_numberController.text);
                                                      if (clothPrice != null) {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                collectionName)
                                                            .doc(documentid)
                                                            .update({
                                                          "clothName": name,
                                                          "initialPrice":
                                                              initialPrice,
                                                          "clothPrice":
                                                              clothPrice,
                                                        });
                                                        _clothnameController
                                                            .text = '';
                                                        _clothPriceController
                                                            .text = '';
                                                        _clothPriceController
                                                            .text = '';

                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    child: const Text("Update"))
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Kactivecolor,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        getcustomerdocid(items[index]
                                                ['clothName']
                                            .toString());
                                        deleteProduct(documentid.toString());
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              ],
                            )
                            //end row 1
                          ],
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class UpdateFieldDialog extends StatefulWidget {
  final String documentId; // The ID of the document you want to update
  final String fieldName; // The name of the field you want to update

  const UpdateFieldDialog(
      {super.key, required this.documentId, required this.fieldName});

  @override
  _UpdateFieldDialogState createState() => _UpdateFieldDialogState();
}

class _UpdateFieldDialogState extends State<UpdateFieldDialog> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update ${widget.fieldName}'),
      content: TextField(
        controller: _textFieldController,
        decoration: InputDecoration(hintText: 'Enter new value'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String newValue = _textFieldController.text;
            // Update the field in Firebase
            try {
              await FirebaseFirestore.instance
                  .collection('your_collection')
                  .doc(widget.documentId)
                  .update({
                widget.fieldName: newValue,
              });
              Navigator.pop(context); // Close the dialog box
            } catch (e) {
              // Handle any error that occurred during the update process
              print('Error updating ${widget.fieldName}: $e');
            }
          },
          child: Text('Update'),
        ),
      ],
    );
  }

  void _showUpdateFieldDialog(
      BuildContext context, String documentId, String fieldName) {
    showDialog(
      context: context,
      builder: (context) =>
          UpdateFieldDialog(documentId: documentId, fieldName: fieldName),
    );
  }
}

String? validateClothName(String? name) {
  if (name!.isEmpty) {
    return 'Please Enter the Cloth name';
  } else {
    return null;
  }
}

String? validateInitalPrice(String? initalPrice) {
  if (initalPrice!.isEmpty) {
    return 'Please Enter the initial Pirce';
  } else {
    return null;
  }
}
