// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../exports.dart';
import 'package:image_picker/image_picker.dart';

import 'admin/widgets/uploadproductimages.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

// final firestor = FirebaseFirestore.instance.collection("productdb");

class _AddProductState extends State<AddProduct> {
  late String txtid = '',
      txtclothid = '',
      txtclothname = '',
      txtinitialprice = '',
      txtclothprice = '',
      txtinitialPrice = '',
      txtquantity = '';
  bool isloading = false;
  // imageurl = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _clothId = TextEditingController();
  final TextEditingController _clothName = TextEditingController();
  final TextEditingController _initialPrice = TextEditingController();
  final TextEditingController _clothPrice = TextEditingController();
  final TextEditingController _quanity = TextEditingController();
  final TextEditingController _imageUrl = TextEditingController();

  final databaseReference =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.reference().child("laundry");
  var collectionName = "laundry";
  // String _currentItemSelected = "productdb";
  void clearControlers() {
    _id.clear();
    _clothId.clear();
    _clothName.clear();
    _initialPrice.clear();
    _clothPrice.clear();
    _quanity.clear();
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSnack(String title) {
    final snackbar = SnackBar(
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 1, 29, 5),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 2),
    );
    scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final productImages = Provider.of<UploadImages>(context);
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Prodcuts to the firestoer"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Add the product in here",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _id,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(18),
                        fillColor: Colors.black,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Kinactivetextcolor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Kinactivetextcolor, width: 1),
                        ),
                        hintText: "Enter Id",
                      ),
                      onSaved: (value) {
                        txtid = value!;
                      },
                      validator: validateId,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _clothId,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(18),
                        fillColor: Colors.black,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Kinactivetextcolor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Kinactivetextcolor, width: 1)),
                        hintText: "Enter cloth id",
                      ),
                      onSaved: (value) {
                        txtclothid = value!;
                      },
                      validator: validateclothId,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _clothName,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(18),
                        fillColor: Colors.black,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Kinactivetextcolor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Kinactivetextcolor, width: 1)),
                        hintText: "Enter cloth name",
                      ),
                      onSaved: (value) {
                        txtclothname = value!;
                      },
                      validator: validateclothname,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      controller: _initialPrice,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(18),
                        fillColor: Colors.black,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Kinactivetextcolor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Kinactivetextcolor, width: 1)),
                        hintText: "Enter initial price",
                      ),
                      onSaved: (value) {
                        txtinitialPrice = value!;
                      },
                      validator: validateInitalpirace,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      controller: _clothPrice,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(18),
                        fillColor: Colors.black,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Kinactivetextcolor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Kinactivetextcolor, width: 1)),
                        hintText: "Enter cloth price",
                      ),
                      onSaved: (value) {
                        txtclothprice = value!;
                      },
                      validator: validateclothprice,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      controller: _quanity,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(18),
                        fillColor: Colors.black,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Kinactivetextcolor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Kinactivetextcolor, width: 1)),
                        hintText: "Quantity",
                      ),
                      onSaved: (value) {
                        txtquantity = value!;
                      },
                      validator: validateclothprice,
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // TextFormField(
                    //   obscureText: false,
                    //   controller: imageUrl,
                    //   decoration: InputDecoration(
                    //     contentPadding: const EdgeInsets.all(18),
                    //     fillColor: Colors.black,
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide: const BorderSide(
                    //           color: Kinactivetextcolor, width: 1),
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //         borderSide: const BorderSide(
                    //             color: Kinactivetextcolor, width: 1)),
                    //     hintText: "Image url",
                    //   ),
                    //   onSaved: (value) {
                    //     imageurl = value!;
                    //   },
                    //   validator: validateimageurl,
                    // ),

                    const SizedBox(height: 20),
                    // here the begining of uplading image
                    productImages.image != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: InkWell(
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        size: 60,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "Camera",
                                        style: TextStyle(fontSize: 19),
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    Map<Permission, PermissionStatus> statUser =
                                        await [
                                      Permission.camera,
                                    ].request();
                                    if (statUser[Permission.camera]!
                                        .isGranted) {
                                      productImages
                                          .pickImage(ImageSource.camera);

                                      // Navigator.pop(context);
                                    } else {
                                      print("no Permission CAMERA");
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 60,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "Gallery",
                                        style: TextStyle(fontSize: 19),
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    Map<Permission, PermissionStatus> statUser =
                                        await [
                                      Permission.storage,
                                    ].request();
                                    if (statUser[Permission.storage]!
                                        .isGranted) {
                                      productImages
                                          .pickImage(ImageSource.gallery);
                                      //Navigator.pop(context);
                                    } else {
                                      print("no Permission GALLERY");
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: InkWell(
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        size: 60,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "Camera",
                                        style: TextStyle(fontSize: 19),
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    Map<Permission, PermissionStatus> statUser =
                                        await [
                                      Permission.camera,
                                    ].request();
                                    if (statUser[Permission.camera]!
                                        .isGranted) {
                                      productImages
                                          .pickImage(ImageSource.camera);

                                      //Navigator.pop(context);
                                    } else {
                                      print("no Permission CAMERA");
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 60,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "Gallery",
                                        style: TextStyle(fontSize: 19),
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    Map<Permission, PermissionStatus> statUser =
                                        await [
                                      Permission.storage,
                                    ].request();
                                    if (statUser[Permission.storage]!
                                        .isGranted) {
                                      productImages
                                          .pickImage(ImageSource.gallery);
                                      //Navigator.pop(context);
                                    } else {
                                      print("no Permission GALLERY");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                    // end of updloading image
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          //<-- SEE HERE
                          borderSide: BorderSide(color: Colors.black, width: 1),
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
                          fontSize: 25,
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
                        'suitorder',
                        'ironOrders',
                        'washIronOrder',
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
                    const SizedBox(
                      height: 20,
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        isloading = true;
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (_formKey.currentState!.validate()) {
                            try {
                              Map<String, dynamic> addProduct = {
                                'id': int.parse(_id.text),
                                'clothid': int.parse(_clothId.text),
                                'clothName': _clothName.text,
                                'initialPrice':
                                    double.parse(_initialPrice.text),
                                'clothPrice': double.parse(_clothPrice.text),
                                'quantity': int.parse(_quanity.text),
                                'imageUrl': productImages.imageURL.toString(),
                              };

                              FirebaseFirestore.instance
                                  .collection(collectionName)
                                  .add(addProduct);
                              print(
                                  'The url image must be this: ${productImages.imageURL}');
                              print("added to te firestoer");
                            } catch (err) {
                              print(err);
                            }
                          }
                        });
                        isloading = false;
                        setState(() {
                          showSnack('Added to ..  $collectionName');
                        });
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isloading
                                ? const CircularProgressIndicator(
                                    backgroundColor: Colors.amber,
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Register",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        clearControlers();
                      },
                      child: const Text(
                        "Clear",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? validateId(String? id) {
  if (id!.isEmpty) {
    return 'id is messing!';
  } else {
    return null;
  }
}

String? validateclothId(String? clothid) {
  if (clothid!.isEmpty) {
    return 'cloth id is messing!';
  } else {
    return null;
  }
}

String? validateclothname(String? id) {
  if (id!.isEmpty) {
    return 'cloth name is messing!';
  } else {
    return null;
  }
}

String? validateInitalpirace(String? inprice) {
  if (inprice!.isEmpty) {
    return 'Inititialpirace is messing!';
  } else {
    return null;
  }
}

String? validateclothprice(String? price) {
  if (price!.isEmpty) {
    return 'Price is messing';
  } else {
    return null;
  }
}

String? validatequantity(String? quantity) {
  if (quantity!.isEmpty) {
    return 'quantity is messing';
  } else {
    return null;
  }
}

String? validateimageurl(String? image) {
  if (image!.isEmpty) {
    return 'imageurl is messing';
  } else {
    return null;
  }
}
