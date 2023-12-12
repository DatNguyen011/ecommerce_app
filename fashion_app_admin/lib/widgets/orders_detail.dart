import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app_admin/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/menucontroller.dart';
import '../responsive.dart';
import 'header.dart';

class OrderDetailWidget extends StatelessWidget {
  final double price, totalPrice;
  final String productId, orderId, userId, imageUrl, userName, billId, phone, address, state;
  final int quantity;
  final Timestamp orderDate;

  const OrderDetailWidget({
    Key? key,
    required this.price,
    
    required this.totalPrice,
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuControllers>().getDetailOrdersScaffoldKey,
      drawer: const SideMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: SideMenu(),
            ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(
                    showTexField: false,
                    fct: () {
                      context.read<MenuControllers>().controlGetDetailOrderMenu();
                    },
                    title: 'Chi tiết đơn hàng',
                  ),
                  Text('Mã Đơn Hàng: $orderId',style: const TextStyle(fontSize: 16),),
                  SizedBox(height: 8),
                  Text('Ngày Đặt Hàng: ${DateFormat('dd/MM/yyyy HH:mm').format(orderDate.toDate())}',style: const TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  // Text('Tên Sản Phẩm: $productName'),
                  // SizedBox(height: 8),
                  Text('Số Lượng: $quantity',style: const TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Đơn Giá: $price đồng',style: const TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Tổng Tiền: $totalPrice đồng',style: const TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Người Đặt: $userName',style: const TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Số Điện Thoại: $phone',style: const TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Địa Chỉ: $address',style: const TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Trạng Thái: $state',style: const TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Mã Bill: $billId',style: const TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Image.network(imageUrl, height: 200, width: 200), // Ảnh sản phẩm
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
