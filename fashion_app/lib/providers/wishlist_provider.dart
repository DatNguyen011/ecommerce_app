import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../consts/firebase_const.dart';
import '../models/wishlist.dart';


class WishlistProvider with ChangeNotifier {
  Map<String, WishlistModel> _wishlistItems = {};

  Map<String, WishlistModel> get getWishlistItems {
    return _wishlistItems;
  }

  // void addRemoveProductToWishlist({required String productId}) {
  //   if (_wishlistItems.containsKey(productId)) {
  //     removeOneItem(productId);
  //   } else {
  //     _wishlistItems.putIfAbsent(
  //         productId,
  //         () => WishlistModel(
  //             id: DateTime.now().toString(), productId: productId));
  //   }
  //   notifyListeners();
  // }

  final userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> fetchWishlist() async {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();

    if (userDoc.exists) {
      final userWish = userDoc.get('userWish');

      if (userWish != null && userWish is List) {
        final leng = userWish.length;

        for (int i = 0; i < leng; i++) {
          _wishlistItems.putIfAbsent(
            userWish[i]['productId'],
                () => WishlistModel(
              id: userWish[i]['wishlistId'],
              productId: userWish[i]['productId'],
            ),
          );
        }
      }
    }

    notifyListeners();
  }

  Future<void> removeOneItem({
    required String wishlistId,
    required String productId,
  }) async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWish': FieldValue.arrayRemove([
        {
          'wishlistId': wishlistId,
          'productId': productId,
        }
      ])
    });
    _wishlistItems.remove(productId);
    await fetchWishlist();
    notifyListeners();
  }

  Future<void> clearOnlineWishlist() async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWish': [],
    });
    _wishlistItems.clear();
    notifyListeners();
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}