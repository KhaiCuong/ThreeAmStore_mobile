import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/core/notifiers/authentication.notifer.dart';
import 'package:scarvs/core/notifiers/product.notifier.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:scarvs/core/notifiers/user.notifier.dart';
import 'package:scarvs/presentation/screens/productScreen/widgets/brands.widget.dart';
import 'package:scarvs/presentation/widgets/shimmer.effects.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';
import 'package:scarvs/presentation/widgets/dimensions.widget.dart';

import '../../../app/routes/api.routes.dart';
import '../../../app/routes/app.routes.dart';
import '../../../core/models/auction_watch.dart';
import '../../../core/models/favorite_product.dart';
import '../../../core/models/product.model.dart';
import '../../../core/service/favorite_product_box.dart';
import '../../../core/utils/snackbar.util.dart';
import '../productDetailScreen/product.detail.screen.dart';
import '../profileScreens/auctionPage/auction_detail_page.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductNotifier productNotifier = ProductNotifier();
  List<AuctionWatch> auctionedWatches = [];
  List<ProductData> products = [];
  Future<void>? _auctionsFuture;

  @override
  void initState() {
    super.initState();
    _auctionsFuture = _fetchAuctions(context: context);
  }

  Future<void> _fetchAuctions({required BuildContext context}) async {
    try {
      final dio = Dio();
      final response = await dio.get(ApiRoutes.baseurl + '/api/aution/getlist');

      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>fetchAuctions response.statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData != null && responseData['data'] is List<dynamic>) {
          List<AuctionWatch> auctionList =
              (responseData['data'] as List<dynamic>)
                  .map((json) => AuctionWatch.fromJson(json))
                  .toList();
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>AuctionList: ${auctionList.length}");

          setState(() {
            auctionedWatches = auctionList;
          });
          //
        } else {
          // Trường hợp không có dữ liệu
          setState(() {
            auctionedWatches = [];
          });
        }
      } else {
        // Trường hợp response code không phải 200
        setState(() {
          auctionedWatches = [];
        });
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
        text: 'Oops No You Need A Good Internet Connection',
        context: context,
      ));
      setState(() {
        auctionedWatches = [];
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        auctionedWatches = [];
      });
    }
  }

  List<AuctionWatch> get _upcomingAuctions {
    // Lấy thời gian hiện tại
    DateTime now = DateTime.now();

    // Lọc danh sách để chỉ lấy những đồng hồ với thời gian bắt đầu đấu giá trong tương lai
    // và không có điều kiện
    List<AuctionWatch> upcomingAuctions = auctionedWatches;
    return upcomingAuctions.toList();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    // AuthenticationNotifier _userData =
    //     Provider.of<AuthenticationNotifier>(context);
    // var userName = _userData.getUserName ?? ' ';
    var userName = authNotifier.auth.username ?? 'Wait';

    Widget _buildAuctionCard(AuctionWatch watch) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRouter.auction,
          );
          // Navigator.of(context).pushNamed(
          //   AppRouter.auctionDetailPage,
          //   arguments: AuctionDetailsPageArgs(auction: watch),
          // );
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.39,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width *
                        0.26, // Đặt chiều cao của SizedBox là chiều cao mong muốn của hình ảnh
                    width: double
                        .infinity, // Đặt chiều rộng của SizedBox là vô hạn để đảm bảo lấp đầy không gian
                    child: watch.autionProductEntity.image != null &&
                            watch.autionProductEntity.image.isNotEmpty
                        ? Image.network(
                            '$domain/${watch.autionProductEntity.image}',
                            fit: BoxFit
                                .cover, // Đặt thuộc tính fit thành BoxFit.cover
                          )
                        : Container(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    height: 40,
                    child: Text(
                      watch.autionProductEntity.producName,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Text(
                    'From: \$ ${watch.autionProductEntity.price.toString()!}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_alarm,
                        size: 16, // Kích thước của biểu tượng đồng hồ
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${DateFormat('HH:mm  dd/MM/yyyy').format(watch.startTime!)}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi , $userName',
                      style: CustomTextWidget.bodyTextB1(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
                      ),
                    ),
                    vSizedBox1,
                    Text(
                      'What Would You Like To Wear Today ??',
                      style: CustomTextWidget.bodyText3(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
                      ),
                    ),
                    vSizedBox2,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.rawSienna,
                            AppColors.mediumPurple,
                            AppColors.fuchsiaPink,
                          ],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.23,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 5, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time is an art',
                              style: CustomTextWidget.bodyTextB2(
                                  color: AppColors.creamColor),
                            ),
                            Text(
                              'Daytona Gold 18k M126508-0003 40mm',
                              style: CustomTextWidget.bodyTextB4(
                                  color: AppColors.creamColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               Padding(
  padding: const EdgeInsets.symmetric(horizontal: 0.0),
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.creamColor,
      enableFeedback: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
    onPressed: () {},
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'Comming soon',
        style: CustomTextWidget.bodyText3(
          color: AppColors.mirage,
        ),
      ),
    ),
  ),
),

                                
                                SizedBox(
                                  height: 124,
                                  width: 170,
                                  child: Image.network(
                                      'https://rolex.dafc.com.vn/wp-content/uploads/watch-assets-laying-down/landscape_assets/m126508-0003_modelpage_laying_down_landscape.png'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Auctions',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 200,
                      child: FutureBuilder(
                        future:
                            _auctionsFuture, // Thay yourFuture bằng Future bạn muốn chờ
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ShimmerEffects.loadShimmer(context: context);
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _upcomingAuctions.length,
                              itemBuilder: (context, index) {
                                return _buildAuctionCard(
                                    _upcomingAuctions[index]);
                              },
                            );
                          }
                        },
                      ),
                    ),
                    vSizedBox2,
                    BrandWidget(),
                    vSizedBox2,
                    Text(
                      'New Watches',
                      style: CustomTextWidget.bodyTextB2(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
                      ),
                    ),
                    vSizedBox1,
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Consumer<ProductNotifier>(
                        builder: (context, notifier, _) {
                          return FutureBuilder(
                            future: notifier.fetchProductsShortNew(
                                context: context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ShimmerEffects.loadShimmer(
                                    context: context);
                              } else {
                                var _snapshot = snapshot.data;
                                if (_snapshot == null) {
                                  return Center(
                                    child: Text(
                                      'Data is null...',
                                      style: CustomTextWidget.bodyTextUltra(
                                        color: themeFlag
                                            ? AppColors.creamColor
                                            : AppColors.mirage,
                                      ),
                                    ),
                                  );
                                } else if (_snapshot is List) {
                                  return ListView.separated(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(width: 8),
                                    itemCount: _snapshot.length,
                                    itemBuilder: (context, index) {
                                      ProductData prod = _snapshot[index];
                                      return ProductCard(
                                        prod: prod,
                                        themeFlag: themeFlag,
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      'Invalid data format...',
                                      style: CustomTextWidget.bodyTextUltra(
                                        color: themeFlag
                                            ? AppColors.creamColor
                                            : AppColors.mirage,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                    Text(
                      'Most purchased products',
                      style: CustomTextWidget.bodyTextB2(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
                      ),
                    ),
                    vSizedBox1,
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Consumer<ProductNotifier>(
                        builder: (context, notifier, _) {
                          return FutureBuilder(
                            future: notifier.fetchProductss(context: context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ShimmerEffects.loadShimmer(
                                    context: context);
                              } else {
                                var _snapshot = snapshot.data;
                                if (_snapshot == null) {
                                  return Center(
                                    child: Text(
                                      'Data is null...',
                                      style: CustomTextWidget.bodyTextUltra(
                                        color: themeFlag
                                            ? AppColors.creamColor
                                            : AppColors.mirage,
                                      ),
                                    ),
                                  );
                                } else if (_snapshot is List) {
                                  return ListView.separated(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(width: 8),
                                    itemCount: _snapshot.length,
                                    itemBuilder: (context, index) {
                                      ProductData prod = _snapshot[index];
                                      return ProductCard1(
                                        prod: prod,
                                        themeFlag: themeFlag,
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      'Invalid data format...',
                                      style: CustomTextWidget.bodyTextUltra(
                                        color: themeFlag
                                            ? AppColors.creamColor
                                            : AppColors.mirage,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final ProductData prod;
  final bool themeFlag;
  const ProductCard({
    Key? key,
    required this.prod,
    required this.themeFlag,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    var domain = ApiRoutes.baseurl;
    print(
        ">>>>>>>>>>>>>> Product Image Url In Product screen: ${widget.prod.productImage}");

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.prodDetailRoute,
          arguments: ProductDetailsArgs(id: widget.prod.productId),
        );
      },
      child: Container(
        width: 190,
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          elevation: 6,
          color: widget.themeFlag ? AppColors.mirage : AppColors.creamColor,
          child: Stack(
            children: [
              Positioned(
                top: 4,
                left: -16,
                child: Transform.rotate(
                  angle: -45 * 3.141592653589793238462 / 180,
                  child: Container(
                    width: 60,
                    height: 20,
                    color: Colors.red,
                    child: const Center(
                      child: Text(
                        "NEW",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -8,
                left: 124,
                child: IconButton(
                  onPressed: () {
                    toggleFavoriteStatus(context, widget.prod.productId);
                  },
                  icon: Icon(
                    isProductFavorite(widget.prod.productId)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.themeFlag
                        ? AppColors.creamColor
                        : AppColors.mirage,
                  ),
                ),
              ),
              Positioned(
                top: 26,
                left: 15,
                child: Hero(
                  tag: Key(widget.prod.productId.toString()),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.14,
                    width: MediaQuery.of(context).size.height * 0.160,
                    child: widget.prod.productImage != null &&
                            widget.prod.productImage!.isNotEmpty
                        ? Image.network(
                            "$domain/${widget.prod.productImage!}",
                            fit: BoxFit.cover,
                          )
                        : Container(),
                  ),
                ),
              ),
              Positioned(
                top: 132,
                left: 02,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.prod.productName,
                        style: CustomTextWidget.bodyText3(
                          color: widget.themeFlag
                              ? AppColors.creamColor
                              : AppColors.mirage,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '      \$  ${widget.prod.productPrice}',
                        style: CustomTextWidget.bodyText3(
                          color: widget.themeFlag
                              ? AppColors.creamColor
                              : AppColors.mirage,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

class ProductCard1 extends StatefulWidget {
  final ProductData prod;
  final bool themeFlag;
  const ProductCard1({
    Key? key,
    required this.prod,
    required this.themeFlag,
  }) : super(key: key);

  @override
  State<ProductCard1> createState() => _ProductCardState1();
}

class _ProductCardState1 extends State<ProductCard1> {
  @override
  Widget build(BuildContext context) {
    var domain = ApiRoutes.baseurl;
    print(
        ">>>>>>>>>>>>>> Product Image Url In Product screen: ${widget.prod.productImage}");

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.prodDetailRoute,
          arguments: ProductDetailsArgs(id: widget.prod.productId),
        );
      },
      child: Container(
        width: 190,
        height: 140,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          elevation: 6,
          color: widget.themeFlag ? AppColors.mirage : AppColors.creamColor,
          child: Stack(
            children: [
              Positioned(
                top: 4,
                left: -16,
                child: Transform.rotate(
                  angle: -45 * 3.141592653589793238462 / 180,
                  child: Container(
                    width: 60,
                    height: 20,
                    color: Color.fromARGB(255, 221, 126, 17),
                    child: const Center(
                      child: Text(
                        "BEST",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -8,
                left: 124,
                child: IconButton(
                  onPressed: () {
                    toggleFavoriteStatus(context, widget.prod.productId);
                  },
                  icon: Icon(
                    isProductFavorite(widget.prod.productId)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.themeFlag
                        ? AppColors.creamColor
                        : AppColors.mirage,
                  ),
                ),
              ),
              Positioned(
                top: 26,
                left: 15,
                child: Hero(
                  tag: Key(widget.prod.productId.toString()),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.14,
                    width: MediaQuery.of(context).size.height * 0.160,
                    child: widget.prod.productImage != null &&
                            widget.prod.productImage!.isNotEmpty
                        ? Image.network(
                            "$domain/${widget.prod.productImage!}",
                            fit: BoxFit.cover,
                          )
                        : Container(),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 00,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.prod.productName,
                        style: CustomTextWidget.bodyText3(
                          color: widget.themeFlag
                              ? AppColors.creamColor
                              : AppColors.mirage,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '\$  ${widget.prod.productPrice}',
                        style: CustomTextWidget.bodyText3(
                          color: widget.themeFlag
                              ? AppColors.creamColor
                              : AppColors.mirage,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 00,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buy:${widget.prod.totalBuy}',
                        style: CustomTextWidget.bodyText3(
                          color: widget.themeFlag
                              ? AppColors.creamColor
                              : AppColors.mirage,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
