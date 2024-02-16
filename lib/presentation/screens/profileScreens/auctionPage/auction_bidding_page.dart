import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/models/auction_watch.dart';

class AuctionBiddingPage extends StatefulWidget {
  const AuctionBiddingPage({Key? key, required this.auctionDetailsPageArgs}) : super(key: key);

  final AuctionBiddingPageArgs auctionDetailsPageArgs;

  @override
  _AuctionBiddingPageState createState() => _AuctionBiddingPageState();
}

class _AuctionBiddingPageState extends State<AuctionBiddingPage> {
  late String highestBid = '5000'; // Giá cao nhất khởi tạo mặc định

  List<Bid> bidHistory = []; // Lịch sử bids

  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Bắt đầu timer khi widget được khởi tạo
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
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
      highestBid = '6000'; // Giả lập dữ liệu mới
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Auction Bidding'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Start Price: \$${widget.auctionDetailsPageArgs.auction.startPrice}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Highest Price: $highestBid',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi người dùng nhấn nút Đặt Bid
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Place Bid'),
              ),
            ),
            SizedBox(height: 20),
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
