class ProductModel {
  ProductModel({
    // required this.filled,
    // required this.received,
    required this.data,
  });
  // late final bool filled;
  // late final bool received;
  late final List<ProductData>? data;

  ProductModel.fromJson(Map<String, dynamic> json) {
    // filled = json['filled'];
    // received = json['received'];
    data = List.from(json['data']).map((e) => ProductData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    // _data['filled'] = filled;
    // _data['received'] = received;
    _data['data'] = data?.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ProductData {
  late final String productId;
  late final String productName;
  late final String? productDescription;
  late final double? productPrice;
  late final bool? status;
  late final String? description;
  late final String? category;
  late final String? productImage;
  late final DateTime? createdAt;
  late final DateTime? updatedAt;

  ProductData({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.status,
    required this.description,
    required this.category,
    required this.productImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      productId: json['product_id'],
      productName: json['produc_name'],
      productDescription: json['description'],
      productPrice: json['price']?.toDouble(),
      status: json['status'],
      description: json['description'],
      category: json['category'],
      productImage: json['image'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt:
          json['update_at'] != null ? DateTime.parse(json['update_at']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'product_id': productId,
      'produc_name': productName,
      'description': productDescription,
      'price': productPrice,
      'status': status,
      'category': category,
      'image': productImage,
      'created_at': createdAt?.toIso8601String(),
      'update_at': updatedAt?.toIso8601String(),
    };
    return data;
  }
}
