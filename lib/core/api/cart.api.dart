import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:scarvs/app/routes/api.routes.dart';
import '../models/orders.dart';

class CartAPI {
  final client = http.Client();
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': "*",
    // "Authorization": token,
  };

//  Future addToCart({
//   required String useremail,
//   required BuildContext context,
//   required String productSize,
// }) async {
//   const subUrl = '/api/Order/AddOrder';
//   final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);

//   final http.Response response = await client.post(uri,
//       headers: headers,
//       body: jsonEncode({
//         "username": 'nguyen minh hoang',
//         "address": 'tran van dang q5',
//         "phone_number": '0909090909',
//         "userId": 1,
//       }));

//   print(">>>>>>>>>>>>>>>>>>>>>>>>>> ADD Order response.statusCode : ${response.statusCode}");

//   final dynamic orderBody = jsonDecode(response.body);
//   final int orderId = orderBody["orderId"];
//   print(">>>>>>>>>>>>>>>>>>>>>>>>>>  orderId: ${orderId}");

//   const subUrl2 = '/api/OrderDetail/AddOrderDetail';
//   final Uri uri2 = Uri.parse(ApiRoutes.baseurl + subUrl2);

//   final http.Response response2 = await client.post(uri2,
//       headers: headers,
//       body: jsonEncode({
//         "quantity": 2,
//         "price": 1223412,
//         "produc_name": 'CALVIN KLEIN K8M216G6',
//         "productId": 'PD03',
//         "image": '/uploads/lue14k4d.3i4PD1-1.jpg',
//         "orderId": orderId,
//       }));
//   print(">>>>>>>>>>>>>>>>>>>>>>>>>> ADD OrderDetail response.statusCode : ${response2.statusCode}");
//   final dynamic body = jsonDecode(response2.body);
//   return body;
// }
  Future addToApiCart({
    required String useremail,
    required String username,
    required String address,
    required String phone_number,
    required int userId,
    required List<OrderData> orders,
    required double totalPrice,
  }) async {
    const subUrl = '/api/Order/AddOrder';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    // Tính tổng số lượng của tất cả các order trong danh sách orders
    int totalQuantity = orders.isNotEmpty
        ? orders.map((order) => order.quantity).reduce((a, b) => a + b)
        : 0;
    // Truy cập image của order đầu tiên trong danh sách orders
    String firstOrderImage = orders.isNotEmpty ? orders[0].image : '';
    final http.Response response = await client.post(uri,
        headers: headers,
        body: jsonEncode({
          "phone_number": phone_number,
          "address": address,
          "Status": "Preparing",
          "username": username,
          "userId": userId,
          "totalPrice": totalPrice,
          "image": firstOrderImage,
          "quantity": totalQuantity,
        }));

    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>> ADD Order APi response.statusCode : ${response.statusCode}");
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>> ADD Order APi response.body : ${response.body}");

    final dynamic orderBody = jsonDecode(response.body);
    final dynamic data = orderBody["data"];
    final dynamic orderId = data["orderId"];
    print("Order ID: $orderId");

    const subUrl2 = '/api/OrderDeTail/AddOrderDetail';
    final Uri uri2 = Uri.parse(ApiRoutes.baseurl + subUrl2);

    //Lặp qua danh sách orders để thêm từng OrderDetail
    for (OrderData order in orders) {
      http.Response response2 = await client.post(uri2,
          headers: headers,
          body: jsonEncode({
            "quantity": order.quantity,
            "price": order.price,
            "produc_name": order.productName,
            "image": order.image,
            "orderId": orderId,
            "productId": order.productId,
          }));
      print(
          "====================================================================");
      print("quantity : ${order.quantity}");
      print("price    : ${order.price}");
      print("name     : ${order.productName}");
      print("product id: ${order.productId}");
      print("image    : ${order.image}");
      print("order id : ${orderId}");

      print(
          "ADD OrderDetail APi response.statusCode : ${response2.statusCode}");
    }
    return true;
  }

  Future addToHiveCart({
    required String useremail,
    required String username,
    required String address,
    required String phoneNumber,
    required int userId,
    required int quantity,
    required double price,
    required String productName,
    required String productId,
    required String image,
  }) async {
    // Tạo đối tượng OrderData và lưu vào Hive
    final orderBox =  Hive.box<OrderData>('orders');
    final orderId = orderBox.values.length + 1; // Tăng orderId tự động
    await orderBox.add(OrderData(
      orderId: orderId,
      username: username,
      address: address,
      phoneNumber: phoneNumber,
      userId: userId,
      quantity: quantity,
      price: price,
      productName: productName,
      productId: productId,
      image: image,
    ));

    // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new orderId     : $orderId");
    // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new orderId     : $username");
    // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new address     : $address");
    // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new phoneNumber : $phoneNumber");
    // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new userId      : $userId");
    // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new quantity    : $quantity");
    // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new price       : $price");
    // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new productName : $productName");
    // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new productName : $productId");
    // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new productName : $image");

    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>> ADD Order response.statusCode : ${orderBox.length}");
    return orderBox;
  }

  // Future addToCartDetail({
  //   required String useremail,
  //   required String productPrice,
  //   required String productName,
  //   required String productCategory,
  //   required String productImage,
  //   required BuildContext context,
  //   required String productSize,
  // }) async {
  //   const subUrl = '/cart/add-to-cart';
  //   final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
  //   final http.Response response = await client.post(uri,
  //       headers: headers,
  //       body: jsonEncode({
  //         "useremail": useremail,
  //         "product_price": productPrice,
  //         "product_name": productName,
  //         "product_category": productCategory,
  //         "product_image": productImage,
  //         "product_size": productSize
  //       }));
  //   final dynamic body = response.body;
  //   return body;
  // }

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
