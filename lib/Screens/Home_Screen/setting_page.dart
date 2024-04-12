import 'package:expense_app/Custom_Widget/app_custom_widget.dart';
import 'package:expense_app/Screens/Home_Screen/theme_manage_page.dart';
import 'package:expense_app/Screens/Splash/splash_page.dart';
import 'package:expense_app/Screens/User_onBoarding/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Setting",style: Theme.of(context).textTheme.headlineSmall,),
              hSpacer(height: 30),
              settingsButton(icon: Icons.published_with_changes, title: "Theme", onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ThemePage(),));
              }),
              settingsButton(icon: Icons.logout, title: "Log Out", onTap: ()async{
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.setBool(SplashPageState.KEYLOGIN,false);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
              }),
              settingsButton(icon: Icons.share, title: "Share", onTap: (){}),
              settingsButton(icon: Icons.star_rate_outlined, title: "Rate", onTap: (){}),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget settingsButton({required IconData icon,required String title,required VoidCallback onTap}){
    return InkWell(
      onTap: onTap,
      child: ListTile(
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade300)),
        leading: Icon(icon,size: 25,color: Theme.of(context).colorScheme.primary,),
        title: Text(title,style: Theme.of(context).textTheme.titleLarge,),
      ),
    );
  }
  
}
