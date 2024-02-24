import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../app/constants/app.assets.dart';
import '../../../../app/routes/api.routes.dart';
import '../../../../core/models/auction_watch.dart';
import '../../../../core/models/bid_auction.dart';
import '../../../../core/notifiers/authentication.notifer.dart';
import '../../../../core/notifiers/cart.notifier.dart';
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
  bool isAutoAddToCart = false;
  late Bid highestBidBid = Bid(bidId: 0, pidPrice: 0.0, autionId: 3, userId: 1,userName: "demo");
  bool isWinnerAddedToCart = false;
  @override
  void initState() {
    super.initState();
    // Bắt đầu timer khi widget được khởi tạo
    var watch = widget.auctionDetailsPageArgs.auction;
    endTime = watch.startTime.add(Duration(hours: 1));
 
    _fetchAuctionsBids();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      fetchHighestBid();
    });

    // kiểm tra mới vào nếu hết thời gian rồi thì không cho tự động thêm vào cart nữa
    if (endTime.isBefore(DateTime.now())) {
      isWinnerAddedToCart = true;
    }
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
                  widget.auctionDetailsPageArgs.auction
                      .autionId) // Lọc các bid với auctionId = 3
              .toList();
          print(
              ">>>>>>>>>>>>>>>>>>>>>>>>>>_fetchAuctionsBids: ${auctionList.length}");

          setState(() {
            bidHistory = auctionList;

            // Tìm bid có giá cao nhất từ danh sách bid mới
            double maxBidPrice = 0.0;
            Bid maxBid = Bid(bidId: 0, pidPrice: 0.0, autionId: 3, userId: 1,userName: "hoang");
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
          // setState(() {
            bidHistory = [];
          // });
        }
      } else {
        // Trường hợp response code không phải 200
        // setState(() {
          bidHistory = [];
        // });
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
        text: 'Oops No You Need A Good Internet Connection',
        context: context,
      ));
      // setState(() {
        bidHistory = [];
      // });
    } catch (e) {
      print("Error: $e");
      // setState(() {
        bidHistory = [];
      // });
    }
  }

  Future<void> addToCart(Bid bid) async {
    try {
      // Kiểm tra nếu người đặt giá cao nhất không trùng với userId hiện tại
      final authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      final currentUserID = authNotifier.auth.id!;
      if (bid.userId == currentUserID) {
        // Thực hiện thêm vào giỏ hàng
        // var box = await Hive.openBox('cart'); // Mở hoặc tạo mới giỏ hàng
        // box.add(bid); // Thêm bid vào giỏ hàng
        CartNotifier cartNotifier = CartNotifier();

        final authNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        var _userId = authNotifier.auth.id != null
            ? int.parse(authNotifier.auth.id.toString())
            : 1;
        var _username = authNotifier.auth.username ?? 'Wait';
        var _userEmail = authNotifier.auth.useremail ?? 'exam@gmail.com';
        var _userPhone = authNotifier.auth.userphoneNo ?? '0909090909';
        var _userAddress = authNotifier.auth.useraddress ?? 'Tran Van Dand';
        cartNotifier.addToHiveCart(
          userEmail: _userEmail,
          username: _username,
          address: _userAddress,
          phoneNumber: _userPhone,
          price: bid.pidPrice!,
          productName: widget
              .auctionDetailsPageArgs.auction.autionProductEntity.producName,
          productId: widget
              .auctionDetailsPageArgs.auction.autionProductEntity.productId,
          image:
              widget.auctionDetailsPageArgs.auction.autionProductEntity.image!,
          userId: _userId,
          quantity: 1,
          context: context,
          productSize: widget
              .auctionDetailsPageArgs.auction.autionProductEntity.diameter
              .toString(),
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You are winner bidder. Product has been added to CART .'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  // Hàm gọi API để lấy giá cao nhất
  Future<void> fetchHighestBid() async {
    _fetchAuctionsBids();

    // Giả lập dữ liệu
    setState(() {
      endTime = endTime.subtract(Duration(seconds: 1)); // Giả lập dữ liệu mới
      // highestBid = '6000';
    });

    // Kiểm tra xem đã hết thời gian chưa
    if (endTime.isBefore(DateTime.now())) {
      // Nếu đã hết thời gian và chưa thêm vào giỏ hàng, thêm người đặt giá cao nhất vào giỏ hàng

      if (isWinnerAddedToCart == false) {
        isAutoAddToCart = true;
        print(">>>>>>>>>>>>>>>>>>>>>>>endTime ${endTime}");
        await addToCart(highestBidBid);
        isWinnerAddedToCart =
            true; // Đặt biến cờ hiệu thành true để chỉ thêm vào giỏ hàng một lần
      }
    }
  }

  // Hàm giả lập lịch sử bids
  // void fetchBidHistory() {
  //   _fetchAuctionsBids();

  //   setState(() {
  //     // bidHistory = tempBids;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var watch = widget.auctionDetailsPageArgs.auction;
    final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    var _userId = authNotifier.auth.id!;
    var _userName = authNotifier.auth.username!;

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
             Text(
              'Time to Bid: ${_formatTimeLeft(endTime)}',
              style: TextStyle(fontSize: 18),
            ),
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
           
            SizedBox(height: 20),
            // Kiểm tra điều kiện để hiển thị nút Place Bid hoặc Time out to Bid
            if (DateTime.now()
                .isBefore(endTime)) // Kiểm tra nếu vẫn còn thời gian
              ElevatedButton(
                onPressed: () {
                  _showBidDialog(context, "Bidding", watch.autionId, _userId,
                      100, double.parse(highestBid), isAutoAddToCart,endTime,_userName);
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
                    title: Text('Bidder: ${bidHistory[index].userName!}'),
                    subtitle: Text('Bid: ${bidHistory[index].pidPrice!}'),
                    // trailing:Text('Bid: ${bidHistory[index].createdAt!}'),
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

void _showBidDialog(BuildContext context, String field, int autionId,
    int userId, double pidPice, double highestBid, bool isAutoAddToCart, DateTime endTime, String userName) async {
  TextEditingController _textEditingController = TextEditingController();

  Future addBidToApiCart(
      {required double pidPice,
      required int autionId,
      required int userId, required userName}) async {
        final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    // var userName = authNotifier.auth.username ?? 'Wait';
    var userName =
        authNotifier.auth.username;
print(">>>>>>>>>>>>>>>>>>>userName $userName");

    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(ApiRoutes.baseurl + '/api/bid/addnew'));
    request.body = json
        .encode({"pidPice": pidPice, "autionId": autionId, "userId": userId,"userName":userName});
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

  bool isAddedToCart = false;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
            
        title: Text("Place Bid:  "),
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
               if (DateTime.now().isBefore(endTime)) {
              String newBid = _textEditingController.text;
              double intBid = double.parse(newBid);

              // Kiểm tra nếu giá bid mới nhỏ hơn hoặc bằng giá cao nhất
              if (intBid <= highestBid) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Your bid must be higher than the current highest bid.'),
                ));
              } else {
                // Xử lý logic đặt bid ở đây
                addBidToApiCart(
                    autionId: autionId, pidPice: intBid, userId: userId,userName:userName);

                // Nếu là tự động thêm vào giỏ hàng, đặt cờ hiệu isAddedToCart thành true
                if (isAutoAddToCart) {
                  isAddedToCart = true;
                }

                Navigator.pop(context);
              }
               } else {
                // Hiển thị thông báo khi thời gian đã hết
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Bid failed. Time is up.'),
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
