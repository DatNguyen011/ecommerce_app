import 'package:flutter/cupertino.dart';

class ProductModel with ChangeNotifier{
  final String id, title, imageUrl, productCategoryName,quantity;
  final double price, salePrice ;
  final bool isOnSale, isPiece;

  ProductModel(
      {required this.id,
        required this.title,
        required this.imageUrl,
        required this.productCategoryName,
        required this.price,
        required this.salePrice,
        required this.quantity,
        required this.isOnSale,
        required this.isPiece});
}