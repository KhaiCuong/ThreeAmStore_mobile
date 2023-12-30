class ProductModel {
  ProductModel({
    required this.filled,
    required this.received,
    required this.data,
  });
  late final bool filled;
  late final bool received;
  late final List<ProductData>? data;

  ProductModel.fromJson(Map<String, dynamic> json) {
    filled = json['filled'];
    received = json['received'];
    data = List.from(json['data']).map((e) => ProductData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['filled'] = filled;
    _data['received'] = received;
    _data['data'] = data?.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ProductData {
  ProductData({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productCategory,
    required this.productImage,
  });
  late final int productId;
  late final String productName;
  late final String productDescription;
  late final String productPrice;
  late final String productCategory;
  late final String productImage;

  ProductData.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    productPrice = json['productPrice'];
    productCategory = json['productCategory'];
    productImage = json['productImage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['productId'] = productId;
    _data['productName'] = productName;
    _data['productDescription'] = productDescription;
    _data['productPrice'] = productPrice;
    _data['productCategory'] = productCategory;
    _data['productImage'] = productImage;
    return _data;
  }
}
