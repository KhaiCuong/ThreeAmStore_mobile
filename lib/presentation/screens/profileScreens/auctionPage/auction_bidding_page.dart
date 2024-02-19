import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../app/constants/app.assets.dart';
import '../../../../app/routes/api.routes.dart';
import '../../../../core/models/auction_watch.dart';
import '../../../../core/notifiers/theme.notifier.dart';

class AuctionBiddingPage extends StatefulWidget {
  const AuctionBiddingPage({Key? key, required this.auctionDetailsPageArgs})
      : super(key: key);

  final AuctionBiddingPageArgs auctionDetailsPageArgs;

  @override
  _AuctionBiddingPageState createState() => _AuctionBiddingPageState();
}

class _AuctionBiddingPageState extends State<AuctionBiddingPage> {
  late String highestBid = '5000'; // Giá cao nhất khởi tạo mặc định
  List<Bid> bidHistory = []; // Lịch sử bids
  late DateTime endTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Bắt đầu timer khi widget được khởi tạo
    var watch = widget.auctionDetailsPageArgs.auction;
 endTime = DateTime.parse(watch.startTime).add(Duration(hours: 1));
 // Thời gian kết thúc đấu giá

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

  // Hàm gọi API để lấy giá cao nhất
  Future<void> fetchHighestBid() async {
    // Giả lập dữ liệu từ API, thay thế với dữ liệu thực tế
    // final response = await http.get(Uri.parse('your_api_url'));
    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body);
    //   setState(() {
    //     highestBid = data['highest_bid'].toString();
    //   });
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('Failed to fetch highest bid'),
    //   ));
    // }

    // Giả lập dữ liệu
    setState(() {
      highestBid = '6000'; 
      endTime = endTime.subtract(Duration(seconds: 1));// Giả lập dữ liệu mới
    });
  }

  // Hàm giả lập lịch sử bids
  void fetchBidHistory() {
    // Giả lập dữ liệu
    List<Bid> tempBids = [
      Bid(bidPrice: 5100, bidderName: 'User A'),
      Bid(bidPrice: 5500, bidderName: 'User B'),
      Bid(bidPrice: 5900, bidderName: 'User C'),
    ];

    setState(() {
      bidHistory = tempBids;
    });
  }

  @override
  Widget build(BuildContext context) {
    var watch = widget.auctionDetailsPageArgs.auction;
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
                    child: watch.image != null && watch.image!.isNotEmpty
                        ? Image.network("$domain/${watch.image!}",
                            alignment: Alignment.center)
                        : Container(),
                  ),
                ),
              ],
            ),
            // ClipRRect(
            //   borderRadius: const BorderRadius.only(
            //     topLeft: Radius.circular(10),
            //     topRight: Radius.circular(10),
            //   ),
            //   child: SizedBox(
            //     height: MediaQuery.of(context).size.height *
            //         0.35, // Đặt chiều cao của SizedBox là chiều cao mong muốn của hình ảnh
            //     width: double
            //         .infinity, // Đặt chiều rộng của SizedBox là vô hạn để đảm bảo lấp đầy không gian
            //     child: watch.image != null && watch.image!.isNotEmpty
            //         ? Image.network(
            //             "$domain/${watch.image!}",
            //             fit: BoxFit
            //                 .cover, // Đặt thuộc tính fit thành BoxFit.cover
            //           )
            //         : Container(),
            //   ),
            // ),
            SizedBox(height: 15),

            Row(
              children: [
                Text(
                  'Start Price: \$${widget.auctionDetailsPageArgs.auction.startPrice}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 20),
                Text(
                  'Highest Price: $highestBid',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            if (DateTime.now().isBefore(endTime)) // Kiểm tra nếu vẫn còn thời gian
              ElevatedButton(
                onPressed: () {
                  _showBidDialog(
                    context,
                    "Bidding",
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Place Bid'),
                ),
              ),
            if (DateTime.now().isAfter(endTime)) // Kiểm tra nếu đã hết thời gian
              ElevatedButton(
                onPressed: null, // Vô hiệu hóa nút khi đã hết thời gian
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey, // Màu xám để biểu thị nút đã bị vô hiệu hóa
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Not Time to Bid'), // Hiển thị thông báo đã hết thời gian
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
                    title: Text('Bid: ${bidHistory[index].bidPrice}'),
                    subtitle: Text('Bidder: ${bidHistory[index].bidderName}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
   // Hàm hiển thị thời gian còn lại dưới dạng giờ:phút:giây
  String _formatTimeLeft(DateTime endTime) {
    Duration difference = endTime.difference(DateTime.now());
    String hours = difference.inHours.toString().padLeft(2, '0');
    String minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class AuctionBiddingPageArgs {
  final AuctionWatch auction;
  const AuctionBiddingPageArgs({required this.auction});
}

class Bid {
  final int bidPrice;
  final String bidderName;

  Bid({required this.bidPrice, required this.bidderName});
}

 void _showBidDialog(BuildContext context, String field) async {
  TextEditingController _textEditingController = TextEditingController();

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
                  labelText: "Enter Price to Bid:",
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
              if (newBid.isNotEmpty) {
                // Xử lý logic đặt bid ở đây
                Navigator.pop(context);
              } else {
                // Hiển thị thông báo khi người dùng chưa nhập giá bid
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter a bid amount'),
                ));
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
