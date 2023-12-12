import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app_admin/consts/colors.dart';
import 'package:fashion_app_admin/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../consts/constants.dart';
import '../../services/global_method.dart';
import '../../services/utils.dart';
import '../../widgets/auth_btn.dart';
import '../../widgets/text_widget.dart';
import '../loading_manager.dart';

import 'forgot_pass.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  bool _obscureText = true;
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        final User? user = authInstance.currentUser;
        final _uid = user!.uid;
        user.updateDisplayName(_fullNameController.text);
        user.reload();
        await FirebaseFirestore.instance.collection('admin').doc(_uid).set({
          'id': _uid,
          'name': _fullNameController.text,
          'email': _emailTextController.text.toLowerCase(),
          'createdAt': Timestamp.now(),
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
        print('Đăng ký thành công');
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
    // final theme = Utils(context).getTheme;
    // Color color = Utils(context).color;
    bool isMobile(BuildContext context) =>
    MediaQuery.of(context).size.width < 850;

    bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 1100;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Responsive(
            mobile: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

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
                  text: "Đăng ký để tiếp tục",
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
                            .requestFocus(_emailFocusNode),
                        keyboardType: TextInputType.name,
                        controller: _fullNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Trường này bị thiếu";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: AppColor.textColor),
                        decoration: const InputDecoration(
                          hintText: 'Họ và tên',
                          hintStyle: TextStyle(color: AppColor.textColor),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.textColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.textColor),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_passFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailTextController,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "Vui lòng nhập địa chỉ Email hợp lệ";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: AppColor.textColor),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: AppColor.textColor),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.textColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.textColor),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //Password
                      TextFormField(
                        focusNode: _passFocusNode,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passTextController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return "Vui lòng nhập mật khẩu hợp lệ";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: AppColor.textColor),
                        // onEditingComplete: () => FocusScope.of(context)
                        //     .requestFocus(_addressFocusNode),
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
                            ),
                          ),
                          hintText: 'Mật khẩu',
                          hintStyle: const TextStyle(color: AppColor.textColor),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.textColor),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.textColor),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context,
                          routeName: ForgetPasswordScreen.routeName);
                    },
                    child: TextWidget(
                    text: 'Quên mật khẩu?',
                    color: AppColor.textColor,
                    textSize: 14,
                    isTitle: false,
                  ),
                  ),
                ),
                AuthButton(
                  buttonText: 'Đăng ký',
                  fct: () {
                    _submitFormOnRegister();
                  },
                ),
            // SizedBox(
            //   width: double.infinity,
            //   height: 50,
            //   child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         primary: AppColor.primaryColor, // background (button) color
            //       ),
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => const LoginScreen()),
            //         );
            //       },
            //       child: TextWidget(
            //         text: 'Sign up',
            //         textSize: 18,
            //         color: Colors.white,
            //         isTitle: true,
            //       )),
            // ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Bạn đã là người dùng?',
                      style: GoogleFonts.montserrat(
                          color: AppColor.textColor, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Đăng nhập',
                            style: GoogleFonts.montserrat(
                                color: AppColor.textColor, fontSize: 15,fontWeight: FontWeight.w700),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                );
                              }),
                      ]),
                ),
              ],
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Image.asset("assets/images/welcome.png")),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 450,
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
                            text: "Đăng ký để tiếp tục",
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
                                      .requestFocus(_emailFocusNode),
                                  keyboardType: TextInputType.name,
                                  controller: _fullNameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Trường này bị thiếu";
                                    } else {
                                      return null;
                                    }
                                  },
                                  style: const TextStyle(color: AppColor.textColor),
                                  decoration: const InputDecoration(
                                    hintText: 'Họ và tên',
                                    hintStyle: TextStyle(color: AppColor.textColor),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.textColor),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.textColor),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  focusNode: _emailFocusNode,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () => FocusScope.of(context)
                                      .requestFocus(_passFocusNode),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailTextController,
                                  validator: (value) {
                                    if (value!.isEmpty || !value.contains("@")) {
                                      return "Vui lòng nhập địa chỉ Email hợp lệ";
                                    } else {
                                      return null;
                                    }
                                  },
                                  style: const TextStyle(color: AppColor.textColor),
                                  decoration: const InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: AppColor.textColor),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.textColor),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.textColor),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                //Password
                                TextFormField(
                                  focusNode: _passFocusNode,
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: _passTextController,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 7) {
                                      return "Vui lòng nhập mật khẩu hợp lệ";
                                    } else {
                                      return null;
                                    }
                                  },
                                  style: const TextStyle(color: AppColor.textColor),
                                  // onEditingComplete: () => FocusScope.of(context)
                                  //     .requestFocus(_addressFocusNode),
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
                                      ),
                                    ),
                                    hintText: 'Mật khẩu',
                                    hintStyle: const TextStyle(color: AppColor.textColor),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.textColor),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.textColor),
                                    ),
                                    errorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                GlobalMethods.navigateTo(
                                    ctx: context,
                                    routeName: ForgetPasswordScreen.routeName);
                              },
                              child: TextWidget(
                                text: 'Quên mật khẩu?',
                                color: AppColor.textColor,
                                textSize: 14,
                                isTitle: false,
                              ),
                            ),
                          ),
                          AuthButton(
                            buttonText: 'Đăng ký',
                            fct: () {
                              _submitFormOnRegister();
                            },
                          ),
                          // SizedBox(
                          //   width: double.infinity,
                          //   height: 50,
                          //   child: ElevatedButton(
                          //       style: ElevatedButton.styleFrom(
                          //         primary: AppColor.primaryColor, // background (button) color
                          //       ),
                          //       onPressed: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(builder: (context) => const LoginScreen()),
                          //         );
                          //       },
                          //       child: TextWidget(
                          //         text: 'Sign up',
                          //         textSize: 18,
                          //         color: Colors.white,
                          //         isTitle: true,
                          //       )),
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Bạn đã là người dùng?',
                                style: GoogleFonts.montserrat(
                                    color: AppColor.textColor, fontSize: 15),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' Đăng nhập',
                                      style: GoogleFonts.montserrat(
                                          color: AppColor.textColor, fontSize: 15,fontWeight: FontWeight.w700),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                                          );
                                        }),
                                ]),
                          ),
                        ],
                ),
                      ),
                    ],
                  ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}