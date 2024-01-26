import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class ProductImageSlider extends StatefulWidget {
  final List<String> imageList;
  final String domain;
  ProductImageSlider({required this.imageList, required this.domain});

  @override
  _ProductImageSliderState createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  int _currentIndex = 0;
@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.3,
            viewportFraction: 0.6,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.imageList.isNotEmpty
              ? widget.imageList.map<Widget>((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.network(
                        "${widget.domain}/$image",
                        alignment: Alignment.center,
                        fit: BoxFit.cover, // Cắt ảnh để lấp đầy không gian
                        width: 600, // Cố định chiều rộng
                        height: 600, // Cố định chiều cao
                      );
                    },
                  );
                }).toList()
              : [Container()],
        ),
        SizedBox(height: 10.0),
        DotsIndicator(
          dotsCount: widget.imageList.length,
          position: _currentIndex.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(8.0),
            activeSize: const Size(20.0, 8.0),
            color: Colors.grey,
            activeColor: Colors.blue, // Chỉnh màu cho indicator active
          ),
        ),
      ],
    );
  }
}
