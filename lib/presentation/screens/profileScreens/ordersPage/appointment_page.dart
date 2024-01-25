// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_paypal/flutter_paypal.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';

// import '../../../../app/constants/url_api.dart';

// class AppointmentPage extends StatefulWidget {
//   const AppointmentPage({Key? key}) : super(key: key);

//   @override
//   State<AppointmentPage> createState() => _AppointmentPageState();
// }

// enum FilterStatus { upcoming, complete, cancel }

// class _AppointmentPageState extends State<AppointmentPage> {
//   List<Booking> schedules = [];
//   FilterStatus statusBooking = FilterStatus.upcoming;
//   Alignment _alignment = Alignment.centerLeft;
//   @override
//   void initState() {
//     super.initState();
//     // Gọi hàm để lấy dữ liệu từ API và cập nhật danh sách bookings
//     fetchBookings();
//   }

//   // Thay đổi hàm fetchBookings trong _AppointmentPageState
//   void fetchBookings() async {
//     final url = Uri.parse('$domain2/api/v1/booking/list');

//     var patientsId;
//     var myAuthProvider = Provider.of<MyAuthProvider>(context, listen: false);

//     if (myAuthProvider.token != null) {
//       patientsId = myAuthProvider.id;
//       // patientsId = '2';
//     } else {
//       patientsId = '2';
//     }

//     print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>User id ${patientsId}');
//     print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>User id }');
//     // print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>User id ${myAuthProvider.token}');

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         // Chuyển đổi JSON thành danh sách Booking và cập nhật state
//         setState(() {
//           // đoạn mã này để lọc danh sách booking theo patientId
//           //  int patientId = 2; // Thay thế bằng patient["id"] cụ thể
//           schedules = List<Booking>.from(jsonDecode(response.body)['data']
//                   .map((booking) => Booking.fromJson(booking)))
//               .where((booking) => booking.patients?.id == int.parse(patientsId))
//               .toList();
//         });
//       } else {
//         // Xử lý khi có lỗi từ API
//         print('Error: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Xử lý khi có lỗi kết nối
//       print('Error: $e');
//     }
//     print('booking length from api: ${schedules.length}');
//   }

//   void reloadBookings() async {
//     fetchBookings();
//     setState(() {
//       // Update state để rebuild trang
//     });
//   }

