// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_management_system/admin/screens/create_users.dart';
import 'package:laundry_management_system/admin/screens/users.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../addproduct.dart';
import '../exports.dart';
import 'screens/delivered_view.dart';
import 'screens/ongoing_view.dart';
import 'screens/pending_view.dart';
import 'screens/productview.dart';
import 'widgets/custom_button.dart';

class AdminUser extends ChangeNotifier {
  int _totolUsersAdmins = 0;
  int _totolcustomers = 0;
  int allusers = 0;
  int _totalProducts = 0;
  final int _totalproductdb = 0;
  int _totalironclothes = 0;
  int _totalpendingOrders = 0;
  int _deliveredOrder = 0;
  int _completeOrders = 0;
  int _ongoingOrders = 0;

  int get totolUsersAdmins => _totolUsersAdmins;
  int get totolcustomers => _totolcustomers;
  // int get allusers => _allusers;
  int get totalProducts => _totalProducts;
  int get totalproductdb => _totalproductdb;
  int get totalironclothes => _totalironclothes;
  int get totalpendingOrders => _totalpendingOrders;
  int get deliveredOrder => _deliveredOrder;
  int get completeOrders => _completeOrders;
  int get ongoingOrders => _ongoingOrders;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
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
    QuerySnapshot querySnapshot1 =
        await firestore.collection('suitorder').get();
    int totalsuitclothdb = querySnapshot1.docs.length;
    _totalironclothes = totalsuitclothdb;
    QuerySnapshot querySnapshot2 =
        await firestore.collection('wash_iron_Oders').get();
    int totalwashironclothdb = querySnapshot1.docs.length;
    _totalironclothes = totalwashironclothdb;
    QuerySnapshot querySnapshot3 =
        await firestore.collection('ironOrders').get();
    int totalironclothdb = querySnapshot1.docs.length;
    _totalironclothes = totalironclothdb;
    QuerySnapshot querySnapshot = await firestore.collection('laundry').get();
    int totalproductdb = querySnapshot.docs.length;
    _totalProducts = totalproductdb + totalironclothdb;
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
    await _totalProdcuts();
    await _totalPendingOrders();
    await _deliveredOrders();
    await _ongoingOrder();
    await _CompleteOrder();
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Future waiting() async {
  //   await Future.delayed(const Duration(seconds: 3));
  // }
  bool isloading = false;
  @override
  void initState() {
    super.initState();

    Provider.of<AdminUser>(context, listen: false).fetchData();
    //Future.delayed(Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    final ImgProfile = Provider.of<UserProfile>(context);
    final adminAccess = Provider.of<AdminUser>(context);

    final currentUser = FirebaseAuth.instance.currentUser;
    adminAccess.allusers =
        adminAccess.totolUsersAdmins + adminAccess.totolcustomers;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Dashboard"),
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
                        ImgProfile.image != null
                            //  Image.file(ImgProfile.image!)

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
                                                      if (statUser[Permission
                                                              .storage]!
                                                          .isGranted) {
                                                        ImgProfile.pickImage(
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
                                          border: Border.all(
                                              width: 4, color: Kactivecolor),
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(
                                                  ImgProfile.image!))),
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
                                                      if (statUser[Permission
                                                              .storage]!
                                                          .isGranted) {
                                                        ImgProfile.pickImage(
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
                                  height: 170,
                                  width: 170,
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.red, width: 1),
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Kactivecolor,
                                    child: CircleAvatar(
                                      radius: 80,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          AssetImage("assets/profile.png"),
                                      child: Column(
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

                    print(adminAccess._totalpendingOrders.toString());
                  },
                  title: 'Users',
                  no: adminAccess.allusers.toString(),
                ),
                const SizedBox(width: 10),
                Admin_controlers(
                  no: '',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignUpScreen()));
                  },
                  title: 'Creat user',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Admin_controlers(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const AddProduct()));

                    // totalProdcuts();
                  },
                  title: 'add products',
                  no: '',
                ),
                const SizedBox(width: 10),
                Admin_controlers(
                  no: '\$140',
                  onPressed: () {
                    adminAccess._getearnedMoney();
                  },
                  title: 'Earning',
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
                            builder: (_) => const AdminProductView()));

                    // totalProdcuts();
                  },
                  title: 'products',
                  no: adminAccess.totalProducts.toString(),
                ),
                const SizedBox(width: 10),
                Admin_controlers(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const PendingView()));
                  },
                  title: 'Pending order',
                  no: adminAccess.totalpendingOrders.toString(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Admin_controlers(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const OngoingView()));

                    // totalProdcuts();
                  },
                  title: 'Ongoing order',
                  no: adminAccess.ongoingOrders.toString(),
                ),
                const SizedBox(width: 10),
                Admin_controlers(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CompleteOrders()));
                  },
                  title: 'Completed order',
                  no: adminAccess.completeOrders.toString(),
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
                    no: adminAccess.deliveredOrder.toString(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DeliveredView()));
                    },
                    title: 'Delivered  order',
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
