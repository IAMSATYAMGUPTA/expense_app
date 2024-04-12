import 'package:expense_app/App%20Database/db_helper.dart';
import 'package:expense_app/Services/graph_provider.dart';
import 'package:expense_app/Screens/Splash/splash_page.dart';
import 'package:expense_app/utills/app_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'Screens/Home_Screen/Add Transection/bloc/expense_bloc.dart';
import 'Services/provider_services.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ManageTheme(),
        ),
        BlocProvider(
            create: (context) => ExpenseBloc(db: DBHelper.db),
        ),
        ChangeNotifierProvider(
            create: (context) => GraphProvider(),
        )
      ],
      child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ManageTheme>(
        builder: (context, value, child) {
          var themeMode;
          if(value.changeTheme()==1){
            themeMode = ThemeMode.system;
          }else if(value.changeTheme()==2){
            themeMode = ThemeMode.light;
          }else{
            themeMode = ThemeMode.dark;
          }
          return MaterialApp(
            title: 'Flutter Demo',
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            // themeMode: value.changeTheme ? ThemeMode.dark:ThemeMode.light,
            darkTheme: AppTheme.darkTheme,
            theme: AppTheme.lightTheme,
            home: const SplashPage(),
          );
        },
    );
  }
}

