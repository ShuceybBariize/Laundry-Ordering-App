// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider.dart';

class CartItem extends StatefulWidget {
  // final  product;
  final product;
  const CartItem({super.key, required this.product, required this.index});
  final int index;
  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int quantity = 1;

  int totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, value, _) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // ignore: deprecated_member_use
          color: Theme.of(context).bottomAppBarColor,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 120,
              height: double.infinity,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(widget.product['imageUrl']),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 4.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                widget.product['clothName'].toString(),
                                style: GoogleFonts.roboto(fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '\$',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.8),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${widget.product['initialPrice']}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      letterSpacing: 1.2,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        // ignore: deprecated_member_use
                        icon: Icon(FontAwesomeIcons.trashAlt),
                        // onPressed: () => value.removeFromCart(widget.product),
                        onPressed: () => showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => AlertDialog(
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    value.removeFromCart(widget.product);
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Text('No'),
                              ),
                            ],
                            title: Text('Confirm'),
                            content: Text(
                              'Are you sure to remove this item from your cart?',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      CustomButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 0) {
                            setState(() {
                              value.decreaseQuantity(widget.index);
                            });
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "${widget.product['quantity']}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            letterSpacing: 1.2,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      CustomButton(
                        onPressed: () {
                          setState(() {
                            //quantity++;
                            value.changeQuantity(widget.index);
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      );
    });
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, this.onPressed, required this.icon})
      : super(key: key);

  final Icon icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onPressed,
        child: Container(
          width: 35.0,
          height: 35.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: icon,
        ),
      ),
    );
  }
}
