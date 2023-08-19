import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../exports.dart';
import '../payments/iron_payment_screen.dart';
import '../utility/cart_item.dart';

// ignore: must_be_immutable
class CartIronScreen extends StatelessWidget {
  static const String id = 'CartIronScreen';
  // showing field
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CartIronScreen({super.key});

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
    // ignore: non_constant_identifier_names, unused_local_variable
    Future<String> Fieldvalue = displayName();
    return Consumer<CartProvider>(
      builder: (context, value, _) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white70,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              FontAwesomeIcons.arrowLeft,
              size: 21,
              color: Kactivecolor,
            ),
            // FontAwesomeIcons.arrowLeft,
          ),
          title: Text(
            'Cart',
            style: GoogleFonts.inter(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
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
                      child: OrderNowButton(
                        onTap: () {
                          if (value.items.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => IronPaymentScreen(
                                        TotalItemCount: value.items.length,
                                        totalCartValue:
                                            value.calculateTotalPrice(),
                                      )),
                            );
                          } else {
                            value.checkoutIron(context, "$Fieldname", "$email");
                          }
                        },
                      ),
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
                'Check Order',
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
