import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


import '../services/global_method.dart';
import '../services/utils.dart';
import 'orders_detail.dart';
import 'text_widget.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget(
      {Key? key,
        required this.state,
        //required this.productName,
        required this.orderId,
        required this.phone,
        required this.address,
        required this.billId,
        required this.price,
        required this.totalPrice,
        required this.productId,
        required this.userId,
        required this.imageUrl,
        required this.userName,
        required this.quantity,
        required this.orderDate})
      : super(key: key);

  final double price, totalPrice;
  final String productId,orderId, userId, imageUrl, userName, billId, phone, address, state;
  final int quantity;
  final Timestamp orderDate;
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late String orderDateStr;
  @override
  void initState() {
    var postDate = widget.orderDate.toDate();
    orderDateStr = '${postDate.day}/${postDate.month}/${postDate.year}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;
    final colorCard = Utils(context).colorCard;
    var formatter = NumberFormat('###,###,###');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: colorCard,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                  widget.imageUrl,

                  fit: BoxFit.fill,
                  // height: screenWidth * 0.15,
                  // width: screenWidth * 0.15,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text:
                      '${(widget.quantity)}X Cho ₫${formatter.format(widget.price)}',
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'Khách hàng:',
                            color: Colors.blue,
                            textSize: 16,
                            isTitle: true,
                          ),
                          Text('  ${widget.userName}')
                        ],
                      ),
                    ),
                    Text(
                      orderDateStr,
                    )
                  ],
                ),
              ),
              Spacer(),
              TextButton(onPressed: ()async{

                await FirebaseFirestore.instance
                    .collection('orders')
                    .where('billId', isEqualTo: widget.billId)
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) async {
                    await documentSnapshot.reference.update({'state': 'Đã xác nhận'});
                  });
                });
              },style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (widget.state == 'Chờ xác nhận') {
                    return Colors.yellow;
                  } else if (widget.state == 'Đã xác nhận') {
                    return Colors.green;
                  } else {
                    return Colors.grey;
                  }
                }),
              ), child: Text(widget.state,style: const TextStyle(
                color: Colors.white,
              ),)),
              PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        deleteProduct();
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                      value: 1,
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
  void deleteProduct() async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .where('billId', isEqualTo: widget.billId)
          .get().then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) async{
              await doc.reference.delete();
            });
      });

      Fluttertoast.showToast(
        msg: 'Đã xóa sản phẩm thành công',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        // textColor: Colors.white,
        // fontSize: 16.0,
      );

      // setState(() {
      //   //getOrderData();
      // });
    } catch (error) {

      Fluttertoast.showToast(
        msg: 'Xóa sản phẩm không thành công: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        // fontSize: 16.0,
      );
    }
  }
}