import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product/product.dart';

class ProductService {
  final FirebaseFirestore firestore;

  ProductService({
    FirebaseFirestore? firebaseFirestore,
  }) : firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<Product>> getAllProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('products').get();
      return querySnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('products').doc(id).get();
      if (doc.exists) {
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
