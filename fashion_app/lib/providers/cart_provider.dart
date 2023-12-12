import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../consts/firebase_const.dart';
import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  // void addProductsToCart({
  //   required String productId,
  //   required int quantity,
  // }) {
  //   _cartItems.putIfAbsent(
  //     productId,
  //     () => CartModel(
  //       id: DateTime.now().toString(),
  //       productId: productId,
  //       quantity: quantity,
  //     ),
  //   );
  //   notifyListeners();
  // }

  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchCart() async {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();

    if (userDoc.exists) {
      final userCart = userDoc.get('userCart');

      if (userCart != null && userCart is List) {
        final leng = userCart.length;

        for (int i = 0; i < leng; i++) {
          _cartItems.putIfAbsent(
            userCart[i]['productId'],
                () => CartModel(
              id: userCart[i]['cartId'],
              productId: userCart[i]['productId'],
              quantity: userCart[i]['quantity'],
                  address: '',
                  phone: '',
                  payments: '',
                  state: '',
            ),
          );
        }
      }
    }

    notifyListeners();
  }


  void reduceQuantityByOne(String productId) {
    _cartItems.update(
      productId,
          (value) => CartModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity - 1,
            address: '', phone: '', payments: '', state: '',
      ),
    );

    notifyListeners();
  }

  void increaseQuantityByOne(String productId) {
    _cartItems.update(
      productId,
          (value) => CartModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity + 1, address: '', phone: '', payments: '', state: '',
      ),
    );
    notifyListeners();
  }

  Future<void> removeOneItem(
      {required String cartId,
        required String productId,
        required int quantity,required int removeQuantity}) async {
    final User? user = authInstance.currentUser;
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({
      'number': '$quantity',
    });
    await userCollection.doc(user!.uid).update({
      'userCart': FieldValue.arrayRemove([
        {'cartId': cartId, 'productId': productId, 'quantity': removeQuantity}
      ])
    });
    _cartItems.remove(productId);
    await fetchCart();
    notifyListeners();
  }

  Future<void> clearOnlineCart() async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userCart': [],
    });
    _cartItems.clear();
    notifyListeners();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }
}