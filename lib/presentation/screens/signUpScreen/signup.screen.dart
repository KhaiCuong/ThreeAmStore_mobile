import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/presentation/screens/signUpScreen/widget/welcome.signup.widget.dart';
import 'package:scarvs/presentation/widgets/dimensions.widget.dart';
import 'package:scarvs/core/notifiers/authentication.notifer.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:scarvs/presentation/widgets/custom.animated.container.dart';
import 'package:scarvs/presentation/widgets/custom.text.field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPassController = TextEditingController();
  final TextEditingController userPhoneController = TextEditingController();
  final TextEditingController userAddressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    AuthenticationNotifier authNotifier(bool renderUI) =>
        Provider.of<AuthenticationNotifier>(context, listen: renderUI);

    _createAccount() {
      if (_formKey.currentState!.validate()) {
        authNotifier(false).createAccount(
            context: context,
            useremail: userEmailController.text,
            username: userNameController.text,
            userpassword: userPassController.text,
            userphone: userPhoneController.text,
            useraddress: userAddressController.text);
      }
    }

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
              welcomeTextSignup(themeFlag: themeFlag),
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
                            padding: const EdgeInsets.fromLTRB(
                                35.0, 10.0, 35.0, 2.0),
                            child: CustomTextField.customTextField(
                                textEditingController: userNameController,
                                hintText: 'Enter User Name',
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter an Username' : null, obscureText: false, labelText: 'User Name:'),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                35.0, 10.0, 35.0, 2.0),
                            child: CustomTextField.customTextField(
                              textEditingController: userEmailController,
                              hintText: 'Enter an email',
                              validator: (val) =>
                                  !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                          .hasMatch(val!)
                                      ? 'Enter an email'
                                      : null, obscureText: false, labelText: 'Email:',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                35.0, 10.0, 35.0, 2.0),
                            child: CustomTextField.customTextField(
                              textEditingController: userPhoneController,
                              hintText: 'Enter a Phone Number',
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Phone is required";
                                } else if (!RegExp(r'^0\d{9}$').hasMatch(val)) {
                                  return "The phone starts with 0 and must have 10 numbers";
                                }
                                return null;
                              }, obscureText: false, labelText: 'Phone Nuber:',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                35.0, 10.0, 35.0, 2.0),
                            child: CustomTextField.customTextField(
                              textEditingController: userAddressController,
                              hintText: 'Enter a Youre Addresss',
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter a Youre Address' : null, obscureText: false, labelText: 'Address:',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                35.0, 10.0, 35.0, 2.0),
                            child: CustomTextField.customTextField(
                              onChanged: (val) {
                                authNotifier(false)
                                    .checkPasswordStrength(password: val);
                              },
                              textEditingController: userPassController,
                              hintText: 'Enter a Password',
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter a password' : null, obscureText: true, labelText: 'Password:',
                            ),
                          ),
                        ],
                      ),
                    ),
                    vSizedBox1,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 2.0),
                      child: Row(
                        children: [
                          Text(authNotifier(true).passwordEmoji!),
                          hSizedBox1,
                          if (authNotifier(true).passwordLevel! == 'Weak')
                            CustomAnimatedContainer.customAnimatedContainer(
                              height: 10,
                              width: MediaQuery.of(context).size.width * 0.10,
                              context: context,
                              color: Colors.red,
                              curve: Curves.easeIn,
                            ),
                          if (authNotifier(true).passwordLevel! == 'Medium')
                            CustomAnimatedContainer.customAnimatedContainer(
                              height: 10,
                              width: MediaQuery.of(context).size.width * 0.40,
                              context: context,
                              color: Colors.blue,
                              curve: Curves.easeIn,
                            ),
                          if (authNotifier(true).passwordLevel! == 'Strong')
                            CustomAnimatedContainer.customAnimatedContainer(
                              height: 10,
                              width: MediaQuery.of(context).size.width * 0.70,
                              context: context,
                              color: Colors.green,
                              curve: Curves.easeIn,
                            ),
                        ],
                      ),
                    ),
                    vSizedBox1,
                    MaterialButton(
                      height: MediaQuery.of(context).size.height * 0.05,
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () async {
                        _createAccount();
                      },
                      color: AppColors.rawSienna,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              vSizedBox2,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Having A Account? ",
                    style: TextStyle(
                      color:
                          themeFlag ? AppColors.creamColor : AppColors.mirage,
                      fontSize: 14.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRouter.loginRoute),
                    child: Text(
                      "Login now",
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
