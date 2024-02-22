import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scarvs/app/routes/api.routes.dart';

class FeedbackService with ChangeNotifier {
  Future<dynamic> fetchProductsFeedBack(String id) async {
    try {
      final dio = Dio();
      Response response = await dio.get(
          ApiRoutes.baseurl + '/api/Feedback/GetFeedbackListByProductId/$id');

      print("Products response.statusCode new: ${response}");

      if (response.statusCode == 200) {
        var responseData = response.data;
        print("fetchProductsFeedBacknew3data : $responseData");
        var responseData2 = responseData['data'];

        print("fetchProductsFeedBacknew2data :  ${responseData['data']}");
        print("fetchProductsFeedBacknew4data : $responseData2");

        if (responseData2 != null) {
          return responseData2;
        } else {
          return null;
          // Xử lý khi data là null hoặc không phù hợp
        }
      } else {
        // Xử lý khi mã trạng thái không phải là 200
        return null;
      }
    } catch (e) {
      // Xử lý lỗi tổng quát
      print("Error: $e");
      return null;
    }
  }
}
