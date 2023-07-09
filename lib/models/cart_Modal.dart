// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductItem {
  final String? id;
  final String clothid;
  final String clothName;
  final int initialPrice;
  final int clothPrice;
  final int quantity;
  final String imageUrl;

  ProductItem({
    this.id,
    required this.clothid,
    required this.clothName,
    required this.initialPrice,
    required this.clothPrice,
    required this.quantity,
    required this.imageUrl,
  });

  ProductItem.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> res)
      : id = res['id'],
        clothid = res.data()!["clothid"],
        clothName = res.data()!["clothName"],
        initialPrice = res.data()!["initialPrice"],
        clothPrice = res.data()!["clothPrice"],
        quantity = res.data()!["quantity"],
        imageUrl = res.data()!["imageUrl"];

  Map<String, dynamic> toMap() {
    return {
      'clothid': clothid,
      'clothName': clothName,
      'initialPrice': initialPrice,
      'clothPrice': clothPrice,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}
