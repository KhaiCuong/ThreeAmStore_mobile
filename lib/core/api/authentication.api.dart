import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
// import 'package:jwt_decode/jwt_decode.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:scarvs/app/routes/api.routes.dart';
import 'package:scarvs/core/models/api_response.dart';
import 'package:scarvs/presentation/screens/homeScreen/home.screen.dart';
import 'package:scarvs/presentation/screens/signUpScreen/widget/loading/loading_options_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:get/get.dart';

class AuthenticationAPI {
  final client = http.Client();
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': "*",
  };
  // RxBool showPassword = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//User Sign Up
  Future createAccount(
      {required String useremail,
      required String username,
      required String userpassword,
      required String userphone,
      required String useraddress}) async {
    const subUrl = '/api/User/AddUser';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    final http.Response response = await client.post(uri,
        headers: headers,
        body: jsonEncode({
          "fullname": username,
          "phone_number": userphone,
          "address": useraddress,
          "role": "User",
          "email": useremail,
          "password": userpassword
        }));
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>> ${response.statusCode}");
    final dynamic body = response.body;
    return body;
  }

  Future userLogin(
      {required String useremail, required String userpassword}) async {
    const subUrl = '/api/Auth/Login';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    final http.Response response = await client.post(uri,
        headers: headers,
        body: jsonEncode({
          "email": useremail,
          "password": userpassword,
        }));
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>> ${response.statusCode}}");
    final dynamic body = response.body;
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>> ${response.body}}");
    return body;
  }

  //  onToggleShowPassword() => showPassword.value = !showPassword.value;

  // Future userLogin(
  //     String email, String pass, BuildContext context, {required String useremail, required String userpassword}) async {
  //   try {
  //     LoadingOptions.showLoading();
  //    const subUrl = 'Auth/Login';
  //   final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
  //   final http.Response response = await client.post(uri,
  //       headers: headers,
  //       body: jsonEncode({
  //         "email": useremail,
  //         "password": userpassword,
  //       }));
  //     print(" res: $response");
  //     Map<String, dynamic> responseMap = json.decode(response.body);
  //     ApiResponse apiResponse = ApiResponse.fromJson(responseMap);
  //     if (apiResponse.status == 200) {
  //       String accessToken = apiResponse.data['token'];
  //       final SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('token', accessToken);

  //       bool result = await getDataToken(accessToken, prefs);
  //       if (result) {
  //         getPosition().then((value) async {
  //           double longitude = value.longitude;
  //           double latitude = value.latitude;
  //           await prefs.setDouble('latitude', latitude);
  //           await prefs.setDouble('longitude', longitude);
  //           LoadingOptions.hideLoading();
  //           // Get.offAll(() => const HomeScreen());
  //         }).catchError((error) {
  //           LoadingOptions.hideLoading();
  //           print("error position: $error");
  //         });
  //       }
  //     } else {
  //       LoadingOptions.hideLoading();
  //       QuickAlert.show(
  //         context: context,
  //         type: QuickAlertType.error,
  //         text: apiResponse.message,
  //       );
  //     }
  //   } catch (e) {
  //     LoadingOptions.hideLoading();
  //     print("error: $e");
  //     QuickAlert.show(
  //       context: context,
  //       type: QuickAlertType.error,
  //       text: 'Switch to a different IP or a different WiFi',
  //     );
  //   }
  // }

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

  // bool checkTokenExp(int expireTime) {
  //   bool checkTime = DateTime.now().millisecondsSinceEpoch > expireTime * 1000;
  //   return checkTime;
  // }

  // Future<Position> getPosition() async {
  //   LocationPermission? permission;

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error("Location permission is denied");
  //     }
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }
}
