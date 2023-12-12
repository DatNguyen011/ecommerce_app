import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderAdvanced> orders = [];

  List<OrderAdvanced> get getOrders => orders;

  Future<List<OrderAdvanced>> fetchOrder() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var uid = user!.uid;
    try {
      await FirebaseFirestore.instance
          .collection("orderAdvanced")
          .where('userId', isNotEqualTo: uid)
          .orderBy('orderDate', descending: false)
          .get()
          .then((orderSnapshot) {
        orders.clear();
        for (var element in orderSnapshot.docs) {
          orders.insert(
              0,OrderAdvanced(
              orderId: element.get('orderId'),
              userId: element.get('userId'),
              productId: element.get('productId'),
              productTitle: element.get('productTitle').toString(),
              userName: element.get('userName'),
              price: element.get('price').toString(),
              imageUrl: element.get('imageUrl'),
              quantity: element.get('quantity').toString(),
              orderDate: element.get('orderDate'), ));
        }
      });
      return orders;
    } catch (e) {
      rethrow;
    }
  }
}
