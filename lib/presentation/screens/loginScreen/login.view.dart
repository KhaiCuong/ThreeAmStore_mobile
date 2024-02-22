import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/presentation/screens/loginScreen/widget/welcome.login.widget.dart';
import 'package:scarvs/presentation/widgets/dimensions.widget.dart';
import 'package:scarvs/core/notifiers/authentication.notifer.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:scarvs/presentation/widgets/custom.text.field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //  var _email='nguyenminhbrian95@gmail.com';
  //   var _password = '1234567';
  // var _email = 'a@a.com';
  // var _password = '123456';

  @override
  Widget build(BuildContext context) {
    // userEmailController.text = _email;
    // userPassController.text = _password;
    _userLogin() {
      if (_formKey.currentState!.validate()) {
        var authNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authNotifier.userLogin(
            context: context,
            useremail: userEmailController.text,
            userpassword: userPassController.text);
      }
    }

    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              welcomeTextLogin(themeFlag: themeFlag),
              vSizedBox2,
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
                            child: CustomTextField.customTextField(
                              textEditingController: userEmailController,
                              hintText: 'Enter an email',
                              validator: (val) =>
                                  !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                          .hasMatch(val!)
                                      ? 'Enter an email'
                                      : null,
                              obscureText: false,
                              labelText: 'Email',
                            ),
                          ),
                          vSizedBox1,
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
                            child: CustomTextField.customTextField(
                              textEditingController: userPassController,
                              hintText: 'Enter a password',
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter a password' : null,
                              obscureText: true,
                              labelText: 'Password',
                            ),
                          )
                        ],
                      ),
                    ),
                    vSizedBox2,
                    MaterialButton(
                      height: MediaQuery.of(context).size.height * 0.05,
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () async {
                        _userLogin();
                      },
                      color: AppColors.rawSienna,
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              vSizedBox2,
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "",
                    style: TextStyle(
                      color:
                          themeFlag ? AppColors.creamColor : AppColors.mirage,
                      fontSize: 14.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRouter.signUpRoute),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Thêm khoảng cách giữa các phần tử
                  Text(
                    "|",
                    style: TextStyle(
                      color:
                          themeFlag ? AppColors.creamColor : AppColors.mirage,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(width: 10), 
                  // Thêm khoảng cách giữa các phần tử
                  Flexible( child: Text(
                    "",
                    style: TextStyle(
                      color:
                          themeFlag ? AppColors.creamColor : AppColors.mirage,
                      fontSize: 14.0,
                    ),
                    softWrap: true,
                    )
                
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(AppRouter.forgetPassword),
                    child: Text(
                      "Forget Password",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
