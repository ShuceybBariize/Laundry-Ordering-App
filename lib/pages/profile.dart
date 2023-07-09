import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart' show Provider;

import '../exports.dart';
import '../utility/profile_textbox.dart';

class ImageProfile extends ChangeNotifier {
  File? _image;
  String? _imageUrl;

  File? get image => _image;
  String? get imageUrl => _imageUrl;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      File? croppedImage = await _cropImage(File(pickedFile.path));
      // _image = File(pickedFile.path);
      if (croppedImage != null) {
        _image = croppedImage;
        uploadImageToFirebase();
        notifyListeners();
      }
    }
  }

  Future<void> uploadImageToFirebase() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    // collaction of customer
    final custCollection = FirebaseFirestore.instance.collection("customers");
    if (_image != null) {
      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.png');
        UploadTask uploadTask = storageReference.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        // _imageUrl = downloadUrl;

        await custCollection
            .doc(currentUser!.uid)
            .update({'image': downloadUrl});

        notifyListeners();
        print('Image uploaded. Download URL: $downloadUrl');

        // Store the image URL in the "profile_image" collection in Firestore
        // FirebaseFirestore.instance.collection('imgProfileCustomer').add({
        //   'image_url': downloadUrl,
        //   'timestamp': FieldValue.serverTimestamp(),
        // });
        print('Image URL stored in Firestore');
      } catch (error) {
        // Handle any errors that occur during image upload
        print('Image upload failed. Error: $error');
      }
    } else {
      print('No image selected');
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    File? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio16x9,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio7x5,
            ],
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Crop Image',
      ),
    );

    return croppedFile;
  }
}

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  //CurrentUser
  final currentUser = FirebaseAuth.instance.currentUser!;

  // collaction of customer
  final custCollection = FirebaseFirestore.instance.collection("customers");

  //edit field
  // ProfileModel profileModel = ProfileModel();

  @override
  Widget build(BuildContext context) {
    final ImgProfile = Provider.of<ImageProfile>(context);
    Future<void> editField(String field) async {
      String newValue = "";
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            "Edit $field",
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: const TextStyle(color: Colors.grey),
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
        await custCollection.doc(currentUser.uid).update({field: newValue});
      }
    }

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(title: const Text("Profile Page")),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("customers")
              .doc(currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  ImgProfile.image != null
                      //  Image.file(ImgProfile.image!)

                      ? GestureDetector(
                          onTap: () {
                            showBottomSheet(
                                context: context,
                                builder: (Builder) {
                                  return Card(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5.2,
                                      margin: const EdgeInsets.only(top: 12),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                ],
                                              ),
                                              onTap: () async {
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statUser = await [
                                                  Permission.camera,
                                                ].request();
                                                if (statUser[Permission.camera]!
                                                    .isGranted) {
                                                  ImgProfile.pickImage(
                                                      ImageSource.camera);
                                                  Navigator.pop(context);
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
                                                ],
                                              ),
                                              onTap: () async {
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statUser = await [
                                                  Permission.storage,
                                                ].request();
                                                if (statUser[
                                                        Permission.storage]!
                                                    .isGranted) {
                                                  ImgProfile.pickImage(
                                                      ImageSource.gallery);

                                                  Navigator.pop(context);
                                                } else {
                                                  print(
                                                      "no Permission GALLERY");
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 170,
                                width: 170,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(ImgProfile.image!))),
                              )
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            showBottomSheet(
                                context: context,
                                builder: (Builder) {
                                  return Card(
                                    color: Colors.grey.shade100,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5.2,
                                      margin: const EdgeInsets.only(top: 12),
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    style:
                                                        TextStyle(fontSize: 19),
                                                  ),
                                                ],
                                              ),
                                              onTap: () async {
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statUser = await [
                                                  Permission.camera,
                                                ].request();
                                                if (statUser[Permission.camera]!
                                                    .isGranted) {
                                                  ImgProfile.pickImage(
                                                      ImageSource.camera);

                                                  Navigator.pop(context);
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
                                                    style:
                                                        TextStyle(fontSize: 19),
                                                  ),
                                                ],
                                              ),
                                              onTap: () async {
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statUser = await [
                                                  Permission.storage,
                                                ].request();
                                                if (statUser[
                                                        Permission.storage]!
                                                    .isGranted) {
                                                  ImgProfile.pickImage(
                                                      ImageSource.gallery);
                                                  Navigator.pop(context);
                                                } else {
                                                  print(
                                                      "no Permission GALLERY");
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: CircleAvatar(
                            radius: 120,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 110,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  NetworkImage(userData['image'].toString()),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ],
                              ),
                              // child:
                              // CachedNetworkImage(
                              //   imageUrl: userData['image'].toString(),
                              //   placeholder: (context, url) =>
                              //       CircularProgressIndicator(),
                              //   errorWidget: (context, url, error) =>
                              //       Icon(Icons.error),
                              // ),
                            ),
                          ),
                        ),
                  //Profile Picture

                  const SizedBox(height: 10),
                  // user email
                  Text(
                    ' ${currentUser.email!}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 50),

                  // user detials
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

                  //username
                  MyTextBox(
                    text: userData['name']!,
                    sectionName: 'fullname',
                    onPressed: () => editField('name'),
                  ),
                  // bio
                  MyTextBox(
                    text: userData['phone']!,
                    sectionName: 'phone',
                    onPressed: () => editField('phone'),
                  ),
                  const SizedBox(height: 50),
                  //user posts
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "my post",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error})'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

// class ProfileModel {
//   int? phone;
//   String? name;

//   ProfileModel({
//     this.phone,
//     this.name,
//   });

//   ProfileModel.fromJson(Map<String, dynamic> json) {
//     phone = json['id'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': phone,
//       'name': name,
//     };
//   }
// }

// class StrogeMethods {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   //Adding image to firebase storage
//   Future<String> uploadImageToStorage(String childName, Uint8List file) async {
//     Reference ref =
//         _storage.ref().child(childName).child(_auth.currentUser!.uid);
//     UploadTask uploadTask = ref.putData(file);
//     TaskSnapshot snapshot = await uploadTask;
//     String downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
//   }
// }
