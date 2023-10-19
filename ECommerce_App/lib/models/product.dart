import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String productId,
      productTitle,
      productPrice,
      productCategory,
      productDescription,
      productImage,
      productQuantity;

  Product(
      {required this.productId,
      required this.productTitle,
      required this.productPrice,
      required this.productCategory,
      required this.productDescription,
      required this.productImage,
      required this.productQuantity,});
}
