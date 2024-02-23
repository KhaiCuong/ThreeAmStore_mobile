import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../app/constants/app.assets.dart';
import '../../../../app/routes/api.routes.dart';
import '../../../../core/models/auction_watch.dart';
import '../../../../core/models/bid_auction.dart';
import '../../../../core/notifiers/authentication.notifer.dart';
import '../../../../core/notifiers/theme.notifier.dart';
import '../../../../core/utils/snackbar.util.dart';

class AuctionBiddingPage extends StatefulWidget {
  const AuctionBiddingPage({Key? key, required this.auctionDetailsPageArgs})
      : super(key: key);

  final AuctionBiddingPageArgs auctionDetailsPageArgs;

  @override
  _AuctionBiddingPageState createState() => _AuctionBiddingPageState();
}

class _AuctionBiddingPageState extends State<AuctionBiddingPage> {
  late String highestBid = '0'; // Giá cao nhất khởi tạo mặc định
  List<Bid> bidHistory = []; // Lịch sử bids
  late DateTime endTime;
  late Timer timer;
  
  late Bid highestBidBid = Bid(bidId: 0, pidPrice: 0.0, autionId: 3, userId: 1);

  @override
  void initState() {
    super.initState();
    // Bắt đầu timer khi widget được khởi tạo
    var watch = widget.auctionDetailsPageArgs.auction;
    endTime = watch.startTime.add(Duration(hours: 1));
    // Thời gian kết thúc đấu giá
    _fetchAuctionsBids();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      fetchHighestBid();
    });
    fetchBidHistory(); // Lấy lịch sử bids ban đầu
  }

  @override
  void dispose() {
    // Hủy timer khi widget bị hủy
    timer.cancel();
    super.dispose();
  }

  Future<void> _fetchAuctionsBids() async {
    try {
      final dio = Dio();
      final response = await dio.get(ApiRoutes.baseurl + '/api/bid/getlist');
      // print(
      // ">>>>>>>>>>>>>>>>>>>>>>>>>>_fetchAuctionsBids response.data: ${response.data}");
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>_fetchAuctionsBids response.statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData != null && responseData['data'] is List<dynamic>) {
          List<Bid> auctionList = (responseData['data'] as List<dynamic>)
              .map((json) => Bid.fromJson(json))
              .where((bid) =>
                  bid.autionId ==
                  widget.auctionDetailsPageArgs.auction.autionId) // Lọc các bid với auctionId = 3
              .toList();
          print(
              ">>>>>>>>>>>>>>>>>>>>>>>>>>_fetchAuctionsBids: ${auctionList.length}");

          setState(() {
            bidHistory = auctionList;

            // Tìm bid có giá cao nhất từ danh sách bid mới
            double maxBidPrice = 0.0;
            Bid maxBid = Bid(bidId: 0, pidPrice: 0.0, autionId: 3, userId: 1);
            for (var bid in auctionList) {
              if (bid.pidPrice! > maxBidPrice) {
                maxBidPrice = bid.pidPrice!;
                maxBid = bid;
              }
            }
            highestBidBid = maxBid;
            highestBid = maxBidPrice.toString();
          });
          //
        } else {
          // Trường hợp không có dữ liệu
          setState(() {
            bidHistory = [];
          });
        }
      } else {
        // Trường hợp response code không phải 200
        setState(() {
          bidHistory = [];
        });
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
        text: 'Oops No You Need A Good Internet Connection',
        context: context,
      ));
      setState(() {
        bidHistory = [];
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        bidHistory = [];
      });
    }
  }

  // Hàm gọi API để lấy giá cao nhất
  Future<void> fetchHighestBid() async {

    _fetchAuctionsBids();

    // Giả lập dữ liệu
    setState(() {
      // highestBid = '6000';
      endTime = endTime.subtract(Duration(seconds: 1)); // Giả lập dữ liệu mới
    });
  }

  // Hàm giả lập lịch sử bids
  void fetchBidHistory() {
    _fetchAuctionsBids();

    setState(() {
      // bidHistory = tempBids;
    });
  }

  @override
  Widget build(BuildContext context) {
    var watch = widget.auctionDetailsPageArgs.auction;
    final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    var _userId = authNotifier.auth.id!;
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Auction Bidding'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: themeFlag
                      ? Image.asset(AppAssets.diamondWhite)
                      : Image.asset(AppAssets.diamondBlack),
                ),
                InteractiveViewer(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: watch.autionProductEntity.image != null &&
                            watch.autionProductEntity.image!.isNotEmpty
                        ? Image.network(
                            "$domain/${watch.autionProductEntity.image!}",
                            alignment: Alignment.center)
                        : Container(),
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),

            Row(
              children: [
                Text(
                  'Start Price: \$${widget.auctionDetailsPageArgs.auction.autionProductEntity.price}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 20),
                Text(
                  'Highest Price: $highestBid',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            // Hiển thị thời gian còn lại
            Text(
              'Time to Bid: ${_formatTimeLeft(endTime)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // Kiểm tra điều kiện để hiển thị nút Place Bid hoặc Time out to Bid
            if (DateTime.now()
                .isBefore(endTime)) // Kiểm tra nếu vẫn còn thời gian
              ElevatedButton(
                onPressed: () {
                _showBidDialog(context, "Bidding", watch.autionId, _userId, 100, double.parse(highestBid));

                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Place Bid'),
                ),
              ),
            if (DateTime.now()
                .isAfter(endTime)) // Kiểm tra nếu đã hết thời gian
              ElevatedButton(
                onPressed: null, // Vô hiệu hóa nút khi đã hết thời gian
                style: ElevatedButton.styleFrom(
                  primary:
                      Colors.grey, // Màu xám để biểu thị nút đã bị vô hiệu hóa
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                      'Not Time to Bid'), // Hiển thị thông báo đã hết thời gian
                ),
              ),
            SizedBox(height: 20),
            Text(
              'Curent Bid: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: bidHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Bidder: ${bidHistory[index].userId!}'),
                    subtitle: Text('Bid: ${bidHistory[index].pidPrice!}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeLeft(DateTime startTime) {
    DateTime endTime = startTime;
    Duration difference = endTime.difference(DateTime.now());

    if (difference.inSeconds < 0) {
      return 'Time out';
    } else if (difference.inHours > 1) {
      return 'Please Waite';
    } else {
      String hours = difference.inHours.toString().padLeft(2, '0');
      String minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
      String seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    }
  }
}

class AuctionBiddingPageArgs {
  final AuctionWatch auction;
  const AuctionBiddingPageArgs({required this.auction});
}

void _showBidDialog(BuildContext context, String field, int autionId, int userId, double pidPice, double highestBid) async {

  TextEditingController _textEditingController = TextEditingController();

  Future addBidToApiCart(
      {required double pidPice,
      required int autionId,
      required int userId}) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(ApiRoutes.baseurl + '/api/bid/addnew'));
    request.body = json
        .encode({"pidPice": pidPice, "autionId": autionId, "userId": userId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      // print(await response.stream.bytesToString());
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          context: context, text: 'Bid SuccessFully'));
    } else {
      // print(response.reasonPhrase);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackUtil.stylishSnackBar(context: context, text: 'Bid fail'));
    }
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>> ADD Bid APi response.statusCode : ${response.statusCode}");
    // print(
    // ">>>>>>>>>>>>>>>>>>>>>>>>>> ADD Bid APi response.body : ${response.}");
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Place Bid"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              TextFormField(
                controller: _textEditingController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Enter Price > $highestBid:",
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
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
         ElevatedButton(
  onPressed: () {
    String newBid = _textEditingController.text;
    double intBid = double.parse(newBid);

    // Kiểm tra nếu giá bid mới nhỏ hơn hoặc bằng giá cao nhất
    if (intBid <= highestBid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Your bid must be higher than the current highest bid.'),
      ));
    } else {
      // Xử lý logic đặt bid ở đây
      addBidToApiCart(
          autionId: autionId, pidPice: intBid, userId: userId);
      Navigator.pop(context);
    }
  },
  child: Text("Bid"),
),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      );
    },
  );
}
