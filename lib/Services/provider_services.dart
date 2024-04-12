import 'package:expense_app/Screens/Home_Screen/theme_manage_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageTheme extends ChangeNotifier{

  int _changeTheme = 1;

  int changeTheme() => _changeTheme;

  void changeThemeValue(int value) {
    _changeTheme=value;
    notifyListeners();
  }

  void getThemeValue()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var value = sharedPreferences.getInt(ThemePageState.THEMEKEY);
    // print(value);
    if(value==null){
      value = 1;
    }
    _changeTheme = value;
    notifyListeners();
  }

}