import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminStafsUserview extends StatefulWidget {
  const AdminStafsUserview({super.key});

  @override
  State<AdminStafsUserview> createState() => _AdminStafsUserviewState();
}

class _AdminStafsUserviewState extends State<AdminStafsUserview> {
  String getInitials(String user) => user.isNotEmpty
      ? user.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  // ignore: unused_field
  List<User> _searchResults = [];

  Future<void> searchUsers(String query) async {
    final QuerySnapshot usersSnapshot = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    setState(() {
      _searchResults = usersSnapshot.docs
          .map((doc) =>
              User(name: doc['name'] as String, email: doc['email'] as String))
          .toList();
    });
  }

  // here is function to get docid
  String? documentid;
  Future<void> getdocid(String name) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot =
          await collectionRef.where('name', isEqualTo: name).get();
      for (var doc in querySnapshot.docs) {
        documentid = doc.id;
        //print('Document ID: ${doc.id}');
        //  print('Documentid waa : $documentid');
        setState(() {});
      }
    } on FirebaseAuthException catch (e) {
      print('The erro waa: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final FirebaseAuth auth = FirebaseAuth.instance;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Card(
              child: TextField(
            controller: _searchController,
            onChanged: (value) => searchUsers(value),
            decoration: const InputDecoration(
                hintText: "searching....", prefixIcon: Icon(Icons.search)),
          )),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where('role', whereIn: ['admin', 'staff']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("ERROR OCCURED"),
              );
            }
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              List<Map> items = documents.map((e) => e.data() as Map).toList();
              final Set<int> uniqueFields = <int>{};
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index) {
                  final field = documents.length;
                  if (!uniqueFields.contains(field)) {
                    uniqueFields.add(field);

                    if (_searchController.text.isEmpty) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        child: Column(children: [
                          Text("the total customer users: $field"),
                          UserCardView(
                            imageURl: items[index]['image'].toString(),
                            user: items[index]['name'].toString(),
                            email: items[index]['email'].toString(),
                            phone: items[index]['phone'].toString(),
                            orderstatus: items[index]['orderstatus'].toString(),
                          ),
                        ]),
                      );
                    }
                  } else {
                    return Container(
                      margin: EdgeInsets.all(1),
                      child: Column(children: [
                        // Text("the total customer user: $field"),
                        UserCardView(
                          imageURl: items[index]['image'].toString(),
                          user: items[index]['name'].toString(),
                          email: items[index]['email'].toString(),
                          phone: items[index]['phone'].toString(),
                          orderstatus: items[index]['orderstatus'].toString(),
                        ),
                      ]),
                    );
                  }

                  if (items[index]['name']
                      .toString()
                      .toLowerCase()
                      .startsWith(_searchController.text.toLowerCase())) {
                    // ignore: sized_box_for_whitespace
                    return Container(
                      width: 100,
                      child: UserCardView(
                        imageURl: items[index]['image'].toString(),
                        user: items[index]['name'].toString(),
                        email: items[index]['email'].toString(),
                        phone: items[index]['phone'].toString(),
                        orderstatus: items[index]['orderstatus'].toString(),
                        // onPressed: () {
                        //   editField();
                        // }
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Future<void> editField() async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "Edit Order Status",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter new Order Status",
            hintStyle: TextStyle(color: Colors.grey),
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
      // await custCollection.doc(currentUser.uid).update({field: newValue});
      CollectionReference ref = FirebaseFirestore.instance.collection('users');

      ref.doc(documentid).update({'orderstatus': newValue});
    }
  }
}

class UserCardView extends StatelessWidget {
  final String user;
  final String email;
  final String phone;
  final String? orderstatus;
  final String imageURl;
  //final Function()? onPressed;

  const UserCardView({
    super.key,
    required this.user,
    required this.email,
    required this.phone,
    this.orderstatus,
    //this.onPressed,
    required this.imageURl,
  });
  // String getInitials(String user) => user.isNotEmpty
  //     ? user.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
  //     : '';
  @override
  Widget build(BuildContext context) {
    // return Container(
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        isThreeLine: true,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(5), //<-- SEE HERE
        ),
        leading: Container(
          height: 90,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 1),
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(imageURl.toString()),
              fit: BoxFit.cover,
            ),
          ),
          // border: Border.all(color: Colors.black),
          // borderRadius: BorderRadius.circular(12)),
          // child: Image.network(imageURl.toString(), fit: BoxFit.cover),
        ),
        title: Text(user),
        subtitle: Text('$email\n$phone\n$orderstatus'),
        // trailing: IconButton(
        //   onPressed: onPressed,
        //   icon: Icon(
        //     Icons.settings,
        //     color: Colors.grey[400],
        //   ),
        // ),
      ),
    );
  }
}

////////////////////code be/////////
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}
