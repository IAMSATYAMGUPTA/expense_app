import 'package:expense_app/utills/my_styles.dart';
import 'package:flutter/material.dart';

import '../Constant/color_constant.dart';

class AppTheme {

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.black54,
      titleTextStyle: mTextStyle25(fontColor: Colors.white),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.grey.shade900,
      secondary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Color(0xff483ACE),
      onInverseSurface: Colors.grey.shade400,
      inversePrimary: Colors.white
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.grey.shade600),
      labelStyle: TextStyle(color: Colors.grey.shade600),
      suffixIconColor: Colors.grey.shade500,
      prefixIconColor: Colors.grey.shade500,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(color: ColorConstant.mattBlackColor,width: 1)
        )
    ),

    cardTheme: CardTheme(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: TextTheme(
      displayLarge: mTextStyle43(fontColor: Colors.black),
      displayMedium: mTextStyle34(fontColor: Colors.black),
      displaySmall: mTextStyle25(fontColor: Colors.black),
      titleLarge: mTextStyle20(fontColor: Colors.black),
      titleMedium: mTextStyle16(fontColor: Colors.black,),
      titleSmall: mTextStyle12(fontColor: Colors.black),
      headlineLarge: mTextStyle43(fontColor: Colors.black,mWeight: FontWeight.bold),
      headlineMedium: mTextStyle34(fontColor: Colors.black,mWeight: FontWeight.bold),
      headlineSmall: mTextStyle25(fontColor: Colors.black,mWeight: FontWeight.bold),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.grey.shade700,
      titleTextStyle: mTextStyle25(fontColor: Colors.white),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      onPrimary: Colors.white60,
      secondary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.purple.shade400,
      onInverseSurface: Colors.grey.shade700,
      inversePrimary: Colors.grey.shade900,
    ),
    inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.grey),
        suffixIconColor: Colors.grey,
        prefixIconColor: Colors.grey,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
            borderSide: BorderSide(color: ColorConstant.whiteColor,width: 1)
        )
    ),
    cardTheme: CardTheme(
      color: Colors.white24,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: TextTheme(
      displayLarge: mTextStyle43(fontColor: Colors.white),
      displayMedium: mTextStyle34(fontColor: Colors.white),
      displaySmall: mTextStyle25(fontColor: Colors.white),
      titleLarge: mTextStyle20(fontColor: Colors.white),
      titleMedium: mTextStyle16(fontColor: Colors.white,),
      titleSmall: mTextStyle12(fontColor: Colors.white),
      headlineLarge: mTextStyle43(fontColor: Colors.white,mWeight: FontWeight.bold),
      headlineMedium: mTextStyle34(fontColor: Colors.white,mWeight: FontWeight.bold),
      headlineSmall: mTextStyle25(fontColor: Colors.white,mWeight: FontWeight.bold),
    ),
  );
}