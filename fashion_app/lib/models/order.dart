import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderModel with ChangeNotifier {
  final String orderId, userId, productId, userName, price, imageUrl, quantity, billId, state, address, phone;
  final Timestamp orderDate;

  OrderModel(
      {required this.orderId,
        required this.userId,
        required this.productId,
        required this.userName,
        required this.price,
        required this.imageUrl,
        required this.quantity,
        required this.billId,
        required this.state,
        required this.address,
        required this.phone,
        required this.orderDate});

  double calculateTotalPrice() {
    // Chuyển đổi giá và số lượng từ String sang double và int
    double parsedPrice = double.parse(price);
    int parsedQuantity = int.parse(quantity);

    // Tính tổng tiền
    return parsedPrice * parsedQuantity;
  }
}