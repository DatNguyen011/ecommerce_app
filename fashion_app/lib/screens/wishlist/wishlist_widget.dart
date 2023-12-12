import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/product_details.dart';
import '../../models/wishlist.dart';
import '../../providers/products_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';
import '../../widgets/text_widget.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('###,###,###');
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final getCurrProduct =
    productProvider.findProdById(wishlistModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    bool? _isInWishlist =
    wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Card(
      elevation: 1,
      color: Theme.of(context).canvasColor,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: wishlistModel.productId);
        },
        child: Container(
          height: size.height * 0.20,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  //margin: const EdgeInsets.only(left: 8),
                  // width: size.width * 0.2,
                  height: size.width * 0.25,
                  child: FancyShimmerImage(
                    imageUrl: getCurrProduct.imageUrl,
                    boxFit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              IconlyLight.bag2,
                              color: color,
                            ),
                          ),
                          HeartBTN(
                            productId: getCurrProduct.id,
                            isInWishlist: _isInWishlist,
                          )
                        ],
                      ),
                    ),
                    TextWidget(
                      text: getCurrProduct.title,
                      color: color,
                      textSize: 20.0,
                      maxLines: 2,
                      isTitle: false,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: '₫${formatter.format(double.parse(usedPrice.toString()))}',
                      color: color,
                      textSize: 18.0,
                      maxLines: 1,
                      isTitle: false,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}