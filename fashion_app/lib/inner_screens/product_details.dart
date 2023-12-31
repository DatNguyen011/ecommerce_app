import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fashion_app/consts/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_const.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../providers/viewed_prod_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/heart_btn.dart';
import '../widgets/text_widget.dart';


class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    var formatter = NumberFormat('###,###,###');
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(productId);
    int quantity=int.parse(getCurrProduct.quantity);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityTextController.text);
    bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);

    bool? _isInWishlist =
    wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);

    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        viewedProdProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            leading: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () =>
              Navigator.canPop(context) ? Navigator.pop(context) : null,
              child: Icon(
                IconlyLight.arrowLeft2,
                color: color,
                size: 24,
              ),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        bottomNavigationBar: Card(
          color: Theme.of(context).canvasColor,
          child: SizedBox(
            height: size.height*0.1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Tổng Tiền',
                      color: AppColor.primaryColor,
                      textSize: 20,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text:
                            '₫${formatter.format(totalPrice)}',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                          TextWidget(
                            text: '/${_quantityTextController.text}',
                            // text: '₫',
                            color: color,
                            textSize: 16,
                            isTitle: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Material(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: _isInCart
                        ? null
                        : () async {
                      // if (_isInCart) {
                      //   return;
                      // }
                      final User? user =
                          authInstance.currentUser;

                      if (user == null) {
                        GlobalMethods.errorDialog(
                            subtitle:
                            'Vui lòng đăng nhập tài khoản trước !!!',
                            context: context);
                        return;
                      }
                      await GlobalMethods.addToCart(
                          productId: getCurrProduct.id,
                          quantity: int.parse(
                              _quantityTextController.text),
                          context: context);
                      await GlobalMethods.updateProductAdd(
                          productId: getCurrProduct.id,
                          context: context,
                          quantity: int.parse(getCurrProduct.quantity), addQuantity: int.parse(_quantityTextController.text));
                      await cartProvider.fetchCart();
                      // cartProvider.addProductsToCart(
                      //     productId: getCurrProduct.id,
                      //     quantity: int.parse(
                      //         _quantityTextController.text));
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextWidget(
                            text:
                            _isInCart ? 'Đã thêm' : 'Thêm vào giỏ',
                            color: Colors.white,
                            textSize: 18)),
                  ),
                ),
              ],
      ),
            ),
          ),
        ),
        body: Column(children: [
          Flexible(
            flex: 2,
            child: FancyShimmerImage(
              imageUrl: getCurrProduct.imageUrl,
              boxFit: BoxFit.scaleDown,
              width: size.width,
              // height: screenHeight * .4,
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(

              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 1),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: getCurrProduct.title,
                            color: color,
                            textSize: 25,
                            isTitle: true,
                          ),
                        ),
                        HeartBTN(
                          productId: getCurrProduct.id,
                          isInWishlist: _isInWishlist,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: '₫${formatter.format(usedPrice)}',
                          color: AppColor.primaryColor,
                          textSize: 22,
                          isTitle: true,
                        ),
                        // TextWidget(
                        //   text: getCurrProduct.isPiece ? '/Piece' : '/Kg',
                        //   color: color,
                        //   textSize: 12,
                        //   isTitle: false,
                        // ),
                        const SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: getCurrProduct.isOnSale ? true : false,
                          child: Text(
                            '₫${formatter.format(getCurrProduct.price)}',
                            style: TextStyle(
                                fontSize: 15,
                                color: color,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          child: Image.asset('assets/images/freeship.png'),
                          // padding: const EdgeInsets.symmetric(
                          //     vertical: 4, horizontal: 8),
                          // decoration: BoxDecoration(
                          //     color: const Color.fromRGBO(63, 200, 101, 1),
                          //     borderRadius: BorderRadius.circular(5)),
                          // child: TextWidget(
                          //   text: 'Free delivery',
                          //   color: Colors.white,
                          //   textSize: 20,
                          //   isTitle: true,
                          // ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      quantityControl(
                        fct: () {
                          if (_quantityTextController.text == '1') {
                            return;
                          } else {
                            setState(() {
                              _quantityTextController.text =
                                  (int.parse(_quantityTextController.text) - 1)
                                      .toString();
                            });
                          }
                        },
                        icon: CupertinoIcons.minus,
                        color: AppColor.primaryColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextField(

                          controller: _quantityTextController,
                          key: const ValueKey('quantity'),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: const InputDecoration(

                            border: UnderlineInputBorder(),
                          ),
                          textAlign: TextAlign.center,
                          cursorColor: AppColor.primaryColor,
                          enabled: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                _quantityTextController.text = '1';
                              } else {}
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      quantityControl(
                        fct: () {
                          setState(() {
                            if(quantity>int.parse(_quantityTextController.text)){
                              _quantityTextController.text =
                                  (int.parse(_quantityTextController.text) + 1)
                                      .toString();
                            }else {
                              _quantityTextController.text=_quantityTextController.text;
                            }
                          });
                        },
                        icon: CupertinoIcons.plus,
                        color: AppColor.primaryColor,
                      ),
                    ],
                  ),
                  const Padding(padding:
                  EdgeInsets.only(top: 40, left: 30, right: 30),
                  child: Text('Mô tả:',maxLines: 1,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),),
                  const Padding(padding:
                  EdgeInsets.only(left: 30, right: 30),
                    child: Text('Long lanh, kiêu sa tựa như những đóa hoa ban nở giữa rừng, thiết kế bông tai của Elegant được tạo nên giữa sự kết hợp của vàng 14K cùng đá CZ lấp lánh. Từng đường viền mềm mại được chế tác sinh động, kết hợp những viên đá CZ tròn nhỏ, tất cả đã mang đến đôi bông tai nổi bật với vẻ đẹp tinh tế.Đừng chờ đợi mà hãy chăm chút bản thân và đẹp mọi lúc mọi nơi vì chính nàng muốn thế mà chẳng cần lý do nào khác. PNJ tin rằng, khí chất của nàng sẽ được lột tả hết khi ướm lên mình đôi bông tai này.'
                      ,maxLines: 4,overflow: TextOverflow.ellipsis,),),
                  // const Spacer(),
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.symmetric(
                  //       vertical: 20, horizontal: 30),
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).canvasColor,
                  //     // borderRadius: const BorderRadius.only(
                  //     //   topLeft: Radius.circular(20),
                  //     //   topRight: Radius.circular(20),
                  //     // ),
                  //     border: Border.all(
                  //       color: Colors.black12, // Màu của viền đen
                  //       width: 1.0, // Độ dày của viền
                  //     ),
                  //     // boxShadow: [
                  //     //   BoxShadow(
                  //     //     color: Colors.grey.withOpacity(0.2), // Màu của shadow
                  //     //     spreadRadius: 5, // Độ mở rộng của shadow
                  //     //     blurRadius: 7, // Độ mờ của shadow
                  //     //     offset: Offset(0, 1), // Độ dịch chuyển của shadow (dx, dy)
                  //     //   ),
                  //     // ],
                  //   ),
                  //
                  // ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget quantityControl(
      {required Function fct, required IconData icon, required Color color}) {
    return Flexible(
      flex: 2,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: color,
        child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
            )),
      ),
    );
  }
}