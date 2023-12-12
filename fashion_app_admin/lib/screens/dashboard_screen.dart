import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app_admin/consts/colors.dart';
import 'package:fashion_app_admin/inner_screen/analysis.dart';
import 'package:fashion_app_admin/widgets/user_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../consts/constants.dart';
import '../inner_screen/add_prod.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/orders_list.dart';
import '../widgets/text_widget.dart';
import '../controllers/menucontroller.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/DashboardScreen';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int countProducts = 0;
  int countOrders = 0;
  int countTotalPrices=0;
  //Map<String, int> result = await countOrder();
  @override
  void initState() {
    fetchData();
    // countOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;
    var formatter = NumberFormat('###,###,###');
    final menuProvider = Provider.of<MenuControllers>(context);
    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              fct: () {
                menuProvider.controlDashboardMenu();
              },
              title: 'Trang chủ',
            ),
            // AnalysisApp(),
            const SizedBox(
              height: 20,
            ),
            // TextWidget(
            //   text: 'Tổng Quan',
            //   textSize: 30,
            //   isTitle: true,
            //   color: color,
            // ),

            const SizedBox(
              height: 15,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: '   Thống kê',
                        textSize: 16,
                        color: color,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Tổng số sản phẩm',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '$countProducts',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Số lượng đơn hàng',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  '$countOrders',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Tổng doanh thu',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  '${formatter.format(countTotalPrices)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextWidget(
                        textSize: 16,
                        text: '   Sản phẩm',
                        color: color,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Responsive(
                        mobile: ProductGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 5,
                          childAspectRatio: size.width < 650 && size.width > 350
                              ? 0.65
                              : 0.65,
                        ),
                        desktop: ProductGridWidget(
                          crossAxisCount: 6,
                          childAspectRatio: size.width < 1400 ? 0.65 : 0.65,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextWidget(
                        textSize: 16,
                        text: '   Đơn hàng',
                        color: color,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const OrdersList(),
                      const SizedBox(
                        height: 20,
                      ),
                      TextWidget(
                        textSize: 16,
                        text: '   Người dùng',
                        color: color,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const UserList(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<int> countProduct() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      int documentCount = querySnapshot.size;
      print(documentCount);
      return documentCount;
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
      rethrow;
    }
  }



  Future<Map<String, int>> countOrder() async {
    try {
      // Thực hiện truy vấn để lấy dữ liệu từ Firestore collection 'orders'
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      // Map để lưu tổng của từng billId
      Map<String, int> billIdTotals = {};

      // Lặp qua các document trong collection
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Lấy dữ liệu của document
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        // Lấy giá trị của trường 'billId'
        String billId = data['billId'];

        // Kiểm tra xem billId đã tồn tại trong Map chưa
        if (billIdTotals.containsKey(billId)) {
          // Nếu đã tồn tại, thì cộng giá trị vào tổng của billId đó
          billIdTotals[billId] = billIdTotals[billId]! +
              1; // Đổi giá trị này tùy vào yêu cầu thực tế của bạn
        } else {
          // Nếu chưa tồn tại, thêm billId vào Map với giá trị là 1 (hoặc giá trị tùy thuộc vào yêu cầu của bạn)
          billIdTotals[billId] = 1;
        }
      }
      print(billIdTotals);
      // Trả về Map chứa tổng của từng billId
      return billIdTotals;
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
      // Trả về Map trống nếu có lỗi
      return {};
    }
  }
  Future<int> countTotalPrice() async {
    try {
      // Thực hiện truy vấn để lấy dữ liệu từ Firestore collection 'orders'
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('orders').get();

      // Biến để lưu tổng giá trị totalPrice
      int totalPriceTotal = 0;

      // Lặp qua các document trong collection
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Lấy dữ liệu của document
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        // Lấy giá trị của trường 'totalPrice'
        int totalPrice = data['price'];

        // Cộng giá trị vào tổng
        totalPriceTotal += totalPrice;
      }

      // Trả về tổng giá trị totalPrice
      return totalPriceTotal;
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
      // Trả về 0 nếu có lỗi
      return 0;
    }
  }
  Future<void> fetchData() async {
    try {
      int product = await countProduct();
      int total=await countTotalPrice();
      Map<String, int> result = await countOrder();
      setState(() {
        countOrders= result.length;
        countProducts = product;
        countTotalPrices=total;
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}
