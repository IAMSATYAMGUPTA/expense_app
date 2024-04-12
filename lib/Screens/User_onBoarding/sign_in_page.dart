import 'package:expense_app/App%20Database/db_helper.dart';
import 'package:expense_app/Custom_Widget/app_custom_widget.dart';
import 'package:expense_app/Screens/Splash/splash_page.dart';
import 'package:expense_app/Screens/User_onBoarding/sign_up_page.dart';
import 'package:expense_app/Screens/Home_Screen/home_page.dart';
import 'package:expense_app/utills/my_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Mixing classes/validator_mixing.dart';
import '../../Constant/image_constant.dart';
import '../Home_Screen/manage_bottom_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ValidatorMixin {

  var formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  late DBHelper dbHelper;

  final emailcController = TextEditingController();
  final passwordcController = TextEditingController();

  bool isEmail = false;
  bool isPassword = false;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.db;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    var mWidth = mediaQueryData.size.width;
    var mHeight = mediaQueryData.size.height;
    var mOrientation = mediaQueryData.orientation;
    return Scaffold(
      body: Center(
        child: mOrientation==Orientation.portrait ? PortraitUI(mWidth):LandscapeUI(mWidth),
      ),
    );
  }

  Widget mainUI(double mWidth){
    return Padding(
      padding: mWidth>450.0 ? EdgeInsets.symmetric(horizontal: mWidth*0.2):EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // App Logo
              AppLOGO(mWidth: mWidth,bgColor: Theme.of(context).colorScheme.secondary,iconColor: Theme.of(context).colorScheme.onSecondary),
              hSpacer(height: 15.0),

              // Login welcome title TextFeild
              Text("Welcome, Back !!",style: Theme.of(context).textTheme.headlineSmall,),
              hSpacer(height: 40.0),

              // User Email Text
              TextFormField(
                validator: emailValidate,
                controller: emailcController,
                decoration: myDecoration(
                    errorText: "This Email is not Exist",
                    showError: isEmail,
                    // mHint: "Enter your Email",
                    mLabel: "Email",
                    mPrefixIcon: Icons.email_outlined
                ),
              ),
              hSpacer(),

              // User Password TextFeild
              TextFormField(
                validator: passValidate,
                controller: passwordcController,
                obscuringCharacter: "*",
                obscureText: !isPasswordVisible,
                decoration: myDecoration(
                    errorText: "Password is not Correct",
                    showError: isPassword,
                    // mHint: "Enter your Password",
                    mLabel: "Password",
                    mPrefixIcon: Icons.password,
                    mSuffixIcon: isPasswordVisible ? Icons.visibility :Icons.visibility_off,
                    onSuffixIconTap: (){
                      isPasswordVisible = !isPasswordVisible;
                      setState(() {
                      });
                    }
                ),
              ),
              hSpacer(height: 40.0),

              // Login Button
              RoundedButton(onTap: (){
                if (formKey.currentState != null) {
                  if (formKey.currentState!.validate()) {
                    checkUserAuthentication(emailcController.text.toString(),passwordcController.text.toString());
                  }
                }
              },
                  context: context,
                  title: "LOGIN"),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: (){}, child: Text("Forgot Password")),
              ),

              hSpacer(height: 55),

              // create new account page button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ",style: mTextStyle16(fontColor: Theme.of(context).colorScheme.onPrimary),),
                  TextButton(
                      onPressed: () {
                        formKey.currentState!.reset();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(),));
                        },
                      child: Text("Sign up",style: TextStyle(fontSize: 18),))
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget PortraitUI(double mWidth){
    return mainUI(mWidth);
  }

  Widget LandscapeUI(double mWidth){
    return Row(
      children: [

        Expanded(
          flex: 2,
            child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Theme.of(context).colorScheme.onSurface,
            child: Image.asset(ImageConstants.appBanner1))),

        Expanded(
          flex: 3,
            child: LayoutBuilder(
          builder: (context,constraint) {
            return mainUI(constraint.maxWidth);
          }
        ))

      ],
    );
  }

  checkUserAuthentication(email,password)async{
    var sharedPref = await SharedPreferences.getInstance();
    bool uEmail = await dbHelper.checkUserEmail(email);
    bool uPassword = await dbHelper.checkUserPassword(password);
    if(uEmail && uPassword){

      // set detail in sharepreference
      sharedPref.setBool(SplashPageState.KEYLOGIN, true);

      formKey.currentState!.reset();
      emailcController.clear();
      passwordcController.clear();
      dbHelper.setCurrentUserID(email, password);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ManageBottomNavigation(),));
      isEmail = false;
      isPassword = false;
    }else if(!uEmail){
      CustomToast().toastMessage(msg: "This Email is not Exist");
      isPassword = false;
      isEmail = true;
      setState(() {

      });
    }else if (uEmail && !uPassword){
      CustomToast().toastMessage(msg: "Password is not Correct");
      isEmail = false;
      isPassword = true;
      setState(() {

      });
    }

  }

}
