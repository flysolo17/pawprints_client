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
      final querySnapshot = await firestore
          .collection("carts")
          .where("userID", isEqualTo: cart.userID)
          .where("productID", isEqualTo: cart.productID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the item is already in the cart, increment the quantity
        final existingCartDoc = querySnapshot.docs.first;
        final existingCart = Cart.fromJson(existingCartDoc.data());
        final newQuantity = existingCart.quantity + 1;

        await firestore
            .collection("carts")
            .doc(existingCart.id)
            .update({"quantity": newQuantity});
      } else {
        // If the item is not in the cart, add it to the cart
        await firestore.collection('carts').doc(cart.id).set(cart.toJson());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Get cart items with product details by user ID
  Stream<List<CartWithProduct>> getCartWithProductByUserID() async* {
    User? user = auth.currentUser;
    if (user == null) {
      yield [];
      return;
    }

    yield* firestore
        .collection('carts')
        .where('userID', isEqualTo: user.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Cart> cartItems = snapshot.docs
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
    });
  }

  // Remove from cart
  Future<void> removeFromCart(String id) async {
    try {
      await firestore.collection('carts').doc(id).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> increaseQuantity(String cartID) {
    return firestore.collection("carts").doc(cartID).update({
      "quantity": FieldValue.increment(1),
    });
  }

  Future<void> decreaseQuantity(String cartID) {
    return firestore.collection("carts").doc(cartID).update({
      "quantity": FieldValue.increment(-1),
    });
  }
}
