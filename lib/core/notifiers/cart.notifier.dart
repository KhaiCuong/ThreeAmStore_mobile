import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scarvs/core/api/cart.api.dart';
import 'package:scarvs/core/models/cart.model.dart';
import 'package:scarvs/core/utils/snackbar.util.dart';

import '../models/orders.dart';

class CartNotifier with ChangeNotifier {
  final CartAPI _cartAPI = CartAPI();

  Future checkCartData(
      {required BuildContext context, required String useremail}) async {
    try {
      var products =
          await _cartAPI.checkCartData(useremail: 1, context: context);

      var response = CartData.fromJson(jsonDecode(products));

      final _productBody = response.data;
      // final _productFilled = response.filled;
      final _productReceived = response.received;

      notifyListeners();
      if (_productReceived) {
        return _productBody;
      } else if (!_productReceived) {
        return null;
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    }
  }

  Future addToHiveCart({
    required String userEmail,
    required BuildContext context,
    required String productSize,
    required double price,
    required String productName,
    required username,
    required String image,
    required String productId,
    required address,
    required phoneNumber,
    required userId,
    required quantity,
  }) async {
    try {
      var products = await _cartAPI.addToHiveCart(
        username: username,
        address: address,
        phoneNumber: phoneNumber,
        userId: userId,
        quantity: quantity,
        price: price,
        productName: productName,
        productId: productId,
        image: image,
        useremail: userEmail,
      );
      var response = jsonDecode(products);

      print(">>>>>>>>>>>>>>>>>>>>>>>>>>products data: ${products}");

      final _productAdded = response.added;
      return _productAdded;
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context,
        ),
      );
    }
  }

  //lấy dữ liệu orders từ Hive
  Future<List<OrderData>> getCartData() async {
    var ordersBox = await Hive.openBox<OrderData>('orders');
    return ordersBox.values.toList();
  }

  Future isProductInCart(String productId) async {
    var ordersBox = await Hive.openBox<OrderData>('orders');
    final Map<dynamic, OrderData> deliveriesMap = ordersBox.toMap();

    // Kiểm tra xem sản phẩm có trong danh sách hay không
    return deliveriesMap.values.any((order) => order.productId == productId);
  }

  Future updateQuantityInCart(String productId, int quantity) async {
    var ordersBox = await Hive.openBox<OrderData>('orders');
    final Map<dynamic, OrderData> deliveriesMap = ordersBox.toMap();
    dynamic desiredKey;

    // Tìm sản phẩm có productId trong danh sách
    deliveriesMap.forEach((key, value) {
      if (value.productId == productId) {
        desiredKey = key;
      }
    });

    if (desiredKey != null) {
      // Cập nhật quantity của sản phẩm đã có
      OrderData existingOrder = deliveriesMap[desiredKey]!;
      existingOrder.quantity += quantity;

      // Lưu lại vào Hive
      ordersBox.put(desiredKey, existingOrder);
      return true;
    } else {
      return false;
    }
    // Cuối cùng, thông báo cho các người nghe (listeners) về sự thay đổi trong danh sách
    // notifyListeners();
  }



  Future addToApiCart({
    required String userEmail,
    required String userName,
    required String address,
    required String phoneNumber,
    required int userId,
    // required String productPrice,
    // required String productName,
    // required String productId,
    // required String productImage,
    // required BuildContext context,
    // required int quantity,
    required List<OrderData> orders,
  }) async {
    try {
      var products = await _cartAPI.addToApiCart(
          useremail: userEmail,
          username: userName,
          address: address,
          phone_number: phoneNumber,
          user_id: userId,
          // price: productPrice,
          // product_name: productName,
          // product_id: productId,
          // image: productImage,
          // context: context,
          // quantity: quantity,
          orders: orders);
      var response = jsonDecode(products);
      final _productAdded = response.added;
      return _productAdded;
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackUtil.stylishSnackBar(
      //     text: 'Oops No You Need A Good Internet Connection',
      //     context: context,
      //   ),
      // );
    }
  }

  void refresh() {
    notifyListeners();
  }

  Future deleteFromCart(
      {required BuildContext context, required int productId}) async {
    try {
      var ordersBox = await Hive.openBox<OrderData>('orders');
      await ordersBox.delete(productId);

      notifyListeners();

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
          text: 'Oops! An error occurred while deleting the item.',
          context: context,
        ),
      );

      return false;
    }
  }
}
