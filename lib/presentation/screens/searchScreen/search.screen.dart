import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.assets.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/core/models/product.model.dart';
import 'package:scarvs/core/notifiers/product.notifier.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:scarvs/presentation/screens/categoryScreen/widgets/category.widget.dart';
import 'package:scarvs/presentation/screens/productScreen/product.screen.dart';
import 'package:scarvs/presentation/widgets/custom.loader.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';
import 'package:scarvs/presentation/widgets/dimensions.widget.dart';
import 'package:scarvs/presentation/widgets/shimmer.effects.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<ProductData> products = [];
  final TextEditingController searchProductController = TextEditingController();
  final ProductNotifier notifier = ProductNotifier();
  bool isExecuted = true;
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              1,
              1,
              1,
              MediaQuery.of(context).viewInsets.top,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  buildSearchInput(searchContent: '', themeFlag: isExecuted),
                  vSizedBox2,
                  isExecuted
                      ? searchData(
                          searchContent: searchProductController.text,
                          themeFlag: themeFlag,
                        )
                      : Center(
                          child: Text(
                            'Search Any Product',
                            style: CustomTextWidget.bodyText2(
                              color: themeFlag
                                  ? AppColors.creamColor
                                  : AppColors.mirage,
                            ),
                          ),
                        )
                  //      vSizedBox1,
                  // SizedBox(
                  //   height: 200,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Consumer<ProductNotifier>(
                  //     builder: (context, notifier, _) {
                  //       return FutureBuilder<List<ProductData>>(
                  //         future: notifier.fetchProducts(context: context),
                  //         builder: (context, snapshot) {
                  //           if (snapshot.connectionState ==
                  //               ConnectionState.waiting) {
                  //             return ShimmerEffects.loadShimmer(
                  //                 context: context);
                  //           } else {
                  //             var _snapshot = snapshot.data;
                  //             if (_snapshot == null) {
                  //               return Center(
                  //                 child: Text(
                  //                   'Data is null...',
                  //                   style: CustomTextWidget.bodyTextUltra(
                  //                     color: themeFlag
                  //                         ? AppColors.creamColor
                  //                         : AppColors.mirage,
                  //                   ),
                  //                 ),
                  //               );
                  //             } else if (_snapshot is List) {
                  //               return ListView.separated(
                  //                 physics: const ScrollPhysics(),
                  //                 shrinkWrap: true,
                  //                 scrollDirection: Axis.horizontal,
                  //                 separatorBuilder: (context, index) =>
                  //                     const SizedBox(width: 8),
                  //                 itemCount: _snapshot.length,
                  //                 itemBuilder: (context, index) {
                  //                   ProductData prod = _snapshot[index];
                  //                   return ProductCard(
                  //                     prod: prod,
                  //                     themeFlag: themeFlag,
                  //                   );
                  //                 },
                  //               );
                  //             } else {
                  //               return Center(
                  //                 child: Text(
                  //                   'Invalid data format...',
                  //                   style: CustomTextWidget.bodyTextUltra(
                  //                     color: themeFlag
                  //                         ? AppColors.creamColor
                  //                         : AppColors.mirage,
                  //                   ),
                  //                 ),
                  //               );
                  //             }
                  //           }
                  //         },
                  //       );
                  //     },
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSearchInput(
      {required String searchContent, required bool themeFlag}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      elevation: 6,
      color: themeFlag ? AppColors.mirage : AppColors.creamColor,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            hSizedBox1,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextField(
                controller: searchProductController,
                style: CustomTextWidget.bodyText2(
                  color: themeFlag ? AppColors.creamColor : AppColors.mirage,
                ),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.rawSienna,
                    ),
                  ),
                  hintText: 'Search......',
                  hintStyle: CustomTextWidget.bodyText2(
                    color: themeFlag ? AppColors.creamColor : AppColors.mirage,
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    isExecuted = true;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    isExecuted = true;
                  });
                  notifier.searchProduct(
                    context: context,
                    query: value,
                    productName: value,
                  );
                },
              ),
            ),
            hSizedBox1,
            IconButton(
              onPressed: () {
                setState(() {
                  isExecuted = true;
                });
              },
              icon: Icon(
                Icons.search,
                color: themeFlag ? AppColors.creamColor : AppColors.mirage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchData({required String searchContent, required bool themeFlag}) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          child: Consumer<ProductNotifier>(
            builder: (context, notifier, _) {
              return FutureBuilder(
                future: notifier.searchProduct(
                  context: context,
                  query: searchProductController.text,
                  productName: searchProductController.text,
                ),
                builder: (context, snapshot) {
                  print("424324234?>>>>>" + snapshot.toString());

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ShimmerEffects.buildCategoryShimmer(
                        context: context);
                  }

                  if (snapshot?.data == null) {
                    // Trường hợp snapshot null
                    return customLoader(
                      context: context,
                      themeFlag: themeFlag,
                      text: 'No Product Found !',
                      lottieAsset: AppAssets.error,
                    );
                  }

                  var data = snapshot.data;

                  if (data is List<ProductData> && data.isEmpty) {
                    // Trường hợp snapshot.data là một danh sách rỗng
                    return customLoader(
                      context: context,
                      themeFlag: themeFlag,
                      text: 'No Product Found !',
                      lottieAsset: AppAssets.error,
                    );
                  }

                  // Trường hợp còn lại: snapshot.data không null và không rỗng
                  var _snapshot = data as List<ProductData>;
                  return ShowDataGrid(prods: _snapshot);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
