import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fashion_app/inner_screens/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/product_details.dart';
import '../../models/order.dart';
import '../../providers/orders_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('###,###,###');
    final ordersModel = Provider.of<OrderModel>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(ordersModel.productId);
    // final ordersProvider = Provider.of<OrdersProvider>(context);
    // final getCurrOrder = productProvider.findProdById(ordersModel.productId);
    void deleteOrder() async {
      try {
        await FirebaseFirestore.instance
            .collection('orders')
            .where('billId', isEqualTo: ordersModel.billId)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) async {
            // String productId = doc['productId'];
            // int quantity = doc['quantity'];
            // print(quantity);
            // print(productId);
            // String currentNumberString = doc['number'];
            // int currentNumber = int.parse(currentNumberString);
            // int newNumber = currentNumber + quantity;
            // String newNumberString = newNumber.toString();
            // await FirebaseFirestore.instance.collection('products').doc(productId).update({
            //   'number': newNumberString,
            // });

            // Step 6: Delete the order
            await doc.reference.delete();
          });
        });

        Fluttertoast.showToast(
          msg: 'Đã xóa sản phẩm thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
        );
      } catch (error) {
        Fluttertoast.showToast(
          msg: 'Xóa sản phẩm không thành công: $error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
    Future<void> showDeleteConfirmationDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Xác Nhận Xóa'),
            content: Text('Bạn có chắc chắn muốn xóa không?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại
                },
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  deleteOrder();
                  // Đóng hộp thoại
                  Navigator.of(context).pop();
                },
                child: Text('Xác Nhận'),
              ),
            ],
          );
        },
      );
    }
    return ListTile(
      subtitle:
          Text('Giá: \₫${formatter.format(double.parse(ordersModel.price))}'),
      onLongPress: (){
        showDeleteConfirmationDialog(context);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailWidget(
              price: double.parse(ordersModel.price),
              productId: ordersModel.productId,
              userId: ordersModel.userId,
              quantity: int.parse(ordersModel.quantity),
              orderDate: orderDateToShow,
              imageUrl: ordersModel.imageUrl,
              userName: ordersModel.userName,
              state: ordersModel.state,
              phone: ordersModel.phone,
              address: ordersModel.address,
              billId: ordersModel.billId,
              orderId: ordersModel.orderId,
            ),
          ),
        );
      },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl: getCurrProduct.imageUrl,
        boxFit: BoxFit.fill,
      ),
      title: TextWidget(
          text: '${getCurrProduct.title}  x${ordersModel.quantity}',
          color: color,
          textSize: 18),
      trailing: Column(
        children: [
          TextWidget(text: orderDateToShow, color: color, textSize: 18),
          // Row(
          //   children: [
          //     Text(ordersModel.state == 'Chờ xác nhận'?'Chờ xác nhận':'Đã xác nhận',
          //       style: TextStyle(fontSize: 12, color: color),),
          //     ordersModel.state == 'Chờ xác nhận'? Icon(Icons.brightness_1,color: Colors.yellow,)
          //         :Icon(Icons.brightness_1,color: Colors.green,)
          //   ],
          // )
          SizedBox(
            height: 5,
          ),
          Text(
            ordersModel.state == 'Chờ xác nhận'
                ? 'Chờ xác nhận'
                : 'Đã xác nhận',
            style: TextStyle(fontSize: 12, color: color),
          ),
          // TextButton(onPressed: ()async{
          // },style: ButtonStyle(
          //   backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          //     if (ordersModel.state == 'Chờ xác nhận') {
          //       return Colors.yellow;
          //     } else if (ordersModel.state == 'Đã xác nhận') {
          //       return Colors.green;
          //     } else {
          //       return Colors.grey;
          //     }
          //   }),
          // ), child: Text(ordersModel.state,style: const TextStyle(
          //   color: Colors.white,
          // ),)),
        ],
      ),
    );
  }


}
