import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/order.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrderModel> _orders = [];
  List<OrderModel> get getOrders {
    return _orders;
  }
  OrderModel findProdById(String orderId) {
    return _orders.firstWhere((element) => element.orderId == orderId);
  }
  Future<void> fetchOrders() async {
    final FirebaseAuth auth=FirebaseAuth.instance;
    User? user=auth.currentUser;
    var uid=user!.uid;
    await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('orderDate', descending: false)
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      _orders = [];
      // _orders.clear();
      ordersSnapshot.docs.forEach((element) {
        _orders.insert(
          0,
          OrderModel(
            orderId: element.get('orderId'),
            userId: element.get('userId'),
            productId: element.get('productId'),
            userName: element.get('userName'),
            price: element.get('price').toString(),
            imageUrl: element.get('imageUrl'),
            quantity: element.get('quantity').toString(),
            orderDate: element.get('orderDate'),
            billId: element.get('billId'),
            state: element.get('state'),
            address: element.get('address'),
            phone: element.get('phone'),
          ),
        );
      });
    });
    notifyListeners();
  }

}