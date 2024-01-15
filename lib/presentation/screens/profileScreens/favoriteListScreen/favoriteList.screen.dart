import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:scarvs/presentation/widgets/custom.back.btn.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';

import '../../../../app/routes/api.routes.dart';
import '../../../../core/models/favorite_product.dart';
import '../../../../core/service/favorite_product_box.dart';

class FavoriteList extends StatefulWidget {
  const FavoriteList({Key? key}) : super(key: key);

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  late List<FavoriteProduct> _favoriteProducts;

  @override
  void initState() {
    super.initState();
    _loadFavoriteProducts();
  }

  Future<void> _loadFavoriteProducts() async {
    final favoriteBox = FavoriteProductBox.getBox();
    setState(() {
      _favoriteProducts = favoriteBox.values.toList();
    });
  }

  var domain = ApiRoutes.baseurl;
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        body: Column(
          children: [
            Row(
              children: [
                CustomBackPop(themeFlag: themeFlag),
                Text(
                  'Favorite List',
                  style: CustomTextWidget.bodyTextB2(
                    color: themeFlag ? AppColors.creamColor : AppColors.mirage,
                  ),
                ),
              ],
            ),
            Consumer<ThemeNotifier>(
              builder: (context, notifier, _) {
                return SwitchListTile(
                  contentPadding: const EdgeInsets.only(left: 16, right: 4),
                  title: Text(
                    'Dark Mode',
                    style: CustomTextWidget.bodyTextB4(
                      color:
                          themeFlag ? AppColors.creamColor : AppColors.mirage,
                    ),
                  ),
                  value: themeFlag,
                  activeColor:
                      themeFlag ? AppColors.creamColor : AppColors.mirage,
                  onChanged: (bool value) {
                    notifier.toggleTheme();
                  },
                );
              },
            ),
            Divider(height: 0, color: Colors.grey[400]),
            Expanded(
              child: _favoriteProducts.isNotEmpty
                  ? ListView.builder(
                      itemCount: _favoriteProducts.length,
                      itemBuilder: (context, index) {
                        var product = _favoriteProducts[index];
                        print(">>>>>>>>>>>> Favorite ${product.productImage}");

                        // Kiểm tra xem product.productImage có giá trị hay không
                        ImageProvider<Object>? productImage;
                        if (product.productImage != null &&
                            product.productImage!.isNotEmpty) {
                          productImage =
                              NetworkImage("$domain${product.productImage!}");
                        } else {
                          // Nếu không có hình ảnh, sử dụng hình ảnh placeholder hoặc mặc định
                          productImage =
                              AssetImage("assets/placeholder_image.png");
                        }

                        return Card(
                          elevation: 4,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: themeFlag
                              ? AppColors.mirage
                              : AppColors.creamColor, // Thêm màu sắc vào đây
                          child: ListTile(
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: productImage,
                                ),
                              ),
                            ),
                            title: Text(
                              product.productName,
                              style: CustomTextWidget.bodyTextB4(
                                color: themeFlag
                                    ? AppColors.creamColor
                                    : AppColors.mirage,
                              ),
                            ),
                            subtitle: Text(
                              '\$${product.productPrice}',
                              style: CustomTextWidget.bodyTextB4(
                                color: themeFlag
                                    ? AppColors.creamColor
                                    : AppColors.mirage,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: themeFlag
                                    ? AppColors.creamColor
                                    : AppColors.mirage,
                              ),
                              onPressed: () {
                                _removeFavoriteProduct(product.productId);
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No favorite products yet.',
                        style: CustomTextWidget.bodyTextB2(
                          color: themeFlag
                              ? AppColors.creamColor
                              : AppColors.mirage,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeFavoriteProduct(String productId) async {
    await FavoriteProductBox.removeFromFavorites(productId);

    _loadFavoriteProducts(); // Sau khi xoá, load lại danh sách sản phẩm yêu thích
  }
}
