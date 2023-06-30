import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_management_system/admin/screens/addproduct.dart';

import '../exports.dart';
import '../pages/login.dart';
import 'screens/create_users.dart';
import 'screens/users.dart';
import 'widgets/custom_button.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _totolUsersAdmins = 0;
  int _totolcustomers = 0;
  int allusers = 0;
  int _totalProducts = 0;
  int _totalpendingOrders = 0;
  bool isloading = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<int> _totalCustomerUsers() async {
    QuerySnapshot querySnapshot = await firestore.collection('customers').get();
    int totalusers = querySnapshot.docs.length;
    _totolcustomers = totalusers;
    setState(() {});
    return totalusers;
  }

  Future<int> _totalUsersStaffs() async {
    QuerySnapshot querySnapshot = await firestore.collection('users').get();
    int totalusers = querySnapshot.docs.length;

    _totolUsersAdmins = totalusers;
    setState(() {});
    return totalusers;
  }

  Future<int> _totalProdcuts() async {
    QuerySnapshot querySnapshot = await firestore.collection('productdb').get();
    int totalproducts = querySnapshot.docs.length;
    print('The total totalproducts :  $totalproducts');
    _totalProducts = totalproducts;
    setState(() {});
    return totalproducts;
  }

  Future<int> _totalPendingOrders() async {
    QuerySnapshot querySnapshot =
        await firestore.collection('cart_orders').get();
    int totalpending = querySnapshot.docs.length;
    _totalpendingOrders = totalpending;
    print('The total of  pending orders:  $_totalpendingOrders');
    setState(() {});
    return totalpending;
  }

  // Future waiting() async {
  //   await Future.delayed(const Duration(seconds: 3));
  // }
  @override
  void initState() {
    super.initState();
    _totalCustomerUsers();
    _totalUsersStaffs();
    _totalProdcuts();
    _totalPendingOrders();

    //Future.delayed(Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    allusers = _totolUsersAdmins + _totolcustomers;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Addmin Dashboard"),
          centerTitle: true,
          leading: IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginPage()));
              },
              icon: const Icon(Icons.exit_to_app)),
        ),
        body: ListView(
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const Image(
                              image: AssetImage("assets/shuceyb.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          userData['role'],
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

//  _totolUsersAdmins = 0;
//    _totolcustomers = 0;
//    allusers = 0;
//   _totalProducts = 0;
//   _totalpendingOrders = 0;

                    // _totalCustomerUsers();

                    print('the tolal users are: $_totalpendingOrders');
                  },
                  title: 'Users',
                  no: '$allusers',
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
                  title: 'Products',
                  no: '$_totalProducts',
                ),
                const SizedBox(width: 10),
                Admin_controlers(
                  no: '\$140',
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
                    print('the total pendig orders are:  $_totalpendingOrders');
                    // totalPendingOrders();
                  },
                  title: 'Pending order',
                  no: '$_totalpendingOrders',
                ),
                const SizedBox(width: 10),
                Admin_controlers(
                  no: '0',
                  onPressed: () {},
                  title: 'Delivery Order',
                ),
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
