import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.assets.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/core/notifiers/product.notifier.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:scarvs/presentation/screens/categoryScreen/widgets/category.widget.dart';
import 'package:scarvs/presentation/widgets/custom.back.btn.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';
import 'package:scarvs/presentation/widgets/custom.loader.dart';
import 'package:scarvs/presentation/widgets/dimensions.widget.dart';
import 'package:scarvs/presentation/widgets/shimmer.effects.dart';

import '../../../app/routes/api.routes.dart';
import '../../../core/models/favorite_product.dart';
import '../../../core/models/product.model.dart';
import '../../../core/service/favorite_product_box.dart';
import '../productDetailScreen/product.detail.screen.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryScreenArgs categoryScreenArgs;

  const CategoryScreen({Key? key, required this.categoryScreenArgs})
      : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                children: [
                  CustomBackButton(
                    route: AppRouter.homeRoute,
                    themeFlag: themeFlag,
                  ),
                  Center(
                    child: Text(
                      widget.categoryScreenArgs.categoryName,
                      style: CustomTextWidget.bodyTextB2(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            vSizedBox2,
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width,
                  child: Consumer<ProductNotifier>(
                    builder: (context, notifier, _) {
                      return FutureBuilder(
                        future: widget.categoryScreenArgs.categoryName ==
                                'All Brands'
                            ? notifier.fetchProducts(context: context)
                            : notifier.fetchProductCategoryById(
                                context: context,
                                id: widget.categoryScreenArgs.categoryName ==
                                        'Rolex'
                                    ? 'RL'
                                    : widget.categoryScreenArgs.categoryName ==
                                            'Omega'
                                        ? 'OM'
                                        : widget.categoryScreenArgs
                                                    .categoryName ==
                                                'Casio'
                                            ? 'CS'
                                            : widget.categoryScreenArgs
                                                        .categoryName ==
                                                    'Orient'
                                                ? 'OR'
                                                : widget.categoryScreenArgs
                                                            .categoryName ==
                                                        'Citizen'
                                                    ? 'CT'
                                                    : widget.categoryScreenArgs
                                                                .categoryName ==
                                                            'Calvin Klein'
                                                        ? 'CK'
                                                        : widget.categoryScreenArgs
                                                                    .categoryName ==
                                                                'Daniel Wellington'
                                                            ? 'DW'
                                                             : widget.categoryScreenArgs
                                                        .categoryName ==
                                                    'Movado'
                                                ? 'MV'
                                                            : widget.categoryScreenArgs
                                                                        .categoryName ==
                                                                    'Seiko'
                                                                ? 'Sk'
                                                                : widget.categoryScreenArgs
                                                                            .categoryName ==
                                                                        'Hublot'
                                                                    ? 'HL'
                                                                    : 'HL',
                              ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ShimmerEffects.buildCategoryShimmer(
                                context: context);
                          } else if (!snapshot.hasData) {
                            return customLoader(
                              context: context,
                              themeFlag: themeFlag,
                              text: 'No Stock Available',
                              lottieAsset: AppAssets.error,
                            );
                          } else {
                            var _snapshot = snapshot.data as List<ProductData>;
                            return ShowDataGrid(prods: _snapshot);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryScreenArgs {
  final dynamic categoryName;
  const CategoryScreenArgs({required this.categoryName});
}
