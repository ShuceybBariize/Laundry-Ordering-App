// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_management_system/admin/screens/addproduct.dart';
import 'package:laundry_management_system/admin/screens/create_users.dart';
import 'package:laundry_management_system/admin/screens/delivered_view.dart';
import 'package:laundry_management_system/admin/screens/ongoing_view.dart';
import 'package:laundry_management_system/admin/screens/pending_view.dart';
import 'package:laundry_management_system/admin/screens/productview.dart';
import 'package:laundry_management_system/admin/screens/users.dart';
import 'package:laundry_management_system/admin/widgets/custom_button.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../exports.dart';
import '../pages/login.dart';
import '../satff/screens/completeorder.dart';
import '../satff/screens/staff_dashboard.dart';

class TotalPending extends ChangeNotifier {
  int _totolUsersAdmins = 0;
  int _totolcustomers = 0;
  int allusers = 0;
  int _totalProducts = 0;
  int totalproductdb = 0;
  int totalironclothes = 0;
  int _totalpendingOrders = 0;
  int _deliveredOrder = 0;
  int _completeOrders = 0;
  int _ongoingOrders = 0;
  bool isloading = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<int> _totalCustomerUsers() async {
    QuerySnapshot querySnapshot = await firestore.collection('customers').get();
    int totalusers = querySnapshot.docs.length;
    _totolcustomers = totalusers;

    notifyListeners();
    return totalusers;
  }

  Future<int> _totalUsersStaffs() async {
    QuerySnapshot querySnapshot = await firestore.collection('users').get();
    int totalusers = querySnapshot.docs.length;

    _totolUsersAdmins = totalusers;

    notifyListeners();
    return totalusers;
  }

  Future<int> _totalProdcuts() async {
    QuerySnapshot querySnapshot1 =
        await firestore.collection('ironOrders').get();
    int totalironclothdb = querySnapshot1.docs.length;
    // print('The total Customers users:  $totalusers');
    totalironclothes = totalironclothdb;
    QuerySnapshot querySnapshot = await firestore.collection('laundry').get();
    int totalproductdb = querySnapshot.docs.length;
    // print('The total Customers users:  $totalusers');
    totalproductdb = totalproductdb;
    _totalProducts = totalproductdb + totalironclothdb;

    //print('the total products of collections are:  $totalProducts');

    notifyListeners();
    return _totalProducts;
  }

  Future<int> _totalPendingOrders() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('cart_orders')
        .where('orderstatus', isEqualTo: '')
        .get();
    int totalpending = querySnapshot.docs.length;
    _totalpendingOrders = totalpending;
    //print('The total of  pending orders:  $_totalpendingOrders');

    notifyListeners();
    return totalpending;
  }

  Future<int> _deliveredOrders() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('cart_orders')
        .where('orderstatus', whereIn: [
      'delivered',
      'Delivered',
      'deliver',
      'Deliver',
      'del',
      'Del',
      'd',
      'D',
    ]).get();
    int totaldelivered = querySnapshot.docs.length;
    _deliveredOrder = totaldelivered;
    notifyListeners();
    return totaldelivered;
  }

  Future<int> _ongoingOrder() async {
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
    int totalongoing = querySnapshot.docs.length;
    _ongoingOrders = totalongoing;

    notifyListeners();
    return totalongoing;
  }

  Future<int> _completeOrder() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('cart_orders')
        .where('orderstatus', whereIn: [
      'Com',
      'com',
      'complete',
      'Complete',
      'completed',
      'Completed',
      'c',
      'C',
      'Comp',
      'comp'
    ]).get();
    int totalcomplete = querySnapshot.docs.length;

    _completeOrders = totalcomplete;
    // print('The total of  pending orders:  $completeOrder');

    notifyListeners();
    return totalcomplete;
  }

  double totalmoney = 0.0;
  Future<double> _getearnedMoney() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('cart_orders')
        .where('orderstatus', whereIn: [
      'delivered',
      'Delivered',
      'deliver',
      'Deliver',
      'del',
      'Del',
      'd',
      'D',
    ]).get();
    //int totalcomplete = querySnapshot.docs.length;

    //  _completeOrders = totalcomplete;
    // print('The total of  pending orders:  $completeOrder');

    List<double> totalvalue = [];

    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        dynamic fieldValue = documentSnapshot.get('Total');
        totalvalue.add(fieldValue);
        totalmoney = totalmoney + fieldValue;
      }
    }
    print('total money of completed delivery are:  $totalmoney');
    return totalmoney;
  }

  // Future waiting() async {
  //   await Future.delayed(const Duration(seconds: 3));
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   _totalCustomerUsers();
  //   _totalUsersStaffs();
  //   _totalProdcuts();
  //   _totalPendingOrders();
  //   _deliveredOrders();
  //   _ongoingOrder();
  //   _completeOrder();

  //   notifyListeners();
  //   //Future.delayed(Duration(seconds: 5));
  // }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final ImgProfile = Provider.of<UserProfile>(context);
    final totalPending = Provider.of<TotalPending>(context);
    totalPending._totalCustomerUsers();
    totalPending._totalUsersStaffs();
    totalPending._totalProdcuts();
    totalPending._totalPendingOrders();
    totalPending._deliveredOrders();
    totalPending._ongoingOrder();
    totalPending._completeOrder();

    final currentUser = FirebaseAuth.instance.currentUser;
    totalPending.allusers =
        totalPending._totolUsersAdmins + totalPending._totolcustomers;
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
                                                    child: Column(
                                                      children: const [
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
                                                    child: Column(
                                                      children: const [
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
                                                    child: Column(
                                                      children: const [
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
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: const [
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

                    print(
                        'the tolal users are: $totalPending._totalpendingOrders');
                  },
                  title: 'Users',
                  no: '$totalPending.allusers',
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AddProductForm()));

                    // totalProdcuts();
                  },
                  title: 'add products',
                  no: '',
                ),
                const SizedBox(width: 10),
                Admin_controlers(
                  no: '\$140',
                  onPressed: () {
                    // setState(() {
                    totalPending._getearnedMoney();
                    // });
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
                  no: '$totalPending._totalProducts',
                ),
                const SizedBox(width: 10),
                Admin_controlers(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const PendingView()));
                  },
                  title: 'Pending order',
                  no: '$totalPending._totalpendingOrders',
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
                  no: ' $totalPending._ongoingOrders',
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
                  no: '$totalPending._completeOrders',
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
                    no: '$totalPending._deliveredOrder',
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
