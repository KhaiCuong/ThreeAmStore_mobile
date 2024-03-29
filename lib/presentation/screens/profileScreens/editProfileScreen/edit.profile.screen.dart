import 'package:flutter/material.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/core/models/userDetails.model.dart';
import 'package:scarvs/core/notifiers/authentication.notifer.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/core/notifiers/user.notifier.dart';
import 'package:scarvs/core/utils/snackbar.util.dart';
import 'package:scarvs/presentation/widgets/custom.back.btn.dart';
import 'package:scarvs/presentation/widgets/custom.text.field.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';
import 'package:scarvs/presentation/widgets/dimensions.widget.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // final authNotifier =
  //     Provider.of<AuthenticationNotifier>( BuildContext context, listen: false);

  late TextEditingController passwordController = TextEditingController();
  late TextEditingController addressController = TextEditingController();
  late TextEditingController numberController = TextEditingController();
  late TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  
  @override
  void initState() {
    super.initState();

    final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    var password = authNotifier.auth.userpassword ?? 'password demo';
    passwordController.text = password;
    var adress = authNotifier.auth.useraddress ?? 'adress demo';
    addressController.text = adress;
    var phone = authNotifier.auth.userphoneNo ?? '0909090909';
    numberController.text = phone;
    var username = authNotifier.auth.username ?? 'Wait';
    nameController.text = username;
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    // UserNotifier userNotifier =
    //     Provider.of<UserNotifier>(context, listen: false);
    // AuthenticationNotifier authNotifier =
    //     Provider.of<AuthenticationNotifier>(context, listen: false);
    final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    // final TextEditingController passwordController =
    //     TextEditingController(text: authNotifier.auth.userpassword);
    // final TextEditingController addressController =
    //     TextEditingController(text: authNotifier.auth.useraddress);
    // final TextEditingController numberController =
    //     TextEditingController(text: authNotifier.auth.userphoneNo);
    // final TextEditingController nameController =
    //     TextEditingController(text: authNotifier.auth.username);

    // passwordController.value =
    //     authNotifier.auth.userpassword as TextEditingValue;
    // addressController.value = authNotifier.auth.useraddress as TextEditingValue;
    // numberController.value = authNotifier.auth.userphoneNo as TextEditingValue;
    // nameController.value = authNotifier.auth.username as TextEditingValue;
    String patttern = r'(^(?:[+0]9)?[0-9]{10,15}$)';
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
              Row(
                children: [
                  CustomBackPop(themeFlag: themeFlag),
                  Text(
                    'Edit Profile',
                    style: CustomTextWidget.bodyTextB2(
                      color:
                          themeFlag ? AppColors.creamColor : AppColors.mirage,
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(35.0, 45.0, 35.0, 2.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Full Name',
                          style: TextStyle(
                            color: themeFlag
                                ? AppColors.creamColor
                                : AppColors.mirage,
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      CustomTextField.customTextField(
                        textEditingController: nameController,
                        hintText: 'Enter FullName', labelText: 'Full Name:',
                        obscureText: false,

                        // validator: (val) =>
                        //     val!.isEmpty ? 'Enter FullName' : null,
                      ),
                      vSizedBox3,
                         Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: themeFlag
                                ? AppColors.creamColor
                                : AppColors.mirage,
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      CustomTextField.customTextField(
                        textEditingController: passwordController,

                        hintText: 'Enter New Password',
                        obscureText: true, labelText: 'PassWord:',
                        // validator: (val) =>
                        //     val!.isEmpty ? 'Enter New Password' : null,
                      ),
                      vSizedBox3,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Address',
                          style: TextStyle(
                            color: themeFlag
                                ? AppColors.creamColor
                                : AppColors.mirage,
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      CustomTextField.customTextField(
                        textEditingController: addressController,
                        hintText: 'Enter Address', obscureText: false,
                        labelText: 'Address:',
                        // validator: (val) =>
                        //     val!.isEmpty ? 'Enter Address' : null,
                      ),
                      vSizedBox3,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Phone Number',
                          style: TextStyle(
                            color: themeFlag
                                ? AppColors.creamColor
                                : AppColors.mirage,
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      CustomTextField.customTextField(
                        textEditingController: numberController,
                        hintText: 'Enter Phone No', obscureText: false,
                        labelText: 'Phone No:',
                        // validator: (val) => !RegExp(patttern).hasMatch(val!)
                        //     ? 'Enter Phone No'
                        //     : null,
                      ),
                      vSizedBox3,
                      MaterialButton(
                        height: MediaQuery.of(context).size.height * 0.05,
                        minWidth: MediaQuery.of(context).size.width * 0.8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () async {
                          // print(_formKey.currentState!.validate());
                          if (_formKey.currentState!.validate()) {
                            authNotifier
                                .updateUserDetails(
                                    userId: authNotifier.auth.id,
                                    email: authNotifier.auth.useremail,
                                    address: addressController.text,
                                    phone_number: numberController.text,
                                    fullname: nameController.text,
                                    password: authNotifier.auth.userpassword,
                                    context: context)
                                .then((value) {
                              print(">>>>>>>>>>>>>>>>>>>>>>>password: ${authNotifier.auth.userpassword}");

                              // if (value.status == 200) {
                              //   print(
                              //       ">>>>>>>>>>>>>>>>>>>>>>>value.hashCode: ${value.hashCode}");

                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackUtil.stylishSnackBar(
                              //       text: 'Info Updated',
                              //       context: context,
                              //     ),
                              //   );
                              //   Navigator.of(context).pop();
                              // } else {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackUtil.stylishSnackBar(
                              //       text:
                              //           'Error Please Try Again , After a While',
                              //       context: context,
                              //     ),
                              //   );
                              //   Navigator.of(context).pop();
                              // }
                            });
                          }
                        },
                        color: AppColors.rawSienna,
                        child: const Text(
                          'Update',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
