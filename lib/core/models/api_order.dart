class ApiOrder {
  final int orderId;
  final String phoneNumber;
  final String address;
  final String username;
  final int? quantity;
  final double? totalPrice;
  final String? image;
  final int userId;
  final String status;

  ApiOrder({
    required this.orderId,
    required this.phoneNumber,
    required this.address,
    required this.username,
    this.quantity,
    this.totalPrice,
    this.image,
    required this.userId,
    required this.status,
  });

  factory ApiOrder.fromJson(Map<String, dynamic> json) {
    return ApiOrder(
      orderId: json['orderId'] as int,
      phoneNumber: json['phone_number'] as String,
      address: json['address'] as String,
      username: json['username'] as String,
      quantity: json['quantity'] as int?,
      totalPrice: json['totalPrice'] as double?,
      image: json['image'] as String?,
      userId: json['user_id'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'orderId': orderId,
      'phone_number': phoneNumber,
      'address': address,
      'username': username,
      'userId': userId,
      'status': status,
    };
    if (quantity != null) {
      data['quantity'] = quantity;
    }
    if (totalPrice != null) {
      data['totalPrice'] = totalPrice;
    }
    if (image != null) {
      data['image'] = image;
    }
    return data;
  }
}
