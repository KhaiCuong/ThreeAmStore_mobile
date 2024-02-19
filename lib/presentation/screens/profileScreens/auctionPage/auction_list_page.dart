import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scarvs/presentation/screens/profileScreens/auctionPage/auction_detail_page.dart';

import '../../../../app/routes/api.routes.dart';
import '../../../../app/routes/app.routes.dart';
import '../../../../core/models/auction_watch.dart';

class AuctionPage extends StatefulWidget {
  @override
  _AuctionPageState createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  List<AuctionWatch> auctionedWatches = [
    AuctionWatch(
      name: 'Rolex Submariner',
      image: 'uploads/4160a8da-1665-421c-b035-47304146a665hublot.png',
      startTime: '2024-02-20 00:30',
      year: '1996',
      startPrice: '2000',
      biddingCount: 10,
      gender: 'Male',
      faceSize: '42mm',
      material: 'Stainless Steel',
      weight: '150g',
      brand: 'Rolex',
      description: 'Classic chronograph watch with moonphase',
    ),
    AuctionWatch(
      name: 'Omega Speedmaster',
      image: 'uploads/4160a8da-1665-421c-b035-47304146a665hublot.png',
      startTime: '2024-02-16 23:30',
      year: '1995',
      startPrice: '2001',
      biddingCount: 12,
      gender: 'Male',
      faceSize: '38mm',
      material: 'Titanium',
      weight: '120g',
      brand: 'Omega',
      description: 'Iconic square-shaped chronograph watch',
    ),
    AuctionWatch(
      name: 'Tag Heuer Carrera',
      image: 'uploads/4160a8da-1665-421c-b035-47304146a665hublot.png',
      startTime: '2024-02-15 23:00',
      year: '1986',
      startPrice: '2002',
      biddingCount: 8,
      gender: 'Male',
      faceSize: '40mm',
      material: 'Carbon Fiber',
      weight: '130g',
      brand: 'Tag Heuer',
      description: 'Iconic square-shaped chronograph watch',
    ),
  ];

  List<AuctionWatch> get _upcomingAuctions {
    // Lấy thời gian hiện tại
    DateTime now = DateTime.now();

    // Lọc danh sách để chỉ lấy những đồng hồ với thời gian bắt đầu đấu giá trong tương lai
    List<AuctionWatch> upcomingAuctions = auctionedWatches.where((watch) {
      DateTime startTime =
          DateFormat('yyyy-MM-dd HH:mm').parse(watch.startTime);
      return startTime.isAfter(now);
    }).toList();

    return upcomingAuctions;
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
                    text:
                        'The auction takes place within 1 hour.\n',
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
              'Current Auctions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: auctionedWatches.length,
              itemBuilder: (context, index) {
                return _buildAuctionCard(auctionedWatches[index]);
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
                  child: watch.image != null && watch.image.isNotEmpty
                      ? Image.network(
                          '$domain/${watch.image}',
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
                    watch.name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: Text(
                 'Start from: \$ ${watch.startPrice}',
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
                      ': ${watch.startTime}',
                      style: TextStyle(fontSize: 12),
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
                            '$domain/${watch.image}',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          watch.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              'Start from: \$ ${watch.startPrice}',
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
                  ': ${watch.startTime}',
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
