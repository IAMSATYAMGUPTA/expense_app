import 'dart:async';

import 'package:expense_app/Services/provider_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  State<ThemePage> createState() => ThemePageState();
}

class ThemePageState extends State<ThemePage> {

  static const THEMEKEY = 'themekey';
  late String selectedOption = '1';

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 400), () {
      getThemeValue();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Themes"),
      ),
      body: Column(
        children: [
          CustomRadioButton(
            label: 'System',
            value: '1',
            selectedValue: selectedOption,
            onChanged: (value) {
              setThemeValue(int.parse(value));
              setState(() {
                selectedOption = value;
              });
            },
            selectedColor: Theme.of(context).colorScheme.primary,
            unselectedColor: Colors.grey,
          ),
          CustomRadioButton(
            label: 'Light',
            value: '2',
            selectedValue: selectedOption,
            onChanged: (value) {
              setThemeValue(int.parse(value));
              setState(() {
                selectedOption = value;
              });
            },
            selectedColor: Theme.of(context).colorScheme.primary,
            unselectedColor: Colors.grey,
          ),
          CustomRadioButton(
            label: 'Dark',
            value: '3',
            selectedValue: selectedOption,
            onChanged: (value) {
              setThemeValue(int.parse(value));
              setState(() {
                selectedOption = value;
              });
            },
            selectedColor: Theme.of(context).colorScheme.primary,
            unselectedColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  void getThemeValue()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var themeValue = sharedPreferences.getInt(THEMEKEY);
    selectedOption = themeValue.toString();
    setState(() {
    });
  }
  void setThemeValue(int value)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(THEMEKEY,value);
    context.read<ManageTheme>().changeThemeValue(value);
  }
}
class CustomRadioButton extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final Function(String) onChanged;
  final Color selectedColor;
  final Color unselectedColor;

  CustomRadioButton({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(value);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20,20,20,0),
        child: Row(
          children: [
            Icon(selectedValue == value ?Icons.radio_button_checked:Icons.radio_button_off,
                color : selectedValue == value ? Theme.of(context).colorScheme.primary:Colors.grey),
            SizedBox(width: 12.0),
            Text(label,style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 16),),
          ],
        ),
      ),
    );
  }
}
