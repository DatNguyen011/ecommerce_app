import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/consts/colors.dart';
import 'package:fashion_app/consts/consts_data.dart';
import 'package:fashion_app/widgets/back_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../inner_screens/feeds_screen.dart';
import '../inner_screens/on_sale_screen.dart';
import '../models/product.dart';
import '../providers/products_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/feed_items.dart';
import '../widgets/on_sale_widget.dart';
import '../widgets/text_widget.dart';
import 'account_screen.dart';
import 'btm_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    APIs.getSelfInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    final Color color = Utils(context).color;
    Size size = utils.getScreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;
    ProductsProvider provider = ProductsProvider();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        backgroundColor: AppColor.primaryColor,
        title: const Text(
          'Trang chủ',style: TextStyle(
          color: Colors.white
        ),
        ),
        elevation: 1,
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(IconlyLight.search),color: Colors.white,
                onPressed: () async {
                  await GlobalMethods.navigateTo(
                    ctx: context,
                    routeName: FeedsScreen.routeName,
                  );
                },
              ),
              // IconButton(
              //   icon: Icon(IconlyLight.notification),color: Colors.white,
              //   onPressed: () async {
              //     // await Navigator.of(context).pushReplacement(MaterialPageRoute(
              //     //   builder: (ctx) => FeedsScreen(),
              //     // ));
              //   },
              // ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColor.primaryColor,
        backgroundColor: Colors.white,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          await Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (ctx) => BottomBarScreen(),
          ));
        },
        child: CustomScrollView(
          slivers: [
            // SliverToBoxAdapter(
            //   child: GestureDetector(
            //     onTap: ()async{
            //       await Navigator.of(context).pushReplacement(MaterialPageRoute(
            //         builder: (ctx) => FeedsScreen(),
            //       ));
            //     },
            //     child: TextField(
            //       decoration: InputDecoration(
            //         hintText: "Tìm kiếm",
            //         prefixIcon: Icon(
            //           Icons.search,
            //           color: color,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SliverAppBar(
              expandedHeight: size.height * 0.2,
              flexibleSpace: FutureBuilder(
                future: getBanner(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Lỗi: ${snapshot.error}');
                  } else {
                    List<String> imageUrls =
                        (snapshot.data as List<String>?) ?? [];
                    return Swiper(
                      autoplay: true,
                      itemCount: imageUrls.length,
                      itemBuilder: (BuildContext context, int index) {
                        return imageUrls[index].isNotEmpty?Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                        ):Image.network('https://scontent.fhan15-2.fna.fbcdn.net/v/t39.30808-6/279371357_112990048065141_1845581227208806699_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=efb6e6&_nc_eui2=AeFSrRH1P-X2QkMR7iqAkBBSB6ZsBA9ZOAcHpmwED1k4B2RRjcmMw140_TN-3bdXqOJ72zRDqUSfWQvbO87dETFx&_nc_ohc=hevKyO6z9JgAX_sg2BG&_nc_ht=scontent.fhan15-2.fna&oh=00_AfBy2QlUp-oZayyOI-r6UU9ipx3QTS_aB_3KIKAgVxrnIw&oe=657CEC71');
                      },
                      pagination: const SwiperPagination(
                        margin: EdgeInsets.all(2)
                      ),
                      // control: const SwiperControl(
                      //   color: AppColor.primaryColor
                      // ),
                    );
                  }
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 8.0),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 18,
                      child: InkWell(
                        onTap: () {
                          GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: OnSaleScreen.routeName,
                          );
                        },
                        child: Image.asset(
                          'assets/images/flashsale.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: size.height * 0.28,
                      child: ListView.builder(
                        itemCount: productsOnSale.length < 10
                            ? productsOnSale.length
                            : 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return ChangeNotifierProvider.value(
                            value: productsOnSale[index],
                            child: const OnSaleWidget(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(
                height: 10,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: ' Sản Phẩm',
                      color: color,
                      textSize: 20,
                      isTitle: true,
                    ),
                  ],
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: size.width / (size.height * 0.80),
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ChangeNotifierProvider.value(
                    value: allProducts[index],
                    child: const FeedsWidget(),
                  );
                },
                childCount: allProducts.length < 8 ? allProducts.length : 8,
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      GlobalMethods.navigateTo(
                        ctx: context,
                        routeName: FeedsScreen.routeName,
                      );
                    },
                    child: TextWidget(
                      text: 'Xem thêm >',
                      maxLines: 1,
                      color: color,
                      textSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> getBanner() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('banners').get();

      List<String> imageUrls = [];

      querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey('imageUrl')) {
          String imageUrl = data['imageUrl'];
          imageUrls.add(imageUrl);
        }
      });

      return imageUrls;
    } catch (error) {
      print('Lỗi khi lấy dữ liệu: $error');
      throw error;
    }
  }
}

// TextField(
//   onChanged: (valuee) {
//     setState(() {
//     });
//   },
//   decoration: InputDecoration(
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(6),
//       borderSide:
//       const BorderSide(color: AppColor.primaryColor, width: 1),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(6),
//       borderSide:
//       BorderSide(color: color, width: 1),
//     ),
//     hintText: "Tìm kiếm",
//     prefixIcon: Icon(Icons.search,color: color,),
//     suffix: IconButton(
//       onPressed: () {
//       },
//       icon: Icon(
//         Icons.close,
//         color: Colors.red,
//       ),
//     ),
//   ),
// ),
