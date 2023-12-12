import 'package:ecommerce_app/models/order.dart';
import 'package:ecommerce_app/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/empty_bag.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/title_text.dart';
import 'orders_widget.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const TitlesTextWidget(
            label: 'Placed orders',
          ),
        ),
        body: FutureBuilder<List<OrderAdvanced>>(
          future: orderProvider.fetchOrder(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                    child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                    child: SelectableText(snapshot.error.toString()),
              );
            }else if(!snapshot.hasData || orderProvider.getOrders.isEmpty){
              return EmptyBagWidget(
                  imagePath: AssetsManager.orderBag,
                  title: "No orders has been placed yet",
                  subtitle: "",
                  buttonText: "Shop now");
            }return ListView.separated(
                itemBuilder: (ctx, index){
                  return Padding(padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 6),
                  child: OrdersWidgetFree(orderAdvanced: orderProvider.getOrders[index],),
                  );
                },
                separatorBuilder: (BuildContext context, int index){
                  return Divider(

                  );
                },
                itemCount: snapshot.data!.length,);
          },
        ));
  }
}
