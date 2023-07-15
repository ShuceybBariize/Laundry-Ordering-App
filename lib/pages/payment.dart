import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laundry_management_system/exports.dart';
import 'package:http/http.dart' as http;
import 'package:laundry_management_system/provider.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Payments extends StatelessWidget {
  static const String id = 'CartScreen';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final double totalCartValue;
  final int TotalItemCount;
  Payments({
    super.key,
    required this.totalCartValue,
    required this.TotalItemCount,
  });

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

  Future<bool> makePayment(
      BuildContext context, String accountNo, double totalAmount) async {
    var url = Uri.parse('https://api.waafipay.net/asm');

    var paymentCode = {
      "schemaVersion": "1.0",
      "requestId": "10111331033",
      "timestamp": "client_timestamp",
      "channelName": "WEB",
      "serviceName": "API_PURCHASE",
      "serviceParams": {
        "merchantUid": "M0910291",
        "apiUserId": "1000416",
        "apiKey": "API-675418888AHX",
        "paymentMethod": "mwallet_account",
        "payerInfo": {"accountNo": accountNo},
        "transactionInfo": {
          "referenceId": "12334",
          "invoiceId": "7896504",
          "amount": totalAmount,
          "currency": "USD",
          "description": "Test USD"
        }
      }
    };
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(paymentCode),
    );

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);

      var responseMsg = responseJson['responseMsg'];
      var stateStartIndex = responseMsg.indexOf('(STATE: ') + '(STATE: '.length;
      var stateEndIndex = responseMsg.indexOf(',', stateStartIndex);
      var state = responseMsg.substring(stateStartIndex, stateEndIndex);

      print(state);

      if (state == 'N_TIMEOUT_AT_ISSUER_SYSTEM (Timeout_no_response_recvd') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.RIGHSLIDE,
          title: 'Timeout error occurred',
          desc: state,
          btnOkOnPress: () {},
        ).show();
        return false;
      } else if (state == 'declined') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          title: 'Warbixin11',
          desc: state,
          btnOkOnPress: () {},
        ).show();

        return false;
      } else if (state == 'rejected') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.RIGHSLIDE,
          title: 'Dhaq dhaqaaqa Waa KaNoqotay',
          desc: state,
          btnOkOnPress: () {},
        ).show();
        return false;
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.RIGHSLIDE,
          title: 'Warbixin33',
          desc: state,
          btnOkOnPress: () {},
        ).show();
        return true;
      }
    } else {
      // The request failed
      print('Error: ${response.statusCode}');
      return false;
    }
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

  @override
  Widget build(BuildContext context) {
    Future<String> Fieldvalue = displayName();
    return Consumer<CartProvider>(
      builder: (context, value, _) => Scaffold(
        appBar: AppBar(
          title: const Text("Payment"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 250,
                width: double.infinity,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Items",
                            style: GoogleFonts.inter(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$TotalItemCount',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Price",
                            style: GoogleFonts.inter(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Total Price",
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Price",
                            style: GoogleFonts.inter(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${totalCartValue.toStringAsFixed(1)}',
                            style: GoogleFonts.inter(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      custombtn(
                          txtbtn: "Pay Now",
                          onpress: () async {
                            String? accountNo = await getAccountNo();
                            double totalAmount = value.calculateTotalPrice();
                            if (accountNo != null) {
                              bool paymentResult = await makePayment(
                                  context, accountNo, totalAmount);

                              if (paymentResult) {
                                value.checkOutOrder(context, "$Fieldname");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomePage()));
                              }
                            } else {
                              print('Failed to get account number');
                            }
                          },
                          colorbtn: Kactivecolor,
                          colortxt: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
