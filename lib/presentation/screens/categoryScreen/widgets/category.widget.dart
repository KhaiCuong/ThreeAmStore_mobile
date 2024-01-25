import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/core/models/product.model.dart';
import 'package:scarvs/presentation/screens/productDetailScreen/product.detail.screen.dart';
import '../../../../app/routes/api.routes.dart';
import '../../../../core/models/favorite_product.dart';
import '../../../../core/notifiers/cart.notifier.dart';
import '../../../../core/notifiers/product.notifier.dart';
import '../../../../core/notifiers/size.notifier.dart';
import '../../../../core/notifiers/theme.notifier.dart';
import '../../../../core/service/favorite_product_box.dart';
import '../../../../core/utils/snackbar.util.dart';

class ShowDataGrid extends StatefulWidget {
  final List<ProductData> prods;

  ShowDataGrid({super.key, required this.prods});

  @override
  State<ShowDataGrid> createState() => _ShowDataGridState();
}

class _ShowDataGridState extends State<ShowDataGrid> {
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    var height = MediaQuery.of(context).size.height * 0.20;
    var domain = ApiRoutes.baseurl;
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);
    SizeNotifier sizeNotifier =
        Provider.of<SizeNotifier>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GridView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.700,
        ),
        itemCount: widget.prods.length,
        itemBuilder: (context, index) {
          ProductData prod = widget.prods[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            elevation: 6,
            color: themeFlag ? AppColors.mirage : AppColors.creamColor,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRouter.prodDetailRoute,
                  arguments: ProductDetailsArgs(id:prod.productId),
                );
              },
              child: Stack(
                children: [
                  // Hình ảnh sản phẩm
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Hero(
                      tag: Key(prod.productId.toString()),
                      child: SizedBox(
                        height: height,
                        child: prod.productImage != null &&
                                prod.productImage!.isNotEmpty
                            ? Image.network(
                                "$domain${prod.productImage!}",
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height - 170,
                    left: 120,
                    right: 8,
                    child: IconButton(
                      onPressed: () {
                        toggleFavoriteStatus(context, prod.productId);
                      },
                      icon: Icon(
                        isProductFavorite(prod.productId)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
                      ),
                    ),
                  ),
                  // Giá sản phẩm
                  Positioned(
                    top: height - 18, // Điều chỉnh vị trí của tên sản phẩm
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '\$ ${prod.productPrice}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  // Tên sản phẩm
                  Positioned(
                    bottom: 10,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      height: 60,
                      child: Row(
                        children: [
                          Container(
                            width: 104,
                            padding: EdgeInsets.only(
                                left: 2), // Đặt giá trị width mong muốn
                            child: Text(
                              prod.productName,
                              style: TextStyle(
                                color: themeFlag
                                    ? AppColors.creamColor
                                    : AppColors.blackPearl,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 248, 248, 248)
                                  .withOpacity(1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () async {
                                bool isInCart = await cartNotifier
                                    .isProductInCart(prod.productId);

                                if (isInCart) {
                                  // Sản phẩm đã có trong OrderData, cập nhật quantity thêm 1
                                  bool updateQuantity =
                                      await cartNotifier.updateQuantityInCart(
                                          prod.productId, 1);
                                  if (updateQuantity) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackUtil.stylishSnackBar(
                                        text: 'Added More To Cart',
                                        context: context,
                                      ),
                                    );
                                  }
                                } else {
                                  cartNotifier.addToHiveCart(
                                    // useremail: userNotifier.getUserEmail!,
                                    userEmail: 'hoang@tiwi.vn',
                                    username: "Hoang",
                                    address: "Tran Van Dang",
                                    phoneNumber: '0909222009',
                                    price: prod.productPrice!,
                                    productName: prod.productName,
                                    productId: prod.productId,
                                    image: prod.productImage!,
                                    userId: 2,
                                    quantity: 1,
                                    context: context,
                                    productSize: sizeNotifier.getSize,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackUtil.stylishSnackBar(
                                      text: 'Added To Cart',
                                      context: context,
                                    ),
                                  );
                                }
                              },
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.blue,
                                size: 20, // Kích thước của biểu tượng
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool isProductFavorite(String productId) {
    final favoriteBox = FavoriteProductBox();
    return favoriteBox.isFavorite(productId);
  }

  Future<void> toggleFavoriteStatus(
      BuildContext context, String productId) async {
    final favoriteBox = FavoriteProductBox();

    if (favoriteBox.isFavorite(productId)) {
      await FavoriteProductBox.removeFromFavorites(productId);
      print("Đã xoá yêu thích");
    } else {
      ProductNotifier productNotifier = ProductNotifier();
      ProductData productToAdd =
          await productNotifier.fetchProductDetail(id: productId);

      final favoriteProduct = FavoriteProduct(
        productId: productToAdd.productId,
        productName: productToAdd.productName,
        productDescription: productToAdd.productDescription,
        productPrice: productToAdd.productPrice,
        productImage: productToAdd.productImage,
      );

      await favoriteBox.addToFavorites(favoriteProduct);

      print("Đã thêm yêu thích");
    }

    // Trigger UI rebuild
    setState(() {});
  }
}
