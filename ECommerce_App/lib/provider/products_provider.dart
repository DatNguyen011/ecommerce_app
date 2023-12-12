import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';


class ProductsProvider with ChangeNotifier {
  List<Product> products = [];
  List<Product> get getProducts {
    return products;
  }

  Product? findByProdId(String productId) {
    if (products.where((element) => element.productId == productId).isEmpty) {
      return null;
    }
    return products.firstWhere((element) => element.productId == productId);
  }

  List<Product> findByCategory({required String categoryName}) {
    List<Product> categoryList = products
        .where(
          (element) => element.productCategory.toLowerCase().contains(
        categoryName.toLowerCase(),
      ),
    )
        .toList();
    return categoryList;
  }

  List<Product> searchQuery(
      {required String searchText, required List<Product> passedList}) {
    List<Product> searchList = passedList
        .where(
          (element) => element.productTitle.toLowerCase().contains(
        searchText.toLowerCase(),
      ),
    )
        .toList();
    return searchList;
  }

  final productDb = FirebaseFirestore.instance.collection("products");
  Future<List<Product>> fetchProducts() async {
    try {
      await productDb
          .orderBy('createdAt', descending: false)
          .get()
          .then((productSnapshot) {
        products.clear();
        // products = []
        for (var element in productSnapshot.docs) {
          products.insert(0, Product.fromFirestore(element));
        }
      });
      notifyListeners();
      return products;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Product>> fetchProductsStream() {
    try {
      return productDb.snapshots().map((snapshot) {
        products.clear();
        // products = []
        for (var element in snapshot.docs) {
          products.insert(0, Product.fromFirestore(element));
        }
        return products;
      });
    } catch (e) {
      rethrow;
    }
  }
}