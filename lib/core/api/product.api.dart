import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:scarvs/app/routes/api.routes.dart';

class ProductAPI {
  final client = http.Client();
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': "*",
  };
  // Future fetchProducts() async {
  //   try {
  //     final dio = Dio();
  //     final response =
  //         await dio.get(ApiRoutes.baseurl + '/api/Product/GetProductList');
  //     // print(">>>>>>>>>>>>>>>>>>>>>>>>>>response body: ${response.data}");

  //     final responseData = response.data;

  //     if (responseData != null && responseData['data'] != null) {
  //       // print(
  //       //     ">>>>>>>>>>>>>>>>>>>>>>>>>>response body: ${responseData['data']}");
  //       return responseData['data'];
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     return null;
  //   }
  // }

  // Future fetchProducts() async {
  //   try {
  //     const subUrl = '/api/Product/GetProductList';
  //     final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
  //       //  final uri = Uri.parse('https://c7da-113-161-76-176.ngrok-free.app/api/Product/GetProductList');
  //     print(">>>>>>>>>>>>>>>>>>>>>>>>>>uri get product: $uri");

  //     final http.Response  response = await client.get(uri
  //         // ,
  //         // headers: headers,
  //         );
  //     final body = response.body;
  //     print(">>>>>>>>>>>>>>>>>>>>>>>>>>response body: ${body}");

  //     return body;
  //   } catch (e) {
  //     // Xử lý khi có lỗi (ví dụ: trả về một giá trị mặc định hoặc null)
  //     print(">>>>>>>>>>>>>>>>>>>>>>>>>>Error: $e");
  //     return null;
  //   }
  // }

  Future fetchProductDetail({required dynamic id}) async {
    try {
      final dio = Dio();
      final response =
          await dio.get(ApiRoutes.baseurl + '/product/details/$id');
      final responseData = response.data;
      if (responseData != null && responseData['data'] != null) {
        print(
            ">>>>>>>>>>>>>>>>>>>>>>>>>>fetchProductDetail body: ${responseData['data']}");
        return responseData['data'];
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future fetchProductCategory({required dynamic id}) async {
    var subUrl = 'api/Product/GetProductListByCategoryId/$id';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);

    final http.Response response = await client.get(
      uri,
      headers: headers,
    );
    final body = response.body;
    return body;
  }

  Future searchProduct({required dynamic productName}) async {
    var subUrl = '/product/search/$productName';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);

    final http.Response response = await client.get(
      uri,
      headers: headers,
    );
    final body = response.body;
    return body;
  }
}
