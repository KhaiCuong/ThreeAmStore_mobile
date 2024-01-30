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
//         "user_id": 1,
//       }));

//   print(">>>>>>>>>>>>>>>>>>>>>>>>>> ADD Order response.statusCode : ${response.statusCode}");

//   final dynamic orderBody = jsonDecode(response.body);
//   final int orderId = orderBody["order_id"];
//   print(">>>>>>>>>>>>>>>>>>>>>>>>>>  orderId: ${orderId}");

//   const subUrl2 = '/api/OrderDetail/AddOrderDetail';
//   final Uri uri2 = Uri.parse(ApiRoutes.baseurl + subUrl2);

//   final http.Response response2 = await client.post(uri2,
//       headers: headers,
//       body: jsonEncode({
//         "quantity": 2,
//         "price": 1223412,
//         "produc_name": 'CALVIN KLEIN K8M216G6',
//         "product_id": 'PD03',
//         "image": '/uploads/lue14k4d.3i4PD1-1.jpg',
//         "order_id": orderId,
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
    required int user_id,
    required List<OrderData> orders,
  }) async {
    const subUrl = '/api/Order/AddOrder';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    // print(
    //       "====================================================================");
    //   print("phone_number : ${phone_number}");
    //   print("address    : ${address}");
    //   print("username     : ${username}");
    //   print("user_id: ${user_id}");

    final http.Response response = await client.post(uri,
        headers: headers,
        body: jsonEncode({
          "phone_number": phone_number,
          "address": address,
          "Status": "Preparing",
          "username": username,
          "user_id": user_id,
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
            "order_id": orderId,
            "product_id": order.productId,
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

      // In log trạng thái mã HTTP của mỗi yêu cầu POST

      // final dynamic body = jsonDecode(response2.body);
      // Thực hiện xử lý với phản hồi nếu cần
    }
    return true; // hoặc giá trị khác tùy thuộc vào cần thiết

// final List<Map<String, dynamic>> orderDetails = orders.map((order) => {
//   "quantity": order.quantity,
//   "price": order.price,
//   "produc_name": order.productName,
//   "product_id": order.productId,
//   "image": order.image,
//   "order_id": orderId, // orderId được trả về từ yêu cầu POST thứ nhất
// }).toList();
// final String orderDetailsJson = jsonEncode(orderDetails);
// final http.Response response2 = await client.post(uri2,
//     headers: headers,
//     body: orderDetailsJson);
//      final dynamic body = jsonDecode(response2.body);
//      print(">>>>>>>>>>>>>>>>>>>>>>>>>> ADD OrderDetail APi response.statusCode : ${response2.statusCode}");

    // return body; // hoặc giá trị khác tùy thuộc vào cần thiết
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
    final orderBox = Hive.box<OrderData>('orders');
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

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new orderId     : $orderId");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new orderId     : $username");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new address     : $address");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new phoneNumber : $phoneNumber");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new userId      : $userId");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new quantity    : $quantity");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new price       : $price");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new productName : $productName");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new productName : $productId");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new productName : $image");

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
