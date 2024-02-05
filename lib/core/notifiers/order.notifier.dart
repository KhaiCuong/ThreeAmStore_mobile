import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('PUT', uri);
      print(">>>>>>>>>>>>>>>>>>>>>>>uri:${uri}");

      request.body = json.encode("Canceled");
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
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
