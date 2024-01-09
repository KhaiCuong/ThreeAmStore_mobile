import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:scarvs/app/routes/api.routes.dart';

class CartAPI {
  final client = http.Client();
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': "*",
  };

 Future addToCart({
  required String useremail,
  required BuildContext context,
  required String productSize,
}) async {
  const subUrl = '/api/Order/AddOrder';
  final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);

  final http.Response response = await client.post(uri,
      headers: headers,
      body: jsonEncode({
        "username": 'nguyen minh hoang',
        "address": 'tran van dang q5',
        "phone_number": '0909090909',
        "user_id": 1,
      }));

  print(">>>>>>>>>>>>>>>>>>>>>>>>>> ADD Order response.statusCode : ${response.statusCode}");

  final dynamic orderBody = jsonDecode(response.body);
  final int orderId = orderBody["order_id"];
  print(">>>>>>>>>>>>>>>>>>>>>>>>>>  orderId: ${orderId}");

  const subUrl2 = '/api/OrderDetail/AddOrderDetail';
  final Uri uri2 = Uri.parse(ApiRoutes.baseurl + subUrl2);

  final http.Response response2 = await client.post(uri2,
      headers: headers,
      body: jsonEncode({
        "quantity": 2,
        "price": 1223412,
        "produc_name": 'CALVIN KLEIN K8M216G6',
        "product_id": 'PD03',
        "image": '/uploads/lue14k4d.3i4PD1-1.jpg',
        "order_id": orderId,
      }));
  print(">>>>>>>>>>>>>>>>>>>>>>>>>> ADD OrderDetail response.statusCode : ${response2.statusCode}");
  final dynamic body = jsonDecode(response2.body);
  return body;
}


  Future addToCartDetail({
    required String useremail,
    required String productPrice,
    required String productName,
    required String productCategory,
    required String productImage,
    required BuildContext context,
    required String productSize,
  }) async {
    const subUrl = '/cart/add-to-cart';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    final http.Response response = await client.post(uri,
        headers: headers,
        body: jsonEncode({
          "useremail": useremail,
          "product_price": productPrice,
          "product_name": productName,
          "product_category": productCategory,
          "product_image": productImage,
          "product_size": productSize
        }));
    final dynamic body = response.body;
    return body;
  }

  Future checkCartData({
    required int useremail,
    required BuildContext context,
  }) async {
    var subUrl = '/api/Order/GetOrderListByUserId/$useremail';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    final http.Response response = await client.get(
      uri,
      headers: headers,
    );
    final dynamic body = response.body;
    return body;
  }

  Future deleteFromCart({
    required dynamic productId,
    required BuildContext context,
  }) async {
    var subUrl = '/cart/delete/$productId';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    final http.Response response = await client.delete(
      uri,
      headers: headers,
    );
    final dynamic body = response.body;
    return body;
  }
}
