import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../consts/colors.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'wishlist_widget.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = "/WishlistScreen";
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList =
    wishlistProvider.getWishlistItems.values.toList().reversed.toList();
    return wishlistItemsList.isEmpty
        ? const EmptyScreen(
      title: 'Danh sách của bạn đang trống',
      subtitle: 'Khám phá thêm và liệt kê một số mặt hàng',
      imagePath: 'assets/images/wishlist.png',
      buttonText: 'Thêm wishlist',
    )
        : Scaffold(
        appBar: AppBar(
            centerTitle: true,
            leading: const BackWidget(),
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: AppColor.primaryColor,
            title: TextWidget(
              text: 'Wishlist (${wishlistItemsList.length})',
              color: Colors.white,
              isTitle: true,
              textSize: 22,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  GlobalMethods.warningDialog(
                      title: 'Xóa wishlist?',
                      subtitle: 'Bạn có chắc không?',
                      fct: () async {
                        await wishlistProvider.clearOnlineWishlist();
                        wishlistProvider.clearLocalWishlist();
                      },
                      context: context);
                },
                icon: const Icon(
                  IconlyBroken.delete,
                  color: AppColor.primaryColor,
                ),
              ),
            ]),
        body: MasonryGridView.count(
          itemCount: wishlistItemsList.length,
          crossAxisCount: 2,
          // mainAxisSpacing: 16,
          // crossAxisSpacing: 20,
          itemBuilder: (context, index) {
            return ChangeNotifierProvider.value(
                value: wishlistItemsList[index],
                child: const WishlistWidget());
          },
        ));
  }
}