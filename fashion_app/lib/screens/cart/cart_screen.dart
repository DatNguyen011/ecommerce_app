import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/consts/colors.dart';
import 'package:fashion_app/screens/account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../consts/firebase_const.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'cart_widget.dart';
import 'package:momo_vn/momo_vn.dart';
class CartScreen extends StatefulWidget {


  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}
final TextEditingController _addressTextController = TextEditingController(text: "");
final TextEditingController _phoneTextController = TextEditingController(text: "");
final TextEditingController _paymentTextController = TextEditingController(text: "Thanh toán khi nhận hàng");

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
    cartProvider.getCartItems.values.toList().reversed.toList();

    return cartItemsList.isEmpty
        ? const EmptyScreen(
      title: 'ohhh',
      subtitle: 'Giỏ của bạn trống trơn',
      buttonText: 'Mua ngay',
      imagePath: 'assets/images/box.png',
    )
        : Scaffold(
      appBar: AppBar(
          toolbarHeight: 70,
          automaticallyImplyLeading: false,
          elevation: 1,
          backgroundColor: AppColor.primaryColor,
          title: TextWidget(
            text: 'Giỏ hàng (${cartItemsList.length})',
            color: Colors.white,
            isTitle: true,
            textSize: 22,
          ),
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                    title: 'Xóa giỏ hàng của bạn?',
                    subtitle: 'Bạn có chắc không?',
                    fct: () async {
                      await cartProvider.clearOnlineCart();
                      cartProvider.clearLocalCart();
                    },
                    context: context);
              },
              icon: const Icon(
                IconlyLight.delete,
                color: Colors.white,
              ),
            ),
          ]),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItemsList.length,
              itemBuilder: (ctx, index) {
                return ChangeNotifierProvider.value(
                    value: cartItemsList[index],
                    child: CartWidget(
                      q: cartItemsList[index].quantity,
                    ));
              },
            ),
          ),
          _checkout(ctx: context),
        ],
      ),
    );
  }

  Widget _checkout({required BuildContext ctx}) {
    final formatter = NumberFormat('###,###,###');
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    final cartItemsList =
    cartProvider.getCartItems.values.toList().reversed.toList();
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
          ? getCurrProduct.salePrice
          : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      // color: ,
      child: Card(
        color: Theme.of(ctx).canvasColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            FittedBox(
              child: TextWidget(
                text: 'Tổng: ₫${formatter.format(total)}',
                color: color,
                textSize: 18,
                isTitle: true,
              ),
            ),
            const Spacer(),
            Material(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(6),
              child: TextButton(
                onPressed: () async {
                  await showDialog(
                      context: ctx,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Thông tin đơn hàng'),
                          content: Container(
                            width: size.width * 0.95,
                            height: size.width * 0.9,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormField(
                                  initialValue: APIs.me.name,
                                  decoration: InputDecoration(
                                    enabled: false,
                                      prefixIcon:
                                      const Icon(Icons.person, color: AppColor.primaryColor),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                      label: const Text('Tên')
                                  ),
                                ),
                                SizedBox(height: 20,),
                                TextFormField(
                                  initialValue: APIs.me.phone,
                                  validator: (val) => val != null && val.isNotEmpty
                                      ? null
                                      : 'Vui lòng nhập đủ',
                                  decoration: InputDecoration(
                                      enabled: false,
                                      prefixIcon:
                                      const Icon(Icons.phone, color: AppColor.primaryColor),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                      label: const Text('Sđt')
                                  ),
                                ),
                                SizedBox(height: 20,),
                                DropdownButtonFormField<String>(
                                  value: 'Khi nhận hàng',
                                  decoration: InputDecoration(
                                    enabled: false,
                                    prefixIcon: const Icon(Icons.payments, color: AppColor.primaryColor),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    labelText: 'Hình thức thanh toán',
                                  ),
                                  items: [
                                    'Khi nhận hàng',
                                    'Thanh toán Momo',
                                  ].map((String paymentMethod) {
                                    return DropdownMenuItem<String>(
                                      value: paymentMethod,
                                      child: Text(paymentMethod),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _paymentTextController.text = newValue;
                                      });
                                    }
                                  },
                                ),
                                SizedBox(height: 20,),
                                TextFormField(
                                  initialValue: APIs.me.address,
                                  validator: (val) => val != null && val.isNotEmpty
                                      ? null
                                      : 'Vui lòng nhập đủ',
                                  decoration: InputDecoration(
                                      enabled: false,
                                      prefixIcon:
                                      const Icon(Icons.location_on, color: AppColor.primaryColor),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                      label: const Text('Địa chỉ')
                                  ),
                                ),

                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, 'Hủy'),
                              child: const Text('Hủy',style: TextStyle(color: AppColor.primaryColor,fontWeight: FontWeight.w600,fontSize: 20)),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(ctx, 'Xác Nhận');
                                User? user = authInstance.currentUser;
                                final productProvider =
                                Provider.of<ProductsProvider>(ctx, listen: false);
                                final billID = Uuid().v4();
                                cartProvider.getCartItems.forEach((key, value) async {
                                  final getCurrProduct = productProvider.findProdById(
                                    value.productId,
                                  );
                                  try {
                                    final orderId = const Uuid().v4();
                                    await FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(orderId)
                                        .set({
                                      'orderId': orderId,
                                      'userId': user!.uid,
                                      'productId': value.productId,
                                      'price': (getCurrProduct.isOnSale
                                          ? getCurrProduct.salePrice
                                          : getCurrProduct.price) *
                                          value.quantity,

                                      'phone': APIs.me.phone,
                                      'totalPrice': total,
                                      'quantity': value.quantity,
                                      'imageUrl': getCurrProduct.imageUrl,
                                      'userName': user.displayName,
                                      'billId': billID,
                                      'address':APIs.me.address,
                                      'state': 'Chờ xác nhận',
                                      'orderDate': Timestamp.now(),
                                    });
                                    // await FirebaseFirestore.instance
                                    //     .collection('products')
                                    //     .doc(orderId)
                                    //     .set({
                                    //   'orderId': orderId,
                                    //   'userId': user!.uid,
                                    //   'productId': value.productId,
                                    //   'price': (getCurrProduct.isOnSale
                                    //       ? getCurrProduct.salePrice
                                    //       : getCurrProduct.price) *
                                    //       value.quantity,
                                    //   'phone': APIs.me.phone,
                                    //   'totalPrice': total,
                                    //   'quantity': value.quantity,
                                    //   'imageUrl': getCurrProduct.imageUrl,
                                    //   'userName': user.displayName,
                                    //   'billId': billID,
                                    //   'address':APIs.me.address,
                                    //   'state': 'Chờ xác nhận',
                                    //   'orderDate': Timestamp.now(),
                                    // });
                                    await cartProvider.clearOnlineCart();
                                    cartProvider.clearLocalCart();
                                    ordersProvider.fetchOrders();
                                    await Fluttertoast.showToast(
                                      msg: "Đơn hàng của bạn đã được đặt",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                  } catch (error) {
                                    GlobalMethods.errorDialog(
                                        subtitle: error.toString(), context: ctx);
                                  } finally {}
                                });
                              },
                              child: const Text('Xác nhận',
                                style: TextStyle(color: AppColor.primaryColor,fontWeight: FontWeight.w600,fontSize: 20),
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TextWidget(
                    text: 'Mua ngay',
                    textSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
  // void processMomoPayment() async {
  //   try {
  //
  //     MomoPaymentInfo options = MomoPaymentInfo(
  //         merchantName: "Tên đối tác",
  //         merchantCode: 'Mã đối tác',
  //         partnerCode: 'Mã đối tác',
  //         appScheme: "1221212",
  //         amount: 6000000000,
  //         orderId: '12321312',
  //         orderLabel: 'Label để hiển thị Mã giao dịch',
  //         merchantNameLabel: "Tiêu đề tên cửa hàng",
  //         fee: 0,
  //         description: 'Mô tả chi tiết',
  //         username: 'Định danh user (id/email/...)',
  //         partner: 'merchant',
  //         extra: "{\"key1\":\"value1\",\"key2\":\"value2\"}",
  //         isTestMode: true
  //     );
  //     try {
  //       _momoPay.open(options);
  //     } catch (e) {
  //       debugPrint(e);
  //     }
  //     // Xử lý kết quả thanh toán ở đây
  //     if (response.isSuccess) {
  //       // Thanh toán thành công
  //       print('Payment successful');
  //     } else {
  //       // Thanh toán thất bại
  //       print('Payment failed: ${response.message}');
  //     }
  //   } catch (e) {
  //     // Xử lý lỗi nếu có
  //     print('Error during payment: $e');
  //   }
  // }

}
