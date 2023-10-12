import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/provider/theme_provider.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider=Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitlesTextWidget(label: "label"),
            SubtitleTextWidget(label: "label"),
            ElevatedButton(onPressed: (){}, child: Text("Text")),
            SwitchListTile(
              title: Text(themeProvider.getIsDarkTheme?"Dark Mode": "Light Mode"),
                value: themeProvider.getIsDarkTheme,
                onChanged: (value){
                  themeProvider.setDarkTheme(themeValue: value);
                })
          ],
        ),
      ),
    );
  }
}
