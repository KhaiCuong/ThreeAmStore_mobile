class ProductIdModel {
  ProductIdModel({
    required this.filled,
    required this.received,
    required this.data,
  });
  late final bool filled;
  late final bool received;
  late final SingleProductData data;

  ProductIdModel.fromJson(Map<String, dynamic> json) {
    filled = json['filled'];
    received = json['received'];
    data = SingleProductData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['filled'] = filled;
    _data['received'] = received;
    _data['data'] = data.toJson();
    return _data;
  }
}

class SingleProductData {
  SingleProductData({
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

  SingleProductData.fromJson(Map<String, dynamic> json) {
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
