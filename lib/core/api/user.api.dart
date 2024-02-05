import 'dart:convert';

import 'package:cache_manager/core/write_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scarvs/app/constants/app.keys.dart';
import 'package:scarvs/app/routes/api.routes.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/core/utils/snackbar.util.dart';

class UserAPI {
  final client = http.Client();

  Future getUserData({required String token, required int id}) async {
    var subUrl = '/api/User/GetUser/$id';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    final http.Response response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': "*",
        //  "Authorization": token,
      },
    );
    final dynamic body = response.body;
    return body;
  }

  Future getUserDetails({required int id}) async {
    var subUrl = 'api/User/GetUser/$id';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    final http.Response response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': "*",
      },
    );
    final dynamic body = response.body;
    return body;
  }

  Future updateUserDetails(
      {required String userEmail,
      required String userAddress,
      required String userPhoneNo}) async {
    const subUrl = '/info/add-user-info';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    final http.Response response = await client.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
        },
        body: jsonEncode({
          "useremail": userEmail,
          "user_address": userAddress,
          "user_phone_no": userPhoneNo,
        }));
    final dynamic body = response.body;
    return body;
  }

  Future forgetPassword({
    required String userEmail,
    required BuildContext context,
  }) async {
    var subUrl = '/api/User/ResetPassword';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);

    var request = http.Request('GET', uri);
    print(">>>>>>>>>>>>>>>>>>>>>>>uri:${uri}");
    request.body = userEmail;
    print(">>>>>>>>>>>>>>>>>>>>>>>userEmail:${userEmail}");

    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': "*",
    });

    http.StreamedResponse response = await request.send();
    print(">>>>>>>>>>>>>>>>>>>>>>>response:${response.statusCode}");
    if (response.statusCode == 200) {
      WriteCache.setString(key: AppKeys.userData, value: userEmail)
          .whenComplete(
        () => Navigator.of(context)
            .pushReplacementNamed(AppRouter.successForgetPassword),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          context: context, text: 'Forget Password faill'));
    }

    return response.statusCode == 200;
  }
}
