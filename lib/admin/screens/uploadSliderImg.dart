// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../exports.dart';
import 'package:image_picker/image_picker.dart';

class UploadSliderImages extends StatefulWidget {
  const UploadSliderImages({super.key});

  @override
  State<UploadSliderImages> createState() => _UploadSliderImagesState();
}

// final firestor = FirebaseFirestore.instance.collection("productdb");

class _UploadSliderImagesState extends State<UploadSliderImages> {
  late String imageName = '';
  bool isloading = false;
  // imageurl = '';
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _imageName = TextEditingController();
  // final TextEditingController _clothId = TextEditingController();

  // String _currentItemSelected = "productdb";

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSnack(String title) {
    final snackbar = SnackBar(
      content: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 1, 29, 5),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: Duration(seconds: 2),
    );
    scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final imageSlder = Provider.of<UploadSliderImage>(context);
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Prodcuts to the firestoer"),
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
                    Text(
                      "Add the product in here",
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: false,
                      controller: _imageName,
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
                        imageName = value!;
                      },
                      validator: validateInitalpirace,
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(height: 20),
                    // here the begining of uplading image
                    imageSlder.image != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: InkWell(
                                  child: Column(
                                    children: const [
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
                                      imageSlder.pickImage(ImageSource.camera);

                                      // Navigator.pop(context);
                                    } else {
                                      print("no Permission CAMERA");
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Column(
                                    children: const [
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
                                      imageSlder.pickImage(ImageSource.gallery);
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
                                  child: Column(
                                    children: const [
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
                                      imageSlder.pickImage(ImageSource.camera);

                                      //Navigator.pop(context);
                                    } else {
                                      print("no Permission CAMERA");
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Column(
                                    children: const [
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
                                      imageSlder.pickImage(ImageSource.gallery);
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
                                'imageName': _imageName.text,
                                'imageUrl': imageSlder.imageURL.toString(),
                              };

                              FirebaseFirestore.instance
                                  .collection('slider_images')
                                  .add(addProduct);
                              print(
                                  'The url image must be this: ${imageSlder.imageURL}');
                              print("added to te firestoer");
                            } catch (err) {
                              print(err);
                            }
                          }
                        });
                        isloading = false;
                        setState(() {
                          showSnack('Added to ..  sliderimges');
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
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.amber,
                                    color: Colors.white,
                                  )
                                : Text(
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
                        // clearControlers();
                      },
                      child: Text(
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

class UploadSliderImage extends ChangeNotifier {
  File? _image;
  String? _imageUrl;

  File? get image => _image;
  String? get imageUrl => _imageUrl;
  String? imageURL;
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      uploadImageToFirebase();
      notifyListeners();
      // if (croppedImage != null) {
      //   _image = croppedImage;

      // }
    }
  }

  Future<void> uploadImageToFirebase() async {

    // collaction of customer
    // final custCollection = FirebaseFirestore.instance.collection("productdb");
    if (_image != null) {
      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.png');
        UploadTask uploadTask = storageReference.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        // _imageUrl = downloadUrl;

        //  // await custCollection
        //       .doc(currentUser!.uid)
        //       .set({'imageUrl': downloadUrl});

        notifyListeners();
        print('Image uploaded. Download URL: $downloadUrl');

        // Store the image URL in the "profile_image" collection in Firestore
        // FirebaseFirestore.instance.collection('imgProfileCustomer').add({
        //   'image_url': downloadUrl,
        //   'timestamp': FieldValue.serverTimestamp(),
        // });
        imageURL = downloadUrl;
        //   return downloadUrl;
        print('Image URL stored in Firestore');
      } catch (error) {
        // Handle any errors that occur during image upload
        print('Image upload failed. Error: $error');
      }
    } else {
      print('No image selected');
    }
  }

//  Future<CroppedFile?> _cropImage(File imageFile) async {
//     final croppedFile = await ImageCropper().cropImage(
//         sourcePath: imageFile.path,
//         aspectRatioPresets: Platform.isAndroid
//             ? [
//                 CropAspectRatioPreset.square,
//                 CropAspectRatioPreset.original,
//                 CropAspectRatioPreset.ratio3x2,
//                 CropAspectRatioPreset.ratio4x3,
//                 CropAspectRatioPreset.ratio16x9
//               ]
//             : [
//                 CropAspectRatioPreset.original,
//                 CropAspectRatioPreset.square,
//                 CropAspectRatioPreset.ratio16x9,
//                 CropAspectRatioPreset.ratio3x2,
//                 CropAspectRatioPreset.ratio5x3,
//                 CropAspectRatioPreset.ratio4x3,
//                 CropAspectRatioPreset.ratio7x5,
//               ],
//         uiSettings: [
//           AndroidUiSettings(
//               toolbarTitle: "Image Cropper",
//               toolbarColor: Colors.orange,
//               toolbarWidgetColor: Colors.white,
//               initAspectRatio: CropAspectRatioPreset.original,
//               lockAspectRatio: false),
//           IOSUiSettings(
//             title: "Image Corpper",
//           )
//         ]);

//     return croppedFile;
//   }
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
