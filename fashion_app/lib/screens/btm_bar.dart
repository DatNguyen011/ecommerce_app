import 'package:badges/badges.dart' as badges;
import 'package:fashion_app/consts/colors.dart';
import 'package:fashion_app/screens/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/text_widget.dart';
import 'cart/cart_screen.dart';
import 'categories.dart';
import 'home_screen.dart';

class BottomBarScreen extends StatefulWidget {

  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {
      'page': const HomeScreen(),
      'title': 'Home Screen',
    },
    {
      'page': CategoriesScreen(),
      'title': 'Categories Screen',
    },
    {
      'page': const CartScreen(),
      'title': 'Cart Screen',
    },
    {
      'page': const UserScreen(),
      'title': 'User Screen',
    },
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);

    bool _isDark = themeState.getDarkTheme;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text( _pages[_selectedIndex]['title']),
      // ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        unselectedItemColor: _isDark ? Colors.white38 : Colors.black12,
        selectedItemColor: _isDark ? AppColor.primaryColor : AppColor.primaryColor,
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:
            Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? IconlyBold.category
                : IconlyLight.category),
            label: "Thể loại",
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(builder: (_, myCart, ch) {
              return badges.Badge(
                badgeAnimation: const badges.BadgeAnimation.slide(
                  toAnimate: true,
                ),
                badgeStyle: badges.BadgeStyle(
                  shape: badges.BadgeShape.circle,
                  badgeColor: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(8),

                ),
                position: badges.BadgePosition.topEnd(top: -7, end: -7),
              badgeContent: FittedBox(
                  child: TextWidget(
                      text: myCart.getCartItems.length.toString(),
                      color: Colors.white,
                      textSize: 15)),
              child: Icon(
                  _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy),);

            }),
            label: "Giỏ hàng",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
            label: "Người dùng",
          ),
        ],
      ),
    );
  }
}