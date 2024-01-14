import 'package:hive_flutter/hive_flutter.dart';

part 'favorite_product.g.dart';

@HiveType(typeId: 3)
class FavoriteProduct {
  @HiveField(0)
  late final String productId;

  @HiveField(1)
  late final String productName;

  @HiveField(2)
  late final String? productDescription;

  @HiveField(3)
  late final double? productPrice;

  @HiveField(4)
  late final String? productImage;

  FavoriteProduct({
    required this.productId,
    required this.productName,
    this.productDescription,
    this.productPrice,
    this.productImage,
  });
}
