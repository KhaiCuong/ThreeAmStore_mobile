import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scarvs/core/api/cart.api.dart';
import 'package:scarvs/core/models/cart.model.dart';
import 'package:scarvs/core/utils/snackbar.util.dart';

import '../../app/routes/api.routes.dart';
import '../models/api_order_detail.dart';
import '../models/orders.dart';
import 'package:http/http.dart' as http;

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
    required double totalPrice,
  }) async {
    try {
      var products = await _cartAPI.addToApiCart(
          useremail: userEmail,
          username: userName,
          address: address,
          phone_number: phoneNumber,
          userId: userId,
          totalPrice: totalPrice,
          // price: productPrice,
          // product_name: productName,
          // productId: productId,
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

  Future<List<OrderDetail>> getOrderDetailList(int orderId) async {
    final Uri url = Uri.parse(
        '$domain/api/OrderDeTail/GetDetailListByOrder/$orderId');

    print(">>>>>>>>>>>>>>>>>>>>>url ${url}");
    try {
      final response = await http.get(url);
      print(">>>>>>>>>>>>>>>>>>>>>response ${response.statusCode}");

      if (response.statusCode == 200) {
        // Nếu kết quả trả về thành công (status code 200)
        final List<dynamic> data = json.decode(response.body)['data'];
        // Dữ liệu được trả về dưới dạng một danh sách các đối tượng JSON

        // Chuyển đổi dữ liệu JSON thành danh sách các đối tượng OrderDetail
        final List<OrderDetail> orderDetails =
            data.map((json) => OrderDetail.fromJson(json)).toList();

        print(
            ">>>>>>>>>>>>>>>>>>>>>orderDetails.length ${orderDetails.length}");
        return orderDetails;
      } else {
        // Nếu không thành công, ném một ngoại lệ để xử lý lỗi
        throw Exception('Failed to load order details');
      }
    } catch (e) {
      // Xử lý các ngoại lệ nếu có
      throw Exception('Error: $e');
    }
  }
// Future<void> addOrderDetailsToHiveCart(_orderId,_userId) async {
//   // Mở hộp Hive Cart
//      final cartBox = Hive.box<OrderData>('orders');
//   final orderId = cartBox.values.length + 1;
//   print(">>>>>>>>>>>>>>>>>>>>>>>>>>> orderId in addOrderDetailsToHiveCart    : $orderId");

//   // Lấy danh sách chi tiết đơn hàng từ hàm getOrderDetailList
//   List<OrderDetail> orderDetails = await getOrderDetailList(_orderId);

//   print(">>>>>>>>>>>>>>>>>>>>>>>>>>> orderDetails    : ${orderDetails.length}");

//   // Duyệt qua danh sách chi tiết đơn hàng và thêm vào Hive Cart
//   for (var detail in orderDetails) {
//     await cartBox.add(OrderData(
//       orderId: orderId,
//       quantity: detail.quantity,
//       price: detail.price,
//       productName: detail.productName,
//       productId: detail.productId,
//       image: detail.image,
//          username: "username",
//       address: "address",
//       phoneNumber: "phoneNumber",
//       userId: _userId,
//     ));

//     print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new orderId     : $_orderId");
//     print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new quantity     : ${detail.quantity}");
//     print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new price     : ${detail.price}");
//     print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new productName : ${detail.productName}");
//     print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new productId      : ${detail.productId}");
//     print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new image    : ${detail.image}");
//     print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new _userId       : $_userId");
//     // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new productName : $productName");
//     // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new productName : $productId");
//     // print(">>>>>>>>>>>>>>>>>>>>>>>>>>> new productName : $image");
//   }

//   // Đóng hộp Hive Cart
//   await cartBox.close();
// }
// ///
  Future<int> addOrderDetailsToHiveCart(int _orderId, int _userId) async {
    int addedSuccessfully = 0;
    try {
      // Mở hộp Hive Cart
      final cartBox = Hive.box<OrderData>('orders');
      final orderId = cartBox.values.length + 1;
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>> orderId in addOrderDetailsToHiveCart    : $orderId");

      // Lấy danh sách chi tiết đơn hàng từ hàm getOrderDetailList
      List<OrderDetail> orderDetails = await getOrderDetailList(_orderId);
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>> orderDetails    : ${orderDetails.length}");

      // Biến cờ để kiểm tra xem đã thêm sản phẩm thành công hay chưa

      // Duyệt qua danh sách chi tiết đơn hàng và thêm vào Hive Cart
      for (var detail in orderDetails) {
        // Kiểm tra xem sản phẩm đã tồn tại trong Hive Cart hay chưa
        bool productExists = cartBox.values
            .any((item) => item.productName == detail.productName);

        // Nếu sản phẩm đã tồn tại, không thêm mới mà chỉ cập nhật số lượng
        if (productExists) {
          // Tăng số lượng của sản phẩm trong Hive Cart
          final existingProduct = cartBox.values
              .firstWhere((item) => item.productName == detail.productName);
          existingProduct.quantity += detail.quantity;
          // existingProduct.save();
          addedSuccessfully = 2;
          // Sản phẩm đã được cập nhật
        } else {
          // Thêm sản phẩm mới vào Hive Cart
          await cartBox.add(OrderData(
            orderId: orderId,
            quantity: detail.quantity,
            price: detail.price,
            productName: detail.productName,
            productId: detail.productId,
            image: detail.image,
            username: "username",
            address: "address",
            phoneNumber: "phoneNumber",
            userId: _userId,
          ));
          addedSuccessfully = 1; // Sản phẩm đã được thêm mới
        }
      }

      // Đóng hộp Hive Cart
      // await cartBox.close();
      return addedSuccessfully;
    } catch (e) {
      print("Error adding order details to Hive Cart: $e");
      return addedSuccessfully; // Thêm thất bại
    }
  }
}
