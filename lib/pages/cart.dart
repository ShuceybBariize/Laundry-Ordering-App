import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../exports.dart';
import '../provider.dart';
import '../utility/cart_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatelessWidget {
  static const String id = 'CartScreen';
  // showing field
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CartScreen({super.key});

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
  // User? user = FirebaseAuth.instance.currentUser;
  // ignore: non_constant_identifier_names
  String? Fieldname;
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

  bool isLoading = false;

//end of showing field name
  @override
  Widget build(BuildContext context) {
    Future<String> Fieldvalue = displayName();
    return Consumer<CartProvider>(
      builder: (context, value, _) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              FontAwesomeIcons.arrowLeft,
              size: 21,
            ),
            // FontAwesomeIcons.arrowLeft,
          ),
          title: const Text(
            'Cart',
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: value.items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "There is No orders For now",
                            style: GoogleFonts.poppins(fontSize: 18),
                          ),
                          // const SizedBox(
                          //   height: 50,
                          // ),
                          Lottie.asset(
                            'assets/cart.json',
                            // 'assets/bag.svg',
                            width: 100,
                            height: 100,
                          )
                        ],
                      ),
                    )
                  : value.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          itemCount: value.items.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: CartItem(
                              product: value.items[index],
                              index: index,
                            ),
                          ),
                        ),
            ),
            Visibility(
              visible: true,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '\$',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.70),
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: "${value.calculateTotalPrice()}.",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  letterSpacing: 1.2,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: OrderNowButton(onTap: () async {
                        String? accountNo = await getAccountNo();
                        String totalAmount = value.calculateTotalPrice();
                        if (accountNo != null) {
                          bool paymentResult = await makePayment(
                              accountNo, double.parse(totalAmount));
                          if (paymentResult) {
                            print('Payment Successful');
                          } else {
                            print('Payment Failed');
                          }

                          // Use a parent context for showDialog
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Payment Result'),
                                content: Text(paymentResult
                                    ? 'Payment Successful'
                                    : 'Payment Failed'),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          print('Failed to get account number');
                        }
                        value.checkOutOrder(context, "$Fieldname");
                      }),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

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

Future<bool> performAdditionalAction() async {
  Completer<bool> completer = Completer<bool>();

  // Simulating additional action delay
  await Future.delayed(const Duration(seconds: 2));

  // Perform the additional action
  // Replace this with your actual logic
  bool isSuccess = true;

  // Complete the completer based on the action result
  if (isSuccess) {
    completer.complete(true);
  } else {
    completer.complete(false);
  }

  // Return the future of the completer
  return completer.future;
}

Future<bool> makePayment(String accountNo, double tatalAmount) async {
  var url = Uri.parse('https://api.waafipay.net/asm');

  // Create the payment code JSON payload
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
        "amount": tatalAmount,
        "currency": "USD",
        "description": "Test USD"
      }
    }
  };
// Make the HTTP POST request
  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(paymentCode),
  );

  // Check the response status
  if (response.statusCode == 200) {
    // Payment successful
    return true;
  } else {
    // Payment failed
    return false;
  }
}

class OrderNowButton extends StatelessWidget {
  final Function() onTap;

  const OrderNowButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/bag.svg',
                width: 40,
                // ignore: deprecated_member_use
                color: Theme.of(context).primaryColor,
                // ignore: deprecated_member_use
                cacheColorFilter: true,
              ),
              const SizedBox(width: 15),
              Text(
                'Order Now',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Gilroy',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
