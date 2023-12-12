import 'package:ecommerce_app/screens/cart/quantity_bottom.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../models/cart.dart';
import '../../provider/cart_provider.dart';
import '../../provider/products_provider.dart';
import '../../widgets/product/heart_btn.dart';
import '../../widgets/subtitle_text.dart';
import '../../widgets/title_text.dart';


class CartBottomSheetWidget extends StatelessWidget {
  const CartBottomSheetWidget({super.key, required this.function});
  final Function function;
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                        child: TitlesTextWidget(
                            label:
                            "Total (${cartProvider.getCartitems.length} products/${cartProvider.getQty()} items)")),
                    SubtitleTextWidget(
                      label:
                      "${cartProvider.getTotal(productsProvider: productsProvider).toStringAsFixed(2)}\$",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await function();
                },
                child: const Text("Checkout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
