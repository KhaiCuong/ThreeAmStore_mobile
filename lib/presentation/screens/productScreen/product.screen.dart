import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.assets.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/core/notifiers/authentication.notifer.dart';
import 'package:scarvs/core/notifiers/product.notifier.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:scarvs/core/notifiers/user.notifier.dart';
import 'package:scarvs/presentation/screens/productScreen/widgets/brands.widget.dart';
import 'package:scarvs/presentation/screens/productScreen/widgets/recommended.widget.dart';
import 'package:scarvs/presentation/widgets/shimmer.effects.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';
import 'package:scarvs/presentation/widgets/dimensions.widget.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.creamColor,
                                    enableFeedback: true,
                                    padding: const EdgeInsets.symmetric(
                                        // horizontal: 20,
                                        // vertical: 2,
                                        ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Check',
                                    style: CustomTextWidget.bodyText3(
                                      color: AppColors.mirage,
                                    ),
                                  ),
                                ),
                                hSizedBox3,
                                SizedBox(
                                  height: 124,
                                  width: 190,
                                  child: Image.network(
                                      'https://rolex.dafc.com.vn/wp-content/uploads/watch-assets-laying-down/landscape_assets/m126508-0003_modelpage_laying_down_landscape.png'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    vSizedBox2,
                    const BrandWidget(),
                    vSizedBox2,
                    Text(
                      'More Watches',
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
                            future: notifier.fetchProducts(context: context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ShimmerEffects.loadShimmer(
                                    context: context);
                                // } else if (!snapshot.hasData) {
                                //   return Center(
                                //     child: Text(
                                //       'Some Error Occurred...',
                                //       style: CustomTextWidget.bodyTextUltra(
                                //         color: themeFlag
                                //             ? AppColors.creamColor
                                //             : AppColors.mirage,
                                //       ),
                                //     ),
                                //   );
                              } else {
                                var _snapshot = snapshot.data;
                                if (_snapshot == null) {
                                  // Xử lý khi dữ liệu là null
                                  // Ví dụ: Hiển thị thông báo hoặc thực hiện hành động khác
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
                                  // Thực hiện chuyển đổi kiểu và xử lý dữ liệu
                                  return productForYou(
                                    snapshot: _snapshot,
                                    themeFlag: themeFlag,
                                    context: context,
                                  );
                                } else {
                                  // Xử lý khi _snapshot không phải là List
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
