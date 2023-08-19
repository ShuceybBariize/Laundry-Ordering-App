// ignore_for_file: use_build_context_synchronously

import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'utility/0nitems_list.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> items = [];
  bool isLoading = false;
  late double total;
  void addToCart(Map<String, dynamic> item) {
    print("length is ${items.length}");
    if (!items.contains(item)) {
      items.add(item);
      notifyListeners();
    }
  }

  void removeFromCart(Map<String, dynamic> productToremove) {
    // items.remove(item);
    items.removeWhere((item) => _isEqual(item, productToremove));
    notifyListeners();
  }

  void clearAllCarts(Map<String, dynamic> productToremove) {
    items.clear();
    notifyListeners();
  }

  bool _isEqual(Map<String, dynamic> item1, Map<String, dynamic> item2) {
    return item1['clothPrice'] == item2['clothPrice'] &&
        item1['clothId'] == item2['clothId'] &&
        item1['quantity'] == item2['quantity'] &&
        item1['initialPrice'] == item2['initialPrice'] &&
        item1['imageUrl'] == item2['imageUrl'] &&
        item1['id'] == item2['id'] &&
        item1['clothName'] == item2['clothName'];
  }

  void changeQuantity(int index) {
    if (index >= 0 && index < items.length) {
      items[index]['quantity'] = items[index]['quantity'] + 1;
      notifyListeners();
      items[index]['clothPrice'] =
          items[index]['initialPrice'] * items[index]['quantity'];
      notifyListeners();
    } else {}
  }

  calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in items) {
      if (item.containsKey('clothPrice')) {
        totalPrice += item['clothPrice'];
        total = totalPrice;
      }
    }
    return totalPrice;
    // return totalPrice.toStringAsFixed(2);
  }

  void decreaseQuantity(int index) {
    if (index >= 0 && index < items.length && items[index]['quantity'] > 1) {
      items[index]['quantity'] = items[index]['quantity'] - 1;
      notifyListeners();
      items[index]['clothPrice'] =
          items[index]['initialPrice'] * items[index]['quantity'];
      notifyListeners();
    } else {}
  }

  bool isInCart(Map<String, dynamic> product) {
    return items.any((item) => item.toString() == product.toString());
  }

