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

  String? _password = "";
  String? get password => _password;

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

      var userData = response.body;

      // print(">>>>>>>>>>>>>>>>>>>>>>>userData: ${response}");

      final Map<String, dynamic> parseData = await jsonDecode(userData);
      print(">>>>>>>>>>>>>>>>>>>>>>>parseData: ${parseData}");

      // bool isAuthenticated = parseData['authentication'];
      // dynamic authData = parseData as String;

      // var response;
      if (response.statusCode == 201) {
        WriteCache.setString(key: AppKeys.userData, value: username)
            .whenComplete(
          () => Navigator.of(context)
              .pushReplacementNamed(AppRouter.successSignup),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            context: context, text: 'Register faill'));
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

      print(
          ">>>>>>>>>>>>>>>>>>>>>>>userData statusCode: ${response.statusCode}");
      // print(">>>>>>>>>>>>>>>>>>>>>>>userData : ${userData}");

      if (response.statusCode == 200) {
        var userData = response.body;
        final Map<String, dynamic> parseData = await jsonDecode(userData);
// Check if the 'data' key exists in the JSON object

        // bool isAuthenticated = parseData['authentication'];
        // dynamic authData = parseData['data'];
        if (parseData.containsKey('data')) {
          // If 'data' key exists, get its value which is another map
          Map<String, dynamic> dataMap = parseData['data'];

          if (dataMap.containsKey('userToken')) {
            final Map<String, dynamic> userToken = dataMap['userToken'];
            final Map<String, dynamic> kkk = {
              "token": dataMap['token'],
              "id": userToken['userId'] ?? '',
              "username": userToken['fullname'] ?? '',
              "userphoneNo": userToken['phone_number'] ?? '',
              "useraddress": userToken['address'] ?? '',
              "useremail": userToken['email'] ?? '',
              "userpassword": userToken['password'] ?? '',
              "role": userToken['role'] ?? '',
              "verify": userToken['verify'] ?? '',
            };
            print(">>>>>>>>>>>>>>>>>>>>>>>userData0:${kkk}");
            _user = User.fromJson(kkk);

            if (_user.verify == true) {
              WriteCache.setString(key: AppKeys.userData, value: useremail)
                  .whenComplete(
                () => Navigator.of(context)
                    .pushReplacementNamed(AppRouter.homeRoute),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackUtil.stylishSnackBar(
                      context: context,
                      text: 'UnVerify Account. Please Verify'));
            }
          }
        } else {
          print('data key does not exist in the JSON object');
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            context: context, text: 'Login SuccessFully'));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            context: context, text: 'UnVerify Account. Please Verify'));
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Please check your Password & Email', context: context));
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

  Future updateUserDetails(
      {required BuildContext context,
      required int userId,
      required String password,
      required String fullname,
      required String phone_number,
      required String address,
      required String email}) async {
    // try {
    final subUrl = '/api/User/UpdateUser/$userId';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    print(">>>>>>>>>>>>>>>>>>>>>>>uri: ${uri}");
    final http.Response response = await http.Client().put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
        },
        body: jsonEncode({
          "userId": userId,
          "fullname": fullname,
          "email": email,
          "address": address,
          "phone_number": phone_number,
          "role": "User",
          "password": password
        }));
    // print(">>>>>>>>>>>>>>>>>>>>>>>body: ${jsonEncode({
    //       "userId": userId,
    //       "fullname": fullname,
    //       "email": email,
    //       "address": address,
    //       "phone_number": phone_number,
    //       "role": "User",
    //       "password": password
    //     })}");
    var userData = response.body;
    print(">>>>>>>>>>>>>>>>>>>>>>>response.body: ${response.body}");
    final Map<String, dynamic> parseData = await jsonDecode(userData);
    print(">>>>>>>>>>>>>>>>>>>>>>>parseData: ${parseData}");
    final dynamic body = response.body;
    // final Map<String, dynamic> kkkupdate = {
    //   "token": _user.token,
    //   "id": parseData['data']['userId'],
    //   "username": parseData['data']['fullname'],
    //   "userphoneNo": parseData['data']['phone_number'],
    //   "useraddress": parseData['data']['address'],
    //   "useremail": parseData['data']['email'],
    //   "userpassword": parseData['data']['password'],
    //   "role": parseData['data']['role'],
    // };

    // _user = User.fromJson(kkkupdate);

    if (parseData.containsKey('data')) {
      // If 'data' key exists, get its value which is another ma
      final Map<String, dynamic> userToken = parseData['data'];
      final Map<String, dynamic> kkkupdate = {
        "token": _user.token,
        "id": userToken['userId'] ?? '',
        "username": userToken['fullname'] ?? '',
        "userphoneNo": userToken['phone_number'] ?? '',
        "useraddress": userToken['address'] ?? '',
        "useremail": userToken['email'] ?? '',
        "userpassword": userToken['password'] ?? '',
        "role": userToken['role'] ?? '',
        "verify": userToken['verify'] ?? '',
      };
      print(">>>>>>>>>>>>>>>>>>>>>>>userData0:${kkkupdate}");
      _user = User.fromJson(kkkupdate);

      print(">>>>>>>>>>>>>>>>>>>>>>>parseData: ${parseData}");
      print(">>>>>>>>>>>>>>>>>>>>>>>StatusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        // _user.username = fullname;
        // _user.useremail = email;
        // _user.userphoneNo = phone_number;
        // _user.useraddress = address;
        // _user.id = userId;
        // _user.userpassword = password;
        await WriteCache.setString(key: AppKeys.userData, value: fullname);
        await WriteCache.setInt(key: 'userId', value: userId);
        await WriteCache.setString(key: 'email', value: email);

        Navigator.of(context)
            .pushReplacementNamed(AppRouter.successEditProfile);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            text: 'Please Check Infor Enter', context: context));
      }
      print(">>>>>>>>>>>>>>>>>>>>>>>userData: ${response.body}");

      // } on SocketException catch (_) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
      //       text: 'Oops No You Need A Good Internet Connection',
      //       context: context));
      // } catch (e) {
      //   print("Error: $e");
      //   ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
      //       text: 'Please check your Password & Email', context: context));
      // }

      return parseData;
    }
  }
}
