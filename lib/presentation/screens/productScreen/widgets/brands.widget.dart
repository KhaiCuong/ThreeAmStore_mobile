import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.assets.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:scarvs/presentation/screens/categoryScreen/category.screen.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';
import 'package:scarvs/presentation/widgets/dimensions.widget.dart';

import '../../../../core/notifiers/product.notifier.dart';

class BrandWidget extends StatelessWidget {
  BrandWidget({Key? key}) : super(key: key);

  // Khai báo biến future
  ProductNotifier productNotifier = ProductNotifier();

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    // Không cần khởi tạo categoryListFuture ở đây nữa

    List<String> _categoriesImages = [
      AppAssets.brandRolex,
      AppAssets.brandHublot,
      AppAssets.brandPatek,
      AppAssets.brandOmega,
      AppAssets.brandBreitling,
      AppAssets.brandCalvin,
      AppAssets.brandCasio,
      AppAssets.brandCitizen,
      AppAssets.brandMovado,
      AppAssets.brandOrient,
      AppAssets.brandSeiko,
      AppAssets.brandDaniel
    ];
    Map<String, int> brandToImageIndex = {
      "Rolex": 0,
      "Hublot": 1,
      "Patek Philippe": 2,
      "Omega": 3,
      "Breitling": 4,
      "Calvin Klein": 5,
      "Casio": 6,
      "Citizen": 7,
      "Movado": 8,
      "Orient": 9,
      "Seiko": 10,
      "Daniel Wellington": 11
    };

    // Widget showBrands không thay đổi

    showBrands(String text, String images) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRouter.categoryRoute,
            arguments: CategoryScreenArgs(categoryName: text),
          );
        },
        child: Padding(
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
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.14,
                  width: MediaQuery.of(context).size.width * 0.38,
                  child: Image.asset(images),
                ),
                vSizedBox1,
                Text(
                  text,
                  style: CustomTextWidget.bodyText2(
                    color: themeFlag ? AppColors.creamColor : AppColors.mirage,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Brands We Have',
              style: CustomTextWidget.bodyTextB2(
                color: themeFlag ? AppColors.creamColor : AppColors.mirage,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRouter.categoryRoute,
                  arguments:
                      const CategoryScreenArgs(categoryName: 'All Brands'),
                );
              },
              child: Text(
                'See All',
                style: TextStyle(
                  color:
                      themeFlag ? AppColors.creamColor : AppColors.blueZodiac,
                  fontSize: 16.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: themeFlag
                    ? AppColors.blackPearl
                    : AppColors.creamColor, // Màu nền của nút
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Độ bo tròn của nút
                ),
              ),
            )
          ],
        ),
        vSizedBox2,
        // Sử dụng FutureBuilder để lấy dữ liệu từ hàm fetchProductCategoryList
        FutureBuilder<List<String>>(
          future: productNotifier.fetchProductCategoryList(context: context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Hiển thị loading indicator nếu dữ liệu đang được tải
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Xử lý lỗi nếu có
              return Text('Error: ${snapshot.error}');
            } else {
              // Hiển thị danh sách sản phẩm khi dữ liệu đã sẵn sàng
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Lấy brand từ snapshot.data![index]
                    String brand = snapshot.data![index];
                    // Kiểm tra xem brand có trong ánh xạ không
                    if (brandToImageIndex.containsKey(brand)) {
                      // Nếu có, lấy chỉ số tương ứng trong _categoriesImages
                      int imageIndex = brandToImageIndex[brand]!;
                      // Sử dụng chỉ số đó để lấy hình ảnh tương ứng trong _categoriesImages
                      String image = _categoriesImages[imageIndex];
                      // Trả về widget hiển thị hình ảnh và brand
                      return showBrands(brand, image);
                    } else {
                      // Nếu không tìm thấy ánh xạ, trả về widget trống
                      return showBrands(brand, _categoriesImages[4]);
                    }
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
