import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:scarvs/core/utils/snackbar.util.dart';

import '../../app/routes/api.routes.dart';

class OrderNotifier with ChangeNotifier {
  Future<bool> updateStatus({
    required BuildContext context,
    required int id,
    required String status,
  }) async {
    try {
      var subUrl = '/api/Order/UpdateStatusOrder/$id';
      final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
      final client = http.Client();
      final http.Response response = await client.put(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
        },
        body: jsonEncode(
          "Canceled",
        ),
      );
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>Change Status response.statusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Xử lý lỗi tổng quát
      print("Error: $e");
      return false;
    }
  }
}