//checkout wash order
  void checkwashOrder(BuildContext context, String name, String email) async {
    isLoading = true;
    var today = DateTime.now();

    var dateFormat = DateFormat('dd-MM-yyyy');

    String currentDate = dateFormat.format(today);
    notifyListeners();
    if (items.isNotEmpty) {
      CollectionReference cardCollection =
          FirebaseFirestore.instance.collection('Washing Clothes Order');

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        for (var item in items) {
          Map<String, dynamic> newItem = {
            ...item,
            // 'price': 0, // Custom price field
            // 'quantity': 0, // Custom quantity field
            'userId': userId,
            // Add logged-in user's ID
            // 'name': '${Fieldname}',
            'name': name,
            'date': currentDate,
            'Total': total,
            'orderstatus': '',
            'email': email,
            //'email': email,
            // 'name': displayStatusOrder().asStream(),
          };
          await cardCollection.add(newItem);
        }
        showMyDialog(context);
        items.length = 0;
        notifyListeners();
      } else {
        Fluttertoast.showToast(
          msg: 'No logged-in user.',
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'There is no order',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
    isLoading = false;
    notifyListeners();
  }

// //copy
//   Future<void> copyCollectionData() async {
//     final QuerySnapshot sourceSnapshot =
//         await FirebaseFirestore.instance.collection('cart_iron_orders').get();

//     for (QueryDocumentSnapshot document in sourceSnapshot.docs) {
//       final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//       final String documentId = document.id;

//       await FirebaseFirestore.instance
//           .collection('cartOrders')
//           .doc(documentId)
//           .set(data);
//       print('Data copied for document ID: $documentId');
//     }

//     print('Copy operation completed');
//   }

//checkout iron clothes
  void checkoutIron(BuildContext context, String name, String email) async {
    isLoading = true;
    var today = DateTime.now();

    var dateFormat = DateFormat('dd-MM-yyyy');

    String currentDate = dateFormat.format(today);
    notifyListeners();
    if (items.isNotEmpty) {
      CollectionReference cardCollection =
          FirebaseFirestore.instance.collection('Ironing Clothes Order');

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        for (var item in items) {
          Map<String, dynamic> newItem = {
            ...item,
            // 'price': 0, // Custom price field
            // 'quantity': 0, // Custom quantity field
            'userId': userId,
            // Add logged-in user's ID
            // 'name': '${Fieldname}',
            'name': name,
            'date': currentDate,
            'Total': total,
            'orderstatus': '',
            'email': email,
            // 'name': displayStatusOrder().asStream(),
          };
          await cardCollection.add(newItem);
        }
        showMyDialog(context);
        items.length = 0;
        notifyListeners();
      } else {
        Fluttertoast.showToast(
          msg: 'No logged-in user.',
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'There is no order',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
    isLoading = false;
    notifyListeners();
  }

  //checkout wash and iron
  void checkoutwashIron(BuildContext context, String name, String email) async {
    isLoading = true;
    var today = DateTime.now();

    var dateFormat = DateFormat('dd-MM-yyyy');

    String currentDate = dateFormat.format(today);
    notifyListeners();
    if (items.isNotEmpty) {
      CollectionReference cardCollection = FirebaseFirestore.instance
          .collection('Washing and Ironing Clothes Order');

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        for (var item in items) {
          Map<String, dynamic> newItem = {
            ...item,
            // 'price': 0, // Custom price field
            // 'quantity': 0, // Custom quantity field
            'userId': userId,
            // Add logged-in user's ID
            // 'name': '${Fieldname}',
            'name': name,
            'date': currentDate,
            'Total': total,
            'orderstatus': '',
            'email': email,
            // 'name': displayStatusOrder().asStream(),
          };
          await cardCollection.add(newItem);
        }
        showMyDialog(context);
        items.length = 0;
        notifyListeners();
      } else {
        Fluttertoast.showToast(
          msg: 'No logged-in user.',
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'There is no order',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
    isLoading = false;
    notifyListeners();
  }

// //check out suit
  void checkoutSuits(BuildContext context, String name, String email) async {
    isLoading = true;
    var today = DateTime.now();

    var dateFormat = DateFormat('dd-MM-yyyy');

    String currentDate = dateFormat.format(today);
    notifyListeners();
    if (items.isNotEmpty) {
      CollectionReference cardCollection =
          FirebaseFirestore.instance.collection('Suits Order');

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        for (var item in items) {
          Map<String, dynamic> newItem = {
            ...item,
            // 'price': 0, // Custom price field
            // 'quantity': 0, // Custom quantity field
            'userId': userId,
            // Add logged-in user's ID
            // 'name': '${Fieldname}',
            'name': name,
            'date': currentDate,
            'Total': total,
            'orderstatus': '',
            'email': email,
            // 'name': displayStatusOrder().asStream(),
          };
          await cardCollection.add(newItem);
        }
        showMyDialog(context);
        items.length = 0;
        notifyListeners();
      } else {
        Fluttertoast.showToast(
          msg: 'No logged-in user.',
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'There is no order',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
    isLoading = false;
    notifyListeners();
  }

  Widget showAddToCartLotty() {
    return Lottie.asset(
      'assets/add-to-cart.json',
      // 'assets/bag.svg',
      width: 150,
      height: 150,
    );
  }

  ///showing added to cart dialog
  void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a timer that will automatically close the dialog after 3 seconds
        Timer(const Duration(seconds: 3), () {
          Navigator.of(context).pop(); // Close the dialog
        });

        return SizedBox(
          width: 200,
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/add-to-cart.json',
                  // 'assets/bag.svg',
                  width: 200,
                  height: 200,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // // here is function to get docid
  // String? documentid;
  // Future<void> getcompltedorder(String name) async {
  //   try {
  //     CollectionReference collectionRef =
  //         FirebaseFirestore.instance.collection(collectionName);
  //     QuerySnapshot querySnapshot =
  //         await collectionRef.where('orderstatus', isEqualTo: name).get();
  //     for (var doc in querySnapshot.docs) {
  //       documentid = doc.id;
  //       print('Documnetn ID of Order: $documentid');
  //       // print('Documentid waa : $documentid');
  //       notifyListeners();
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     print('The erro waa: ${e.toString()}');
  //   }
  // }

  // //update orderSate
  // var collectionName = "cart_wash_orders";
  // Future<void> updateorderstate() async {
  //   try {
  //     CollectionReference ref =
  //         FirebaseFirestore.instance.collection(collectionName);

  //     ref.doc(documentid).update({'orderstatus': 'Ongoing'});
  //   } on FirebaseAuthException catch (e) {
  //     print('The erro waa: ${e.toString()}');
  //   }
  // }
}

class ProductProvider extends ChangeNotifier {
  List<OnItems> products = [
    OnItems(
      id: 1,
      imgcloth: const AssetImage("assets/jeans.jpg"),
      pricecloth: "2",
      typecloth: 'Jeans',
    ),
    OnItems(
        id: 2,
        imgcloth: const AssetImage("assets/shoes.jpg"),
        pricecloth: "3.5",
        typecloth: 'Shoes'),
    OnItems(
        id: 3,
        imgcloth: const AssetImage("assets/shirt.jpg"),
        pricecloth: "1",
        typecloth: 'Shirt'),
    OnItems(
        id: 4,
        imgcloth: const AssetImage("assets/macawiis.jpg"),
        pricecloth: "5",
        typecloth: 'Macawiis'),
    OnItems(
        id: 4,
        imgcloth: const AssetImage("assets/shirt.jpg"),
        pricecloth: "1",
        typecloth: 'Shirt'),
  ];
}
