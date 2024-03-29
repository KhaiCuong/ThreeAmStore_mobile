import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.assets.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/core/models/api_order_detail.dart';
import 'package:scarvs/core/notifiers/product.notifier.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:scarvs/presentation/screens/productDetailScreen/widget/ui.detail.dart';
import 'package:scarvs/presentation/widgets/custom.loader.dart';
import 'package:scarvs/core/notifiers/cart.notifier.dart';
import 'package:scarvs/core/notifiers/user.notifier.dart';
import 'package:scarvs/core/utils/snackbar.util.dart';
import 'package:scarvs/presentation/widgets/custom.back.btn.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';
import 'package:scarvs/presentation/widgets/dimensions.widget.dart';
import '../../../../app/routes/api.routes.dart';
import '../../../core/notifiers/authentication.notifer.dart';

class ProductDetail extends StatefulWidget {
  final ProductDetailsArgs productDetailsArguements;
  const ProductDetail({
    Key? key,
    required this.productDetailsArguements,
  }) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var domain = ApiRoutes.baseurl;
  int _currentIndex = 0;
  CartNotifier cartNotifier = CartNotifier();
  UserNotifier userNotifier = UserNotifier();
  // SizeNotifier sizeNotifier =
  ProductNotifier productNotifier = ProductNotifier();

  Widget _buildProductUI(
      BuildContext context, bool themeFlag, dynamic _snapshot, int _userId) {
    final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    var _userId = authNotifier.auth.id != null
        ? int.parse(authNotifier.auth.id.toString())
        : 1;
    var _username = authNotifier.auth.username ?? 'Wait';
    var _userEmail = authNotifier.auth.useremail ?? 'exam@gmail.com';
    var _userPhone = authNotifier.auth.userphoneNo ?? '0909090909';
    var _userAddress = authNotifier.auth.useraddress ?? 'Tran Van Dand';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomBackPop(themeFlag: themeFlag),
            Text(
              'Product Detail',
              style: CustomTextWidget.bodyTextB2(
                color: themeFlag ? AppColors.creamColor : AppColors.mirage,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Center(
              child: Text(
                _snapshot.productName,
                style: CustomTextWidget.bodyTextB1(
                  color: themeFlag ? AppColors.creamColor : AppColors.mirage,
                ),
              ),
            ),
            vSizedBox2,
            Stack(
              alignment: Alignment.center,
              children: [
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.35,
                //   width: MediaQuery.of(context).size.width * 0.8,
                //   child: themeFlag
                //       ? Image.asset(AppAssets.diamondWhite)
                //       : Image.asset(AppAssets.diamondBlack),
                // ),
                Hero(
                  tag: Key(_snapshot.productId.toString()),
                  child: InteractiveViewer(
                    child: SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.3,
                        //   width: MediaQuery.of(context).size.width * 0.7,
                        //   child: _snapshot.productImage != null &&
                        //           _snapshot.productImage!.isNotEmpty
                        //       ? Image.network("$domain${_snapshot.productImage!}",
                        //           alignment: Alignment.center)
                        //       : Container(),
                        ),
                  ),
                ),
              ],
            ),
            vSizedBox2,
            Stack(
              alignment: Alignment.center,
              children: [
                FutureBuilder(
                  future:
                      productNotifier.fetchProductImages(_snapshot.productId),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState == ConnectionState.done) {
                      List<String> imageList =
                          imageSnapshot.data as List<String>;
                      if (imageList != null) {
                        return ProductImageSlider(
                          imageList: imageList,
                          domain: domain,
                        );
                      } else {
                        return const SizedBox
                            .shrink(); // hoặc Widget khác để hiển thị khi dữ liệu rỗng.
                      }
                    } else {
                      return CircularProgressIndicator(); // Hoặc bạn có thể thay bằng Widget khác để hiển thị khi đang tải ảnh.
                    }
                  },
                ),
              ],
            ),
            //     vSizedBox2,
            //     Text(
            //       _snapshot.productDescription!,
            //       style: CustomTextWidget.bodyText3(
            //         color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            //       ),
            //       textAlign: TextAlign.justify,
            //     ),
            //     vSizedBox2,
            //     Text(
            //       _snapshot.isWaterproof.toString(),
            //       style: CustomTextWidget.bodyText3(
            //         color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            //       ),
            //       textAlign: TextAlign.justify,
            //     ),
            //     Text(
            //       '\$ ${_snapshot.productPrice}',
            //       style: CustomTextWidget.bodyText3(
            //         color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            //       ),
            //       textAlign: TextAlign.justify,
            //     ),
            //   ],
            // ),
            // vSizedBox2,
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            //       child: Text(
            //         '\$ ${_snapshot.productPrice}',
            //         style: CustomTextWidget.bodyTextUltra(
            //           color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            //       child: Text(
            //         '\duong kinh: ${_snapshot.diameter}mm',
            //         textAlign: TextAlign
            //             .center, // hoặc TextAlign.left hoặc TextAlign.right tùy thuộc vào yêu cầu của bạn
            //         style: CustomTextWidget.bodyTextUltra(
            //           color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            //         ),
            //       ),
            //     ),

