import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Styles{
  static ThemeData themeData({required bool isDarkTheme,required BuildContext context}){
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
          ? AppColors.darkScaffoldColor
          :AppColors.lightScaffoldColor,
      cardColor: isDarkTheme
        ? const Color.fromARGB(225, 13, 6, 37)
          : AppColors.lightCardColor,
    );
  }
}