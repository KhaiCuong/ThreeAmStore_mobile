import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.assets.dart';
import 'package:scarvs/app/constants/app.colors.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/core/notifiers/address.notifiter.dart';
import 'package:scarvs/core/notifiers/authentication.notifer.dart';
import 'package:scarvs/core/notifiers/cart.notifier.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'package:scarvs/presentation/widgets/custom.back.btn.dart';
import 'package:scarvs/presentation/widgets/custom.loader.dart';
import 'package:scarvs/presentation/widgets/custom.text.style.dart';
import 'package:scarvs/core/utils/snackbar.util.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import '../../../../app/routes/api.routes.dart';
import '../../../../core/models/orders.dart';
import '../../../app/constants/url_api.dart';
import '../../../core/models/address.dart';
import '../../widgets/custom.text.field.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isDisposed = false;
  late String _selectedAddress = "";
  late TextEditingController receiverNameController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setSelectedAddressFromUserAddress();
    final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    var username = authNotifier.auth.username ?? 'Wait';
    receiverNameController.text = username;

    var phone = authNotifier.auth.userphoneNo ?? 'Wait';
    phoneNumberController.text = phone;
  }

  void _setSelectedAddressFromUserAddress() {
    final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    if (authNotifier.auth.useraddress != null) {
      setState(() {
        _selectedAddress = authNotifier.auth.useraddress!;
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    receiverNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

//lấy dữ liệu orders từ Hive
  Future<List<OrderData>> getCartData() async {
    var ordersBox = await Hive.openBox<OrderData>('orders');
    return ordersBox.values.toList();
  }

  void _decreaseOrderQuantity(OrderData order) async {
    if (order.quantity > 1) {
      setState(() {
        order.quantity--;
        _updateOrderQuantity(order);
      });
    }
  }

  Widget _buildReceiverNameField() {
    return
        // CustomTextField.customTextField(
        //   textEditingController: receiverNameController,
        //   hintText: 'Receiver Name',
        //   obscureText: false,
        // );
        TextFormField(
      controller: receiverNameController,
      decoration: InputDecoration(
        labelText: 'Receiver Name',
        // Add any other decoration properties as needed
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: phoneNumberController,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        // Add any other decoration properties as needed
      ),
    );
  }

  void _increaseOrderQuantity(OrderData order) async {
    setState(() {
      order.quantity++;
      _updateOrderQuantity(order);
    });
  }

  // Phương thức cập nhật số lượng của order trong Hive Box
  void _updateOrderQuantity(OrderData order) async {
    var ordersBox = await Hive.openBox<OrderData>('orders');
    final Map<dynamic, OrderData> deliveriesMap = ordersBox.toMap();
    dynamic desiredKey;

    deliveriesMap.forEach((key, value) {
      if (value.orderId == order.orderId) {
        desiredKey = key;
      }
    });

    if (desiredKey != null) {
      ordersBox.put(desiredKey, order);
    }
  }

  deleteOrderFromHive(int id) async {
    var ordersBox = await Hive.openBox<OrderData>('orders');

    final Map<dynamic, OrderData> deliveriesMap = ordersBox.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.orderId == id) {
        desiredKey = key;
      }
    });
    print(">>>>>>>>>>>>>>>>desiredKey : $desiredKey");
    if (desiredKey != null) {
      ordersBox.delete(desiredKey);
      setState(() {
        // Cập nhật state hoặc thực hiện bất kỳ hành động nào cần thiết sau khi xoá
      });
      return true; // Trả về true nếu xóa thành công
    } else {
      print('Order with ID $id not found in Hive Box.');
      return false; // Trả về false nếu không tìm thấy đối tượng cần xóa
    }
  }

  Future<List<String>> getAddressesFromHive() async {
    List<String> addresses = [];
    var addressesBox = await Hive.openBox<Address>('addresses');
    addresses = addressesBox.values.map((address) => address.address).toList();
    return addresses;
  }

  deleteAdressFromHive(String address) async {
    Box<Address> _addressesBox = Hive.box<Address>('addresses');

    final Map<dynamic, Address> deliveriesMap = _addressesBox.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.address == address) {
        desiredKey = key;
      }
    });
    print(">>>>>>>>>>>>>>>>desiredKey : $desiredKey");
    if (desiredKey != null) {
      _addressesBox.delete(desiredKey);
      setState(() {});
      return true;
    } else {
      print('$address not found in Hive Box.');
      return false;
    }
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
  Widget build(BuildContext context) {
    Future<List<String>> addresses = getAddressesFromHive();
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    // final userNotifier = Provider.of<AuthenticationNotifier>(context, listen: false);

    final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    var useremail = authNotifier.auth.useremail ?? 'Wait';

    print(">>>>>>>>>>>>>>>> useremail: $useremail");

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
                      route: AppRouter.homeRoute,
                      themeFlag: themeFlag,
                    ),
                    Text(
                      'Cart',
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
                        future: getCartData(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              (snapshot.data as List<OrderData>).isEmpty) {
                            return customLoader(
                              context: context,
                              themeFlag: themeFlag,
                              text: 'Eww Cart is Empty',
                              lottieAsset: AppAssets.nodata,
                            );
                          } else {
                            var _snapshot = snapshot.data as List<OrderData>;
                            return showCartData(
                              height: MediaQuery.of(context).size.height * 0.17,
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

  void _onAddressSelected(String address) {
    setState(() {
      _selectedAddress = address;
    });
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

  void _showEditDialog(BuildContext context, String field) async {
    TextEditingController _textEditingController = TextEditingController();
    var addressesBox = await Hive.openBox<Address>('addresses');
    List<Address> addresses = addressesBox.values.toList();
    AddressNotifier addressNotifier = AddressNotifier();

    print(">>>>>>>>>>>> Address List From Hive: ${addresses.length}");
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Màu nền xám
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400]!, // Màu boxShadow xám
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(
                        left: 14, top: 14, right: 14, bottom: 0),
                    child: ListTile(
                      title: Text(addresses[index].address),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          if (addresses.length > 1) {
                            if (_selectedAddress == addresses[index].address) {
                              _selectedAddress =
                                  addresses[addresses.length - 1].address;
                              deleteAdressFromHive(addresses[index].address)
                                  .then((success) {
                                if (success) {
                                  setState(() {});
                                  Navigator.pop(context);
                                  showAlertSnackBar(context, 'Delete Address',
                                      addresses[index].address, 1);
                                }
                              });
                            } else {
                              deleteAdressFromHive(addresses[index].address);
                              setState(() {});
                              Navigator.pop(context);
                            }
                            showAlertSnackBar(context, 'Delete Address',
                                addresses[index].address, 1);
                          }
                        },
                      ),
                      onTap: () {
                        _onAddressSelected(addresses[index].address);
                        Navigator.pop(context); // Đóng dialog sau khi chọn
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 14),
                child: TextFormField(
                  controller: _textEditingController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Enter new address here:",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  cursorColor: Colors.blue,
                  cursorWidth: 3,
                  cursorHeight: 20,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 80,
                  maxLines: 3,
                  onChanged: (value) {},
                  onEditingComplete: () {},
                  validator: (value) {},
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  String newAddress = _textEditingController.text;
                  if (newAddress.isNotEmpty) {
                    addressNotifier.addAddress(newAddress);
                    _selectedAddress = newAddress;
                    setState(() {});
                    Navigator.pop(context);
                  } else {}
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 233, 153, 34),
                  onPrimary: Colors.white,
                ),
                child: Text("Save"),
              ),
              SizedBox(height: 25),
            ],
          ),
        );
      },
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
    required double height,
  }) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.58,
          padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
          child: Stack(
            children: [
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.length,
                itemBuilder: (context, index) {
                  OrderData order = snapshot[index];
                  print(">>>>>>>>>>${order.orderId}");
                  print(">>>>>>>>>>${order.address}");
                  print(">>>>>>>>>>${order.image}");
                  print(">>>>>>>>>>${order.phoneNumber}");
                  print(">>>>>>>>>>${order.price}");
                  print(">>>>>>>>>>${order.productId}");
                  print(">>>>>>>>>>${order.productName}");
                  print(">>>>>>>>>>${order.quantity}");
                  print(">>>>>>>>>>${order.userId}");
                  print(">>>>>>>>>>${order.username}");
                  return _showCartData(
                    context: context,
                    order: order,
                    themeFlag: themeFlag,
                    height: height,
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping Address: ',
                style: TextStyle(
                  color: themeFlag ? AppColors.creamColor : AppColors.mirage,
                ),
                textAlign: TextAlign.end,
              ),
              ElevatedButton(
                onPressed: () {
                  _showEditDialog(
                    context,
                    "Edit Address",
                  );
                },
                child: Text('Edit'),
              ),
            ],
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.9,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 115, 115, 115).withOpacity(0.8),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Colors.white),
            child: Text(_selectedAddress)),
        _buildReceiverNameField(),
        _buildPhoneNumberField(),
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
    List<OrderData> cart = snapshot;

    for (int i = 0; i < cart.length; i++) {
      totalPrice += (cart[i].price ?? 0.0) * cart[i].quantity;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
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
        MaterialButton(
          height: MediaQuery.of(context).size.height * 0.05,
          minWidth: MediaQuery.of(context).size.width * 0.2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => UsePaypal(
                    sandboxMode: true,
                    clientId: Constants.clientId,
                    secretKey: Constants.secretKey,
                    returnURL: Constants.returnURL,
                    cancelURL: Constants.cancelURL,
                    transactions: const [
                      {
                        "amount": {
                          "total": 10,
                          "currency": "USD",
                        },
                        "description": "The payment transaction description.",
                        // "item_list": {
                        //           "items": cart,

                        //           // shipping address is not required though
                        //           // "shipping_address": {
                        //           //   "recipient_name": "Jane Foster",
                        //           //   "line1": "Travis County",
                        //           //   "line2": "",
                        //           //   "city": "Austin",
                        //           //   "country_code": "US",
                        //           //   "postal_code": "73301",
                        //           //   "phone": "+00000000",
                        //           //   "state": "Texas"
                        //           // },
                        //         },
                      }
                    ],
                    note:
                        "Contact us 0909222009 for any questions on your order.",
                    onSuccess: (Map params) async {
                      print("onSuccess: $params");
            addOrderToApiCart(snapshot, totalPrice);
            showPayedSuccessSnackbar();
            clearOrdersFromHive();
                    },
                    onError: (error) {
                      print("onError: $error");
                      // UIHelper.showAlertDialog(
                      //     'Unable to completet the Payment',
                      //     title: 'Error',
                      //     context: context);
                    },
                    onCancel: (params) {
                      print('cancelled: $params');
                      // UIHelper.showAlertDialog('Payment Cannceled',
                      //     title: 'Cancel', context: context);
                    }),
              ),
            );
          },
          color: AppColors.rawSienna,
          child: const Text(
            'Pay Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildReceiverNameField() {
  //   final authNotifier =
  //       Provider.of<AuthenticationNotifier>(context, listen: false);
  //   var username = authNotifier.auth.username ?? 'Wait';
  //   TextEditingController receiverNameController =
  //       TextEditingController(text: username);
  //   print(">>>>>>>>>>>>>>>> userName: $username");

  //   return CustomTextField.customTextField(
  //     textEditingController: receiverNameController,

  //     hintText: 'Receiver Name', obscureText: false,
  //     // validator: (val) =>
  //     //     val!.isEmpty ? 'Enter FullName' : null,
  //   );
  // }

  // Widget _buildPhoneNumberField() {
  //   final authNotifier =
  //       Provider.of<AuthenticationNotifier>(context, listen: false);
  //   var phone = authNotifier.auth.userphoneNo ?? 'Wait';
  //   TextEditingController phoneNumberController =
  //       TextEditingController(text: phone);
  //   print(">>>>>>>>>>>>>>>> userPhone: $phone");
  //   return TextFormField(
  //     controller: phoneNumberController,
  //     decoration: InputDecoration(
  //       labelText: 'Phone Number',
  //       // Add any other decoration properties as needed
  //     ),
  //   );
  // }

  void addOrderToApiCart(snapshot, double totalPrice) async {
    if (mounted) {
      CartNotifier cartNotifier = context.read<CartNotifier>();
       final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    var _userId = authNotifier.auth.id != null ? int.parse(authNotifier.auth.id.toString()) : 1;
    var _username = authNotifier.auth.username ?? 'Wait';
    var _userEmail = authNotifier.auth.useremail ?? 'exam@gmail.com';
    var _phoneNumber = authNotifier.auth.userphoneNo ?? '0909090909';
    
      await cartNotifier.addToApiCart(
        userId: _userId,
        userName: _username,
        address: _selectedAddress,
        userEmail: _userEmail,
        phoneNumber: _phoneNumber,
        totalPrice:totalPrice,
    
        orders: snapshot,
      );
      // Tiếp tục xử lý xoá dữ liệu trong OrderData trống
      // if (!_isDisposed) {
      // await clearOrdersFromHive();
      //   setState(() {});
      // }
    }
  }

  Future<void> clearOrdersFromHive() async {
    if (mounted) {
      var ordersBox = await Hive.openBox<OrderData>('orders');

      await ordersBox.clear();
      setState(() {});
      Navigator.of(context).pushNamed('/succesOrder');
    }
  }

  Widget _showCartData({
    required BuildContext context,
    required OrderData order,
    required bool themeFlag,
    required double height,
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
                      margin: const EdgeInsets.only(top: 5),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          deleteItemFromCart(
                            context: context,
                            themeFlag: themeFlag,
                            order: order,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 1, color: Colors.grey[300]!),
                          ),
                          child: Icon(
                            Icons.delete,
                            color: AppColors.rawSienna,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            splashRadius: 10.0,
                            onPressed: () => _decreaseOrderQuantity(order),
                            icon: const Icon(
                              Icons.remove,
                              color: Color(0xFFEC6813),
                            ),
                          ),
                          Text(
                            '${order.quantity}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            splashRadius: 10.0,
                            onPressed: () => _increaseOrderQuantity(order),
                            icon:
                                const Icon(Icons.add, color: Color(0xFFEC6813)),
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

  void deleteItemFromCart({
    required BuildContext context,
    required bool themeFlag,
    required OrderData order,
  }) {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);

    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'No',
        style: TextStyle(
          color: themeFlag ? AppColors.creamColor : AppColors.mirage,
        ),
      ),
    );
    Widget continueButton = TextButton(
      onPressed: () {
        deleteOrderFromHive(order.orderId).then((value) {
          if (value) {
            Navigator.pop(context);
            cartNotifier.refresh();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackUtil.stylishSnackBar(
                text: 'Deleted From Cart',
                context: context,
              ),
            );
          } else if (!value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackUtil.stylishSnackBar(
                text: 'Oops Error Occurred',
                context: context,
              ),
            );
          }
        });
      },
      child: Text(
        'Yes',
        style: TextStyle(
          color: themeFlag ? AppColors.mirage : AppColors.mirage,
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text(
        'Delete from Cart',
        style: TextStyle(fontSize: 18),
      ),
      content: Text(
        'Are you sure to delete this item from your Shopping Cart?',
        style: TextStyle(
          fontSize: 13,
          color: themeFlag ? AppColors.creamColor : AppColors.mirage,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
