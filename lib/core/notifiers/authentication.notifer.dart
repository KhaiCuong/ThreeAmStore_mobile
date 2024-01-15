// ignore_for_file: avoid_print, recursive_getters

import 'dart:convert';

import 'dart:io';
import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
// import 'package:jwt_decode/jwt_decode.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'package:scarvs/app/constants/app.keys.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/core/api/authentication.api.dart';
import 'package:scarvs/core/models/api_response.dart';
import 'package:scarvs/core/models/userDetails.model.dart';
import 'package:scarvs/core/utils/snackbar.util.dart';
import 'package:scarvs/presentation/screens/signUpScreen/widget/loading/loading_options_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/routes/api.routes.dart';

class AuthenticationNotifier with ChangeNotifier {
  final AuthenticationAPI _authenticationAPI = AuthenticationAPI();

  String? _passwordLevel = "";
  String? get passwordLevel => _passwordLevel;

  String? _fullName = "";
  String? get fullName => _fullName;

  String? _passwordEmoji = "";
  String? get passwordEmoji => _passwordEmoji;

  User _user = User(
      token: '',
      id: 0,
      username: '',
      useremail: '',
      userpassword: '',
      useraddress: '',
      userphoneNo: '',
      role: '');
  User get auth => _user;

  void checkPasswordStrength({required String password}) {
    String mediumPattern = r'^(?=.*?[!@#\$&*~]).{8,}';
    String strongPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

    if (password.contains(RegExp(strongPattern))) {
      _passwordEmoji = '🚀';
      _passwordLevel = 'Strong';
      notifyListeners();
    } else if (password.contains(RegExp(mediumPattern))) {
      _passwordEmoji = '🔥';
      _passwordLevel = 'Medium';
      notifyListeners();
    } else if (!password.contains(RegExp(strongPattern))) {
      _passwordEmoji = '😢';
      _passwordLevel = 'Weak';
      notifyListeners();
    }
  }

  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': "*",
  };
  Future createAccount(
      {required String useremail,
      required BuildContext context,
      required String username,
      required String userpassword,
      required String userphone,
      required String useraddress}) async {
    try {
      const subUrl = '/api/User/AddUser';
      final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
      print(">>>>>>>>>>>>>>>>>>>>>>>userData: ${uri}");
      final http.Response response = await http.Client().post(uri,
          headers: headers,
          body: jsonEncode({
            "fullname": username,
            "phone_number": userphone,
            "address": useraddress,
            "role": "User",
            "email": useremail,
            "password": userpassword
          }));

      // var userData = await _authenticationAPI.createAccount(
      //     useremail: useremail, username: username, userpassword: userpassword, userphone: userphone, useraddress: useraddress);
      // print(userData);
      var userData = response.body;

      // print(">>>>>>>>>>>>>>>>>>>>>>>userData: ${response}");

      final Map<String, dynamic> parseData = await jsonDecode(userData);
      print(">>>>>>>>>>>>>>>>>>>>>>>parseData: ${parseData}");

      // bool isAuthenticated = parseData['authentication'];
      // dynamic authData = parseData as String;

      // var response;
      if (response.statusCode == 200) {
        WriteCache.setString(key: AppKeys.userData, value: username)
            .whenComplete(
          () =>
              Navigator.of(context).pushReplacementNamed(AppRouter.successSignup),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackUtil.stylishSnackBar(context: context, text: ''));
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'An error occurred', context: context));
    }
  }

  Future userLogin({
    required String useremail,
    required BuildContext context,
    required String userpassword,
  }) async {
    try {
      const subUrl = '/api/Auth/Login';
      final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
      // print(">>>>>>>>>>>>>>>>>>>>>>>userData: ${uri}");
      final http.Response response = await http.Client().post(uri,
          headers: headers,
          body: jsonEncode({"email": useremail, "password": userpassword}));
      // var userData = await _authenticationAPI.userLogin(
      //     useremail: useremail, userpassword: userpassword);
      // print(userData);
      var userData = response.body;

      // print(">>>>>>>>>>>>>>>>>>>>>>>userData: ${response}");

      final Map<String, dynamic> parseData = await jsonDecode(userData);

      final Map<String, dynamic> kkk = {
        "token": parseData['token'],
        "id": parseData['userToken']['user_id'],
        "username": parseData['userToken']['fullname'],
        "userphoneNo": parseData['userToken']['phone_number'],
        "useraddress": parseData['userToken']['address'],
        "useremail": parseData['userToken']['email'],
        "userpassword": parseData['userToken']['password'],
        "role": parseData['userToken']['role'],
      };

      _user = User.fromJson(kkk);

      print(">>>>>>>>>>>>>>>>>>>>>>>parseData: ${parseData}");

      // bool isAuthenticated = parseData['authentication'];
      // dynamic authData = parseData['data'];

      if (response.statusCode == 200) {
        WriteCache.setString(key: AppKeys.userData, value: useremail)
            .whenComplete(
          () => Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackUtil.stylishSnackBar(context: context, text: ''));
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'An error occurred', context: context));
    }
  }
  // Future<bool> getDataToken(String token, SharedPreferences prefs) async {
  //   Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
  //   if (decodedToken.isNotEmpty) {
  //     String email = decodedToken['sub'];
  //     int expirationTime = decodedToken['exp'];
  //     DateTime expirationDateTime =
  //         DateTime.fromMillisecondsSinceEpoch(expirationTime * 1000);
  //     if (!checkTokenExp(expirationTime)) {
  //       await prefs.setString('email', email);
  //       await prefs.setInt('expirationTime', expirationTime);
  //       print("email: $email");
  //       print("Token Expiration Time: $expirationDateTime");
  //       return true;
  //     }
  //     print("Token Expiration Time: Đã hết hạn");
  //     return false;
  //   } else {
  //     print("Failed to decode JWT");
  //     return false;
  //   }
  // }

  bool checkTokenExp(int expireTime) {
    bool checkTime = DateTime.now().millisecondsSinceEpoch > expireTime * 1000;
    return checkTime;
  }
}
