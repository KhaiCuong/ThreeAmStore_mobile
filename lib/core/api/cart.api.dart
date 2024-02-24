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
      var subUrl4 = '/api/Product/UpdateProductInStock/${order.productId}';
      final Uri uri4 = Uri.parse(ApiRoutes.baseurl + subUrl4);
      http.Response response4 = await client.put(uri4,
          headers: headers, body: jsonEncode( order.quantity));


      var subUrl5 = '/api/Product/UpdateProductTotalBuy/${order.productId}';
      final Uri uri5 = Uri.parse(ApiRoutes.baseurl + subUrl5);
      http.Response response5 = await client.put(uri5,
          headers: headers, body: jsonEncode( order.quantity));
              print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>> Instock update APi response.statusCode : ${response4.statusCode}");
            print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>> Total Buy APi response.statusCode : ${response5.statusCode}");

      // print(
      //     "====================================================================");
      // print("quantity : ${order.quantity}");
      // print("price    : ${order.price}");
      // print("name     : ${order.productName}");
      // print("product id: ${order.productId}");
      // print("image    : ${order.image}");
      // print("order id : ${orderId}");

      print(
          "ADD OrderDetail APi response2.statusCode : ${response2.statusCode}");
               print(
          "ADD Update Product Quantity APi response3.statusCode : ${response4.statusCode}");
    }

    const subUrl3 = '/api/Payment/AddPayment';
    final Uri uri3 = Uri.parse(ApiRoutes.baseurl + subUrl3);
    // print(">>>>>>>>>>>>>>>>>>>>>>>Payment Uri: ${uri3}");
    final http.Response response3 = await http.Client().post(uri3,
        headers: headers,
        body: jsonEncode(
            {"fullname": username, "orderId": orderId, "status": true}));

    var userData3 = response3.body;

    print(
        ">>>>>>>>>>>>>>>>>>>>>>>Payment statusCode3: ${response3.statusCode}");

    final Map<String, dynamic> parseData = await jsonDecode(userData3);
    print(">>>>>>>>>>>>>>>>>>>>>>> Payment parseData: ${parseData}");

    // bool isAuthenticated = parseData['authentication'];
    // dynamic authData = parseData as String;

    // var response;

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
