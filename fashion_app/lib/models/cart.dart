import 'package:flutter/cupertino.dart';

class CartModel with ChangeNotifier {
  final String id, productId, address, phone, payments, state;
  final int quantity;


  CartModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.address,
    required this.phone,
    required this.payments,
    required this.state,
  });
}