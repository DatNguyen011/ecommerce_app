import 'dart:developer';

import 'package:ecommerce_app/consts/theme_data.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/order_provider.dart';
import 'package:ecommerce_app/provider/products_provider.dart';
import 'package:ecommerce_app/provider/theme_provider.dart';
import 'package:ecommerce_app/provider/viewed_recently_provider.dart';
import 'package:ecommerce_app/provider/wishlist_provider.dart';
import 'package:ecommerce_app/root_screen.dart';
import 'package:ecommerce_app/screens/auth/forgot_pass.dart';
import 'package:ecommerce_app/screens/auth/login.dart';
import 'package:ecommerce_app/screens/auth/register.dart';
import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:ecommerce_app/screens/inner_screen/order/orders_screen.dart';
import 'package:ecommerce_app/screens/inner_screen/product_details.dart';
import 'package:ecommerce_app/screens/inner_screen/viewed_recently.dart';
import 'package:ecommerce_app/screens/inner_screen/wish_list.dart';
import 'package:ecommerce_app/screens/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'provider/user_provider.dart';

late Size mq;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: SelectableText(snapshot.error.toString()),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return ThemeProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return ProductsProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return CartProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return WishlistProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return ViewedProdProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return UserProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return OrderProvider();
              }),
            ],
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'ShopSmart EN',
                    theme: Styles.themeData(
                        isDarkTheme: themeProvider.getIsDarkTheme,
                        context: context),
                    home: const RootScreen(),
                    // home: const LoginScreen(),
                    routes: {
                      RootScreen.routeName: (context) => const RootScreen(),
                      ProductDetailsScreen.routName: (context) =>
                      const ProductDetailsScreen(),
                      WishlistScreen.routName: (context) => const WishlistScreen(),
                      ViewedRecentlyScreen.routName: (context) =>
                      const ViewedRecentlyScreen(),
                      RegisterScreen.routName: (context) => const RegisterScreen(),
                      LoginScreen.routeName: (context) => const LoginScreen(),
                      OrdersScreenFree.routeName: (context) =>
                      const OrdersScreenFree(),
                      ForgotPasswordScreen.routeName: (context) =>
                      const ForgotPasswordScreen(),
                      SearchScreen.routeName: (context) => const SearchScreen(),
                    },
                  );
                }),
          );
        });
  }
}
