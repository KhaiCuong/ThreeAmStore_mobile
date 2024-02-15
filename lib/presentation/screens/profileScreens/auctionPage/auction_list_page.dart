import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// class AuctionPage extends StatelessWidget {
  
// // Sample data for auctioned watches (JSON format)
// List<Map<String, dynamic>> auctionedWatches = [
//   {
//     'name': 'Rolex Submariner',
//     'description': 'Iconic dive watch with ceramic bezel',
//     'startingPrice': 5000,
//     'endTime': '2024-02-01 18:00:00',
//     'image': 'assets/rolex_submariner.jpg',
//   },
//   {
//     'name': 'Omega Speedmaster',
//     'description': 'Classic chronograph watch with moonphase',
//     'startingPrice': 4000,
//     'endTime': '2024-02-02 20:00:00',
//     'image': 'assets/omega_speedmaster.jpg',
//   },
//   {
//     'name': 'Tag Heuer Monaco',
//     'description': 'Iconic square-shaped chronograph watch',
//     'startingPrice': 4500,
//     'endTime': '2024-02-03 22:00:00',
//     'image': 'assets/tag_heuer_monaco.jpg',
//   },
// ];

//   List<Map<String, dynamic>> _upcomingAuctions(List<Map<String, dynamic>> watches) {
//   // Lấy thời gian hiện tại
//   DateTime now = DateTime.now();

//   // Lọc danh sách để chỉ lấy những đồng hồ với thời gian bắt đầu đấu giá trong tương lai
//   List<Map<String, dynamic>> upcomingAuctions = watches.where((watch) {
//     DateTime startTime = DateFormat('yyyy-MM-dd HH:mm').parse(watch['startTime']);
//     return startTime.isAfter(now);
//   }).toList();

//   return upcomingAuctions;
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Auction Page'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Auction Rules:',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vehicula nulla eget augue pulvinar, ut posuere nulla commodo. Aenean rhoncus felis eget tellus egestas, in sodales mauris ultricies. Integer feugiat, nulla vel tristique consectetur, turpis dui interdum magna, nec scelerisque sapien dui nec enim.',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Auctioned Watches:',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: auctionedWatches.length,
//               itemBuilder: (context, index) {
//                 return _buildAuctionedWatchCard(auctionedWatches[index]);
//               },
//             ),
//              SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Upcoming Auctions:',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: upcomingAuctions.length,
//               itemBuilder: (context, index) {
//                 return _upcomingAuctions(auctionedWatches[index]);
//               },
//             ),

            
//           ],
//         ),
//       ),
//     );
//   }
// Widget _buildAuctionedWatchCard(Map<String, dynamic> watch) {
//   // Lấy thời gian hiện tại
//   DateTime now = DateTime.now();
//   // Chuyển đổi thời gian kết thúc đấu giá từ String sang DateTime
//   DateTime endTime = DateFormat('yyyy-MM-dd HH:mm').parse(watch['endTime']);

//   // Xác định xem đồng hồ có đang diễn ra đấu giá hay không
//   bool isAuctionInProgress = endTime.isAfter(now);

//   return Card(
//     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     elevation: 4,
//     child: ListTile(
//       contentPadding: EdgeInsets.all(16),
//       leading: Container(
//         width: 80,
//         height: 80,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: isAuctionInProgress ? Colors.green.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
//               spreadRadius: 3,
//               blurRadius: 7,
//               offset: Offset(0, 3), // changes position of shadow
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: Image.asset(
//             watch['image'],
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//       title: Text(
//         watch['name'],
//         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
          // SizedBox(height: 5),
          // Text(
          //   'Năm sản xuất: ${watch['year']}',
          //   style: TextStyle(fontSize: 16),
          // ),
//           SizedBox(height: 5),
//           Text(
//             'Starting Price: \$${watch['startingPrice']}',
//             style: TextStyle(fontSize: 16),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'End Time: ${watch['endTime']}',
//             style: TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//       onTap: () {
//         // Handle tap on watch item
//       },
//     ),
//   );
// }


// Widget _buildUpcomingAuctionCard(Map<String, dynamic> watch) {
//   return Card(
//     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     elevation: 4,
//     child: ListTile(
//       contentPadding: EdgeInsets.all(16),
//       leading: Container(
//         width: 80,
//         height: 80,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blue.withOpacity(0.5),
//               spreadRadius: 3,
//               blurRadius: 7,
//               offset: Offset(0, 3), // changes position of shadow
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: Image.asset(
//             watch['image'],
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//       title: Text(
//         watch['name'],
//         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 5),
//           Text(
//             'Starting Time: ${watch['startTime']}',
//             style: TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//       onTap: () {
//         // Handle tap on upcoming auction item
//       },
//     ),
//   );
// }

class AuctionPage extends StatefulWidget {
  @override
  _AuctionPageState createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  List<Map<String, dynamic>> watches = [
    {
      'name': 'Rolex Submariner',
      'image': 'assets/rolex_submariner.jpg',
      'startTime': '2024-02-05 10:00',
      'year':'1996'

    },
    {
      'name': 'Omega Speedmaster',
      'image': 'assets/omega_speedmaster.jpg',
      'startTime': '2024-02-15 23:30',
      'year':'1996'

    },
    {
      'name': 'Tag Heuer Carrera',
      'image': 'assets/tag_heuer_carrera.jpg',
      'startTime': '2024-02-15 23:00',
      'year':'1996'

    },
  ];

  List<Map<String, dynamic>> get _upcomingAuctions {
    // Lấy thời gian hiện tại
    DateTime now = DateTime.now();

    // Lọc danh sách để chỉ lấy những đồng hồ với thời gian bắt đầu đấu giá trong tương lai
    List<Map<String, dynamic>> upcomingAuctions = watches.where((watch) {
      DateTime startTime = DateFormat('yyyy-MM-dd HH:mm').parse(watch['startTime']);
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
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vehicula nulla eget augue pulvinar, ut posuere nulla commodo. Aenean rhoncus felis eget tellus egestas, in sodales mauris ultricies. Integer feugiat, nulla vel tristique consectetur, turpis dui interdum magna, nec scelerisque sapien dui nec enim.',
                style: TextStyle(fontSize: 16),
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
              itemCount: watches.length,
              itemBuilder: (context, index) {
                return _buildAuctionCard(watches[index]);
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

  Widget _buildAuctionCard(Map<String, dynamic> watch) {
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              child: Image.asset(
                watch['image'],
                fit: BoxFit.cover,
                height: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                watch['name'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                watch['year'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Starting Time: ${watch['startTime']}',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAuctionCard(Map<String, dynamic> watch) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 80,
          height: 80,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              watch['image'],
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          watch['name'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: 5),
          Text(
            'Năm sản xuất: ${watch['year']}',
            style: TextStyle(fontSize: 16),
          ),
            SizedBox(height: 5),
            Text(
              'Starting Time: ${watch['startTime']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        onTap: () {
          // Handle tap on upcoming auction item
        },
      ),
    );
  }
}

