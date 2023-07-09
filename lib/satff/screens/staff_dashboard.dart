import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_management_system/satff/screens/pendingorder.dart';
import 'package:laundry_management_system/satff/screens/productsView.dart';
import 'package:laundry_management_system/satff/screens/staffuserview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../exports.dart';
import '../../pages/login.dart';
import 'completeorder.dart';
import 'deliveredorder.dart';
import 'ongoingorders.dart';

class StaffUser extends ChangeNotifier {
  int _totolcustomers = 0;
  int _totalProducts = 0;
  final int _totalproductdb = 0;
  int _totalironclothes = 0;
  int _totalpendingOrders = 0;
  int _ongoingOrders = 0;
  int _completeOrder = 0;
  int _deliveredOrder = 0;

  int get totolcustomers => _totolcustomers;
  int get totalProducts => _totalProducts;
  int get totalironclothes => _totalironclothes;
  int get totalproductdb => _totalproductdb;
  int get totalpendingOrders => _totalpendingOrders;
  int get ongoingOrders => _ongoingOrders;
  int get completeOrder => _completeOrder;
  int get deliveredOrder => _deliveredOrder;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> _stafftotalCustomers() async {
    QuerySnapshot querySnapshot = await firestore.collection('customers').get();
    _totolcustomers = querySnapshot.docs.length;
    notifyListeners();
  }

  Future<void> _stafftotalProdcuts() async {
    QuerySnapshot querySnapshot1 =
        await firestore.collection('ironclothes').get();
    int totalironclothdb = querySnapshot1.docs.length;
    _totalironclothes = totalironclothdb;
    QuerySnapshot querySnapshot = await firestore.collection('productdb').get();
    int totalproductdb = querySnapshot.docs.length;
    _totalProducts = totalproductdb + totalironclothdb;
    notifyListeners();
  }

  Future<void> _staffftotalPendingOrders() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('cart_orders')
        .where('orderstatus', isEqualTo: '')
        .get();
    _totalpendingOrders = querySnapshot.docs.length;
    notifyListeners();
  }

//Ongoing order
  Future<void> _ongoingOrder() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('cart_orders')
        .where('orderstatus', whereIn: [
      'O',
      'o',
      'On',
      'on',
      'ongoing',
      'Ongoing',
      'ongo',
      'Ongo',
    ]).get();
    _ongoingOrders = querySnapshot.docs.length;
    notifyListeners();
  }

  // complete order
  Future<void> _CompleteOrder() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('cart_orders')
        .where('orderstatus', whereIn: [
      'Com',
      'com',
      'completed',
      'Completed',
      'complete',
      'Complete',
      'c',
      'C',
      'Comp',
      'comp'
    ]).get();
    _completeOrder = querySnapshot.docs.length;
    notifyListeners();
  }

  //delivered orders

  Future<void> _deliveredOrders() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('cart_orders')
        .where('orderstatus', whereIn: [
      'delivered',
      'Delivered',
      'deliver',
      'del',
      'Del',
      'D',
      'd',
      'Deliver',
    ]).get();
    _deliveredOrder = querySnapshot.docs.length;
    notifyListeners();
  }

  // Future waiting() async {
  //   await Future.delayed(const Duration(seconds: 3));
  // }
  Future<void> fetchData() async {
    await _stafftotalCustomers();
    await _stafftotalProdcuts();
    await _staffftotalPendingOrders();
    await _ongoingOrder();
    await _CompleteOrder();
    await _deliveredOrders();
  }
}

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  @override
  void initState() {
    super.initState();
    Provider.of<StaffUser>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final ImgProfile = Provider.of<UserProfile>(context);
    final staff = Provider.of<StaffUser>(context);

    final currentUser = FirebaseAuth.instance.currentUser;
    // totalusers = totolusers + totolcustomers;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Staff Dashboard"),
          centerTitle: true,
          leading: IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const LoginPage(),
                    ),
                    (route) => false);
              },
              icon: const Icon(Icons.exit_to_app)),
        ),
        body: ListView(children: [
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5.2,
                                          margin:
                                              const EdgeInsets.only(top: 12),
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
                                                        Icons
                                                            .camera_alt_outlined,
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
                                                    if (statUser[
                                                            Permission.camera]!
                                                        .isGranted) {
                                                      ImgProfile.pickImage(
                                                          ImageSource.camera);
                                                      Navigator.pop(context);
                                                    } else {
                                                      print(
                                                          "no Permission CAMERA");
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
                                            image:
                                                FileImage(ImgProfile.image!))),
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5.2,
                                          margin:
                                              const EdgeInsets.only(top: 12),
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
                                                        Icons
                                                            .camera_alt_outlined,
                                                        size: 60,
                                                      ),
                                                      SizedBox(
                                                        height: 12,
                                                      ),
                                                      Text(
                                                        "Camera",
                                                        style: TextStyle(
                                                            fontSize: 19),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    Map<Permission,
                                                            PermissionStatus>
                                                        statUser = await [
                                                      Permission.camera,
                                                    ].request();
                                                    if (statUser[
                                                            Permission.camera]!
                                                        .isGranted) {
                                                      ImgProfile.pickImage(
                                                          ImageSource.camera);

                                                      Navigator.pop(context);
                                                    } else {
                                                      print(
                                                          "no Permission CAMERA");
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
                                                        style: TextStyle(
                                                            fontSize: 19),
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
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.red, width: 1),
                                  borderRadius: BorderRadius.circular(360),
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.black,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(
                                        userData['image'].toString(),
                                        scale: 1.2),
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
                                  ),
                                ),
                              ),
                            ),
                      Text(
                        '${userData['role']} role',
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        currentUser.email!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 5,
                        width: 400,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error ${snapshot.error})'),
                  );
                }
                return const CircularProgressIndicator();
              }),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Admin_controlers(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const UserStaffScreen(),
                      ));
                },
                title: 'Users',
                no: staff.totolcustomers.toString(),
              ),
              const SizedBox(width: 10),
              Admin_controlers(
                no: '\$6',
                onPressed: () {},
                title: 'Earning',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Admin_controlers(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProductView()));
                },
                title: 'Products',
                no: staff.totalProducts.toString(),
              ),
              const SizedBox(width: 10),
              Admin_controlers(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PendingOrder()));
                },
                title: 'Pending order',
                no: staff.totalpendingOrders.toString(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Admin_controlers(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const OgoingOrders()));
                },
                title: 'Ongoing order',
                no: staff.ongoingOrders.toString(),
              ),
              const SizedBox(width: 10),
              Admin_controlers(
                no: staff.completeOrder.toString(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CompleteOrders()));
                },
                title: 'Complete Order',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: 350,
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(3, -4),
                      spreadRadius: 6,
                      blurRadius: 38,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ],
                ),
                child: Admin_controlers(
                  no: staff.deliveredOrder.toString(),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DeliveredOrders()));
                  },
                  title: 'Delivered  order',
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ]),
      ),
    );
  }
}

class Admin_controlers extends StatelessWidget {
  final String? no;
  final String title;
  final Function() onPressed;
  const Admin_controlers({
    super.key,
    required this.title,
    required this.onPressed,
    this.no,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(5.5),
        width: 180,
        height: 160,
        decoration: const BoxDecoration(color: Colors.orangeAccent),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$no',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfile extends ChangeNotifier {
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
    final custCollection = FirebaseFirestore.instance.collection("users");
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
