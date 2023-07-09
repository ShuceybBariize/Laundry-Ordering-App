// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../provider.dart';

import 'package:badges/badges.dart' as badges;
import '../utility/0nitems_list.dart';
import 'cart.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  final OnItems product;

  static const String id = 'ProductScreen';

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, _) => Scaffold(
        backgroundColor: Color(0xfff5f9ff),
        appBar: AppBar(
          title: Text(widget.product.typecloth),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => CartScreen())),
              icon: badges.Badge(
                badgeContent: Text(
                  "1",
                  style: const TextStyle(color: Colors.white),
                ),
                child: const Icon(Icons.shopping_basket),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: widget.product.imgcloth, fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(12)),
              width: double.infinity,
              height: 250,
              //     child: Hero(
              //       tag: widget.product.id,
              //       child: image: const DecorationImage(
              //   image: AssetImage("assets/shuceyb.jpg"),
              // ),

              //       )
              //   imageUrl: ,
              //   fit: BoxFit.cover,
              // ),
              // ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          widget.product.typecloth,
                          style: GoogleFonts.poppins(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Text.rich(
                          TextSpan(
                            text: '\$',
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w300,
                            ),
                            children: [
                              TextSpan(
                                text: widget.product.pricecloth.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book. It usually begins wit",
                    style: GoogleFonts.poppins(fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: LikeButton(
                        // onTap: (val) async {
                        //   return true;
                        // },
                        isLiked: true,
                        size: 40,
                        circleColor: CircleColor(
                          start: Color(0xff00ddff),
                          end: Color(0xff0099cc),
                        ),
                        bubblesColor: BubblesColor(
                          dotPrimaryColor: Colors.red,
                          dotSecondaryColor:
                              Theme.of(context).primaryColor.withOpacity(0.15),
                        ),
                        likeBuilder: (bool isLiked) => Icon(
                          Icons.favorite,
                          color: isLiked
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          size: 40,
                        ),
                        likeCount: 0,
                        countBuilder: (count, isLiked, text) => Text(''),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Expanded(
              //   flex: 4,
              //   child: CustomFlatButton(
              //     label: value.isInCart(widget.product)
              //         ? 'Remove It'
              //         : 'Add to Cart',
              //     onTap: () {
              //       if (value.isInCart(widget.product))
              //         value.removeFromCart(widget.product);
              //       else
              //         value.addToCart(widget.product);
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
