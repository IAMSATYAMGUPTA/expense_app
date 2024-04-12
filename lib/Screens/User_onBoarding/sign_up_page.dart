import 'package:expense_app/App%20Database/db_helper.dart';
import 'package:expense_app/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Custom_Widget/app_custom_widget.dart';
import '../../Mixing classes/validator_mixing.dart';
import '../../Constant/image_constant.dart';
import '../../utills/my_styles.dart';
import '../Home_Screen/manage_bottom_navigation.dart';
import '../Splash/splash_page.dart';
import '../Home_Screen/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with ValidatorMixin {

  late DBHelper dbHelper ;

  var formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  final emailcController = TextEditingController();
  final passwordcController = TextEditingController();
  final confirmPasswordcController = TextEditingController();

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
      padding: mWidth>600.0 ? EdgeInsets.symmetric(horizontal: mWidth*0.2):EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // New account title
              Row(
                children: [
                  Text("Create Account",style: Theme.of(context).textTheme.headlineSmall,),
                ],
              ),
              hSpacer(height: 40.0),

              // User Email Text
              TextFormField(
                validator: emailValidate,
                controller: emailcController,
                decoration: myDecoration(
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
                obscureText: isPasswordVisible ? false:true,
                decoration: myDecoration(
                    // mHint: "Enter your Password",
                    mLabel: "Password",
                    mPrefixIcon: Icons.password,
                    mSuffixIcon: isPasswordVisible ? Icons.visibility:Icons.visibility_off,
                    onSuffixIconTap: (){
                      isPasswordVisible = true;
                      setState(() {

                      });
                    }
                ),
              ),
              hSpacer(),

              // User Confirm password Text
              TextFormField(
                validator: passValidate,
                controller: confirmPasswordcController,
                obscuringCharacter: "*",
                obscureText: true,
                decoration: myDecoration(
                    // mHint: "Confirm your Password",
                    mLabel: "Confirm Password",
                    mPrefixIcon: Icons.password
                ),
              ),
              hSpacer(height: 40.0),

              // Login Button
              RoundedButton(onTap: (){
                if (formKey.currentState != null) {
                  if (formKey.currentState!.validate()) {
                    if(confirmPasswordcController.text.toString()==passwordcController.text.toString()){
                      checkUserAuthentication(
                        email: emailcController.text.toString(),
                        password: passwordcController.text.toString()
                      );
                    }
                    else{
                      CustomToast().toastMessage(msg: "Both password are not same");
                    }

                  }
                }
              },
                  context: context,
                  title: "CREATE NEW ACCOUNT"),

              hSpacer(height: 55),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",style: mTextStyle16(fontColor: Theme.of(context).colorScheme.onPrimary),),
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("Sign in",style: TextStyle(fontSize: 18),))
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
                child: Image.asset(ImageConstants.appBanner2))),

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

  checkUserAuthentication({required String email,required String password})async{
    var check = await dbHelper.addUserDetail(UserModel(userName: email, password: password));
    if(check){
      dbHelper.setCurrentUserID(email, password);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ManageBottomNavigation(),));
      var sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool(SplashPageState.KEYLOGIN, true);
      formKey.currentState!.reset();
      emailcController.clear();
      passwordcController.clear();
      confirmPasswordcController.clear();
    }else{
      CustomToast().toastMessage(msg: "This Email already Exist");
    }
  }

}

