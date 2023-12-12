import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fashion_app/consts/colors.dart';
import 'package:fashion_app/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/on_sale_screen.dart';
import '../../inner_screens/product_details.dart';
import '../../models/cart.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';
import '../../widgets/text_widget.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.q, }) : super(key: key);
  final int q;


  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();
  bool isPlusButtonEnabled = true;
  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final formatter = NumberFormat('###,###,###');
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    //final productModel = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findProdById(cartModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
    wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    return Card(
      color: Theme.of(context).canvasColor,
      elevation: 0.1,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: cartModel.productId);
        },
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: size.width * 0.25,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: FancyShimmerImage(
                          imageUrl: getCurrProduct.imageUrl,
                          boxFit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: getCurrProduct.title,
                              maxLines: 1,
                              color: color,
                              textSize: 18,
                              isTitle: false,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: color, width: 0.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(6)
                                ),
                              ),
                              width: size.width * 0.15,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('SL: ${_quantityTextController.text}'),
                              ),
                              // child: Row(
                              //   children: [
                              //     quantityController(
                              //       fct: () {
                              //         if (_quantityTextController.text == '1') {
                              //           return;
                              //         } else {
                              //           cartProvider.reduceQuantityByOne(
                              //               cartModel.productId);
                              //           setState(() {
                              //             _quantityTextController.text = (int.parse(
                              //                 _quantityTextController
                              //                     .text) -
                              //                 1)
                              //                 .toString();
                              //           });
                              //         }
                              //       },
                              //       color: Colors.transparent,
                              //       icon: CupertinoIcons.minus,
                              //     ),
                              //     Flexible(
                              //       flex: 1,
                              //       child: TextField(
                              //         textAlign: TextAlign.center,
                              //         controller: _quantityTextController,
                              //         keyboardType: TextInputType.number,
                              //         maxLines: 1,
                              //         decoration: const InputDecoration(
                              //           focusedBorder: UnderlineInputBorder(
                              //             borderSide: BorderSide(),
                              //           ),
                              //         ),
                              //         inputFormatters: [
                              //           FilteringTextInputFormatter.allow(
                              //             RegExp('[0-9]'),
                              //           ),
                              //         ],
                              //         onChanged: (v) {
                              //           setState(() {
                              //             if (v.isEmpty) {
                              //               _quantityTextController.text = '1';
                              //             } else {
                              //               return;
                              //             }
                              //           });
                              //         },
                              //       ),
                              //     ),
                              //
                              //     quantityController(
                              //       fct: () {
                              //
                              //         cartProvider.increaseQuantityByOne(
                              //             cartModel.productId);
                              //         setState(() {
                              //           if(int.parse(getCurrProduct.quantity)>int.parse(_quantityTextController.text)){
                              //             _quantityTextController.text =
                              //                 (int.parse(_quantityTextController.text) + 1)
                              //                     .toString();
                              //           }else {
                              //             _quantityTextController.text=_quantityTextController.text;
                              //             isPlusButtonEnabled=false;
                              //           }
                              //         });
                              //       },
                              //       color: Colors.transparent,
                              //       icon: CupertinoIcons.plus,
                              //     ),
                              //
                              //   ],
                              // ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        mainAxisAlignment:MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              //await productProvider.fetchProducts();
                              await cartProvider.removeOneItem(
                                cartId: cartModel.id,
                                productId: cartModel.productId,
                                quantity: int.parse(getCurrProduct.quantity), removeQuantity: cartModel.quantity,
                              );


                            },
                            child: const Icon(
                              CupertinoIcons.cart_badge_minus,
                              color: Colors.red,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          HeartBTN(
                            productId: getCurrProduct.id,
                            isInWishlist: _isInWishlist,
                          ),
                          TextWidget(
                            text:
                            '₫${formatter.format((usedPrice * int.parse(_quantityTextController.text)))}',
                            color: color,
                            textSize: 18,
                            maxLines: 1,
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quantityController({
    required Function fct,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => fct(),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                icon,
                color: AppColor.primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}