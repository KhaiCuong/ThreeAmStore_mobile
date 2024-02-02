import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:scarvs/core/models/order_status_enum.dart';

import '../../../../app/constants/app.colors.dart';
import '../../../../app/constants/url_api.dart';
import '../../../../app/routes/api.routes.dart';
import '../../../../core/models/api_order.dart';
import '../../../../core/notifiers/authentication.notifer.dart';
import '../../../../core/notifiers/order.notifier.dart';
import '../../../../core/notifiers/theme.notifier.dart';
import '../../../widgets/custom.back.btn.dart';
import '../../../widgets/custom.text.style.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { upcoming, complete, cancel }

class _AppointmentPageState extends State<AppointmentPage> {
  List<ApiOrder> schedules = [];
  FilterStatus statusBooking = FilterStatus.upcoming;
  Alignment _alignment = Alignment.centerLeft;
  @override
  void initState() {
    super.initState();
    // Gọi hàm để lấy dữ liệu từ API và cập nhật danh sách bookings
    fetchBookings();
  }

  // Thay đổi hàm fetchBookings trong _AppointmentPageState
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
          '>>>>>>>>>>>>>>>>>>>>> Order response.statusCode ${response.statusCode}');

      if (response.statusCode == 200) {
        // Chuyển đổi JSON thành danh sách Booking và cập nhật state
        setState(() {
          // đoạn mã này để lọc danh sách booking theo patientId
          //  int patientId = 2; // Thay thế bằng patient["id"] cụ thể
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

  @override
  Widget build(BuildContext context) {
    List<dynamic> filterSchedules = schedules.where((var schedule) {
      FilterStatus scheduleStatus;
      switch (schedule.status) {
        case 'Preparing':
          scheduleStatus = FilterStatus.upcoming;
          break;
        case 'Completed':
          scheduleStatus = FilterStatus.complete;
          break;
        case 'Canceled':
          scheduleStatus = FilterStatus.cancel;
          break;
        default:
          scheduleStatus = FilterStatus
              .upcoming; // Xác định trạng thái mặc định nếu không khớp
      }
      return scheduleStatus == statusBooking;
    }).toList();
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    // print('>>>>>>>>>>>>>>>>>>>>>>fillerschedule: ${filterSchedules}');
    return SafeArea(
        child: Scaffold(
      backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  CustomBackPop(themeFlag: themeFlag),
                  Text(
                    'Appointment Schedule',
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
                          // this is  the filter tabs
                          for (FilterStatus filterStatus in FilterStatus.values)
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (filterStatus == FilterStatus.upcoming) {
                                    statusBooking = FilterStatus.upcoming;
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
                            return Card(
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
                                                      BorderRadius.circular(15),
                                                  color: Colors
                                                      .blue, // Update with your color logic
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
                                              Text('Code: ${_schedule.orderId}',
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
                                          color: _schedule.status == 'Canceled'
                                              ? Colors
                                                  .red 
                                              : _schedule.status == 'Delivery'
                                                  ? Colors
                                                      .green
                                                  : Color.fromARGB(
                                                      255, 227, 147, 62),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (_schedule.status == 'Preparing')
                                              Text(
                                                'Saler is preparing',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            if (_schedule.status == 'Delivery')
                                              Text(
                                                "Product is Delivering",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            // if (_schedule.status ==
                                            //     'upcoming')
                                            //   Text(
                                            //     'Upcoming schedule',
                                            //     style: TextStyle(
                                            //         color: Colors.white),
                                            //   ),
                                            if (_schedule.status == 'Completed')
                                              Text(
                                                'Order has completed',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            if (_schedule.status == 'Canceled')
                                              Text(
                                                'Order has canceled',
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                          
                                          SizedBox(
                                            width: 20,
                                          ),
                                          // if (_schedule.status == 'Delivery'||_schedule.status == 'Completed' || _schedule.status == 'Canceled')
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  OutlinedButton(
                                                    onPressed: () {
                                                     
                                                    },
                                                    child: Text(
                                                      'Total Money: \$${_schedule.totalPrice}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  if (_schedule.status == 'Preparing')
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  // Gọi hàm để hiển thị hộp thoại xác nhận
                                                  showCancelConfirmationDialog(
                                                      context, _schedule);
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Color.fromARGB(
                                                      255, 227, 147, 62)), // Màu nền là màu vàng
                                                  // Các thuộc tính khác của nút có thể được thiết lập ở đây
                                                ),
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
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
                                ));
                          }))),
            ]),
      ),
    ));
  }

  Future<void> showCancelConfirmationDialog(
      BuildContext context, ApiOrder booking) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Click ngoài không đóng hộp thoại
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
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                // Gọi hàm để hủy đặt hẹn
                OrderNotifier orderService = OrderNotifier();
                OrderStatus orderStatus = OrderStatus.Canceled;
                bool success = await orderService.updateStatus(
                    context: context, id: booking.userId, status:'Canceled');

                if (success) {
                  // Xoá booking thành công, bạn có thể thực hiện các hành động cần thiết
                  print('Order canceled successfully.');
                  // sendCancelNotification(booking);

                  reloadBookings();
                  showDeleteSuccessSnackbar(
                      context); // Hiển thị thông báo thành công
                } else {
                  // Xử lý khi cancel booking không thành công
                  print('Failed to cancel booking.');
                }
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
          ],
        );
      },
    );
  }

  // Hàm để gửi thông báo khi bệnh nhân hủy lịch hẹn
  // void sendCancelNotification(Booking booking) async {
  //   String title = 'Lịch hẹn đã bị hủy';
  //   String body =
  //       'Cuộc hẹn vào ngày ${booking.appointmentDate} lúc ${booking.appointmentTime} đã bị hủy.';

  //   await AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: booking.id.hashCode,
  //       channelKey: 'key_channel_booking',
  //       title: title,
  //       body: body,
  //     ),
  //   );
  // }

  void showDeleteSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã hủy đặt hẹn thành công!'),
        duration: Duration(seconds: 2), // Thời gian hiển thị của snackbar
      ),
    );
  }

  void showPaySuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã Thanh toán thành công!'),
        duration: Duration(seconds: 3), // Thời gian hiển thị của snackbar
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
              booking.quantity?.toString() ??
                  'null', // Sử dụng toán tử null-aware (??) để kiểm tra và hiển thị một giá trị mặc định nếu booking.quantity là null
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

