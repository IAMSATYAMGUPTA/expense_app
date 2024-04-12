import 'package:expense_app/Screens/Home_Screen/Expense_Graph/expense_graph_screen.dart';
import 'package:expense_app/Screens/Home_Screen/home_page.dart';
import 'package:expense_app/Screens/Home_Screen/setting_page.dart';
import 'package:flutter/material.dart';

class ManageBottomNavigation extends StatefulWidget {
  const ManageBottomNavigation({Key? key}) : super(key: key);

  @override
  State<ManageBottomNavigation> createState() => _ManageBottomNavigationState();
}

class _ManageBottomNavigationState extends State<ManageBottomNavigation> {

  int _selectedItem = 0;
  var _pagesData = [HomePage(),ExpenseDetailsPage(),SettingPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pagesData[_selectedItem],
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 20,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          selectedFontSize: 14,
          selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedItem,
          onTap: (index){
            setState(() {
              _selectedItem=index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph),
              label: 'Graph',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ]
      ),
    );
  }
}
