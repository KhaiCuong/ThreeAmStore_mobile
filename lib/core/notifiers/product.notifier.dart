import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scarvs/core/api/product.api.dart';
import 'package:scarvs/core/models/productID.model.dart';
import 'package:scarvs/core/models/product.model.dart';
import 'package:scarvs/core/utils/snackbar.util.dart';

class ProductNotifier with ChangeNotifier {
  final ProductAPI _productAPI = ProductAPI();

  Future<List<ProductData>> fetchProducts(
      {required BuildContext context}) async {
    try {
      var products = [
        {
          "productId": 1,
          "productName": "Cosmograph Daytona",
          "productDescription":
              "Dr. Carter is not your typical doctor. With a passion for travel and adventure, he specializes in travel medicine",
          "productPrice": "200.000",
          "productCategory": "ROLEX",
          "productImage":
              "https://bossluxurywatch.vn/uploads/san-pham/rolex/daytona/rolex-cosmograph-daytona-116503-0001.png"
        },
        {
          "productId": 2,
          "productName": "Rolex Gold 12k",
          "productDescription":
              "Dr. Carter is not your typical doctor. With a passion for travel and adventure, he specializes in travel medicine",
          "productPrice": "2.0",
          "productCategory": "ROLEX",
          "productImage":
              "https://rolex.dafc.com.vn/wp-content/uploads/watch-assets-front-facing/landscape_assets/m228238-0061_modelpage_front_facing_landscape.png"
        },
        {
          "productId": 3,
          "productName": "Rolex Gold 24k",
          "productDescription":
              "Dr. Carter is not your typical doctor. With a passion for travel and adventure, he specializes in travel medicine,",
          "productPrice": "12.0",
          "productCategory": "ROLEX",
          "productImage":
              "https://rolex.dafc.com.vn/wp-content/uploads/watch-assets-front-facing/landscape_assets/m228238-0061_modelpage_front_facing_landscape.png"
        },
        {
          "productId": 4,
          "productName": "Rolex Gold 18k",
          "productDescription":
              "Dr. Walker is a passionate pediatrician dedicated to creating a warm and friendly environment for her young patients. With a reassuring smile, she has a unique ability to connect with children, making every visit to her office an enjoy ",
          "productPrice": "10.0",
          "productCategory": "HUBLOT",
          "productImage":
              "https://rolex.dafc.com.vn/wp-content/uploads/watch-assets-front-facing/landscape_assets/m228238-0061_modelpage_front_facing_landscape.png"
        },
        {
          "productId": 5,
          "productName": "Rolex Gold",
          "productDescription":
              "Dr. Rodriguez is a compassionate and empathetic palliative care specialist who focuses on enhancing the quality of life for patients facing serious illnesses",
          "productPrice": "5.0",
          "productCategory": "HUBLOT",
          "productImage":
              "https://rolex.dafc.com.vn/wp-content/uploads/watch-assets-front-facing/landscape_assets/m228238-0061_modelpage_front_facing_landscape.png"
        }
      ];

      // Chuyển đổi danh sách sản phẩm thành danh sách ProductData
      List<ProductData> productList =
          products.map((product) => ProductData.fromJson(product)).toList();

      return productList;
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
        text: 'Oops No You Need A Good Internet Connection',
        context: context,
      ));
      // Trả về danh sách trống nếu có lỗi
      return [];
    }
  }

  Future fetchProductDetail(
      {required BuildContext context, required dynamic id}) async {
    try {
      var products = 
        {
          "productId": id,
          "productName": "Cosmograph Daytona",
          "productDescription":
              "Dr. Carter is not your typical doctor. With a passion for travel and adventure, he specializes in travel medicine",
          "productPrice": "200.000",
          "productCategory": "ROLEX",
          "productImage":
              "https://bossluxurywatch.vn/uploads/san-pham/rolex/daytona/rolex-cosmograph-daytona-116503-0001.png"
        }
      ;
    SingleProductData product = SingleProductData.fromJson(products);
      print(">>>>>>>>>>>>>>>>>>>> produc at API: ${product.productImage} ");
      return product;

      // var products = await _productAPI.fetchProductDetail(id: id);
      // var response = ProductIdModel.fromJson(jsonDecode(products));

      // final _productBody = response.data;
      // final _productFilled = response.filled;
      // final _productReceived = response.received;

      // if (_productReceived && _productFilled) {
      //   return _productBody;
      // } else if (!_productFilled && _productReceived) {
      //   return [];
      // }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: 'Oops No You Need A Good Internet Connection',
            context: context),
      );
    }
  }

  Future fetchProductCategory(
      {required BuildContext context, required dynamic categoryName}) async {
    try {
      var products =
          await _productAPI.fetchProductCategory(categoryName: categoryName);
      var response = ProductModel.fromJson(jsonDecode(products));

      final _productBody = response.data;
      final _productFilled = response.filled;
      final _productReceived = response.received;

      if (_productReceived && _productFilled) {
        return _productBody;
      } else if (!_productFilled && _productReceived) {
        return [];
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    }
  }

  Future searchProduct(
      {required BuildContext context, required dynamic productName}) async {
    try {
      var products = await _productAPI.searchProduct(productName: productName);
      var response = ProductModel.fromJson(jsonDecode(products));

      final _productBody = response.data;
      final _productFilled = response.filled;
      final _productReceived = response.received;

      if (_productReceived && _productFilled) {
        return _productBody;
      } else if (!_productFilled && _productReceived) {
        return [];
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    }
  }
}
