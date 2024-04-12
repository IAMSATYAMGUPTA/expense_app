import 'dart:ui';

import 'package:expense_app/Constant/color_constant.dart';
import 'package:flutter/material.dart';

/// Text Feild Decoration
InputDecoration myDecoration({
  IconData? mPrefixIcon,
  IconData? mSuffixIcon,
  VoidCallback? onSuffixIconTap,
  required String mLabel,
  String mHint="",
  bool showError=false,
  String errorText="",

})

{
  return InputDecoration(
      suffixIcon: mSuffixIcon != null ? InkWell(child: Icon(mSuffixIcon), onTap: onSuffixIconTap,) : null,
      prefixIcon: mPrefixIcon != null ? Icon(mPrefixIcon) : null,
    label: Text(mLabel),
    hintText: mHint,
      errorText: showError ? errorText : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(21),
      borderSide: BorderSide(color: ColorConstant.mattBlackColor,width: 1)
    )
  );
}

/// Text Style
TextStyle mTextStyle12({ FontWeight mWeight = FontWeight.normal,Color fontColor = Colors.black}){
  return TextStyle(
    fontSize: 12,
    fontFamily: 'Mulish',
    fontWeight: mWeight,
    color: fontColor
  );
}

TextStyle mTextStyle16({ FontWeight mWeight = FontWeight.normal,Color fontColor = Colors.black}){
  return TextStyle(
      fontSize: 16,
      fontFamily: 'Mulish',
      fontWeight: mWeight,
      color: fontColor
  );
}

TextStyle mTextStyle20({ FontWeight mWeight = FontWeight.normal,Color fontColor = Colors.black}){
  return TextStyle(
      fontSize: 20,
      fontFamily: 'Mulish',
      fontWeight: mWeight,
      color: fontColor
  );
}

TextStyle mTextStyle25({ FontWeight mWeight = FontWeight.normal,Color fontColor = Colors.black}){
  return TextStyle(
      fontSize: 25,
      fontFamily: 'Mulish',
      fontWeight: mWeight,
      color: fontColor
  );
}

TextStyle mTextStyle34({ FontWeight mWeight = FontWeight.normal,Color fontColor = Colors.black}){
  return TextStyle(
      fontSize: 34,
      fontFamily: 'Mulish',
      fontWeight: mWeight,
      color: fontColor
  );
}

TextStyle mTextStyle43({ FontWeight mWeight = FontWeight.normal,Color fontColor = Colors.black}){
  return TextStyle(
      fontSize: 43,
      fontFamily: 'Mulish',
      fontWeight: mWeight,
      color: fontColor
  );
}