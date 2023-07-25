// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_management_system/admin/screens/earning.dart';
// import 'package:laundry_order_app/satff/screens/staff_dashboard.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../exports.dart';
import '../utility/menu_par.dart';
import 'screens/completed_view.dart';
import 'screens/create_users.dart';
import 'screens/delivered_view.dart';
import 'screens/ongoing_view.dart';
import 'screens/pending_view.dart';
import 'screens/productview.dart';
import 'screens/users.dart';
import 'widgets/custom_button.dart';

class AdminUser extends ChangeNotifier {
  int _totolUsersAdmins = 0;
  int _totolcustomers = 0;
  double _totalAmount = 0;
  int allusers = 0;
  int _totalProducts = 0;
  // final int _totalproductdb = 0;
  final int _totalironclothes = 0;

  int _totalpendingOrders = 0;
  int _deliveredOrder = 0;
  int _completeOrders = 0;
  int _ongoingOrders = 0;

  int get totolUsersAdmins => _totolUsersAdmins;
  int get totolcustomers => _totolcustomers;
  // int get allusers => _allusers;
  int get totalProducts => _totalProducts;
  double get totalAmount => _totalAmount;
  // int get totalproductdb => _totalproductdb;
  int get totalironclothes => _totalironclothes;

  int get totalpendingOrders => _totalpendingOrders;
  int get deliveredOrder => _deliveredOrder;
  int get completeOrders => _completeOrders;
  int get ongoingOrders => _ongoingOrders;

  void addAmount(int newAmount) {
    _totalAmount += newAmount;
    notifyListeners();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _totalAmountTranssection() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('successful_payments')
        .get();
    double totalAmount = 0;

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic>? paymentData =
          documentSnapshot.data() as Map<String, dynamic>?;
      // double amount = paymentData?['amount'] ?? 0.0;
      double amount = paymentData?['amount']?.toDouble() ?? 0.0;
      // Default to 0 if 'amount' is not found or null.

      totalAmount += amount;
    }

