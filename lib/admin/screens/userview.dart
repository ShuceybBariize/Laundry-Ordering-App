import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
        appBar: AppBar(title: const Text("Customer Users View")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'customer')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text(""));
                }

                int documentCount = snapshot.data!.docs.length;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Card(
                          child: TextField(
                        controller: _searchController,
                        onChanged: (value) => searchUsers(value),
                        decoration: const InputDecoration(
                            hintText: "searching....",
                            prefixIcon: Icon(Icons.search)),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('The Total customers are: $documentCount'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'customer')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("There is no customer"),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          // DocumentSnapshot document = snapshot.data!.docs[index];
                          QuerySnapshot querySnapshot = snapshot.data!;
                          List<QueryDocumentSnapshot> documents =
                              querySnapshot.docs;
                          List<Map> items =
                              documents.map((e) => e.data() as Map).toList();
                          // getdocid(items[index]['email'].toString());

                          // Create your custom widget to display the document fields here
                          if (_searchController.text.isEmpty) {
                            return UserCardView(
                              imageURl: items[index]['image'].toString(),
                              user: items[index]['name'].toString(),
                              email: items[index]['email'].toString(),
                              phone: items[index]['phone'].toString(),
                            );
                          } else if (items[index]['name']
                              .toString()
                              .toLowerCase()
                              .startsWith(
                                  _searchController.text.toLowerCase())) {
                            return Container(
                              margin: const EdgeInsets.all(1),
                              child: Column(children: [
                                // Text("the total customer user: $field"),
                                UserCardView(
                                  imageURl: items[index]['image'].toString(),
                                  user: items[index]['name'].toString(),
                                  email: items[index]['email'].toString(),
                                  phone: items[index]['phone'].toString(),
                                ),
                              ]),
                            );
                          }
                          return null;
                        });
                  } else {
                    return const Center(
                      child: Text(""),
                    );
                  }
                },
              ),
            ),
          ],
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

  final String imageURl;
  //final Function()? onPressed;

  const UserCardView({
    super.key,
    required this.user,
    required this.email,
    required this.phone,

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
        ),
        title: Text(user),
        subtitle: Text('$email\n$phone'),
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
