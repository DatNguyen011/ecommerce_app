import 'package:fashion_app_admin/consts/colors.dart';
import 'package:fashion_app_admin/provider/product_provider.dart';
import 'package:fashion_app_admin/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../consts/constants.dart';
import '../model/product.dart';
import '../responsive.dart';
import '../services/utils.dart';
import 'grid_products.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.title,
    required this.fct,
    this.showTexField = true,
  }) : super(key: key);
  final String title;
  final Function fct;
  final bool showTexField;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final TextEditingController? _searchTextController = TextEditingController();

  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> listProdcutSearch = [];

  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final productsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productsProvider.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProducts;
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Column(
      children: [
        Row(
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  widget.fct();
                },
              ),
            if (Responsive.isDesktop(context))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            if (Responsive.isDesktop(context))
              Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
            !widget.showTexField
                ? Container()
                : Expanded(
                    child: TextField(
                      focusNode: _searchTextFocusNode,
                      controller: _searchTextController,
                      onChanged: (value) {
                        setState(() {
                          listProdcutSearch =
                              productsProvider.searchQuery(value);
                          print(listProdcutSearch);
                        });
                      },
                      decoration: InputDecoration(

                        hintText: "Search",
                        fillColor: Theme.of(context).canvasColor,
                        filled: true,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.primaryColor, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            _searchTextController!.clear();
                            _searchTextFocusNode.unfocus();
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.all(defaultPadding * 0.75),
                            margin: const EdgeInsets.symmetric(
                                horizontal: defaultPadding / 2),
                            decoration: const BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        _searchTextController!.text.isEmpty
            ? Container()
        :GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 6,
          padding: EdgeInsets.zero,
          childAspectRatio: size.width / (size.height * 3.6),
          // crossAxisSpacing: 10,
          children: List.generate(
              listProdcutSearch.length, (index) {
            return ChangeNotifierProvider.value(
              value: listProdcutSearch[index],
              child:  SearchWidget(),
            );
          }),
        )

      ],
    );
  }
}
