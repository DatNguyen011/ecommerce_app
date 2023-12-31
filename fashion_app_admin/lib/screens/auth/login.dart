import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app_admin/responsive.dart';
import 'package:fashion_app_admin/screens/auth/register.dart';
import 'package:fashion_app_admin/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/colors.dart';
import '../../consts/constants.dart';
import '../../services/global_method.dart';
import '../../widgets/auth_btn.dart';
import '../../widgets/text_widget.dart';
import '../loading_manager.dart';
import 'forgot_pass.dart';


class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setBool('isLoggedIn', true);
        bool isAdmin = await checkAdminStatus(authInstance.currentUser?.uid);
        if (isAdmin) {
          print('Đăng nhập thành công');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        }else{
          Fluttertoast.showToast(
            msg: 'Không tồn tại tài khoản',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            // textColor: Colors.white,
            // fontSize: 16.0,
          );
        }
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(children: [
          SingleChildScrollView(
            child: Responsive(
              mobile: Padding( 
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 120.0,
                    ),
                    TextWidget(
                      text: 'Chào mừng',
                      color: AppColor.textColor,
                      textSize: 30,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextWidget(
                      text: "Đăng nhập để tiếp tục",
                      color: AppColor.subTextColor,
                      textSize: 18,
                      isTitle: false,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_passFocusNode),
                              controller: _emailTextController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Vui lòng nhập địa chỉ email hợp lệ';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: AppColor.textColor,),
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(color: AppColor.textColor),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: AppColor.textColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: AppColor.textColor),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            //Password

                            TextFormField(
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () {
                                _submitFormOnLogin();
                              },
                              controller: _passTextController,
                              focusNode: _passFocusNode,
                              obscureText: _obscureText,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 7) {
                                  return 'Vui lòng nhập mật khẩu hợp lệ';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: AppColor.textColor),
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColor.textColor,
                                    )),
                                hintText: 'Mật khẩu',
                                hintStyle: const TextStyle(color: AppColor.textColor),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: AppColor.textColor),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: AppColor.textColor),
                                ),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                          );
                        },
                        child: TextWidget(
                        text: 'Quên mật khẩu?',
                        color: AppColor.textColor,
                        textSize: 14,
                        isTitle: false,
                      ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AuthButton(
                      fct: _submitFormOnLogin,
                      buttonText: 'Đăng nhập',
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    RichText(
                        text: TextSpan(
                            text: 'Bạn chưa có tài khoản?',
                            style: GoogleFonts.montserrat(
                                color: AppColor.textColor, fontSize: 15),
                            children: [
                              TextSpan(
                                  text: '  Đăng ký',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // GlobalMethods.navigateTo(
                                      //     ctx: context,
                                      //     routeName: RegisterScreen.routeName);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                      );
                                    }),
                            ]))
                  ],
                ),
              ),
              desktop: Row(
                children: [
                  Expanded(child: Image.asset("assets/images/welcome.png")),
                  Expanded(
                    child: SizedBox(
                      width: 450,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            TextWidget(
                              text: 'Chào mừng',
                              color: AppColor.textColor,
                              textSize: 30,
                              isTitle: true,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextWidget(
                              text: "Đăng nhập để tiếp tục",
                              color: AppColor.subTextColor,
                              textSize: 18,
                              isTitle: false,
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () => FocusScope.of(context)
                                          .requestFocus(_passFocusNode),
                                      controller: _emailTextController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty || !value.contains('@')) {
                                          return 'Vui lòng nhập địa chỉ email hợp lệ';
                                        } else {
                                          return null;
                                        }
                                      },
                                      style: const TextStyle(color: AppColor.textColor,),
                                      decoration: const InputDecoration(
                                        hintText: 'Email',
                                        hintStyle: TextStyle(color: AppColor.textColor),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColor.textColor),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColor.textColor),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    //Password

                                    TextFormField(
                                      textInputAction: TextInputAction.done,
                                      onEditingComplete: () {
                                        _submitFormOnLogin();
                                      },
                                      controller: _passTextController,
                                      focusNode: _passFocusNode,
                                      obscureText: _obscureText,
                                      keyboardType: TextInputType.visiblePassword,
                                      validator: (value) {
                                        if (value!.isEmpty || value.length < 7) {
                                          return 'Vui lòng nhập mật khẩu hợp lệ';
                                        } else {
                                          return null;
                                        }
                                      },
                                      style: const TextStyle(color: AppColor.textColor),
                                      decoration: InputDecoration(
                                        suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                            child: Icon(
                                              _obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: AppColor.textColor,
                                            )),
                                        hintText: 'Mật khẩu',
                                        hintStyle: const TextStyle(color: AppColor.textColor),
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColor.textColor),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColor.textColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                                  );
                                },
                                child: TextWidget(
                                  text: 'Quên mật khẩu?',
                                  color: AppColor.textColor,
                                  textSize: 14,
                                  isTitle: false,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AuthButton(
                              fct: _submitFormOnLogin,
                              buttonText: 'Đăng nhập',
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            RichText(
                                text: TextSpan(
                                    text: 'Bạn chưa có tài khoản?',
                                    style: GoogleFonts.montserrat(
                                        color: AppColor.textColor, fontSize: 15),
                                    children: [
                                      TextSpan(
                                          text: '  Đăng ký',
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // GlobalMethods.navigateTo(
                                              //     ctx: context,
                                              //     routeName: RegisterScreen.routeName);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                              );
                                            }),
                                    ]))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
  Future<bool> checkAdminStatus(String? userId) async {
    if (userId == null) return false;

    // Replace 'admins' with your Firestore collection name for admins
    DocumentSnapshot adminSnapshot =
    await FirebaseFirestore.instance.collection('admin').doc(userId).get();

    return adminSnapshot.exists;
  }
}