import 'package:hive/hive.dart';

import '../models/favorite_product.dart';


class FavoriteProductBox {
  static const String boxName = 'favorite_products';

  // Thêm hàm init để khởi tạo box
  static Future<void> init() async {
    await Hive.openBox<FavoriteProduct>(boxName);
  }

  // Thay thế ProductData bằng FavoriteProduct trong Box
  static Box<FavoriteProduct> getBox() {
    return Hive.box<FavoriteProduct>(boxName);
  }

  // Thêm hàm addToFavorites để thêm sản phẩm yêu thích vào box
  Future <void> addToFavorites(FavoriteProduct product) async {
    final box = FavoriteProductBox.getBox();
    await box.put(product.productId, product);
  
  }

  // Thay đổi kiểu trả về của hàm getFavoriteProducts để sử dụng FavoriteProduct
  List<FavoriteProduct> getFavoriteProducts() {
    final box = FavoriteProductBox.getBox();
    return box.values.toList();
  }

  // Thêm hàm kiểm tra sản phẩm có trong danh sách yêu thích hay không
  bool isFavorite(String productId) {
    final box = FavoriteProductBox.getBox();
    return box.containsKey(productId);
  }

  // Thêm hàm removeFromFavorites để xóa sản phẩm khỏi danh sách yêu thích
  static Future<void> removeFromFavorites(String productId) async {
    final box = FavoriteProductBox.getBox();
    await box.delete(productId);
  }
}
