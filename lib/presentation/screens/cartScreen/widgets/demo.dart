// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:provider/provider.dart';
// import 'package:scarvs/app/constants/app.assets.dart';
// import 'package:scarvs/app/constants/app.colors.dart';
// import 'package:scarvs/app/routes/app.routes.dart';
// import 'package:scarvs/core/api/authentication.api.dart';
// import 'package:scarvs/core/notifiers/address.notifiter.dart';
// import 'package:scarvs/core/notifiers/authentication.notifer.dart';
// import 'package:scarvs/core/notifiers/cart.notifier.dart';
// import 'package:scarvs/core/notifiers/theme.notifier.dart';
// import 'package:scarvs/core/notifiers/user.notifier.dart';
// import 'package:scarvs/presentation/widgets/custom.back.btn.dart';
// import 'package:scarvs/presentation/widgets/custom.loader.dart';
// import 'package:scarvs/presentation/widgets/custom.text.style.dart';
// import 'package:scarvs/core/utils/snackbar.util.dart';
// import 'package:flutter_paypal/flutter_paypal.dart';
// import '../../../../app/routes/api.routes.dart';
// import '../../../../core/models/orders.dart';
// import '../../../app/constants/url_api.dart';
// import '../../../core/models/address.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({Key? key}) : super(key: key);

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   bool _isDisposed = false;
//   late String _selectedAddress = '';
//   @override
//   void dispose() {
//     _isDisposed = true;
//     super.dispose();
//   }

// //lấy dữ liệu orders từ Hive
//   Future<List<OrderData>> getCartData() async {
//     var ordersBox = await Hive.openBox<OrderData>('orders');
//     return ordersBox.values.toList();
//   }

//   void _decreaseOrderQuantity(OrderData order) async {
//     if (order.quantity > 1) {
//       // Giảm số lượng khi số lượng lớn hơn 1
//       setState(() {
//         order.quantity--;
//         _updateOrderQuantity(order);
//       });
//     }
//   }

//   void _increaseOrderQuantity(OrderData order) async {
//     // Tăng số lượng
//     setState(() {
//       order.quantity++;
//       _updateOrderQuantity(order);
//     });
//   }

//   // Phương thức cập nhật số lượng của order trong Hive Box
//   void _updateOrderQuantity(OrderData order) async {
//     var ordersBox = await Hive.openBox<OrderData>('orders');
//     final Map<dynamic, OrderData> deliveriesMap = ordersBox.toMap();
//     dynamic desiredKey;

//     deliveriesMap.forEach((key, value) {
//       if (value.orderId == order.orderId) {
//         desiredKey = key;
//       }
//     });

//     if (desiredKey != null) {
//       ordersBox.put(desiredKey, order);
//     }
//   }

//   Future<List<String>> getAddressesFromHive() async {
//     List<String> addresses = [];
//     var addressesBox = await Hive.openBox<Address>('addresses');
//     addresses = addressesBox.values.map((address) => address.address).toList();
//     return addresses;
//   }
//   deleteOrderFromHive(int id) async {
//     var ordersBox = await Hive.openBox<OrderData>('orders');

//     final Map<dynamic, OrderData> deliveriesMap = ordersBox.toMap();
//     dynamic desiredKey;
//     deliveriesMap.forEach((key, value) {
//       if (value.orderId == id) {
//         desiredKey = key;
//       }
//     });
//     print(">>>>>>>>>>>>>>>>desiredKey : $desiredKey");
//     if (desiredKey != null) {
//       ordersBox.delete(desiredKey);
//       setState(() {
//         // Cập nhật state hoặc thực hiện bất kỳ hành động nào cần thiết sau khi xoá
//       });
//       return true; // Trả về true nếu xóa thành công
//     } else {
//       print('Order with ID $id not found in Hive Box.');
//       return false; // Trả về false nếu không tìm thấy đối tượng cần xóa
//     }
//   }

//   deleteAdressFromHive(String address) async {
//     Box<Address> _addressesBox = Hive.box<Address>('addresses');

//     final Map<dynamic, Address> deliveriesMap = _addressesBox.toMap();
//     dynamic desiredKey;
//     deliveriesMap.forEach((key, value) {
//       if (value.address == address) {
//         desiredKey = key;
//       }
//     });
//     print(">>>>>>>>>>>>>>>>desiredKey : $desiredKey");
//     if (desiredKey != null) {
//       _addressesBox.delete(desiredKey);
//       Navigator.pop(context);
//       return true; // Trả về true nếu xóa thành công
//     } else {
//       print('$address not found in Hive Box.');
//       return false; // Trả về false nếu không tìm thấy đối tượng cần xóa
//     }
//   }

