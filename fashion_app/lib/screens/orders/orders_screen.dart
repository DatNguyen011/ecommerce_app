import 'package:fashion_app/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/order.dart';
import '../../providers/orders_provider.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'orders_widget.dart';

// ... (your existing imports)

// ... (your existing imports)

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}
class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;

    // Tạo một Map để lưu trữ danh sách các sản phẩm theo billId
    Map<String, List<OrderModel>> groupedOrders = {};

    // Lặp qua danh sách hóa đơn và gộp chúng dựa trên billId
    ordersList.forEach((order) {
      if (groupedOrders.containsKey(order.billId)) {
        // Nếu đã có một danh sách sản phẩm cho billId này, thêm sản phẩm vào đó
        groupedOrders[order.billId]!.add(order);
      } else {
        // Nếu chưa có danh sách sản phẩm cho billId này, tạo một danh sách mới và thêm sản phẩm vào đó
        groupedOrders[order.billId] = [order];
      }
    });

    return FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return ordersList.isEmpty
              ? const EmptyScreen(
            title: 'Bạn chưa đặt đơn hàng nào',
            subtitle: 'đặt cái gì đó',
            buttonText: 'Mua ngay',
            imagePath: 'assets/images/cart.png',
          )
              : Scaffold(
              appBar: AppBar(
                toolbarHeight: 70,
                backgroundColor: AppColor.primaryColor,
                leading: const BackWidget(),
                elevation: 2,
                centerTitle: false,
                title: TextWidget(
                  text: 'Đơn của bạn (${groupedOrders.length})',
                  color: Colors.white,
                  textSize: 24.0,
                  isTitle: true,
                ),
              ),
              body: ListView.separated(
                itemCount: groupedOrders.length,
                itemBuilder: (ctx, index) {
                  List<OrderModel> orders = groupedOrders.values.elementAt(index);

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Set the border radius here
                      side: BorderSide(color: AppColor.primaryColor), // Specify the border color here
                    ),
                    elevation: 0,
                    color: Theme.of(context).canvasColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...orders.map((order) => ChangeNotifierProvider.value(
                            value: order,
                            child: const OrderWidget(),
                          )),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 1,);
                },
              ));
        });
  }
}

// class _OrdersScreenState extends State<OrdersScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final Color color = Utils(context).color;
//     // Size size = Utils(context).getScreenSize;
//     final ordersProvider = Provider.of<OrdersProvider>(context);
//     final ordersList = ordersProvider.getOrders;
//     return FutureBuilder(
//         future: ordersProvider.fetchOrders(),
//         builder: (context, snapshot) {
//           return ordersList.isEmpty
//               ? const EmptyScreen(
//             title: 'You didnt place any order yet',
//             subtitle: 'order something and make me happy :)',
//             buttonText: 'Shop now',
//             imagePath: 'assets/images/cart.png',
//           )
//               : Scaffold(
//               appBar: AppBar(
//                 leading: const BackWidget(),
//                 elevation: 0,
//                 centerTitle: false,
//                 title: TextWidget(
//                   text: 'Your orders (${ordersList.length})',
//                   color: color,
//                   textSize: 24.0,
//                   isTitle: true,
//                 ),
//                 backgroundColor: Theme.of(context)
//                     .scaffoldBackgroundColor
//                     .withOpacity(0.9),
//               ),
//               body: ListView.separated(
//                 itemCount: ordersList.length,
//                 itemBuilder: (ctx, index) {
//                   return Card(
//                     color: Theme.of(context).canvasColor,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 2, vertical: 6),
//                       child: ChangeNotifierProvider.value(
//                         value: ordersList[index],
//                         child: const OrderWidget(),
//                       ),
//                     ),
//                   );
//                 },
//                 separatorBuilder: (BuildContext context, int index) {
//                   return SizedBox(height: 1,);
//                 },
//               ));
//         });
//   }
// }