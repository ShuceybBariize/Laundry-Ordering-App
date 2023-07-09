// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart_Modal.dart';

class FirestoreDB {
  // Initialise Firebase Cloud Firestore

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<ProductItem>> getAllProducts() {
    return _firebaseFirestore
        .collection('productDB')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map<ProductItem>((doc) => ProductItem.fromDocumentSnapshot(doc))
          .toList();
    });
  }
}
