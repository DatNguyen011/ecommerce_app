import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier{
  static const THEME_STATUS="THEME_STATUS";
  bool darkTheme=false;
  bool get getIsDarkTheme => darkTheme;
  ThemeProvider(){
    getTheme();
  }
  setDarkTheme({required bool themeValue}) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setBool(THEME_STATUS, themeValue);
    darkTheme=themeValue;
    notifyListeners();
  }
  Future<bool> getTheme()async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    darkTheme=sharedPreferences.getBool(THEME_STATUS)?? false;
    notifyListeners();
    return darkTheme;
  }
}