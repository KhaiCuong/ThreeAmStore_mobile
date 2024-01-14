import 'package:flutter/material.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/core/models/product.model.dart';
import 'package:scarvs/presentation/screens/productDetailScreen/product.detail.screen.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';

import '../../../../app/routes/api.routes.dart';

Widget showDataInGrid(
    {required snapshot,
    required themeFlag,
    required BuildContext context,
    required double height}) {
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
      itemCount: snapshot.length,
      itemBuilder: (context, index) {
        ProductData prod = snapshot[index];
        return _showProducts(
            context: context, prod: prod, themeFlag: themeFlag, height: height);
      },
    ),
  );
}
Widget _showProducts({
  required BuildContext context,
  required ProductData prod,
  required bool themeFlag,
  required double height,
}) {
  var domain = ApiRoutes.baseurl;

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
          arguments: ProductDetailsArgs(id: prod.productId),
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
            bottom: 1, // Điều chỉnh vị trí của tên sản phẩm
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              // decoration: BoxDecoration(
              //   color: const Color.fromARGB(255, 248, 248, 248).withOpacity(1),
              //   borderRadius: BorderRadius.circular(8),
              // ),
              child: Text(
                prod.productName,
                
                style: TextStyle(
                  color: themeFlag ? AppColors.creamColor : AppColors.blackPearl,
                  fontSize: 12,
                ),
                
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
