import 'package:fashion_app_admin/consts/colors.dart';
import 'package:fashion_app_admin/inner_screen/add_banner.dart';
import 'package:fashion_app_admin/widgets/banner_widget.dart';
import 'package:fashion_app_admin/widgets/grid_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/menucontroller.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/side_menu.dart';

class AllBannerScreen extends StatefulWidget {
  const AllBannerScreen({Key? key}) : super(key: key);

  @override
  State<AllBannerScreen> createState() => _AllBannerScreenState();
}

class _AllBannerScreenState extends State<AllBannerScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<MenuControllers>().getGridBannerScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            SizedBox(width: 10,),
            Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Header(
                        fct: () {
                          context.read<MenuControllers>().controlBannerMenu();
                        },
                        showTexField: false,
                        title: 'Tất cả banner',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ButtonsWidget(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UploadBannerForm(),
                              ),
                            );
                          },
                          text: 'Thêm banner',
                          icon: Icons.add,
                          backgroundColor: AppColor.primaryColor),
                      const SizedBox(
                        height: 25,
                      ),
                      Responsive(
                        mobile: BannerGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                          isInMain: false,
                        ),
                        desktop: BannerGridWidget(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                          isInMain: false,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
