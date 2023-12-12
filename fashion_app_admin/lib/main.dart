import 'package:fashion_app_admin/controllers/menucontroller.dart';
import 'package:fashion_app_admin/inner_screen/edit_user.dart';
import 'package:fashion_app_admin/provider/dark_theme_provider.dart';
import 'package:fashion_app_admin/provider/product_provider.dart';
import 'package:fashion_app_admin/screens/auth/forgot_pass.dart';
import 'package:fashion_app_admin/screens/auth/login.dart';
import 'package:fashion_app_admin/screens/auth/register.dart';
import 'package:fashion_app_admin/screens/dashboard_screen.dart';
import 'package:fashion_app_admin/widgets/side_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;
import 'consts/theme_data.dart';
import 'inner_screen/add_prod.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "AIzaSyDGg_JhkThRgxkLazC-uTm_MYYSz4EDiBs",
      appId: "1:635160594984:web:8736b6610b0249eeb9031d",
      messagingSenderId: "635160594984",
      projectId: "fashion-app-5357d",
      storageBucket: "fashion-app-5357d.appspot.com",
    ),
  );

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
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    // Bắt sự kiện khi người dùng nhấn nút reload
    html.window.onBeforeUnload.listen((html.Event e) {
      print('Trang web sẽ được reload!');

      // Thực hiện chuyển hướng về màn hình chủ
      html.window.location.href = '/'; // Điều này giả định rằng màn hình chủ của bạn có đường dẫn '/'
    });
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text('Ứng dụng đang được khởi tạo'),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text('Đã xảy ra lỗi ${snapshot.error}'),
                ),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => MenuControllers(),
            ),
            ChangeNotifierProvider(
              create: (_) {
                return themeChangeProvider;
              },
            ),
            ChangeNotifierProvider(create: (_) => ProductProvider())
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const MainScreen(),
                routes: {
                  ForgetPasswordScreen.routeName: (context) =>
                      const ForgetPasswordScreen(),
                  RegisterScreen.routeName: (context) => const RegisterScreen(),
                  LoginScreen.routeName: (context) => const LoginScreen(),
                  UploadProductForm.routeName: (context) =>
                      const UploadProductForm(),
                  MainScreen.routeName: (context) => const MainScreen(),
                  DashboardScreen.routeName: (context) =>
                      const DashboardScreen(),
                  SideMenu.routeName: (context) => const SideMenu(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
