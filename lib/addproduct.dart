import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../exports.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController _clothName = TextEditingController();
  final TextEditingController _clothId = TextEditingController();
  final TextEditingController _clothPrice = TextEditingController();
  final TextEditingController _initialPrice = TextEditingController();
  final TextEditingController _Id = TextEditingController();
  final TextEditingController _quanity = TextEditingController();
  File? _image;
  String selectedCollection = 'ironOrders';
  bool isloading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _addProduct() async {
    final clothName = _clothName.text;
    final Id = _Id.text;
    final clothPrice = _clothPrice.text;
    final intialPrice = _initialPrice.text;
    final clothId = _clothId.text;
    final quantity = _quanity.text;

    if (intialPrice.isNotEmpty &&
        quantity.isNotEmpty &&
        clothName.isNotEmpty &&
        intialPrice.isNotEmpty &&
        clothId.isNotEmpty &&
        Id.isNotEmpty &&
        _image != null) {
      // Upload image to Firebase Storage
      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref().child('product_images/${_image!.path}');
      final uploadTask = storageRef.putFile(_image!);
      final TaskSnapshot storageSnapshot = await uploadTask;
      final imageUrl = await storageSnapshot.ref.getDownloadURL();

      // Add product data to Firestore
      final firestore = FirebaseFirestore.instance;
      final productsCollection = firestore.collection(selectedCollection);
      await productsCollection.add({
        'id': Id,
        'clothid': clothId,
        'clothName': clothName,
        'clothPrice': clothPrice,
        'imageUrl': imageUrl,
        'initialPrice': intialPrice,
        'quantity': quantity,
      }).catchError((error) {
        // Error occurred while adding data
        print('Error adding data: $error');
      });

      // Reset form
      _Id.clear();
      _clothId.clear();
      _clothName.clear();
      _quanity.clear();
      _initialPrice.clear();
      _clothPrice.clear();
      setState(() {
        _image = null;
      });
      // const Center(
      //     child: CircularProgressIndicator(
      //   color: Colors.amber,
      // ));

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: Text('Data added to $selectedCollection DataBase'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Please fill all the fields and select an image And Choose Collections.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 249, 245, 245),
        leading: IconButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            size: 21,
          ),
          // FontAwesomeIcons.arrowLeft,
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomTitles(
                    subtitle: "ADD PRODUCT HERE", title: "ADD PRODUCTS"),
                TextFormField(
                  obscureText: false,
                  controller: _Id,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18),
                    fillColor: Kactivecolor,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Kactivecolor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Kactivecolor, width: 2),
                    ),
                    hintText: "Enter ID",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: false,
                  controller: _clothId,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18),
                    fillColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Kactivecolor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Kactivecolor, width: 2),
                    ),
                    hintText: "Enter ClothID",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: false,
                  controller: _clothName,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18),
                    fillColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Kactivecolor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Kactivecolor, width: 2),
                    ),
                    hintText: "Enter Cloth NAME",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: false,
                  controller: _clothPrice,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18),
                    fillColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Kactivecolor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Kactivecolor, width: 2),
                    ),
                    hintText: "Enter Cloth Price",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: false,
                  controller: _initialPrice,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18),
                    fillColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Kactivecolor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Kactivecolor, width: 2),
                    ),
                    hintText: "Enter InitialPrice",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: false,
                  controller: _quanity,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18),
                    fillColor: Colors.black,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Kactivecolor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Kactivecolor, width: 2),
                    ),
                    hintText: "Enter Quantity",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _image != null
                    ? GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    _image!,
                                  )),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Kactivecolor,
                                width: 3,
                              ),
                              color: Colors.transparent),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Choose Image",
                                  style: GoogleFonts.inter(
                                      color: Colors.white, fontSize: 20),
                                ),
                                const Icon(
                                  color: Colors.white,
                                  Icons.image,
                                  size: 40,
                                )
                              ]),
                        ),
                      )
                    : GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Kactivecolor,
                                width: 3,
                              ),
                              color: Colors.transparent),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Choose Image",
                                  style: GoogleFonts.inter(fontSize: 20),
                                ),
                                const Icon(
                                  Icons.image,
                                  size: 40,
                                )
                              ]),
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: selectedCollection,
                      items: [
                        'ironOrders',
                        'laundry',
                        'suitorder',
                        'washOrders'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCollection = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                custombtn(
                    txtbtn: "Add Product",
                    onpress: () {
                      _addProduct();
                      setState(() {
                        isloading = true;
                      });
                    },
                    colorbtn: Kactivecolor,
                    colortxt: Colors.white)
              ],
            ),
          ),
        ],
      ),
    );
  }
}



// String? validateId(String? id) {
//   if (id!.isEmpty) {
//     return 'id is messing!';
//   } else {
//     return null;
//   }
// }

// String? validateclothId(String? clothid) {
//   if (clothid!.isEmpty) {
//     return 'cloth id is messing!';
//   } else {
//     return null;
//   }
// }

// String? validateclothname(String? id) {
//   if (id!.isEmpty) {
//     return 'cloth name is messing!';
//   } else {
//     return null;
//   }
// }

// String? validateInitalpirace(String? inprice) {
//   if (inprice!.isEmpty) {
//     return 'Inititialpirace is messing!';
//   } else {
//     return null;
//   }
// }

// String? validateclothprice(String? price) {
//   if (price!.isEmpty) {
//     return 'Price is messing';
//   } else {
//     return null;
//   }
// }

// String? validatequantity(String? quantity) {
//   if (quantity!.isEmpty) {
//     return 'quantity is messing';
//   } else {
//     return null;
//   }
// }

// String? validateimageurl(String? image) {
//   if (image!.isEmpty) {
//     return 'imageurl is messing';
//   } else {
//     return null;
//   }
// }
