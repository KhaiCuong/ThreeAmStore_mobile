import 'package:hive_flutter/hive_flutter.dart';

part 'orders.g.dart';

@HiveType(typeId: 1)
class OrderData {
  @HiveField(0)
  late int orderId;

  @HiveField(1)
  late String username;

  @HiveField(2)
  late String address;

  @HiveField(3)
  late String phoneNumber;

  @HiveField(4)
  late int userId;

  @HiveField(5) // Thêm trường mới: quantity
  late int quantity;

  @HiveField(6) // Thêm trường mới: price
  late double price;

  @HiveField(7) // Thêm trường mới: productName
  late String productName;

  @HiveField(8) // Thêm trường mới: productId
  late String productId;

  @HiveField(9) // Thêm trường mới: image
  late String image;

  OrderData({
    required this.orderId,
    required this.username,
    required this.address,
    required this.phoneNumber,
    required this.userId,
    required this.quantity,
    required this.price,
    required this.productName,
    required this.productId,
    required this.image,
  });
}