//   void reloadPayAfterBookings() async {
//     showPaySuccessSnackbar(context);
//     fetchBookings();
//     setState(() {
//       // Update state để rebuild trang
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<dynamic> filterSchedules = schedules.where((var schedule) {
//       FilterStatus scheduleStatus;
//       switch (schedule.statusBooking) {
//         case 'upcoming':
//           scheduleStatus = FilterStatus.upcoming;
//           break;
//         case 'complete':
//           scheduleStatus = FilterStatus.complete;
//           break;
//         case 'cancel':
//           scheduleStatus = FilterStatus.cancel;
//           break;
//         default:
//           scheduleStatus = FilterStatus
//               .upcoming; // Xác định trạng thái mặc định nếu không khớp
//       }
//       return scheduleStatus == statusBooking;
//     }).toList();

//     // print('>>>>>>>>>>>>>>>>>>>>>>fillerschedule: ${filterSchedules}');
//     return SafeArea(
//         child: Padding(
//       padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
//       child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             const Text(
//               'Appointment Schedule',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Stack(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // this is  the filter tabs
//                         for (FilterStatus filterStatus in FilterStatus.values)
//                           Expanded(
//                               child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 if (filterStatus == FilterStatus.upcoming) {
//                                   statusBooking = FilterStatus.upcoming;
//                                   _alignment = Alignment.centerLeft;
//                                 } else if (filterStatus ==
//                                     FilterStatus.complete) {
//                                   statusBooking = FilterStatus.complete;
//                                   _alignment = Alignment.center;
//                                 } else if (filterStatus ==
//                                     FilterStatus.cancel) {
//                                   statusBooking = FilterStatus.cancel;
//                                   _alignment = Alignment.centerRight;
//                                 }
//                               });
//                             },
//                             child: Center(child: Text(filterStatus.name)),
//                           ))
//                       ]),
//                 ),
//                 AnimatedAlign(
//                   alignment: _alignment,
//                   duration: const Duration(milliseconds: 200),
//                   child: Container(
//                     width: 100,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Center(
//                         child: Text(
//                       statusBooking.name,
//                       style: const TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     )),
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Expanded(
//                 child: filterSchedules.isEmpty
//                     ? Text('No Booking here')
//                     : ListView.builder(
//                         itemCount: filterSchedules.length,
//                         itemBuilder: ((context, index) {
//                           Booking _schedule = filterSchedules[index];
//                           // print('_schedule id: ${_schedule.id}');

//                           bool isLastElement =
//                               filterSchedules.length + 1 == index;
//                           return Card(
//                               shape: RoundedRectangleBorder(
//                                 side: const BorderSide(
//                                   color: Color.fromARGB(255, 49, 16, 16),
//                                 ),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               margin: !isLastElement
//                                   ? const EdgeInsets.only(bottom: 20)
//                                   : EdgeInsets.zero,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10),
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 34.0,
//                                           child: ClipRRect(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(13)),
//                                             child: Container(
//                                               height: 55,
//                                               width: 55,
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(15),
//                                                 color: Colors
//                                                     .blue, // Update with your color logic
//                                               ),
//                                               child: _schedule
//                                                           .doctors?.imagePath !=
//                                                       null
//                                                   ? Image.network(
//                                                       "$domain2/${_schedule.doctors?.imagePath}",
//                                                       fit: BoxFit.cover,
//                                                     )
//                                                   : Container(),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 FaIcon(
//                                                   FontAwesomeIcons.userDoctor,
//                                                   color: Colors.black,
//                                                   size: 18,
//                                                 ),
//                                                 SizedBox(width: 8),
//                                                 Text(
//                                                   _schedule.doctors!.fullName,
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontWeight: FontWeight.w700,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Text(
//                                                 'Spectial: ${_schedule.doctors!.spectiality}',
//                                                 style: TextStyle(
//                                                     color: Colors.grey,
//                                                     fontSize: 12,
//                                                     fontWeight:
//                                                         FontWeight.w600)),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Column(
//                                           children: [
//                                             Text('Id: ${_schedule.id}',
//                                                 style: TextStyle(
//                                                     color: Colors.grey,
//                                                     fontSize: 12,
//                                                     fontWeight:
//                                                         FontWeight.w600)),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     Container(
//                                       height: 20,
//                                       width: 60,
//                                       decoration: BoxDecoration(
//                                         color: _schedule.statusBooking ==
//                                                 'cancel'
//                                             ? Colors.red
//                                             : Color.fromARGB(255, 227, 124, 15),
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           if (_schedule.statusBooking ==
//                                               'pending')
//                                             Text(
//                                               'Doctor is accepting, please waite',
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                           if (_schedule.statusBooking ==
//                                               'confirmed')
//                                             Text(
//                                               "Doctor confirmed schedule, let's pay",
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                           if (_schedule.statusBooking ==
//                                               'upcoming')
//                                             Text(
//                                               'Upcoming schedule',
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                           if (_schedule.statusBooking ==
//                                               'complete')
//                                             Text(
//                                               'This booking has completed',
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                           if (_schedule.statusBooking ==
//                                               'cancel')
//                                             Text(
//                                               'This booking has canceled',
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                         ],
//                                       ),
//                                     ),
//                                     ScheduleCard(booking: _schedule),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         if (_schedule.statusBooking ==
//                                                 'upcoming' ||
//                                             _schedule.statusBooking ==
//                                                 'pending' ||
//                                             _schedule.statusBooking ==
//                                                 'confirmed')
//                                           Expanded(
//                                             child: OutlinedButton(
//                                               onPressed: () {
//                                                 // Gọi hàm để hiển thị hộp thoại xác nhận
//                                                 showCancelConfirmationDialog(
//                                                     context, _schedule);
//                                               },
//                                               child: Text(
//                                                 'Cancel',
//                                                 style: TextStyle(
//                                                   color: Color.fromARGB(
//                                                       255, 1, 78, 141),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         SizedBox(
//                                           width: 20,
//                                         ),
//                                         if (_schedule.statusBooking ==
//                                             'confirmed')
//                                           Expanded(
//                                             child: OutlinedButton(
//                                               style: OutlinedButton.styleFrom(
//                                                 backgroundColor: Color.fromARGB(
//                                                     255, 1, 78, 141),
//                                               ),
//                                               onPressed: () {
//                                                 Navigator.of(context).push(
//                                                   MaterialPageRoute(
//                                                     builder: (BuildContext
//                                                             context) =>
//                                                         UsePaypal(
//                                                             sandboxMode: true,
//                                                             clientId: Constants
//                                                                 .clientId,
//                                                             secretKey: Constants
//                                                                 .secretKey,
//                                                             returnURL: Constants
//                                                                 .returnURL,
//                                                             cancelURL: Constants
//                                                                 .cancelURL,
//                                                             transactions: [
//                                                               {
//                                                                 "amount": {
//                                                                   "total":
//                                                                       _schedule
//                                                                           .price,

//                                                                   // "total": '',
//                                                                   "currency":
//                                                                       "USD",
//                                                                 },
//                                                                 "description":
//                                                                     "The payment transaction description.",
//                                                               }
//                                                             ],
//                                                             note:
//                                                                 "Contact us for any questions on your order.",
//                                                             onSuccess: (Map
//                                                                 params) async {
//                                                               print(
//                                                                   "onSuccess: $params");
//                                                               UIHelper.showAlertDialog(
//                                                                   'Payment Successfully',
//                                                                   title:
//                                                                       'Success');
//                                                               bool success =
//                                                                   await ApiBooking
//                                                                       .updateStatusToUpcoming(
//                                                                           _schedule);

//                                                               if (success) {
//                                                                 print(
//                                                                     'Pay successfully.');

//                                                                 reloadPayAfterBookings();
//                                                                 // Hiển thị thông báo thành công
//                                                               } else {
//                                                                 // Xử lý khi cancel booking không thành công
//                                                                 print(
//                                                                     'Failed to Pay booking.');
//                                                               }
//                                                             },
//                                                             onError: (error) {
//                                                               print(
//                                                                   "onError: $error");
//                                                               UIHelper.showAlertDialog(
//                                                                   'Unable to completet the Payment',
//                                                                   title:
//                                                                       'Error');
//                                                             },
//                                                             onCancel: (params) {
//                                                               print(
//                                                                   'cancelled: $params');
//                                                               UIHelper.showAlertDialog(
//                                                                   'Payment Cannceled',
//                                                                   title:
//                                                                       'Cancel');
//                                                             }),
//                                                   ),
//                                                 );
//                                               },
//                                               child: Text(
//                                                 'Pay \$${_schedule.price!.round()}',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ));
//                         }))),
//           ]),
//     ));
//   }

//   Future<void> showCancelConfirmationDialog(
//       BuildContext context, Booking booking) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // Click ngoài không đóng hộp thoại
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Xác nhận hủy đặt hẹn'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Bạn có chắc chắn muốn hủy đặt hẹn này không?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Huỷ'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Đóng hộp thoại
//               },
//             ),
//             TextButton(
//               child: Text('Xác nhận'),
//               onPressed: () async {
//                 // Gọi hàm để hủy đặt hẹn
//                 bool success = await ApiBooking.updateStatusToCancel(booking);

//                 if (success) {
//                   // Xoá booking thành công, bạn có thể thực hiện các hành động cần thiết
//                   // (ví dụ: cập nhật UI, hiển thị thông báo, vv.)
//                   print('Booking canceled successfully.');
//                   sendCancelNotification(booking);

//                   reloadBookings();
//                   showDeleteSuccessSnackbar(
//                       context); // Hiển thị thông báo thành công
//                 } else {
//                   // Xử lý khi cancel booking không thành công
//                   print('Failed to cancel booking.');
//                 }
//                 Navigator.of(context).pop(); // Đóng hộp thoại
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Hàm để gửi thông báo khi bệnh nhân hủy lịch hẹn
//   void sendCancelNotification(Booking booking) async {
//     String title = 'Lịch hẹn đã bị hủy';
//     String body =
//         'Cuộc hẹn vào ngày ${booking.appointmentDate} lúc ${booking.appointmentTime} đã bị hủy.';

//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: booking.id.hashCode,
//         channelKey: 'key_channel_booking',
//         title: title,
//         body: body,
//       ),
//     );
//   }

//   void showDeleteSuccessSnackbar(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Đã hủy đặt hẹn thành công!'),
//         duration: Duration(seconds: 2), // Thời gian hiển thị của snackbar
//       ),
//     );
//   }

//   void showPaySuccessSnackbar(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Đã Thanh toán thành công!'),
//         duration: Duration(seconds: 3), // Thời gian hiển thị của snackbar
//       ),
//     );
//   }
// }

// class ScheduleCard extends StatelessWidget {
//   final Booking booking;
//   const ScheduleCard({Key? key, required this.booking}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
//       width: double.infinity,
//       padding: const EdgeInsets.all(10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Icon(
//             Icons.access_alarm,
//             color: Color.fromARGB(255, 1, 78, 141),
//             size: 20,
//           ),
//           Flexible(
//               child: Text(
//             booking.appointmentTime,
//             style: TextStyle(
//               color: Color.fromARGB(255, 1, 78, 141),
//             ),
//           )),
//           SizedBox(
//             width: 40,
//           ),
//           Icon(
//             Icons.calendar_today,
//             color: Color.fromARGB(255, 1, 78, 141),
//             size: 15,
//           ),
//           Text(
//             booking.appointmentDate,
//             style: TextStyle(color: Color.fromARGB(255, 1, 78, 141)),
//           ),
//         ],
//       ),
//     );
//   }
// }
// /////