//   void showPayedSuccessSnackbar() {
//     // Check if the widget is still mounted before calling setState
//     if (!_isDisposed) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Payment successful, See detail in Profile'),
//           duration: Duration(seconds: 4),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
//     var themeFlag = _themeNotifier.darkTheme;
//     // final userNotifier = Provider.of<AuthenticationNotifier>(context, listen: false);

//     final authNotifier =
//         Provider.of<AuthenticationNotifier>(context, listen: false);
//     var useremail = authNotifier.auth.useremail ?? 'Wait';
//     // var useraddress = authNotifier.auth.useraddress??'please login';
//     var useraddress = 'please login';
//     print(">>>>>>>>>>>>>>>> useraddress: $useraddress");
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
//         body: Padding(
//           padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   CustomBackButton(
//                     route: AppRouter.homeRoute,
//                     themeFlag: themeFlag,
//                   ),
//                   Text(
//                     'Cart',
//                     style: CustomTextWidget.bodyTextB2(
//                       color:
//                           themeFlag ? AppColors.creamColor : AppColors.mirage,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.75,
//                 width: MediaQuery.of(context).size.width,
//                 child: Consumer<CartNotifier>(
//                   builder: (context, notifier, _) {
//                     return FutureBuilder(
//                       future: getCartData(),
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData ||
//                             (snapshot.data as List<OrderData>).isEmpty) {
//                           return customLoader(
//                             context: context,
//                             themeFlag: themeFlag,
//                             text: 'Eww Cart is Empty',
//                             lottieAsset: AppAssets.nodata,
//                           );
//                         } else {
//                           var _snapshot = snapshot.data as List<OrderData>;
//                           return showCartData(
//                             height: MediaQuery.of(context).size.height * 0.17,
//                             snapshot: _snapshot,
//                             themeFlag: themeFlag,
//                             context: context,
//                           );
//                         }
//                       },
//                     );
//                   },
//                 ),
//               ),
//                Row(
//                 children: [
//                   Text('Address: '),
//                   FutureBuilder<List<String>>(
//                     future: getAddressesFromHive(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return CircularProgressIndicator(); // Hiển thị tiến trình khi đang tải danh sách địa chỉ
//                       } else if (snapshot.hasError) {
//                         return Text('Error: ${snapshot.error}');
//                       } else {
//                         // snapshot.data chứa danh sách địa chỉ
//                         return Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.5), // Màu của shadow
//                                 spreadRadius: 2, // Bán kính lan rộng của shadow
//                                 blurRadius: 5, // Độ mờ của shadow
//                                 offset: Offset(
//                                     0, 3), // Vị trí của shadow (ngang, dọc)
//                               ),
//                             ],
//                           ),
//                           child: DropdownButton<String>(
//                             value: _selectedAddress, // Giá trị mặc định
//                             onChanged: (String? newValue) {
//                               if (newValue != null) {
//                                 setState(() {
//                                   _selectedAddress = newValue;
//                                 });
//                               }
//                             },
//                             items:
//                                 (snapshot.data as List<String>).map((address) {
//                               return DropdownMenuItem<String>(
//                                 value: address,
//                                 child: Text(address),
//                               );
//                             }).toList(),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Color getContainerBackgroundColor(bool themeFlag) {
//     return themeFlag
//         ? const Color.fromARGB(255, 255, 249, 249)
//         : AppColors.mirage;
//   }

//   Widget showCartData({
//     required snapshot,
//     required themeFlag,
//     required BuildContext context,
//     required double height,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
//       child: Stack(
//         children: [
//           ListView.builder(
//             physics: const ScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: snapshot.length,
//             itemBuilder: (context, index) {
//               OrderData order = snapshot[index];
//               return _showCartData(
//                 context: context,
//                 order: order,
//                 themeFlag: themeFlag,
//                 height: height,
//               );
//             },
//           ),
//           Align(
//             alignment: FractionalOffset.bottomCenter,
//             child: cartPrice(
//               snapshot: snapshot,
//               themeFlag: themeFlag,
//               context: context,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget cartPrice({
//     required snapshot,
//     required themeFlag,
//     required BuildContext context,
//   }) {
//     double cartPrice = 0;
//     List<OrderData> cart = snapshot;

