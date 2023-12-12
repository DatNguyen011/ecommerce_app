import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../model/product.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};
  static List<ProductModel> _productsList = [];
  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> _searchList = _productsList
        .where(
          (element) =>
          element.title.toLowerCase().contains(
            searchText.toLowerCase(),
          ),
    )
        .toList();
    return _searchList;
  }
  List<ProductModel> get getProducts {
    return _productsList;
  }
  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      _productsList = [];
      // _productsList.clear();
      productSnapshot.docs.forEach((element) {
        _productsList.insert(
            0,
            ProductModel(
              id: element.get('id'),
              title: element.get('title'),
              imageUrl: element.get('imageUrl'),
              productCategoryName: element.get('productCategoryName'),
              price: double.parse(
                element.get('price').toString(),
              ),
              salePrice: element.get('salePrice') is int
                  ? double.parse(element.get('salePrice').toString())
                  : element.get('salePrice'),
              // salePrice: 0.1,
              isOnSale: element.get('isOnSale'),
              isPiece: element.get('isPiece'),
              quantity: element.get('number'),
            ));
      });
    });
    notifyListeners();
  }
  getFormData(
      {String? productName,
        int? productPrice,
        int? productQuantity,
        String? productDescription,
        String? category,
        DateTime? scheduleTime,
        List<String>? imageUrlList}) {
    if (category != null) {
      productData['category'] = category;
    }
    notifyListeners();
  }

  clearData() {
    productData.clear();
    notifyListeners();
  }
}
