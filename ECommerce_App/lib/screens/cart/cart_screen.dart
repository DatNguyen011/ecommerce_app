import 'package:ecommerce_app/services/assets_manager.dart';
import 'package:ecommerce_app/widgets/empty_bag.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';

import 'bottom_checkout.dart';
import 'cart_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    return isEmpty ? Scaffold(
      body: EmptyBagWidget(
        imagePath: AssetsManager.shoppingBasket,
        title: 'Your cart is empty',
        subtitle: 'Looks like your cart is empty add something and make me happy',
        buttonText: 'Shop now',
      ),
    ):Scaffold(
      bottomSheet: CartBottomSheetWidget(),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetsManager.shoppingCart,
          ),
        ),
        title: const TitlesTextWidget(label: "Cart (6)"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const CartWidget();
          }),
    );
  }
}
