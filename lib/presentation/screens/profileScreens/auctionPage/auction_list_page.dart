import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scarvs/core/models/product.model.dart';
import 'package:scarvs/presentation/screens/profileScreens/auctionPage/auction_detail_page.dart';

import '../../../../app/routes/api.routes.dart';
import '../../../../app/routes/app.routes.dart';
import '../../../../core/models/auction_watch.dart';
import '../../../../core/notifiers/product.notifier.dart';
import '../../../../core/utils/snackbar.util.dart';

class AuctionPage extends StatefulWidget {
  @override
  _AuctionPageState createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  ProductNotifier productNotifier = ProductNotifier();
  List<AuctionWatch> auctionedWatches = [];
  List<ProductData> products = [];
  void initState() {
    super.initState();
    _fetchAuctions(context: context);
  }

  Future<void> _fetchAuctions({required BuildContext context}) async {
    try {
      final dio = Dio();
      final response = await dio.get(ApiRoutes.baseurl + '/api/aution/getlist');

      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>fetchAuctions response.statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData != null && responseData['data'] is List<dynamic>) {
          List<AuctionWatch> auctionList =
              (responseData['data'] as List<dynamic>)
                  .map((json) => AuctionWatch.fromJson(json))
                  .toList();
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>AuctionList: ${auctionList.length}");

          setState(() {
            auctionedWatches = auctionList;
          });
          //
        } else {
          // Trường hợp không có dữ liệu
          setState(() {
            auctionedWatches = [];
          });
        }
      } else {
        // Trường hợp response code không phải 200
        setState(() {
          auctionedWatches = [];
        });
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
        text: 'Oops No You Need A Good Internet Connection',
        context: context,
      ));
      setState(() {
        auctionedWatches = [];
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        auctionedWatches = [];
      });
    }
  }

  List<AuctionWatch> get _upcomingAuctions {
    // Lấy thời gian hiện tại
    DateTime now = DateTime.now();

    // Lọc danh sách để chỉ lấy những đồng hồ với thời gian bắt đầu đấu giá trong tương lai
    List<AuctionWatch> upcomingAuctions = auctionedWatches.where((watch) {
      DateTime startTime = watch.startTime;
      return startTime.isAfter(now);
    }).toList();

    return upcomingAuctions;
  }

  List<AuctionWatch> get _currentAuctions {
    // Lấy thời gian hiện tại
    DateTime now = DateTime.now();

    // Lọc danh sách để chỉ lấy những đồng hồ với thời gian bắt đầu đấu giá trong khoảng thời gian từ startTime đến endTime
    List<AuctionWatch> currentAuctions = auctionedWatches.where((watch) {
      DateTime startTime = watch.startTime;
      DateTime endTime = startTime.add(Duration(
          hours: 1)); // Thời gian kết thúc là startTime cộng thêm 1 giờ

      // Chỉ lấy các phiên đấu giá đang diễn ra tại thời điểm hiện tại
      return startTime.isBefore(now) && now.isBefore(endTime);
    }).toList();

    return currentAuctions;
  }

  List<AuctionWatch> getPastAuctions() {
    // Lấy thời gian hiện tại
    DateTime now = DateTime.now();

    // Lọc danh sách để chỉ lấy những phiên đấu giá đã qua
    List<AuctionWatch> pastAuctions = auctionedWatches.where((watch) {
      DateTime startTime = watch.startTime;
      DateTime endTime = startTime.add(Duration(hours: 1));
      return endTime.isBefore(now); // Chỉ lấy những phiên đã qua
    }).toList();

    return pastAuctions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auction Page'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Auction Rules:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Fixed Bid Increment:\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'Each bidding increment must be at least a fixed amount.\n',
                  ),
                  TextSpan(
                    text: 'Auction Duration:\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'The auction takes place within 1 hour.\n',
                  ),
                  TextSpan(
                    text: 'Auction Success:\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'The highest bidder when the time expires wins the auction.\n',
                  ),
                  TextSpan(
                    text: 'Information Display:\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'Display information about the auctioned product including name, image, description, current price, and remaining time.\n',
                  ),
                  TextSpan(
                    text: 'User Authentication:\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'Only logged-in or registered users can participate in the auction.\n',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Ongoing Auctions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 200,
            child: _currentAuctions.isEmpty
                ? Center(
                    child: Text('Not yet'),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _currentAuctions.length,
                    itemBuilder: (context, index) {
                      return _buildAuctionCard(_currentAuctions[index]);
                    },
                  ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Upcoming Auctions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: _upcomingAuctions.map<Widget>((watch) {
              return _buildUpcomingAuctionCard(watch);
            }).toList(),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Finished Auctions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: getPastAuctions().map<Widget>((watch) {
              return _buildUpcomingAuctionCard(watch);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAuctionCard(AuctionWatch watch) {
    return GestureDetector(
      onTap: () {
        // chuyển hướng đến trang chi tiết
        Navigator.of(context).pushNamed(
          AppRouter.auctionDetailPage,
          arguments: AuctionDetailsPageArgs(auction: watch),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.39,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.width *
                      0.26, // Đặt chiều cao của SizedBox là chiều cao mong muốn của hình ảnh
                  width: double
                      .infinity, // Đặt chiều rộng của SizedBox là vô hạn để đảm bảo lấp đầy không gian
                  child: watch.autionProductEntity.image != null &&
                          watch.autionProductEntity.image!.isNotEmpty
                      ? Image.network(
                          '$domain/${watch.autionProductEntity.image}',
                          fit: BoxFit
                              .cover, // Đặt thuộc tính fit thành BoxFit.cover
                        )
                      : Container(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  height: 40,
                  child: Text(
                    watch.autionProductEntity.producName!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: Text(
                  'Start from: \$ ${watch.autionProductEntity.price!}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_alarm,
                      size: 16, // Kích thước của biểu tượng đồng hồ
                    ),
                    SizedBox(width: 5),
                    Text(
                      '${DateFormat('HH:mm  dd/MM/yyyy').format(watch.startTime!)}',
                      style: TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingAuctionCard(AuctionWatch watch) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(20, 4, 4, 4),
        leading: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: SizedBox(
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '$domain/${watch.autionProductEntity.image}',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          watch.autionProductEntity.producName!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              'Start from: \$ ${watch.autionProductEntity.price!}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  Icons.access_alarm,
                  size: 16, // Kích thước của biểu tượng đồng hồ
                ),
                SizedBox(width: 5),
                Text(
                  '${DateFormat('HH:mm  dd/MM/yyyy').format(watch.startTime!)}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRouter.auctionDetailPage,
            arguments: AuctionDetailsPageArgs(auction: watch),
          );
        },
      ),
    );
  }
}
