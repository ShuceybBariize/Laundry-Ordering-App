// ignore_for_file: prefer_const_constructors

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, value, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Material(
          color: Color(0xfff5f9ff),
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {},
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ProductScreen(product: product),
            //   ),
            // ),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 150,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(product['imageUrl']),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.blue,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  // const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        product['clothName'].toString(),
                        style: GoogleFonts.poppins(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${product['initialPrice']}',
                        style: GoogleFonts.poppins(
                            fontSize: 22, color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      if (value.isInCart(product)) {
                        Flushbar(
                          message: 'Removed from the cart',
                          flushbarPosition: FlushbarPosition.TOP,
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ).show(context);
                        value.removeFromCart(product);
                      } else {
                        // FlushbarManager.instance.dismissAll();
                        // FlushbarStatus.DISMISSED
                        Flushbar(
                          message: 'Added to cart',
                          flushbarPosition: FlushbarPosition.TOP,
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 3),
                        ).show(context);
                        value.addToCart(product);
                      }
                    },
                    child: Container(
                      height: 45,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color:
                            value.isInCart(product) ? Colors.red : Colors.green,
                      ),
                      child: Center(
                          child: Text(
                        value.isInCart(product) ? "Remove" : "Add to cart",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    // return Text(product['clothName'].toString());
  }
}