            Table(
              border: TableBorder.all(), // Tùy chỉnh border của bảng
              columnWidths: {
                // Đặt độ rộng của cột
                0: FractionColumnWidth(
                    0.4), // Cột trái chiếm 30% chiều rộng của bảng
                1: FractionColumnWidth(
                    0.6), // Cột phải chiếm 70% chiều rộng của bảng
              },
              children: [
                // Dòng 1: Tên trường và dữ liệu tương ứng
                TableRow(
                  children: [
                    // Cột 1: Tên trường
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Product Name', // Tên trường
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Cột 2: Dữ liệu
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _snapshot.productName,
                          style: CustomTextWidget.bodyText3(
                            color: themeFlag
                                ? AppColors.creamColor
                                : AppColors.mirage,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
                // Dòng 2: Tên trường và dữ liệu tương ứng
                TableRow(
                  children: [
                    // Cột 1: Tên trường
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Waterproof', // Tên trường
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Cột 2: Dữ liệu
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _snapshot.isWaterproof.toString(),
                          style: CustomTextWidget.bodyText3(
                            color: themeFlag
                                ? AppColors.creamColor
                                : AppColors.mirage,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Face size', // Tên trường
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${_snapshot.diameter}mm',
                          style: CustomTextWidget.bodyText3(
                            color: themeFlag
                                ? AppColors.creamColor
                                : AppColors.mirage,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),

                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Gender', // Tên trường
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _snapshot.gender!,
                          style: CustomTextWidget.bodyText3(
                            color: themeFlag
                                ? AppColors.creamColor
                                : AppColors.mirage,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    // Cột 1: Tên trường
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'description', // Tên trường
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Cột 2: Dữ liệu
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _snapshot.productDescription!,
                          style: CustomTextWidget.bodyText3(
                            color: themeFlag
                                ? AppColors.creamColor
                                : AppColors.mirage,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    // Cột 1: Tên trường
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Feed Back', // Tên trường
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Cột 2: Dữ liệu
                    TableCell(
                      child: ElevatedButton(
                        child: Text("Show feedbacks"),
                        onPressed: () => {
                          _showHistoryFeedback(context, _snapshot.productId)
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    '\$ ${_snapshot.productPrice}',
                    style: CustomTextWidget.bodyTextUltra(
                      color:
                          themeFlag ? AppColors.creamColor : AppColors.mirage,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        themeFlag ? AppColors.creamColor : AppColors.mirage,
                    enableFeedback: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    bool isInCart =
                        await cartNotifier.isProductInCart(_snapshot.productId);

                    if (isInCart) {
                      bool updateQuantity = await cartNotifier
                          .updateQuantityInCart(_snapshot.productId, 1);
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
                        userEmail: _userEmail,
                        username: _username,
                        address: _userAddress,
                        phoneNumber: _userPhone,
                        price: _snapshot.productPrice!,
                        productName: _snapshot.productName,
                        productId: _snapshot.productId,
                        image: _snapshot.productImage!,
                        userId: _userId,
                        quantity: 1,
                        context: context,
                        productSize: '40',
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackUtil.stylishSnackBar(
                          text: 'Added To Cart',
                          context: context,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Add To Cart',
                    style: CustomTextWidget.bodyTextB2(
                      color:
                          themeFlag ? AppColors.mirage : AppColors.creamColor,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    var myAuthProvider =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    var userId = myAuthProvider.auth.id;
    var order;

    return Scaffold(
      backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 45, 20, 0),
          child: Consumer<ProductNotifier>(builder: (context, notifier, _) {
            return FutureBuilder(
              future: notifier.fetchProductDetail(
                id: widget.productDetailsArguements.id,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var _snapshot = snapshot.data;
                  return _buildProductUI(context, themeFlag, _snapshot, userId);
                } else {
                  return Center(
                    child: customLoader(
                      context: context,
                      themeFlag: themeFlag,
                      lottieAsset: AppAssets.onBoardingTwo,
                      text: 'Please Wait Till It Loads',
                    ),
                  );
                }
              },
            );
          }),
        ),
      ),
    );
  }
}

_showHistoryFeedback(BuildContext context, String id) {
  print(">>>>>>>>>>>>>>>>>>>>>>>id: ${id}");
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(child: Consumer<ProductNotifier>(
        builder: (context, notifier, _) {
          return FutureBuilder(
            future:
                notifier.fetchProductsFeedBack(context: context, id:id ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                dynamic data = snapshot.data;

                print(">>>>>>>>>>>>>>>>>>>>>>>snapshot: ${data}");
                return SingleChildScrollView(
                  child: SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Feedback",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          for (var item in data) ...[
                            SizedBox(height: 8),
                            Text(
                              item['content'],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                for (int i = 0; i < item['start']; i++)
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                              ],
                            ),
                            SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          );
        },
      ));
    },
  );
}

class ProductDetailsArgs {
  final dynamic id;
  const ProductDetailsArgs({required this.id});
}
