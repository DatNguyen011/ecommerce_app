import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../consts/constants.dart';
import '../services/utils.dart';
import 'orders_detail.dart';
import 'orders_widget.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({Key? key, this.isInDashboard = true}) : super(key: key);
  final bool isInDashboard;

  @override
  Widget build(BuildContext context) {
    final colorCard = Utils(context).colorCard;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            // Map to group orders by billId
            final Map<String, List<Map<String, dynamic>>> groupedOrders =
            Map<String, List<Map<String, dynamic>>>();

            snapshot.data!.docs.forEach((order) {
              final String billId = order['billId'];

              if (groupedOrders.containsKey(billId)) {
                groupedOrders[billId]!.add(order.data() as Map<String, dynamic>);
              } else {
                groupedOrders[billId] = [order.data() as Map<String, dynamic>];
              }
            });

            // Build widgets based on grouped orders
            final List<Widget> orderWidgets = groupedOrders.entries
                .map((entry) {
              final String billId = entry.key;
              final List<Map<String, dynamic>> orders = entry.value;

              // Process orders as needed (you can customize this part)
              // ...

              return GestureDetector(
                onTap: (){
                  for (final order in orders){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailWidget(
                          price: order['price'],
                          totalPrice: order['totalPrice'],
                          productId: order['productId'],
                          userId: order['userId'],
                          quantity: order['quantity'],
                          orderDate: order['orderDate'],
                          imageUrl: order['imageUrl'],
                          userName: order['userName'],
                          state: order['state'],
                          phone: order['phone'],
                          address: order['address'],
                          billId: order['billId'],
                          orderId: order['orderId'],
                          // ... other fields
                        ),
                      ),
                    );
                  }

                },
                child: Column(
                  children: [
                    // Display information related to the group (if needed)
                    // ...

                    // Create OrdersWidgets based on the grouped orders
                    for (final order in orders)
                      OrdersWidget(
                        price: order['price'],
                        totalPrice: order['totalPrice'],
                        productId: order['productId'],
                        userId: order['userId'],
                        quantity: order['quantity'],
                        orderDate: order['orderDate'],
                        imageUrl: order['imageUrl'],
                        userName: order['userName'],
                        state: order['state'],
                        phone: order['phone'],
                        address: order['address'],
                        billId: order['billId'],
                        orderId: order['orderId'],
                        //productName: order['orderId'],
                      ),
                    const Divider(
                      thickness: 1,
                    ),
                  ],
                ),
              );
            })
                .toList();

            // Display the list of grouped order widgets
            return Card(
              child: Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: colorCard,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: orderWidgets,
                ),
              ),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('Cửa hàng của bạn trống'),
              ),
            );
          }
        }
        return const Center(
          child: Text(
            'Đã xảy ra lỗi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        );
      },
    );
  }
}
