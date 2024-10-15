import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawprints/services/product.service.dart';

import '../models/cart/cart.dart';
import '../models/cart/cart_with_product.dart';
import '../models/product/product.dart';

class CartService {
  final FirebaseFirestore firestore;
  final ProductService productService;
  final FirebaseAuth auth;
  CartService({
    FirebaseFirestore? firebaseFirestore,
    ProductService? productService,
    FirebaseAuth? firebaseAuth,
  })  : firestore = firebaseFirestore ?? FirebaseFirestore.instance,
        auth = firebaseAuth ?? FirebaseAuth.instance,
        productService = productService ?? ProductService();

  Future<void> addToCart(Cart cart) async {
    try {
      await firestore.collection('carts').doc(cart.id).set(cart.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  // Get cart items with product details by user ID
  Future<List<CartWithProduct>> getCartWithProductByUserID() async {
    try {
      User? user = auth.currentUser;
      if (user == null) {
        return [];
      }
      QuerySnapshot querySnapshot = await firestore
          .collection('carts')
          .where('userID', isEqualTo: user.uid)
          .get();
      List<Cart> cartItems = querySnapshot.docs
          .map((doc) => Cart.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      List<CartWithProduct> cartWithProducts = [];
      for (Cart cart in cartItems) {
        Product? product = await productService.getProductById(cart.productID!);
        if (product != null) {
          cartWithProducts.add(CartWithProduct(cart: cart, product: product));
        }
      }
      return cartWithProducts;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Remove from cart
  Future<void> removeFromCart(String id) async {
    try {
      await firestore.collection('carts').doc(id).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