//     for (int i = 0; i < cart.length; i++) {
//       cartPrice += (cart[i].price ?? 0.0) * cart[i].quantity;
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'Total',
//           style: CustomTextWidget.bodyTextB2(
//             color: themeFlag ? AppColors.creamColor : AppColors.mirage,
//           ),
//         ),
//         Text(
//           '\$ $cartPrice',
//           style: CustomTextWidget.bodyText2(
//             color: themeFlag ? AppColors.creamColor : AppColors.mirage,
//           ),
//         ),
//         MaterialButton(
//           height: MediaQuery.of(context).size.height * 0.05,
//           minWidth: MediaQuery.of(context).size.width * 0.2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           onPressed: () async {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (BuildContext context) => UsePaypal(
//                     sandboxMode: true,
//                     clientId: Constants.clientId,
//                     secretKey: Constants.secretKey,
//                     returnURL: Constants.returnURL,
//                     cancelURL: Constants.cancelURL,
//                     transactions: const [
//                       {
//                         "amount": {
//                           "total": 10,
//                           "currency": "USD",
//                         },
//                         "description": "The payment transaction description.",
//                         // "item_list": {
//                         //           "items": cart,

//                         //           // shipping address is not required though
//                         //           // "shipping_address": {
//                         //           //   "recipient_name": "Jane Foster",
//                         //           //   "line1": "Travis County",
//                         //           //   "line2": "",
//                         //           //   "city": "Austin",
//                         //           //   "country_code": "US",
//                         //           //   "postal_code": "73301",
//                         //           //   "phone": "+00000000",
//                         //           //   "state": "Texas"
//                         //           // },
//                         //         },
//                       }
//                     ],
//                     note:
//                         "Contact us 0909222009 for any questions on your order.",
//                     onSuccess: (Map params) async {
//                       print("onSuccess: $params");
//                       addOrderToApiCart(snapshot);
//                       showPayedSuccessSnackbar();
//                       clearOrdersFromHive();
//                     },
//                     onError: (error) {
//                       print("onError: $error");
//                       // UIHelper.showAlertDialog(
//                       //     'Unable to completet the Payment',
//                       //     title: 'Error',
//                       //     context: context);
//                     },
//                     onCancel: (params) {
//                       print('cancelled: $params');
//                       // UIHelper.showAlertDialog('Payment Cannceled',
//                       //     title: 'Cancel', context: context);
//                     }),
//               ),
//             );
//           },
//           color: AppColors.rawSienna,
//           child: const Text(
//             'Pay Now',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 17,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void addOrderToApiCart(snapshot) async {
//     if (mounted) {
//       CartNotifier cartNotifier = context.read<CartNotifier>();
//       await cartNotifier.addToApiCart(
//         address: 'TRan Van Dang',
//         userEmail: 'honag@tiwi.vn',
//         userName: 'Hoang Nguyen',
//         phoneNumber: '0909222009',
//         userId: 3,
//         orders: snapshot,
//       );
//       // Tiếp tục xử lý xoá dữ liệu trong OrderData trống
//       // if (!_isDisposed) {
//       // await clearOrdersFromHive();
//       //   setState(() {});
//       // }
//     }
//   }

//   Future<void> clearOrdersFromHive() async {
//     if (mounted) {
//       var ordersBox = await Hive.openBox<OrderData>('orders');

//       await ordersBox.clear();
//       setState(() {});
//       Navigator.of(context).pushNamed('/succesOrder');
//     }
//   }
// void _showEditDialog(
//   BuildContext context,
//   String field,
//   String useraddress,
// ) async {
//   TextEditingController _textEditingController = TextEditingController();
//   var addressesBox = await Hive.openBox<Address>('addresses');
//   List<Address> addresses = addressesBox.values.toList();
//   AddressNotifier addressNotifier = AddressNotifier();

//   print(">>>>>>>>>>>> Address List From Hive: ${addresses.length}");

//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: addresses.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(addresses[index].address),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () {
//                       deleteAdressFromHive(addresses[index].address); // Xóa từ Hive
//                     },
//                   ),
//                   onTap: () {
//                     useraddress=addresses[index].address; // Cập nhật useraddress từ bên ngoài
//                     print('Selected Address: ${addresses[index].address}');
//                     print('useraddress: ${useraddress}');
//                     setState(() {
                      
