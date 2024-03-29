import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/app/constants/app.keys.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/core/notifiers/user.notifier.dart';
import 'package:scarvs/core/utils/snackbar.util.dart';
import 'package:scarvs/presentation/widgets/custom.back.btn.dart';
import 'package:scarvs/presentation/widgets/custom.text.field.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';
import 'package:scarvs/presentation/widgets/dimensions.widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController userEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false; // Biến để kiểm tra trạng thái loading

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        body: Column(
          children: [
            Row(
              children: [
                CustomBackPop(themeFlag: themeFlag),
                Text(
                  'Forget Password',
                  style: CustomTextWidget.bodyTextB2(
                    color: themeFlag ? AppColors.creamColor : AppColors.mirage,
                  ),
                ),
              ],
            ),
            isLoading
                ? Expanded(
                    flex: 3,
                    child: Lottie.asset('assets/animations/watch.json'),
                  )
                : Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35.0, 45.0, 35.0, 2.0),
                      child: Column(
                        children: [
                          CustomTextField.customTextField(
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
                          vSizedBox3,
                          MaterialButton(
                            height: MediaQuery.of(context).size.height * 0.05,
                            minWidth: MediaQuery.of(context).size.width * 0.8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                userNotifier.forgetPassword(
                                    userEmail: userEmailController.text,
                                    context: context);
                              }

                              setState(() {
                                isLoading =
                                    true; // Dừng hiển thị trạng thái loading
                              });
                            },
                            color: AppColors.rawSienna,
                            child: const Text(
                              'Submit',
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
                  ),
          ],
        ),
      ),
    );
  }
}
