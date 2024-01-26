import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.assets.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/core/models/product.model.dart';
import 'package:scarvs/core/notifiers/product.notifier.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:scarvs/presentation/screens/categoryScreen/widgets/category.widget.dart';
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
  final TextEditingController searchProductController = TextEditingController();
  final ProductNotifier notifier = ProductNotifier();
  bool isExecuted = false;
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
              20,
              20,
              20,
              MediaQuery.of(context).viewInsets.top,
            ),
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
              ],
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
              width: MediaQuery.of(context).size.width * 0.65,
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ShimmerEffects.buildCategoryShimmer(
                        context: context);
                  } else if (!snapshot.hasData) {
                    return customLoader(
                      context: context,
                      themeFlag: themeFlag,
                      text: 'No Product Found !',
                      lottieAsset: AppAssets.error,
                    );
                  } else {
                    var _snapshot = snapshot.data as List<ProductData>;
                    return 
                  ShowDataGrid(prods: _snapshot);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
