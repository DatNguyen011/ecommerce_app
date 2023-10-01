import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget commonTextFormField(bool obsText,String hintText,TextEditingController controller,String? Function(String?)? validator){
  return Container(
    height: 55,
    padding: const EdgeInsets.only(top:4,left: 15,right: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),

    ),
    child: TextFormField(
      obscureText: obsText,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(0),
          hintStyle: const TextStyle(
            height: 1,
          )
      ),
    ),
  );
}