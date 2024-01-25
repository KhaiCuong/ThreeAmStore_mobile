import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scarvs/core/api/product.api.dart';
import 'package:scarvs/core/models/productID.model.dart';
import 'package:scarvs/core/models/product.model.dart';
import 'package:scarvs/core/utils/snackbar.util.dart';

import '../../app/routes/api.routes.dart';

class ProductNotifier with ChangeNotifier {
  final ProductAPI _productAPI = ProductAPI();
  List<String> searchResults = [];

  // Future<List<ProductData>> fetchProducts(
  //     {required BuildContext context}) async {
  //   try {
  //     var products = [
  //       {
  //         "productId": 1,
  //         "productName": "Cosmograph Daytona",
  //         "productDescription":
  //             "Dr. Carter is not your typical doctor. With a passion for travel and adventure, he specializes in travel medicine",
  //         "productPrice": "200.000",
  //         "productCategory": "ROLEX",
  //         "productImage":
  //             "https://bossluxurywatch.vn/uploads/san-pham/rolex/daytona/rolex-cosmograph-daytona-116503-0001.png"
  //       },
  //       {
  //         "productId": 2,
  //         "productName": "Rolex Gold 12k",
  //         "productDescription":
  //             "Dr. Carter is not your typical doctor. With a passion for travel and adventure, he specializes in travel medicine",
  //         "productPrice": "2.0",
  //         "productCategory": "ROLEX",
  //         "productImage":
  //             "https://rolex.dafc.com.vn/wp-content/uploads/watch-assets-front-facing/landscape_assets/m228238-0061_modelpage_front_facing_landscape.png"
  //       },
  //       {
  //         "productId": 3,
  //         "productName": "Rolex Gold 24k",
  //         "productDescription":
  //             "Dr. Carter is not your typical doctor. With a passion for travel and adventure, he specializes in travel medicine,",
  //         "productPrice": "12.0",
  //         "productCategory": "ROLEX",
  //         "productImage":
  //             "https://rolex.dafc.com.vn/wp-content/uploads/watch-assets-front-facing/landscape_assets/m228238-0061_modelpage_front_facing_landscape.png"
  //       },
  //       {
  //         "productId": 4,
  //         "productName": "Rolex Gold 18k",
  //         "productDescription":
  //             "Dr. Walker is a passionate pediatrician dedicated to creating a warm and friendly environment for her young patients. With a reassuring smile, she has a unique ability to connect with children, making every visit to her office an enjoy ",
  //         "productPrice": "10.0",
  //         "productCategory": "HUBLOT",
  //         "productImage":
  //             "https://rolex.dafc.com.vn/wp-content/uploads/watch-assets-front-facing/landscape_assets/m228238-0061_modelpage_front_facing_landscape.png"
  //       },
  //           {
  //         "productId": 5,
  //         "productName": "Rolex Gold",
  //         "productDescription":
  //             "Dr. Rodriguez is a compassionate and empathetic palliative care specialist who focuses on enhancing the quality of life for patients facing serious illnesses",
  //         "productPrice": "5.0",
  //         "productCategory": "HUBLOT",
  //         "productImage":
  //             "https://rolex.dafc.com.vn/wp-content/uploads/watch-assets-front-facing/landscape_assets/m228238-0061_modelpage_front_facing_landscape.png"
  //       }
  //     ];

  //     // Chuyển đổi danh sách sản phẩm thành danh sách ProductData
  //     List<ProductData> productList =
  //         products.map((product) => ProductData.fromJson(product)).toList();

  //     return productList;
  //   } on SocketException catch (_) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
  //       text: 'Oops No You Need A Good Internet Connection',
  //       context: context,
  //     ));
  //     // Trả về danh sách trống nếu có lỗi
  //     return [];
  //   }
  // }

  // Future fetchProducts({required BuildContext context}) async {
  //   try {
  //     var products = await _productAPI.fetchProducts();

  //     var response = ProductData.fromJson(jsonDecode(products));
  //     print(">>>>>>>>>>>>>>>>>>>>>>>>>>response: ${response}");

  //     final _productBody = response;
  //     // final _productFilled = response.filled;
  //     // final _productReceived = response.received;

  //     // if (_productReceived && _productFilled) {
  //     print(">>>>>>>>>>>>>>>>>>>>>>>>>>_productBody: $_productBody");
  //     if (_productBody != null && _productBody is List<dynamic>) {
  //       // Thực hiện công việc với biến data sau khi chuyển đổi thành List<dynamic>
  //       return _productBody;
  //     } else {
  //       return [];
  //       // Xử lý khi data là null hoặc không phải là List<dynamic>
  //       // Ví dụ: hiển thị thông báo lỗi, hoặc thực hiện công việc khác...
  //     }

  //     // } else if (!_productFilled && _productReceived) {
  //     //   return [];
  //     // }
  //   } on SocketException catch (_) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
  //         text: 'Oops No You Need A Good Internet Connection',
  //         context: context));
  //   }
  // }

