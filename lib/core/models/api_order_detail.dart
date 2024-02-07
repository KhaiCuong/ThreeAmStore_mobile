class OrderDetail {
  final int detailId;
  final int quantity;
  final double price;
  final String productName;
  final String image;
  final int orderId;
  final String productId;

  OrderDetail({
    required this.detailId,
    required this.quantity,
    required this.price,
    required this.productName,
    required this.image,
    required this.orderId,
    required this.productId,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      detailId: json['detailId'] as int,
      quantity: json['quantity'] as int,
      price: json['price'] as double,
      productName: json['produc_name'] as String,
      image: json['image'] as String,
      orderId: json['orderId'] as int,
      productId: json['productId'] as String,
    );
  }
}
