import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:laundry_management_system/exports.dart';
import 'package:laundry_management_system/provider.dart';

import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Import the material package for the context andj other UI widgets.
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
      'AAAAs23xekk:APA91bESWPXzuhTzMkvbumu31NOHCl-Qn0r7dskr4REgUPo_Sc6cIkvhB2WK8HQYc9kXCKHEprmVDMBzDc6iM9ZjSRS3SKsFXnDnBboKH1eSDhyVgJklBj6_NMVl7ryZp7sKBIeAkkQN'; // Replace with your FCM server key

  final Map<String, dynamic> notification = {
    'body': 'There is a new pending order.', // Notification message
    'title': 'New Order', // Notification title
    'sound': 'default', // Notification sound (optional)
  };

  final Map<String, dynamic> data = {
    'click_action':
        'FLUTTER_NOTIFICATION_CLICK', // Action when notification is clicked (optional)
    'payload': 'bending_order', // Payload data (optional)
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

class Payments extends StatefulWidget {
  final double totalCartValue;
  final int TotalItemCount;
  const Payments({
    super.key,
    required this.totalCartValue,
    required this.TotalItemCount,
  });

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
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
            MerchantEvcPlus merchantEvcPlus = const MerchantEvcPlus(
              apiKey: 'API-675418888AHX',
              merchantUid: 'M0910291',
              apiUserId: '1000416',
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
              await merchantEvcPlus.makePayment(
                transactionInfo: transactionInfo,
                onSuccess: (TransactionInfo successTransactionInfo) {
                  // Handle success scenario and access the details from successTransactionInfo.
                  sendNotificationsToStaff();
                  print('Reference ID: ${successTransactionInfo.referenceId}');
                  print('Invoice ID: ${successTransactionInfo.invoiceId}');
                  print('Description: ${successTransactionInfo.description}');

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
                  );
                  value.checkwashOrder(context, "$Fieldname");
                },
                onFailure: (message) {
                  // Show AwesomeDialog with the error message
                  showAwesomeDialog(
                    context: context,
                    title: 'Payment Failed error',
                    description: ' $message',
                  );
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
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: description,
      btnOkOnPress: () {},
    ).show();
  }

  @override

  // static const String id = 'CartScreen';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> getAccountNo() async {
    String? email = FirebaseAuth.instance.currentUser!.email;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('customers')
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
        .collection('customers')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      String documentId = documentSnapshot.id;
      await FirebaseFirestore.instance
          .collection('customers')
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
    Future<String> Fieldvalue = displayName();
    return Consumer<CartProvider>(
      builder: (context, value, _) => StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("customers")
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
                              "MA Hubtaa Inad lambarkan Lacagta Kadirosid",
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

class MerchantEvcPlus {
  final String endPoint;
  final String merchantUid;
  final String apiUserId;
  final String apiKey;

  const MerchantEvcPlus({
    this.endPoint = 'https://api.waafipay.net/asm',
    required this.merchantUid,
    required this.apiUserId,
    required this.apiKey,
  });

  Future<void> makePayment({
    required TransactionInfo transactionInfo,
    Function(TransactionInfo)? onSuccess,
    Function(String)? onFailure,
    Function()? onPaymentCancelled,
    BuildContext? context,
  }) async {
    HttpOverrides.global = MyHttpOverrides();

    try {
      http.Response response = await http.post(
        Uri.parse(endPoint),
        body: json.encode(
          {
            "schemaVersion": "1.0",
            "requestId": "101111003",
            "timestamp": "client_timestamp",
            "channelName": "WEB",
            "serviceName": "API_PURCHASE",
            "serviceParams": {
              "merchantUid": merchantUid,
              "apiUserId": apiUserId,
              "apiKey": apiKey,
              "paymentMethod": "mwallet_account",
              "payerInfo": {"accountNo": transactionInfo.payerPhoneNumber},
              "transactionInfo": {
                "referenceId": transactionInfo.referenceId,
                "invoiceId": transactionInfo.invoiceId,
                "amount": transactionInfo.amount.toString(),
                "currency": transactionInfo.currency,
                "description": transactionInfo.description
              }
            }
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["responseMsg"] == 'RCS_SUCCESS') {
          showAwesomeDialog(
            context: context!,
            title: 'Payment Success',
            description: 'Payment was successful!',
          );
          onSuccess?.call(transactionInfo);

          // Store the successful payment details in Firebase
          try {
            await FirebaseFirestore.instance
                .collection('successful_payments')
                .add({
              'referenceId': transactionInfo.referenceId,
              'invoiceId': transactionInfo.invoiceId,
              'amount': transactionInfo.amount,
              'currency': transactionInfo.currency,
              'description': transactionInfo.description,
              'payerPhoneNumber': transactionInfo.payerPhoneNumber,
              'timestamp': FieldValue
                  .serverTimestamp(), // Add a server timestamp for the current time
            });
          } catch (e) {
            print('Error storing payment details in Firebase: $e');
          }
        } else {
          String message = '';
          var errMessage = data['responseMsg'].toString().split(':');
          if (errMessage.length < 2) {
            message = 'RCS_USER_IS_NOT_AUTHZ_TO_ACCESS_API';
          } else {
            message = errMessage[1].trim();
          }

          if (errMessage[0]
              .contains('RCS_TRAN_FAILED_AT_ISSUER_SYSTEM (User Aborted')) {
            // Payment was aborted by the user.
            showAwesomeDialog(
              context: context!,
              title: 'Payment Cancelled',
              description: 'Payment was cancelled by the user.',
            );
            onPaymentCancelled?.call();
          } else {
            print('Payment failed with error: $message');
            // Payment failed due to other reasons.
            // showAwesomeDialog(
            //   context: context!,
            //   title: 'Payment Failed',
            //   description: ,
            // );
            onFailure?.call('Payment failed with error: $message');
          }
        }
      } else {
        onFailure?.call(response.body);
      }
    } on SocketException {
      onFailure?.call('No Internet Connection');
    } catch (e) {
      print(e);
      onFailure?.call(e.toString());
    }
  }

  void showAwesomeDialog({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.LEFTSLIDE,
      title: title,
      desc: description,
      btnOkOnPress: () {},
    ).show();
  }
}

class TransactionInfo {
  final String referenceId;
  final String invoiceId;
  final double amount;
  final String currency;
  final String description;
  final String payerPhoneNumber;

  TransactionInfo({
    required this.referenceId,
    required this.invoiceId,
    required this.amount,
    required this.currency,
    required this.description,
    required this.payerPhoneNumber,
  });
}
