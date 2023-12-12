import 'dart:convert';
import 'dart:developer';

import 'package:fashion_app/inner_screens/information.dart';
import 'package:fashion_app/inner_screens/order_detail.dart';
import 'package:fashion_app/providers/dark_theme_provider.dart';
import 'package:fashion_app/providers/orders_provider.dart';
import 'package:fashion_app/providers/products_provider.dart';
import 'package:fashion_app/providers/viewed_prod_provider.dart';
import 'package:fashion_app/screens/account_screen.dart';
import 'package:fashion_app/screens/home_screen.dart';
import 'package:fashion_app/screens/viewed_recently/viewed_recently.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'fetch_screen.dart';
import 'inner_screens/category_screen.dart';
import 'inner_screens/feeds_screen.dart';
import 'inner_screens/on_sale_screen.dart';
import 'inner_screens/product_details.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/auth/forget_pass.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
    await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  )),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Center(
                    child: Text('Đã xảy ra lỗi'),
                  )),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(
                create: (_) => ProductsProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WishlistProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ViewedProdProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => OrdersProvider(),
              ),
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
                  return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Elegant',
                      theme: Styles.themeData(themeProvider.getDarkTheme, context),
                      home: const FetchScreen(),
                      routes: {
                        OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                        FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                        ProductDetails.routeName: (ctx) => const ProductDetails(),
                        WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                        OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                        ViewedRecentlyScreen.routeName: (ctx) =>
                        const ViewedRecentlyScreen(),
                        RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                        LoginScreen.routeName: (ctx) => const LoginScreen(),
                        ForgetPasswordScreen.routeName: (ctx) =>
                        const ForgetPasswordScreen(),
                        ProfileScreen.routeName: (ctx) =>  ProfileScreen(user: APIs.me,),
                        CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                      });
                }),
          );
        });
  }
}