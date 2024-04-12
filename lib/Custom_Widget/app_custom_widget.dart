import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constant/image_constant.dart';

Widget hSpacer({double height = 11.0}){
  return SizedBox(
    height: height,
  );
}

Widget wSpacer({double width = 15.0}){
  return SizedBox(
    width: width,
  );
}

class CustomToast{
  FutureOr<Null?> toastMessage({required String msg,Color color = Colors.grey}){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}


Widget RoundedButton({required VoidCallback onTap,required String title,required BuildContext context,Widget? mWidget}){
  return SizedBox(
    height: 40,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
        backgroundColor: Theme.of(context).colorScheme.secondary
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: mWidget ?? Text(title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 16,
                fontFamily: GoogleFonts.notoSerif().fontFamily,),
          ),
          ),
        ],
      ),
    ),
  );
}

Widget AppLOGO({required double mWidth,required Color bgColor,required Color iconColor}){
  return CircleAvatar(
    radius: mWidth<361 ? 34:mWidth*0.05,
    backgroundColor: bgColor,
    child: Image.asset(ImageConstants.appLogoIcon,color: iconColor,
      width: mWidth<400 ? 34:mWidth*0.048,
      height: mWidth<400 ? 34:mWidth*0.048,),
  );
}