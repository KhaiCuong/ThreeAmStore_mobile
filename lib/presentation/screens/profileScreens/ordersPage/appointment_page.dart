import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:scarvs/core/notifiers/cart.notifier.dart';
import '../../../../app/constants/app.colors.dart';
import '../../../../app/routes/api.routes.dart';
import '../../../../app/routes/app.routes.dart';
import '../../../../core/models/api_order.dart';
import '../../../../core/models/api_order_detail.dart';
import '../../../../core/notifiers/authentication.notifer.dart';
import '../../../../core/notifiers/order.notifier.dart';
import '../../../../core/notifiers/theme.notifier.dart';
import '../../../widgets/custom.back.btn.dart';
import '../../../widgets/custom.text.style.dart';
import 'order_detail_page.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { waiting, complete, cancel }

class _AppointmentPageState extends State<AppointmentPage> {
  List<ApiOrder> schedules = [];
  FilterStatus statusBooking = FilterStatus.waiting;
  Alignment _alignment = Alignment.centerLeft;

  
  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

 
  
  void fetchBookings() async {
    final url = Uri.parse('$domain/api/Order/GetOrderList');

    var patientsId;
    var myAuthProvider =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    if (myAuthProvider.auth.token != null) {
      patientsId = myAuthProvider.auth.id;
      // patientsId = '2';
    } else {
      // patientsId = '1';
    }

    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>User id ${patientsId}');
    // print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>User id }');
    // print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>User id ${myAuthProvider.token}');

    try {
      final response = await http.get(url);
      print(
          '>>>>>>>>>>>>>>>>>>>>> Get Order response.statusCode ${response.statusCode}');

      if (response.statusCode == 200) {
        // Chuyển đổi JSON thành danh sách Booking và cập nhật state
        setState(() {
          // đoạn mã này để lọc danh sách booking theo patientId
          schedules = List<ApiOrder>.from(jsonDecode(response.body)['data']
                  .map((booking) => ApiOrder.fromJson(booking)))
              .where((booking) => booking.userId == (patientsId))
              .toList();
        });
      } else {
        // Xử lý khi có lỗi từ API
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý khi có lỗi kết nối
      print('Error: $e');
    }
    print('order length from api: ${schedules.length}');
  }

  void reloadBookings() async {
    fetchBookings();
    setState(() {
      // Update state để rebuild trang
    });
  }

  void reloadPayAfterBookings() async {
    showPaySuccessSnackbar(context);
    fetchBookings();
    setState(() {
      // Update state để rebuild trang
    });
  }

  void _navigateToOrderDetailPage(ApiOrder _order) {
    Navigator.of(context).pushNamed(
      AppRouter.orderDetailPage,
      arguments: OrderDetailPageArgs(order: _order),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filterSchedules = schedules.where((var schedule) {
      FilterStatus scheduleStatus;
      switch (schedule.status) {
        case 'Preparing':
          scheduleStatus = FilterStatus.waiting;
          break;
        case 'Completed':
          scheduleStatus = FilterStatus.complete;
          break;
        case 'Canceled':
          scheduleStatus = FilterStatus.cancel;
          break;
        default:
          scheduleStatus = FilterStatus.waiting;
      }
      return scheduleStatus == statusBooking;
    }).toList();
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
  CartNotifier cartNotifier = CartNotifier();
    final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    var _userId = authNotifier.auth.id != null ? int.parse(authNotifier.auth.id.toString()) : 1;
    var _username = authNotifier.auth.username ?? 'Wait';
    var _userEmail = authNotifier.auth.useremail ?? 'exam@gmail.com';
    var _phoneNumber = authNotifier.auth.userphoneNo ?? '0909090909';
    // print('>>>>>>>>>>>>>>>>>>>>>>fillerschedule: ${filterSchedules}');
    return SafeArea(
        child: Scaffold(
      backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  CustomBackButton(
                    route: AppRouter.profileRoute,
                    themeFlag: themeFlag,
                  ),
                  Text(
                    'Order History',
                    style: CustomTextWidget.bodyTextB2(
                      color:
                          themeFlag ? AppColors.creamColor : AppColors.mirage,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (FilterStatus filterStatus in FilterStatus.values)
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (filterStatus == FilterStatus.waiting) {
                                    statusBooking = FilterStatus.waiting;
                                    _alignment = Alignment.centerLeft;
                                  } else if (filterStatus ==
                                      FilterStatus.complete) {
                                    statusBooking = FilterStatus.complete;
                                    _alignment = Alignment.center;
                                  } else if (filterStatus ==
                                      FilterStatus.cancel) {
                                    statusBooking = FilterStatus.cancel;
                                    _alignment = Alignment.centerRight;
                                  }
                                });
                              },
                              child: Center(child: Text(filterStatus.name)),
                            ))
                        ]),
                  ),
                  AnimatedAlign(
                    alignment: _alignment,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                          child: Text(
                        statusBooking.name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: filterSchedules.isEmpty
                      ? Text('No Booking here')
                      : ListView.builder(
                          itemCount: filterSchedules.length,
                          itemBuilder: ((context, index) {
                            ApiOrder _schedule = filterSchedules[index];
                            // print('_schedule id: ${_schedule.id}');

                            bool isLastElement =
                                filterSchedules.length + 1 == index;
                            return GestureDetector(
                              onTap: () {
                                _navigateToOrderDetailPage(_schedule);
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 49, 16, 16),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  margin: !isLastElement
                                      ? const EdgeInsets.only(bottom: 20)
                                      : EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CircleAvatar(
                                              radius: 34.0,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(13)),
                                                child: Container(
                                                  height: 55,
                                                  width: 55,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Colors.blue,
                                                  ),
                                                  child: _schedule.image != null
                                                      ? Image.network(
                                                          "$domain/${_schedule?.image}",
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Container(),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("To "),
                                                    FaIcon(
                                                      FontAwesomeIcons.user,
                                                      color: Colors.black,
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      _schedule!.username,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    'Phone: ${_schedule.phoneNumber}',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                    'Code: ${_schedule.orderId}',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 40,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 245, 242, 239),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Text(
                                            'Address: ${_schedule.address}',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          height: 20,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (_schedule.status ==
                                                  'Preparing')
                                                Text(
                                                  'Saler is preparing',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              if (_schedule.status ==
                                                  'Delivery')
                                                Text(
                                                  "Product is Delivering",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              if (_schedule.status ==
                                                  'Completed')
                                                Text(
                                                  'Order has completed',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              if (_schedule.status ==
                                                  'Canceled')
                                                Text(
                                                  'Order has canceled',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                            ],
                                          ),
                                        ),
                                        ScheduleCard(booking: _schedule),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // if (_schedule.status == 'Delivery'||_schedule.status == 'Completed' || _schedule.status == 'Canceled')
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  OutlinedButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Total: \$${_schedule.totalPrice}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  if (_schedule.status ==
                                                      'Preparing')
                                                    Expanded(
                                                      child: OutlinedButton(
                                                        onPressed: () {
                                                          showCancelConfirmationDialog(
                                                              context,
                                                              _schedule);
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Color
                                                                      .fromARGB(
                                                                          255,
                                                                          227,
                                                                          147,
                                                                          62)),
                                                        ),
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  if (_schedule.status ==
                                                      'Delivery')
                                                    Expanded(
                                                      child: OutlinedButton(
                                                        onPressed: () {
                                                          showRevievedConfirmationDialog(
                                                              context,
                                                              _schedule);
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Color
                                                                      .fromARGB(
                                                                          255,
                                                                          227,
                                                                          147,
                                                                          62)),
                                                        ),
                                                        child: Text(
                                                          'Recieved',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  if (_schedule.status ==
                                                          'Completed' ||
                                                      _schedule.status ==
                                                          'Canceled')
                                                    Expanded(
                                                      child: OutlinedButton(
                                                        onPressed: () async {
                                                     
                                                        // var orderDetailList = getOrderDetailList(_schedule.orderId);
                                                        int addToCart = await cartNotifier.addOrderDetailsToHiveCart(_schedule.orderId,_userId);
                                                        if(addToCart ==1){
                                                          showSnackbar(context, 'added to Cart', 2);
                                                        }
                                                          if(addToCart ==2){
                                                          showSnackbar(context, 'added More to Cart', 2);
                                                        }
                                                          if(addToCart ==0){
                                                          showSnackbar(context, 'Someting wrong', 2);
                                                        }
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Color
                                                                      .fromARGB(
                                                                          255,
                                                                          227,
                                                                          147,
                                                                          62)),
                                                        ),
                                                        child: Text(
                                                          'Buy Again',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          }))),
            ]),
      ),
    ));
  }

  Future<void> showCancelConfirmationDialog(
      BuildContext context, ApiOrder booking) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm canceling'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to cancel this Order?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                OrderNotifier orderService = OrderNotifier();
                bool success = await orderService.updateStatus(
                    context: context, id: booking.orderId, status: 'Canceled');

                if (success) {
                  print('Order canceled successfully.');

                  reloadBookings();
                  showDeleteSuccessSnackbar(context);
                } else {
                  print('Failed to cancel booking.');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showRevievedConfirmationDialog(
      BuildContext context, ApiOrder booking) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Revieved ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure that you have recieved the Order? If Yes, you can leave Review to the Saler'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                // Gọi hàm để hủy đặt hẹn
                OrderNotifier orderService = OrderNotifier();
                bool success = await orderService.updateStatus(
                    context: context, id: booking.orderId, status: 'Completed');

                if (success) {
                  print('Order Change to Completed successfully.');
                  reloadBookings();
                  showRecievedSuccessSnackbar(context);
                } else {
                  print('Failed to Confirm Recieved order.');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Canceled successful !'),
        duration: Duration(seconds: 2), // Thời gian
      ),
    );
  }
   void showSnackbar(BuildContext context,String message,int time) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: time), // Thời gian
      ),
    );
  }

  void showRecievedSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You have Revieved an Order!'),
        duration: Duration(seconds: 2), // Thời gian
      ),
    );
  }

  void showPaySuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã Thanh toán thành công!'),
        duration: Duration(seconds: 3), // Thời gian
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final ApiOrder booking;
  const ScheduleCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Quantity:',
            style: TextStyle(
              color: Color.fromARGB(255, 1, 78, 141),
            ),
          ),
          Flexible(
            child: Text(
              booking.quantity?.toString() ?? 'null',
              style: TextStyle(
                color: Color.fromARGB(255, 1, 78, 141),
              ),
            ),
          ),
          SizedBox(
            width: 45,
          ),
          Text(
            'Status:',
            style: TextStyle(
              color: Color.fromARGB(255, 1, 78, 141),
            ),
          ),
          Text(
            booking.status,
            style: TextStyle(color: Color.fromARGB(255, 1, 78, 141)),
          ),
        ],
      ),
    );
  }
}
/////