    _totalAmount = totalAmount;
    notifyListeners();
  }

  Future<void> _stafftotalCustomers() async {
    QuerySnapshot querySnapshot = await firestore.collection('customers').get();
    _totolcustomers = querySnapshot.docs.length;
    notifyListeners();
  }

  Future<void> _totalUsersStaffs() async {
    QuerySnapshot querySnapshot = await firestore.collection('users').get();

    _totolUsersAdmins = querySnapshot.docs.length;
    notifyListeners();
  }

  Future<void> _totalProdcuts() async {
    QuerySnapshot querySnapshot1 = await firestore.collection('laundry').get();
    int totalproductdb = querySnapshot1.docs.length;

    QuerySnapshot querySnapshot2 =
        await firestore.collection('ironOrders').get();
    int totalironclothes = querySnapshot2.docs.length;

    QuerySnapshot querySnapshot3 =
        await firestore.collection('suitorder').get();
    int totalsuitsdb = querySnapshot3.docs.length;

    QuerySnapshot querySnapshot4 =
        await firestore.collection('washIronOrder').get();
    int totalWashandIron = querySnapshot4.docs.length;

    _totalProducts =
        totalproductdb + totalironclothes + totalsuitsdb + totalWashandIron;
    notifyListeners();
  }

  Future<void> _totalPendingOrders() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('cart_orders')
        .where('orderstatus', isEqualTo: '')
        .get();
    _totalpendingOrders = querySnapshot.docs.length;
    notifyListeners();
  }

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

  Future<void> _completeOrder() async {
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
    _completeOrders = querySnapshot.docs.length;
    notifyListeners();
  }

  Future<void> _getearnedMoney() async {
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

  Future<void> fetchData() async {
    // await _totalCustomerUsers();
    await _totalUsersStaffs();
    await _stafftotalCustomers();
    await _totalAmountTranssection();
    await _totalProdcuts();
    await _totalPendingOrders();
    await _deliveredOrders();
    await _ongoingOrder();
    await _completeOrder();
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool isloading = false;
  @override
  void initState() {
    super.initState();

    Provider.of<AdminUser>(context, listen: false).fetchData();
    //Future.delayed(Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    final imgProfile = Provider.of<UserProfileAdmin>(context);
    final adminAccess = Provider.of<AdminUser>(context);

    adminAccess.allusers =
        adminAccess.totolUsersAdmins + adminAccess.totolcustomers;
    User? currentUser = FirebaseAuth.instance.currentUser;
    adminAccess._completeOrder();
    adminAccess._totalUsersStaffs();
    adminAccess._totalAmountTranssection();
    adminAccess._stafftotalCustomers();
    adminAccess._totalProdcuts();
    adminAccess._totalPendingOrders();
    adminAccess._ongoingOrder();
    adminAccess._deliveredOrders();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Dashboard"),
          centerTitle: true,
          actions: [
            IconButton(
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
          ],
        ),
        drawer: Drawer(
            width: 250,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ProfilePage()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 265,
                    decoration: const BoxDecoration(
                      color: Kactivecolor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            // shape: BoxShape.circle,
                            // image: DecorationImage(
                            //     fit: BoxFit.cover,
                            //     image:
                            //         CachedNetworkImageProvider(imageUrl)),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'currentUser.email!',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                              letterSpacing: 2),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'currentUser.email!',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                drawerList(
                    icon: Icons.history,
                    text: 'Create User',
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignUpScreen()));
                    }),
                const SizedBox(
                  height: 30,
                ),
                drawerList(
                    icon: Icons.person,
                    text: 'Users View',
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const UsersButton()));
                    }),
                const SizedBox(
                  height: 30,
                ),
                drawerList(
                    icon: MdiIcons.cartVariant,
                    text: 'Add Products',
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const UsersButton()));
                    }),
                const Spacer(),
                drawerList(
                    icon: Icons.logout,
                    text: 'Logout',
                    ontap: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                      } catch (e) {
                        print('Signout Erro$e');
                      }
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (_) => const LoginPage()));
                      // },
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const LoginPage(),
                          ),
                          (route) => false);
                    }),
                const SizedBox(
                  height: 30,
                ),
              ],
            )),
        body: ListView(
          children: [
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
                        imgProfile.image != null
                            ? GestureDetector(
                                onTap: () {
                                  showBottomSheet(
                                      context: context,
                                      builder: (Builder) {
                                        return Card(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                      if (statUser[Permission
                                                              .camera]!
                                                          .isGranted) {
                                                        imgProfile.pickImage(
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
                                                      if (statUser[Permission
                                                              .storage]!
                                                          .isGranted) {
                                                        imgProfile.pickImage(
                                                            ImageSource
                                                                .gallery);

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
                                              image: FileImage(
                                                  imgProfile.image!))),
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                      if (statUser[Permission
                                                              .camera]!
                                                          .isGranted) {
                                                        imgProfile.pickImage(
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
                                                      if (statUser[Permission
                                                              .storage]!
                                                          .isGranted) {
                                                        imgProfile.pickImage(
                                                            ImageSource
                                                                .gallery);
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                        CustomButtom(
                          onPressed: () {},
                        )
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
                          builder: (ctx) => const UsersButton(),
                        ));

                    //print('the tolal users are: $_totalpendingOrders');
                  },
                  title: 'Users',
                  no: adminAccess.allusers.toString(),
                ),
                const SizedBox(width: 10),
                Admin_controlers(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AdminProductView()));

                    // totalProdcuts();
                  },
                  title: 'products',
                  no: adminAccess._totalProducts.toString(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Admin_controlers(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const PendingView()));
                  },
                  title: 'Pending order',
                  no: adminAccess.totalpendingOrders.toString(),
                ),
                const SizedBox(width: 10),
                Admin_controlers(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const OngoingView()));

                    // totalProdcuts();
                  },
                  title: 'Ongoing order',
                  no: adminAccess._ongoingOrders.toString(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Admin_controlers(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CompletedView()));
                  },
                  title: 'Completed Order',
                  no: adminAccess.completeOrders.toString(),
                ),
                const SizedBox(width: 10),
                Admin_controlers(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DeliveredView()));
                  },
                  title: 'Delivered order',
                  no: adminAccess._deliveredOrder.toString(),
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
                    no: adminAccess.totalAmount.toStringAsFixed(2),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const transactionPaymentsStsff()));
                    },
                    title: 'Earning',
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
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
        decoration: const BoxDecoration(color: Kactivecolor),
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

class UserProfileAdmin extends ChangeNotifier {
  File? _image;
  String? _imageUrl;

  File? get image => _image;
  String? get imageUrl => _imageUrl;

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
