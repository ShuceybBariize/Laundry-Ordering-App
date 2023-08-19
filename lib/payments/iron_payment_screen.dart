import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:laundry_management_system/provider.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Import the material package for the context andj other UI widgets.
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../exports.dart';
import 'classtransactionInfo.dart';
import 'marchentevcplus.dart';

// Function to get all staff device tokens from Firestore
Future<List<String>> getStaffDeviceTokens() async {
  List<String> deviceTokens = [];

  try {
    // Access the "users" collection in Firestore
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Query documents with the role "staff"
    QuerySnapshot staffSnapshot =
        await usersCollection.where('role', isEqualTo: 'staff').get();

    // Iterate through the documents and get the device tokens
    for (QueryDocumentSnapshot document in staffSnapshot.docs) {
      String? deviceToken = document.get('deviceToken');
      if (deviceToken != null) {
        deviceTokens.add(deviceToken);
      }
    }
  } catch (e) {
    print('Error getting staff device tokens: $e');
  }

  return deviceTokens;
}

Future<void> sendNotificationsToStaff() async {
  // Step 1: Get the device tokens of all staff members
  List<String> staffDeviceTokens = await getStaffDeviceTokens();

  if (staffDeviceTokens.isEmpty) {
    print('No staff members found.');
    return;
  }

  // Step 2: Send notifications to each staff member
  String serverKey =
      'AAAA0fQfPAY:APA91bF8azi0edbZtBNuX8R-qrLhctwRxJaGFSNz2Wi7gTBQ57eQgvWL4j_T8vAh9QBCszI6prkahxMfWDxMJfqZq3KeEShZD9CIP5Wwdgi4OJs0d9YtWk4t0O718wfdRR6KrzquhtyZ'; // Replace with your FCM server key

  final Map<String, dynamic> notification = {
    'body': 'There is a new pending order.',
    'title': 'New Order',
    'sound': 'default',
  };

  final Map<String, dynamic> data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'payload': 'bending_order',
  };

  final Map<String, dynamic> fcmMessage = {
    'notification': notification,
    'data': data,
  };

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  try {
    // Send notifications to each staff member
    for (String deviceToken in staffDeviceTokens) {
      fcmMessage['to'] = deviceToken;
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: headers,
        body: jsonEncode(fcmMessage),
      );

      if (response.statusCode == 200) {
        print(
            'Notification sent successfully to staff member with device token: $deviceToken');
      } else {
        print(
            'Failed to send notification to staff member with device token: $deviceToken. Status code: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Error sending notifications to staff members: $e');
  }
}

class IronPaymentScreen extends StatefulWidget {
  final double totalCartValue;
  final int TotalItemCount;
  const IronPaymentScreen({
    super.key,
    required this.totalCartValue,
    required this.TotalItemCount,
  });

  @override
  State<IronPaymentScreen> createState() => _IronPaymentScreenState();
}

