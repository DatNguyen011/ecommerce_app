
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';
import '../services/utils.dart';
import 'text_widget.dart';


class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorSub = Utils(context).colorSub;
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final colorSale = Utils(context).colorSale;
    final colorCard = Utils(context).colorCard;
    final productModel = Provider.of<ProductModel>(context);
    var formatter = NumberFormat('###,###,###');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).canvasColor,
        elevation: 1,
        child: InkWell(
          onTap: () {
            // Navigator.pushNamed(context, ProductDetails.routeName,
            //     arguments: productModel.id);
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Column(children: [
                    Image.network(
                      productModel.imageUrl == null
                          ? 'https://yt3.googleusercontent.com/ytc/APkrFKaD8t4oFlgXcZKoW512Z81CBJuej3K9uHAlSI0x=s900-c-k-c0x00ffffff-no-rj'
                          : productModel.imageUrl!,
                      fit: BoxFit.scaleDown,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            child: TextWidget(
                              text: productModel.title,
                              color: color,
                              maxLines: 2,
                              textSize: 18,
                              isTitle: false,
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: productModel.isOnSale
                                  ? '₫${formatter.format(productModel.salePrice)}'
                                  : '₫${formatter.format(productModel.price)}',
                              color: colorSub,
                              textSize: 18,
                            ),
                            const SizedBox(
                              width: 7,
                            ),

                            Visibility(
                                visible: productModel.isOnSale,
                                child: Text(
                                  '₫${formatter.format(productModel.price)}',
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: colorSale),
                                )),
                            Visibility(
                                visible: productModel.isOnSale==false,
                                child: Text(
                                  '₫0',
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: colorSale),
                                )),
                          ],
                        ),
                        ],
                      ),
                    ),
                    // const Spacer(),

                  ]),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}