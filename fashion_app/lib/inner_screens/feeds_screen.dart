import 'package:fashion_app/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products_provider.dart';
import '../services/utils.dart';
import '../widgets/back_widget.dart';
import '../widgets/empty_products.dart';
import '../widgets/feed_items.dart';
import '../widgets/text_widget.dart';


class FeedsScreen extends StatefulWidget {
  static const routeName = "/FeedsScreenState";
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    productsProvider.fetchProducts();
    super.initState();
  }
  List<ProductModel> listProdcutSearch = [];
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProducts;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        title: TextWidget(
          text: 'Tất cả sản phẩm',
          color: Colors.white,
          textSize: 20.0,
          isTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: TextField(
                focusNode: _searchTextFocusNode,
                controller: _searchTextController,
                onChanged: (valuee) {
                  setState(() {
                    listProdcutSearch = productsProvider.searchQuery(valuee);
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                    const BorderSide(color: AppColor.primaryColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                    BorderSide(color: color, width: 1),
                  ),
                  hintText: "Tìm kiếm",
                  prefixIcon: Icon(Icons.search,color: color,),
                  suffix: IconButton(
                    onPressed: () {
                      _searchTextController!.clear();
                      _searchTextFocusNode.unfocus();
                    },
                    icon: Icon(
                      Icons.close,
                      color: _searchTextFocusNode.hasFocus ? Colors.red : color,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _searchTextController!.text.isNotEmpty && listProdcutSearch.isEmpty
              ? const EmptyProdWidget(
              text: 'Không tìm thấy sản phẩm, vui lòng thử lại')
              : GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            padding: EdgeInsets.zero,
            // crossAxisSpacing: 10,
            childAspectRatio: size.width / (size.height * 0.69),
            children: List.generate(
                _searchTextController!.text.isNotEmpty
                    ? listProdcutSearch.length
                    : allProducts.length, (index) {
              return ChangeNotifierProvider.value(
                value: _searchTextController!.text.isNotEmpty
                    ? listProdcutSearch[index]
                    : allProducts[index],
                child: const FeedsWidget(),
              );
            }),
          ),
        ]),
      ),
    );
  }

}