class _IronPaymentScreenState extends State<IronPaymentScreen> {
  Future<void> sendNotificationToAllStaff(
      List<String> staffDeviceTokens) async {
    // ... existing notification sending code ...

    // for (String deviceToken in staffDeviceTokens) {
    //   await sendNotificationToUser(deviceToken);
    // }

    Future<List<String>> getStaffDeviceTokens() async {
      List<String> deviceTokens = [];
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'staff')
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
            String deviceToken = documentSnapshot.get('deviceToken');
            if (deviceToken.isNotEmpty) {
              deviceTokens.add(deviceToken);
            }
          }
        }
      } catch (e) {
        print('Error getting staff device tokens: $e');
      }

      return deviceTokens;
    }
  }

  bool _isProcessingPayment = false;

  Widget _buildPaymentButton(CartProvider value) {
    return custombtn(
        txtbtn: "Pay Now",
        onpress: () async {
          setState(() {
            _isProcessingPayment = true;
          });
          String? accountNo = await getAccountNo();
          double totalAmount = value.calculateTotalPrice();
          if (accountNo != null) {
            MerchantEvcPlus merchantEvcPlus = MerchantEvcPlus(
              apiKey: 'API-675418888AHX',
              merchantUid: 'M0910291',
              apiUserId: '1000416',
              address: _address.text,
            );
            String generateRandomId() {
              Random random = Random();
              int randomNumber = random.nextInt(
                  1000000); // Generate a random number between 0 and 999999.
              int timestamp = DateTime.now()
                  .millisecondsSinceEpoch; // Get the current timestamp in milliseconds.
              String uniqueId =
                  '$timestamp$randomNumber'; // Combine the timestamp and random number to create a unique ID.
              return uniqueId;
            }

            String invoiceId = generateRandomId();
            String referenceId = generateRandomId();
            String description = 'Payment For Order $referenceId';

            TransactionInfo transactionInfo = TransactionInfo(
              referenceId: referenceId,
              invoiceId: invoiceId,
              amount: totalAmount,
              currency: 'USD',
              description: description,
              payerPhoneNumber: accountNo,
            );

            try {
              // ignore: use_build_context_synchronously
              await merchantEvcPlus.makePayment(
                transactionInfo: transactionInfo,
                onSuccess: (TransactionInfo successTransactionInfo) {
                  // Handle success scenario and access the details from successTransactionInfo.
                  sendNotificationsToStaff();
                  print('Reference ID: ${successTransactionInfo.referenceId}');
                  print('Invoice ID: ${successTransactionInfo.invoiceId}');
                  print('Description: ${successTransactionInfo.description}');

                  value.checkoutIron(context, "$Fieldname", "$email");
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => const HomePage()),
                  //   (route) => false,
                  // );
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                },
                onFailure: (message) {
                  // Show AwesomeDialog with the error message
                  showAwesomeDialog(
                    context: context,
                    title: 'Payment Failed',
                    description: 'Payment was cancelled by the user',
                  );
                  // showAwesomeDialog(
                  //   context: context,
                  //   title: 'Payment Failed error',
                  //   description: ' $message',
                  // );
                  // Stop the processing of ModalProgressHUD
                  setState(() {
                    _isProcessingPayment = false;
                  });
                },
                onPaymentCancelled: () {
                  setState(() {
                    _isProcessingPayment = false;
                  });
                  print('Payment was cancelled by the user.');
                },
                context: context,
              );
            } catch (e) {
              print('Error making payment: $e');
              // Show AwesomeDialog with the error message
              showAwesomeDialog(
                context: context,
                title: 'Payment Failed',
                description: 'Payment failed with error: $e',
              );

              // Stop the processing of ModalProgressHUD
              setState(() {
                _isProcessingPayment = false;
              });
            }
          } else {
            print('Failed to get account number');
          }
        },
        colorbtn: Kactivecolor,
        colortxt: Colors.white);
  }

  void showAwesomeDialog({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: description,
      btnOkOnPress: () {},
    ).show();
  }

  @override

  // static const String id = 'CartScreen';

  // ignore: override_on_non_overriding_member
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> getAccountNo() async {
    String? email = FirebaseAuth.instance.currentUser!.email;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return documentSnapshot.get('phone');
    } else {
      print('No matching documents found.');
      return null;
    }
  }

  String currentTimestamp() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

  String generateRequestId() {
    var random = Random();
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    var randomValue = random.nextInt(999999).toString().padLeft(6, '0');
    return timestamp + randomValue;
  }

  String? Fieldname;

  Future<List<String>> getFieldValuesByEmail(String email) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
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

  String? email = FirebaseAuth.instance.currentUser!.email!;

  Future<String> displayName() async {
    await Future.delayed(const Duration(seconds: 1));
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

  final currentUSer = FirebaseAuth.instance.currentUser;

  // Declare a TextEditingController to store the edited phone number
  TextEditingController phoneController = TextEditingController();
  late String addresstxt = '';
  // Method to show a dialog with a form to edit the phone number
  void showPhoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Phone Number'),
          content: TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              hintText: 'Enter new phone number',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Update the phone number in Firestore
                updatePhoneNumber(phoneController.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Method to update the phone number in Firestore
  Future<void> updatePhoneNumber(String newPhoneNumber) async {
    String? email = FirebaseAuth.instance.currentUser!.email;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      String documentId = documentSnapshot.id;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .update({'phone': newPhoneNumber});
      print('Phone number updated successfully');
    } else {
      print('No matching documents found.');
    }
  }

  final TextEditingController _address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names, unused_local_variable
    Future<String> Fieldvalue = displayName();
    return Consumer<CartProvider>(
      builder: (context, value, _) => StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(currentUSer!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final customerData = snapshot.data!;
            final customersPhone = customerData['phone'];
            return ModalProgressHUD(
              inAsyncCall: _isProcessingPayment,
              progressIndicator:
                  const SpinKitCircle(color: Colors.blue, size: 50),
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white54,
                  elevation: 0,
                  title: Text(
                    "Payment",
                    style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        FontAwesomeIcons.arrowLeft,
                        size: 21,
                        color: Kactivecolor,
                      )),
                ),
                body: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(16),
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _address,
                              keyboardType: TextInputType.streetAddress,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(18),
                                fillColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Kactivecolor, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Kactivecolor, width: 1),
                                ),
                                hintText: "Enter Your Address (Optional)",
                              ),
                              // onSaved: (value) {
                              //   txtname = value!;
                              // },
                              validator: validatename,
                            ),
                            const Spacer(),
                            Text(
                              "Ma Hubtaa Inad lambarkan Lacagta Kadireysid",
                              style: GoogleFonts.inter(
                                  color: Kactivecolor,
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                  height: 70,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white),
                                  child: TextButton(
                                    onPressed: () {
                                      showPhoneDialog(context);
                                    },
                                    child: Text(
                                      customersPhone,
                                      style: GoogleFonts.inter(
                                          letterSpacing: 1,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ),
                          ],
                        )),
                    // ElevatedButton(
                    //     onPressed: () {

                    //     },
                    // child: const Text("click")),
                    const Spacer(),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        // height: 50,
                        // width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35)),
                            color: Colors.grey[300]),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order Details",
                                style: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Kactivecolor),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Items",
                                    style: GoogleFonts.inter(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${widget.TotalItemCount}',
                                    style: GoogleFonts.inter(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delivery ",
                                    style: GoogleFonts.inter(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "\$2",
                                    style: GoogleFonts.inter(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Price",
                                    style: GoogleFonts.inter(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${widget.totalCartValue.toString()}',
                                    style: GoogleFonts.inter(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              _buildPaymentButton(value),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