//                     });
//                     // Navigator.pop(context);
//                   },
//                 );
//               },
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _textEditingController,
//               decoration: InputDecoration(labelText: "Enter new address:"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Thêm địa chỉ mới vào Hive
//                 String newAddress = _textEditingController.text;
//                 if (newAddress.isNotEmpty) {
//                   addressNotifier.addAddress(newAddress);
//                   useraddress=newAddress; // Cập nhật useraddress từ bên ngoài
//                   Navigator.pop(context);
//                 } else {
//                   // Hiển thị thông báo hoặc xử lý khác nếu địa chỉ trống
//                 }
//               },
//               child: Text("Save"),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }


//   Widget _showCartData({
//     required BuildContext context,
//     required OrderData order,
//     required bool themeFlag,
//     required double height,
//   }) {
//     var domain = ApiRoutes.baseurl;
//     return Container(
//       margin: const EdgeInsets.only(top: 16),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: themeFlag ? AppColors.mirage : AppColors.creamColor,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Color.fromARGB(255, 132, 211, 211).withOpacity(0.8),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () {},
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Container(
//                 width: 90,
//                 height: 90,
//                 child: order.image != null
//                     ? Image.network(
//                         "$domain/${order.image}",
//                         alignment: Alignment.center,
//                         fit: BoxFit.cover, // Tuỳ chỉnh fit theo nhu cầu
//                       )
//                     : Placeholder(), // Hoặc một widget thay thế nếu không có ảnh
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   order.productName,
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                   style: CustomTextWidget.bodyText3(
//                     color: themeFlag ? AppColors.creamColor : AppColors.mirage,
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 5),
//                   child: Text(
//                     '\$ ${(order.price * order.quantity).toStringAsFixed(2)}',
//                     style: CustomTextWidget.bodyText3(
//                       color:
//                           themeFlag ? AppColors.creamColor : AppColors.mirage,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.only(top: 5),
//                       child: GestureDetector(
//                         behavior: HitTestBehavior.translucent,
//                         onTap: () {
//                           deleteItemFromCart(
//                             context: context,
//                             themeFlag: themeFlag,
//                             order: order,
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//                           height: 30,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border:
//                                 Border.all(width: 1, color: Colors.grey[300]!),
//                           ),
//                           child: Icon(
//                             Icons.delete,
//                             color: AppColors.rawSienna,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             splashRadius: 10.0,
//                             onPressed: () => _decreaseOrderQuantity(order),
//                             icon: const Icon(
//                               Icons.remove,
//                               color: Color(0xFFEC6813),
//                             ),
//                           ),
//                           Text(
//                             '${order.quantity}',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           IconButton(
//                             splashRadius: 10.0,
//                             onPressed: () => _increaseOrderQuantity(order),
//                             icon:
//                                 const Icon(Icons.add, color: Color(0xFFEC6813)),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void deleteItemFromCart({
//     required BuildContext context,
//     required bool themeFlag,
//     required OrderData order,
//   }) {
//     CartNotifier cartNotifier =
//         Provider.of<CartNotifier>(context, listen: false);

//     Widget cancelButton = TextButton(
//       onPressed: () {
//         Navigator.pop(context);
//       },
//       child: Text(
//         'No',
//         style: TextStyle(
//           color: themeFlag ? AppColors.creamColor : AppColors.mirage,
//         ),
//       ),
//     );
//     Widget continueButton = TextButton(
//       onPressed: () {
//         deleteOrderFromHive(order.orderId).then((value) {
//           if (value) {
//             Navigator.pop(context);
//             cartNotifier.refresh();
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackUtil.stylishSnackBar(
//                 text: 'Deleted From Cart',
//                 context: context,
//               ),
//             );
//           } else if (!value) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackUtil.stylishSnackBar(
//                 text: 'Oops Error Occurred',
//                 context: context,
//               ),
//             );
//           }
//         });
//       },
//       child: Text(
//         'Yes',
//         style: TextStyle(
//           color: themeFlag ? AppColors.mirage : AppColors.mirage,
//         ),
//       ),
//     );

//     AlertDialog alert = AlertDialog(
//       backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       title: const Text(
//         'Delete from Cart',
//         style: TextStyle(fontSize: 18),
//       ),
//       content: Text(
//         'Are you sure to delete this item from your Shopping Cart?',
//         style: TextStyle(
//           fontSize: 13,
//           color: themeFlag ? AppColors.creamColor : AppColors.mirage,
//         ),
//       ),
//       actions: [
//         cancelButton,
//         continueButton,
//       ],
//     );

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