  Future<List<ProductData>> fetchProducts(
      {required BuildContext context}) async {
    try {
      final dio = Dio();
      final response =
          await dio.get(ApiRoutes.baseurl + '/api/Product/GetProductList');

      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>Products response.statusCode: ${response.statusCode}");
      // print(">>>>>>>>>>>>>>>>>>>>>>>>>>products data: ${response.data}");
      if (response.statusCode == 200) {
        var responseData = response.data;
        // print(">>>>>>>>>>>>>>>>>>>>>>>>>>responseData : ${responseData['data']}");

        if (responseData != null && responseData['data'] is List<dynamic>) {
          List<ProductData> productList =
              (responseData['data'] as List<dynamic>)
                  .map((json) => ProductData.fromJson(json))
                  .toList();
          // print(">>>>>>>>>>>>>>>>>>>>>>>>>>productList: $productList");
          return productList;
        } else {
          return [];
          // Xử lý khi data là null hoặc không phải là List<dynamic>
        }
      } else {
        // Xử lý khi mã trạng thái không phải là 200
        return [];
      }
    
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
        text: 'Oops No You Need A Good Internet Connection',
        context: context,
      ));
      return [];
    } catch (e) {
      // Xử lý lỗi tổng quát
      print("Error: $e");
      return [];
    }
  }

  Future fetchProductDetail({required dynamic id}) async {
    try {
      final dio = Dio();
      final response =
          await dio.get(ApiRoutes.baseurl + '/api/Product/GetProduct/$id');

      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>HTTP status GetProductById : ${response.statusCode}");
      // print(">>>>>>>>>>>>>>>>>>>>>>>>>>products data: ${response.data}");
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData != null) {
          ProductData product = ProductData.fromJson(responseData['data']);
          return product;
        } else {
          return [];
        }
      } else {
        // Xử lý khi mã trạng thái không phải là 200
        return [];
      }
    
    } on SocketException catch (_) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackUtil.stylishSnackBar(
      //       text: 'Oops No You Need A Good Internet Connection',
      //       context: context),
      // );
    }
  }

  Future<List<ProductData>> fetchProductCategory(
      {required BuildContext context, required String id}) async {
    try {
      // id = 'RL9';
      final dio = Dio();
      final response = await dio.get(
          ApiRoutes.baseurl + '/api/Product/GetProductListByCategoryId/$id');
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>fetchProductCategory response.statusCode: ${response.statusCode}");
      // print(">>>>>>>>>>>>>>>>>>>>>>>>>>products data: ${response.data}");
      if (response.statusCode == 200) {
        var responseData = response.data;
        // print(">>>>>>>>>>>>>>>>>>>>>>>>>>responseData : ${responseData['data']}");

        if (responseData != null && responseData['data'] is List<dynamic>) {
          List<ProductData> productList =
              (responseData['data'] as List<dynamic>)
                  .map((json) => ProductData.fromJson(json))
                  .toList();
          // print(">>>>>>>>>>>>>>>>>>>>>>>>>>productList: $productList");
          return productList;
        } else {
          return [];
          // Xử lý khi data là null hoặc không phải là List<dynamic>
        }
      } else {
        // Xử lý khi mã trạng thái không phải là 200
        return [];
      }
    } on DioError catch (e) {
      // Xử lý lỗi từ Dio.
      print("DioError: $e");
      return [];
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
        text: 'Oops No You Need A Good Internet Connection',
        context: context,
      ));
      return [];
    } catch (e) {
      // Xử lý lỗi tổng quát
      print("Error: $e");
      return [];
    }
  }

  Future<List<ProductData>> searchProduct({
    required BuildContext context,
    required String query,
    required String productName,
  }) async {
    try {
      // Gọi hàm để lấy danh sách sản phẩm từ API
      final dio = Dio();
      final response =
          await dio.get(ApiRoutes.baseurl + '/api/Product/GetProductList');
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>Products response.statusCode: ${response.statusCode}");
      // print(">>>>>>>>>>>>>>>>>>>>>>>>>>products data: ${response.data}");
      if (response.statusCode == 200) {
        var responseData = response.data;
        // print(">>>>>>>>>>>>>>>>>>>>>>>>>>responseData : ${responseData['data']}");
        if (responseData != null && responseData['data'] is List<dynamic>) {
          List<ProductData> productList =
              (responseData['data'] as List<dynamic>)
                  .map((json) => ProductData.fromJson(json))
                  .toList();
          // print(">>>>>>>>>>>>>>>>>>>>>>>>>>productList: $productList");
          // Hàm kiểm tra tên sản phẩm có thỏa mãn điều kiện tìm kiếm gần đúng không

          List<ProductData> searchResults = productList
              .where((item) =>
                  item.productName.toLowerCase().contains(query.toLowerCase()))
              .toList();
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>searchResults: $searchResults");
          return searchResults;
        } else {
          return [];
          // Xử lý khi data là null hoặc không phải là List<dynamic>
        }
      } else {
        // Xử lý khi mã trạng thái không phải là 200
        return [];
      }
    } on DioError catch (e) {
      // Xử lý lỗi từ Dio.
      print("DioError: $e");
      return [];
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
        text: 'Oops No You Need A Good Internet Connection',
        context: context,
      ));
      return [];
    } catch (e) {
      // Xử lý lỗi tổng quát
      print("Error: $e");
      return [];
    }
  }

}
