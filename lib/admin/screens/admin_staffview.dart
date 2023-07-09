import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminStafsUserview extends StatefulWidget {
  const AdminStafsUserview({super.key});

  @override
  State<AdminStafsUserview> createState() => _AdminStafsUserviewState();
}

class _AdminStafsUserviewState extends State<AdminStafsUserview> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? documentid;
  Future<void> getAdminsAndStaffs(String name) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot =
          await collectionRef.where('name', isEqualTo: name).get();
      for (var doc in querySnapshot.docs) {
        documentid = doc.id;
        //print('Document ID: ${doc.id}');
        print('Documentid waa : $documentid');
        setState(() {});
      }
    } on FirebaseAuthException catch (e) {
      print('The erro waa: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userID = FirebaseFirestore.instance.collection("customers").doc().id;

// Function to delete a user document
    Future<void> deleteUser(String userID) async {
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(documentid)
            .delete();
        print('User deleted successfully');
      } catch (e) {
        print('Error deleting user: $e');
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(("User View")),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
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
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 100,
                    child: UserCardView(
                      imageURl: items[index]['image'].toString(),
                      user: items[index]['name'].toString(),
                      email: items[index]['email'].toString(),
                      phone: items[index]['phone'].toString(),
                      role: items[index]['role'].toString(),
                      onPressed: () {
                        setState(() {
                          getAdminsAndStaffs(items[index]['name']);
                          deleteUser(documentid.toString());
                        });
                      },
                    ),
                  );
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
}

class UserCardView extends StatelessWidget {
  final String user;
  final String email;
  final String phone;
  final String role;
  final String imageURl;
  final Function() onPressed;
  const UserCardView({
    super.key,
    required this.user,
    required this.imageURl,
    required this.email,
    required this.phone,
    required this.role,
    required this.onPressed,
  });
  String getInitials(String user) => user.isNotEmpty
      ? user.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';
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
        subtitle: Text('$email\n$phone\n$role'),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future deleteuser() {
    return userCollection.doc(uid).delete();
  }
}

//Email verified
// User? user = FirebaseAuth.instance.currentUser;

// if (user != null && !user.emailVerified) {
//   var actionCodeSettings = ActionCodeSettings(
//       url: 'https://www.example.com/?email=${user.email}',
//       dynamicLinkDomain: 'example.page.link',
//       androidPackageName: 'com.example.android',
//       androidInstallApp: true,
//       androidMinimumVersion: '12',
//       iOSBundleId: 'com.example.ios',
//       handleCodeInApp: true,
//   );

//   await user.sendEmailVerification(actionCodeSettings);
// }

