import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../consts/colors.dart';
import '../widgets/back_widget.dart';
import '../widgets/text_widget.dart';


class OrderDetailWidget extends StatefulWidget {
  final double price;
  final String productId, orderId, userId, imageUrl, userName, billId, phone, address, state;
  final int quantity;
  final String orderDate;

  const OrderDetailWidget({
    Key? key,
    required this.price,
    required this.productId,
    required this.orderId,
    required this.userId,
    required this.imageUrl,
    required this.userName,
    required this.billId,
    required this.phone,
    required this.address,
    required this.state,
    required this.quantity,
    required this.orderDate,
  }) : super(key: key);

  @override
  State<OrderDetailWidget> createState() => _OrderDetailWidgetState();
}

class _OrderDetailWidgetState extends State<OrderDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: AppColor.primaryColor,
        leading: const BackWidget(),
        elevation: 2,
        centerTitle: false,
        title: TextWidget(
          text: 'Đơn của bạn',
          color: Colors.white,
          textSize: 24.0,
          isTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã Đơn Hàng: ${widget.orderId}',style: const TextStyle(fontSize: 16),),
            SizedBox(height: 8),
            Text('Ngày Đặt Hàng: ${widget.orderDate}',style: const TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            // Text('Tên Sản Phẩm: $productName'),
            // SizedBox(height: 8),
            Text('Số Lượng: ${widget.quantity}',style: const TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Đơn Giá: ${widget.price} đồng',style: const TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Người Đặt: ${widget.userName}',style: const TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Số Điện Thoại: ${widget.phone}',style: const TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Địa Chỉ: ${widget.address}',style: const TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Trạng Thái: ${widget.state}',style: const TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Mã Bill: ${widget.billId}',style: const TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Image.network(widget.imageUrl, height: 200, width: 200), // Ảnh sản phẩm
          ],
        ),
      ),
    );
  }
}
