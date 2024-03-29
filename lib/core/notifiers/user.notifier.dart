import 'dart:convert';
import 'dart:io';

import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:scarvs/app/constants/app.keys.dart';
import 'package:scarvs/app/routes/api.routes.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/core/api/authentication.api.dart';
import 'package:scarvs/core/api/user.api.dart';
import 'package:scarvs/core/models/update.user.model.dart';
import 'package:scarvs/core/models/user.model.dart';
import 'package:scarvs/core/models/userDetails.model.dart';
import 'package:scarvs/core/utils/snackbar.util.dart';

class UserNotifier with ChangeNotifier {
  final UserAPI _userAPI = UserAPI();
  final AuthenticationAPI _authenticationAPI = AuthenticationAPI();

  int? userId;
  int? get getUserId => userId;

  String? userEmail = 'Not Available';
  String? get getUserEmail => userEmail;

  String? userName;
  String? get getUserName => userName;

  String userAddress = 'Not Available';
  String get getuserAddress => userAddress;

  String userPhoneNumber = 'Not Available';
  String get getuserPhoneNumber => userPhoneNumber;

  String? token;
  String? get gettoken => gettoken;

  Future userLogin(
      {required String useremail,
      required String userpassword,
      required BuildContext context}) async {
    try {
      // const subUrl = '/api/User/GetUser/$id';
      var userData = await _authenticationAPI.userLogin(
          useremail: useremail, userpassword: userpassword);
      // var userData = await _userAPI.getUserData(id: id);
      var response = RegisterModel.fromJson(jsonDecode(userData));
      print(">>>>>>>>>>>>>>>>>>>>>>>parseData: ${response}");

      final _data = response.data;
      final _received = response.received;

      if (!_received) {
        notifyListeners();
        Navigator.of(context)
            .pushReplacementNamed(AppRouter.loginRoute)
            .whenComplete(
              () => DeleteCache.deleteKey(AppKeys.userData).whenComplete(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackUtil.stylishSnackBar(
                      text: 'Oops Session Timeout', context: context),
                );
              }),
            );
      } else {
        userEmail = _data.email;
        userName = _data.username;
        notifyListeners();
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: 'Oops No You Need A Good Internet Connection',
            context: context),
      );
    }
  }

  Future getUserData({
    required int id,
    required String token,
    required BuildContext context,
  }) async {
    try {
      // const subUrl = '/api/User/GetUser/$id';
      // var userData = await _userAPI.getUserData(token: token);
      var userData = await _userAPI.getUserData(id: id, token: token);
      var response = RegisterModel.fromJson(jsonDecode(userData));

      final _data = response.data;
      final _received = response.received;

      if (!_received) {
        notifyListeners();
        Navigator.of(context)
            .pushReplacementNamed(AppRouter.loginRoute)
            .whenComplete(
              () => DeleteCache.deleteKey(AppKeys.userData).whenComplete(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackUtil.stylishSnackBar(
                      text: 'Oops Session Timeout', context: context),
                );
              }),
            );
      } else {
        userEmail = _data.email;
        userName = _data.username;
        notifyListeners();
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: 'Oops No You Need A Good Internet Connection',
            context: context),
      );
    }
  }

  Future getUserDetails({
    required int userId,
    required BuildContext context,
  }) async {
    try {
      var userData = await _userAPI.getUserDetails(id: userId);
      var response = UserDetails.fromJson(jsonDecode(userData));
      final _data = response.data;
      final _filled = response.filled;
      final _received = response.received;

      if (_received && _filled) {
        userAddress = _data.userAddress;
        userPhoneNumber = _data.userPhoneNo;
        userEmail = _data.user.useremail;
        userName = _data.user.username;
        notifyListeners();
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: 'Welcome To Profile Page ',
            context: context),
      );
    }
  }

  Future updateUserDetails({
    required String userEmail,
    required String userAddress,
    required String userPhoneNo,
    required BuildContext context,
    required BuildContext userName,
  }) async {
    try {
      var userData = await _userAPI.updateUserDetails(
          userEmail: userEmail,
          userAddress: userAddress,
          userPhoneNo: userPhoneNo);
      var response = UpdateUser.fromJson(jsonDecode(userData));
      final _updated = response.updated;
      notifyListeners();

      return _updated;
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: 'Oops No You Need A Good Internet Connection',
            context: context),
      );
    }
  }

  Future forgetPassword({
    required String userEmail,
    required BuildContext context,
  }) async {
    try {
      var userData = await _userAPI.forgetPassword(
        userEmail: userEmail, context: context,
      );

      var response = ForgetUserPassword.fromJson(jsonDecode(userData));
      final _userEmail = response.userEmail;

      notifyListeners();

      return _userEmail;
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: 'Oops No You Need A Good Internet Connection',
            context: context),
      );
    }
  }
}
