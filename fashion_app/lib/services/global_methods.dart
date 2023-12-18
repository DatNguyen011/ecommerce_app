import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../consts/firebase_const.dart';
import '../widgets/text_widget.dart';

class GlobalMethods {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              Image.asset(
                'assets/images/warning-sign.png',
                height: 20,
                width: 20,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(title),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.cyan,
                  text: 'Cancel',
                  textSize: 18,
                ),
              ),
              TextButton(
                onPressed: () {
                  fct();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.red,
                  text: 'OK',
                  textSize: 18,
                ),
              ),
            ],
          );
        });
  }

  static Future<void> errorDialog({
    required String subtitle,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              Image.asset(
                'assets/images/warning-sign.png',
                height: 20,
                width: 20,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text('Đã xảy ra lỗi'),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.cyan,
                  text: 'Ok',
                  textSize: 18,
                ),
              ),
            ],
          );
        });
  }

  static Future<void> addToCart(
      {required String productId,
        required int quantity,
        required BuildContext context}) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final cartId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': quantity,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: "Mục đã được thêm vào giỏ hàng của bạn",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (error) {
      errorDialog(subtitle: error.toString(), context: context);
    }
  }
  static Future<void> updateProductAdd({required String productId,required BuildContext context,
    required int addQuantity, required int quantity}) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({
        'number': '${quantity-addQuantity}',
      });
    } catch (error) {
      // Xử lý lỗi nếu có
      print('Lỗi khi cập nhật thông tin sản phẩm: $error');
    }
  }

  static Future<void> deleteProductOrder({required String billId,required BuildContext context}) async {
    try {
      // Bước 1: Truy vấn đơn đặt hàng với cùng một billId
      QuerySnapshot ordersQuery = await FirebaseFirestore.instance.collection('orders').where('billId', isEqualTo: billId).get();

      // Bước 2: Xử lý từng đơn đặt hàng và tăng giá trị số lượng tương ứng của sản phẩm
      for (QueryDocumentSnapshot orderDoc in ordersQuery.docs) {
        String productId = orderDoc['productId'];
        int quantity = orderDoc['quantity'];
        print(quantity);
        print(productId);
        // Bước 3: Tăng giá trị numberProduct trong bộ sưu tập products
        await FirebaseFirestore.instance.collection('products').doc(productId).update({
          'number': FieldValue.increment(quantity),
        });
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      print('Lỗi khi cập nhật thông tin sản phẩm: $error');
    }
  }
  static Future<void> addToWishlist(
      {required String productId, required BuildContext context}) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final wishlistId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      });
      // await Fluttertoast.showToast(
      //   msg: "Item has been added to your wishlist",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      // );
    } catch (error) {
      errorDialog(subtitle: error.toString(), context: context);
    }
  }
}