import 'package:flutter/material.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/app/routes/api.routes.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/core/models/product.model.dart';
import 'package:scarvs/presentation/screens/productDetailScreen/product.detail.screen.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';

Widget productForYou(
    {required snapshot, required themeFlag, required BuildContext context}) {
  var domain = ApiRoutes.baseurl;
  return ListView.builder(
    physics: const ScrollPhysics(),
    shrinkWrap: true,
    itemCount: snapshot.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      ProductData prod = snapshot[index];
      // print(">>>>>>>>>>>>>>>${prod.category}");
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRouter.prodDetailRoute,
            arguments: ProductDetailsArgs(id: prod.productId),
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
            color: themeFlag ? AppColors.mirage : AppColors.creamColor,
            child:
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                Stack(
              children: [
                Positioned(
                  top: 4,
                    left: -16,
                    child: Transform.rotate(
                        angle: -45 *
                            3.141592653589793238462 /
                            180, // Chuyển đổi độ sang radian
                        child:  Container(
                      width: 60,
                      height: 20,
                      color: Colors.red,
                      child:const Center(
                          child: Text(
                            "NEW",
                            style: TextStyle(
                              color: Colors
                                  .white, // Chọn màu sắc mong muốn cho chữ
                            ),
                          ),
                        ),
                      ),
                    )),
                Positioned(
                  top:-8,
                  left: 124,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border,
                      color:
                          themeFlag ? AppColors.creamColor : AppColors.mirage,
                    ),
                  ),
                ),
                Positioned(
                  top: 26,
                  left: 15,
                  child: Hero(
                    tag: Key(prod.productId.toString()),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.14,
                      width: MediaQuery.of(context).size.height * 0.160,
                      child: prod.productImage != null &&
                              prod.productImage!.isNotEmpty
                          ? Image.network(
                              "$domain${prod.productImage!}",
                              fit: BoxFit.scaleDown,
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
                          prod.productName,
                          style: CustomTextWidget.bodyText3(
                            color: themeFlag
                                ? AppColors.creamColor
                                : AppColors.mirage,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '      \$  ${prod.productPrice}',
                          style: CustomTextWidget.bodyText3(
                            color: themeFlag
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
    },
  );
}
