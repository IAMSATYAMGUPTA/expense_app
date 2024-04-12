import 'dart:async';

import 'package:expense_app/Custom_Widget/app_custom_widget.dart';
import 'package:expense_app/Screens/User_onBoarding/sign_in_page.dart';
import 'package:expense_app/Screens/Home_Screen/home_page.dart';
import 'package:expense_app/Services/provider_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant/image_constant.dart';
import '../../utills/my_styles.dart';
import '../Home_Screen/manage_bottom_navigation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {

  static const String KEYLOGIN = "login";

  @override
  void initState() {
    super.initState();
    context.read<ManageTheme>().getThemeValue();
    Timer(Duration(seconds: 3), () {
      whereToGO();
    });

  }



  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context).size;
    var mWidth = mediaQueryData.width;
    var mHeight = mediaQueryData.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLOGO(mWidth: mWidth,bgColor: Theme.of(context).colorScheme.secondary,iconColor: Theme.of(context).colorScheme.onSecondary),

            Text("Expenser",style: mWidth>800 ? mTextStyle34(mWeight: FontWeight.bold,fontColor: Theme.of(context).colorScheme.primary):
            mTextStyle25(mWeight: FontWeight.bold,fontColor: Theme.of(context).colorScheme.primary),),

          ],
        ),
      ),
    );
  }

  void whereToGO() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isLogin = sharedPreferences.getBool(KEYLOGIN);

    if(isLogin==null){
      isLogin = false;
    }

    if(isLogin) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ManageBottomNavigation(),));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
    }

  }
}
