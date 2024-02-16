import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.assets.dart';
import 'package:scarvs/app/constants/app.colors.dart';
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
import '../../../../app/routes/app.routes.dart';
import '../../../../core/models/auction_watch.dart';
import '../../../../core/notifiers/authentication.notifer.dart';
import 'auction_bidding_page.dart';

class AuctionDetailPage extends StatefulWidget {
  final AuctionDetailsPageArgs auctionDetailsPageArgs;
  const AuctionDetailPage({
    Key? key,
    required this.auctionDetailsPageArgs,
  }) : super(key: key);

  @override
  State<AuctionDetailPage> createState() => _AuctionDetailPageState();
}

class _AuctionDetailPageState extends State<AuctionDetailPage> {
  var domain = ApiRoutes.baseurl;
  int _currentIndex = 0;
  CartNotifier cartNotifier = CartNotifier();
  UserNotifier userNotifier = UserNotifier();
  // SizeNotifier sizeNotifier =
  ProductNotifier productNotifier = ProductNotifier();

  Widget _buildProductUI(
      BuildContext context, bool themeFlag, dynamic _snapshot, int _userId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomBackPop(themeFlag: themeFlag),
            Text(
              'Auction Detail',
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
                _snapshot.name,
                style: CustomTextWidget.bodyTextB1(
                  color: themeFlag ? AppColors.creamColor : AppColors.mirage,
                ),
              ),
            ),
            vSizedBox2,
            Stack(
              alignment: Alignment.center,
              children: [
                InteractiveViewer(
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
              ],
            ),
            vSizedBox2,
            Stack(
              alignment: Alignment.center,
              children: [
                FutureBuilder(
                  future: productNotifier.fetchProductImages('PD04'),
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
           
          ],
        ),
        vSizedBox2,
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
          child: Text(
            'Description: ',
            style: CustomTextWidget.bodyTextUltra(
              color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 00, 0),
          child: Text(
           _snapshot.description!,
            style: CustomTextWidget.bodyText1(
              color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            ),
          ),
        ),
         vSizedBox1,

            Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
          child: Text(
            'Information: ',
            style: CustomTextWidget.bodyTextUltra(
              color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            ),
          ),
        ),
       
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
                      'Brand', // Tên trường
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
                      _snapshot.brand!,
                      style: CustomTextWidget.bodyText3(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
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
                      'Year', // Tên trường
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
                      _snapshot.year!,
                      style: CustomTextWidget.bodyText3(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
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
                      'Material', // Tên trường
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
                      _snapshot.material!,
                      style: CustomTextWidget.bodyText3(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
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
                      'Weight', // Tên trường
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
                      _snapshot.weight!,
                      style: CustomTextWidget.bodyText3(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
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
                      _snapshot.faceSize!,
                      style: CustomTextWidget.bodyText3(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
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
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
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
                      'Start time', // Tên trường
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
                      _snapshot.startTime!,
                      style: CustomTextWidget.bodyText3(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
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
                      'Bidding count', // Tên trường
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
                     '\$ ${_snapshot.biddingCount.toString()}',
                      style: CustomTextWidget.bodyText3(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
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
                      'Start Price', // Tên trường
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
                    '\$ ${_snapshot.startPrice}',
                      style: CustomTextWidget.bodyText3(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        vSizedBox2,
       
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                themeFlag ? AppColors.creamColor : AppColors.mirage,
            enableFeedback: true,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.286,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
             Navigator.of(context).pushNamed(
            AppRouter.auctionBiddingPage,
            arguments: AuctionBiddingPageArgs(auction: _snapshot),
          );
          },
          child: Text(
            'Biding Page',
            style: CustomTextWidget.bodyTextB2(
              color: themeFlag ? AppColors.mirage : AppColors.creamColor,
            ),
          ),
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
    return Scaffold(
      backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 45, 20, 0),
          child: Consumer<ProductNotifier>(builder: (context, notifier, _) {
            return _buildProductUI(context, themeFlag,
                widget.auctionDetailsPageArgs.auction, userId);
          }),
        ),
      ),
    );
  }
}

class AuctionDetailsPageArgs {
  final AuctionWatch auction;
  const AuctionDetailsPageArgs({required this.auction});
}
