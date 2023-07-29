import 'package:firebase_auth/firebase_auth.dart';
import '../exports.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool isloading = false;
  // Initialize Firebase Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;

  //get name by feedback user
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<String>> getFieldValuesByEmail(String email) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('customers')
        .where('email', isEqualTo: email)
        .get();

    List<String> fieldValues = [];

    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        dynamic fieldValue = documentSnapshot.get('name');
        fieldValues.add(fieldValue.toString());
      }
    }
    return fieldValues;
  }

//get phone by feedback user
  Future<List<String>> getPhoneFieldPhone(String email) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('customers')
        .where('email', isEqualTo: email)
        .get();

    List<String> fieldValues = [];

    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        dynamic fieldValue = documentSnapshot.get('phone');
        fieldValues.add(fieldValue.toString());
      }
    }
    return fieldValues;
  }

  String? email = FirebaseAuth.instance.currentUser!.email!;
  // ignore: non_constant_identifier_names
  String? Fieldname;
  bool error = false;
  Future<String> displayName() async {
    await Future.delayed(Duration(seconds: 1));
    List<String> fieldValues = await getFieldValuesByEmail(email!);
    if (fieldValues.isNotEmpty) {
      print('Field Values:');
      for (String fieldValue in fieldValues) {
        Fieldname = fieldValue;
        print('the fieldvalue value: $Fieldname');
        return fieldValue;
      }
    } else {
      print('No matching documents found.');
    }
    return Fieldname!;
  }

  String? phone;
  Future<String> displayPhone() async {
    await Future.delayed(Duration(seconds: 1));
    List<String> fieldValues = await getPhoneFieldPhone(email!);
    if (fieldValues.isNotEmpty) {
      print('Field Values:');
      for (String fieldValue in fieldValues) {
        phone = fieldValue;
        print('the fieldvalue value: $phone');
        return fieldValue;
      }
    } else {
      print('No matching documents found.');
    }
    return phone!;
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // Save feedback to Firestore
      _firestore.collection('feedback').add({
        'rating': int.parse(_ratingController.text),
        'comment': _commentController.text,
        'timestamp': Timestamp.now(),
        'Email': currentUser.email,
        'Name': Fieldname.toString(),
        'Phone': phone.toString(),
      }).then((_) {
        // Feedback submitted successfully
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Thank you for your feedback!'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        _ratingController.clear();
        _commentController.clear();
      }).catchError((error) {
        // Error occurred while submitting feedback
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to submit feedback. Please try again.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    displayName();
    displayPhone();
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('customers')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final customerData = snapshot.data!;
          final imageUrl = customerData['image'];
          final customerName = customerData['name'];
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 285,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Kactivecolor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 170,
                          width: double.infinity,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.blue,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.blueAccent,
                              backgroundImage:
                                  NetworkImage(imageUrl.toString()),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Icon(
                                    Icons.add,
                                    color: Colors.blueAccent,
                                    size: 25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          currentUser.email!,
                          style: const TextStyle(letterSpacing: 2),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Soo Dhawaaw " $customerName"',
                          style: const TextStyle(letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: _ratingController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter the rating value';
                              } else if (int.parse(value) < 1 ||
                                  int.parse(value) > 5) {
                                return 'Rating value must be between 1-5';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Rating (1-5)',
                              // hintText: error ? "Enter the rating value" : "",
                              errorStyle: TextStyle(height: 0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: _commentController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your comments';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Comments',
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(180, 65),
                            backgroundColor: Kactivecolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(57),
                            ),
                            side:
                                const BorderSide(color: Kactivecolor, width: 3),
                            elevation: 0,
                          ),
                          onPressed: () {
                            _submitFeedback();
                          },
                          child: isloading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal),
                                ),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: IconButton(
                                onPressed: () {
                                  // openWhatsapp();
                                },
                                icon: (const FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  size: 35,
                                  color: Kactivecolor,
                                )),
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: IconButton(
                                onPressed: () {
                                  //  openGmail();
                                },
                                icon: const Icon(Icons.email,
                                    size: 35, color: Kactivecolor),
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: IconButton(
                                onPressed: () {
                                  // openCall();
                                },
                                icon: const Icon(Icons.call,
                                    size: 35, color: Kactivecolor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
