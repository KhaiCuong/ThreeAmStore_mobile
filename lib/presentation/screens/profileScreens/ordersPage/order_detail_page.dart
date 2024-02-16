
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.assets.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/core/models/api_order.dart';
import 'package:scarvs/core/notifiers/cart.notifier.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:scarvs/presentation/widgets/custom.back.btn.dart';
import 'package:scarvs/presentation/widgets/custom.loader.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';
import '../../../../app/routes/api.routes.dart';
import '../../../../core/models/api_order_detail.dart';


class OrderDetailPage extends StatefulWidget {
 final  OrderDetailPageArgs orderDetailPageArgs ;

  const OrderDetailPage({Key? key, required this.orderDetailPageArgs}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _isDisposed = false;
  late int orderId;
 @override
  void initState() {
    super.initState();
  }
  


  @override
  void dispose() {
    _isDisposed = true;
  
    super.dispose();
  }

 

  void showPayedSuccessSnackbar() {
    if (!_isDisposed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful, See detail in Profile'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context,) {
    // Future<List<String>> addresses = getAddressesFromHive();
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    // final userNotifier = Provider.of<AuthenticationNotifier>(context, listen: false);
CartNotifier cartNotifier = CartNotifier();
 


    print(">>>>>>>>>>>>>>>> Order Id in Detail Page: ${widget.orderDetailPageArgs.order.orderId}");

    return SafeArea(
      child: Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    CustomBackButton(
                      route: AppRouter.orderManagerment,
                      themeFlag: themeFlag,
                    ),
                    Text(
                      'Order Detail',
                      style: CustomTextWidget.bodyTextB2(
                        color:
                            themeFlag ? AppColors.creamColor : AppColors.mirage,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Consumer<CartNotifier>(
                    builder: (context, notifier, _) {
                      return FutureBuilder(
                        future:cartNotifier.getOrderDetailList(widget.orderDetailPageArgs.order.orderId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              (snapshot.data as List<OrderDetail>).isEmpty) {
                            return customLoader(
                              context: context,
                              themeFlag: themeFlag,
                              text: '',
                              lottieAsset: AppAssets.onBoardingOne,
                            );
                          } else {
                            var _snapshot = snapshot.data as List<OrderDetail>;
                            return showCartData(
                              // height: MediaQuery.of(context).size.height * 0.17,
                              snapshot: _snapshot,
                              themeFlag: themeFlag,
                              context: context,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showAlertSnackBar(
      BuildContext context, String title, String message, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title: $message'),
        duration: Duration(seconds: duration),
      ),
    );
  }

  Color getContainerBackgroundColor(bool themeFlag) {
    return themeFlag
        ? const Color.fromARGB(255, 255, 249, 249)
        : AppColors.mirage;
  }

  Widget showCartData({
    required snapshot,
    required themeFlag,
    required BuildContext context,
    // required double height,
  }) {
    return Column(
      children: [
         SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width,
          child: Text(
            'Order Code: ${widget.orderDetailPageArgs.order.orderId}',
            style: TextStyle(
              color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width,
          child: Text(
            'Status: ${widget.orderDetailPageArgs.order.status}',
            style: TextStyle(
              color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width,
          child: Text(
            'Reciever: ${widget.orderDetailPageArgs.order.username}',
            style: TextStyle(
              color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            ),
            textAlign: TextAlign.start,
          ),
        ),
         SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width,
          child: Text(
            'Phone:  ${widget.orderDetailPageArgs.order.phoneNumber}',
            style: TextStyle(
              color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          // height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width,
          child: Text(
            'Shipping Address: ${widget.orderDetailPageArgs.order.address}',
            style: TextStyle(
              color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: 14,),
       
         SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width,
          child: Text(
            'Payment Method: Paypal',
            style: TextStyle(
              color: themeFlag ? AppColors.creamColor : AppColors.mirage,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          // height: MediaQuery.of(context).size.height * 0.58,
          padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
          child: Stack(
            children: [
              
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.length,
                itemBuilder: (context, index) {
                  OrderDetail order = snapshot[index];
                  // print(">>>>>>>>>>${order.orderId}");
                  // // print(">>>>>>>>>>${order.address}");
                  // print(">>>>>>>>>>${order.image}");
                  // // print(">>>>>>>>>>${order.phoneNumber}");
                  // print(">>>>>>>>>>${order.price}");
                  // print(">>>>>>>>>>${order.productId}");
                  // print(">>>>>>>>>>${order.productName}");
                  // print(">>>>>>>>>>${order.quantity}");
                  // print(">>>>>>>>>>${order.userId}");
                  // print(">>>>>>>>>>${order.username}");
                  return _showCartData(
                    context: context,
                    order: order,
                    themeFlag: themeFlag,
                    // height: height,
                  );
                },
              ),
            ],
          ),
        ),
       
         SizedBox(height: 20,),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: cartPrice(
            snapshot: snapshot,
            themeFlag: themeFlag,
            context: context,
          ),
        ),

      ],
    );
  }

  Widget cartPrice({
    required snapshot,
    required themeFlag,
    required BuildContext context,
  }) {
    double totalPrice = 0;
    List<OrderDetail> cart = snapshot;

    for (int i = 0; i < cart.length; i++) {
      totalPrice += (cart[i].price ?? 0.0) * cart[i].quantity;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Payed',
          style: CustomTextWidget.bodyTextB2(
            color: themeFlag ? AppColors.creamColor : AppColors.mirage,
          ),
        ),
        Text(
          '\$ $totalPrice',
          style: CustomTextWidget.bodyText2(
            color: themeFlag ? AppColors.creamColor : AppColors.mirage,
          ),
        ),
      ],
    );
  }

  Widget _showCartData({
    required BuildContext context,
    required OrderDetail order,
    required bool themeFlag,
    // required double height,
  }) {
    var domain = ApiRoutes.baseurl;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: themeFlag ? AppColors.mirage : AppColors.creamColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 132, 211, 211).withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 90,
                height: 90,
                child: order.image != null
                    ? Image.network(
                        "$domain/${order.image}",
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                      )
                    : Placeholder(),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.productName,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextWidget.bodyText3(
                    color: themeFlag ? AppColors.creamColor : AppColors.mirage,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    '\$ ${(order.price * order.quantity).toStringAsFixed(2)}',
                    style: CustomTextWidget.bodyText3(
                      color:
                          themeFlag ? AppColors.creamColor : AppColors.mirage,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Quantity: ${order.quantity}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailPageArgs {
  final ApiOrder order;

  OrderDetailPageArgs({required this.order});
}
