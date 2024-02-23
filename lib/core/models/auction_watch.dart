// import 'package:flutter/material.dart';

// class AuctionWatch {
//   final DateTime? AuCreatedAt;
//   final DateTime? AuModifiedAt;
//   final DateTime? AuDeletedAt;
//   final int auctionId;
//   final String? name;
//   final double? lastBidPrice;
//   final String? image;
//   final DateTime startTime;
//   final DateTime endTime;
//   final String productId;
//   final bool autionStatus;
//   final int instock;
//   final int price;
//   final String? gender;
//   final int? faceSize;
//   final String? material;
//   final int? totalBuy;
//   final String? description;

//   AuctionWatch({
//     required this.AuCreatedAt,
//     required this.AuModifiedAt,
//     required this.AuDeletedAt,
//     required this.auctionId,
//     this.name,
//     this.lastBidPrice,
//     this.image,
//     required this.startTime,
//     required this.endTime,
//     required this.productId,
//     required this.autionStatus,
//     required this.instock,
//     required this.price,
//     this.gender,
//     this.faceSize,
//     this.material,
//     this.totalBuy,
//     this.description,
//   });

//   // Phương thức cập nhật từ JSON
//   // AuctionWatch updateFromProductJson(Map<String, dynamic> json) {
//   //   return AuctionWatch(
//   //     AuCreatedAt: this.AuCreatedAt,
//   //     AuModifiedAt: this.AuModifiedAt,
//   //     AuDeletedAt: this.AuDeletedAt,
//   //     auctionId: this.auctionId,
//   //     name: json['produc_name'] ?? this.name,
//   //     lastBidPrice: this.lastBidPrice,
//   //     image: json['image'] ?? this.image,
//   //     startTime: this.startTime,
//   //     endTime: this.endTime,
//   //     productId: this.productId,
//   //     autionStatus: this.autionStatus,
//   //     instock: json['instock'] ?? this.instock,
//   //     price: json['price'] ?? this.price,
//   //     gender: json['gender'] ?? this.gender,
//   //     faceSize: json['diameter'] ?? this.faceSize,
//   //     material: json['material'] ?? this.material,
//   //     totalBuy: json['totalBuy'] ?? this.totalBuy,
//   //     description: json['description'] ?? this.description,
//   //   );
//   // }

//   factory AuctionWatch.fromJsonAuction(Map<String, dynamic> json) {
//     return AuctionWatch(
//       AuCreatedAt: DateTime.parse(json['createdAt']),
//       AuModifiedAt: json['modifiedAt'] != null
//           ? DateTime.parse(json['modifiedAt'])
//           : null,
//       AuDeletedAt:
//           json['modifiedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
//       auctionId: json['auctionId'] != null ? json['auctionId'] : 0,
//       name: json['name'] ?? 'hhhhh',
//       lastBidPrice:
//           json['lastBidPrice'] != null ? json['lastBidPrice'].toDouble() : null,
//       image: json['image'] ?? 'hhh',
//       startTime: DateTime.parse(json['startTime']),
//       endTime: DateTime.parse(json['endTime']),
//       productId: json['productId'],
//       price:  0,
//       gender: '',
//       faceSize:  0,
//       material: '',
//       description: '',
//       autionStatus: json['status'] ?? true,
//       instock: 999,
//     );
//   }
// }
import 'package:flutter/material.dart';
class Auction {
  final String name;
  final String image;
  final String startTime;
  final String year;
  final String startPrice;
  final int biddingCount;
  final String gender;
  final String faceSize;
  final String material;
  final String weight;
  final String brand;
  final String description;

  Auction({
    required this.name,
    required this.image,
    required this.startTime,
    required this.year,
    required this.startPrice,
    required this.biddingCount,
    required this.gender,
    required this.faceSize,
    required this.material,
    required this.weight,
    required this.brand,
    required this.description,
  });
}


class AuctionWatch {
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final DateTime? deletedAt;
  final int autionId;
  final String? name;
  final bool status;
  final double? lastBidPrice;
  final String? image;
  final DateTime startTime;
  final DateTime endTime;
  final AutionProductEntity autionProductEntity;
  // final List<BidEntity> bidEntities;

  AuctionWatch({
    required this.createdAt,
    required this.modifiedAt,
    required this.deletedAt,
    required this.autionId,
    required this.name,
    required this.status,
    required this.lastBidPrice,
    required this.image,
    required this.startTime,
    required this.endTime,
    required this.autionProductEntity,
    // required this.bidEntities,
  });

  factory AuctionWatch.fromJson(Map<String, dynamic> json) {
    return AuctionWatch(
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: json['modifiedAt'] != null
          ? DateTime.parse(json['modifiedAt'])
          : null,
      deletedAt:json['modifiedAt'] != null? DateTime.parse(json['deletedAt']):null,
      autionId: json['autionId'],
      name: json['name'] ?? 'hhhhh',
      status: json['status'],
      lastBidPrice: json['lastBidPrice']??0,
      image: json['image']??'hhh',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      autionProductEntity: AutionProductEntity.fromJson(json['autionProductEntity']),
      // bidEntities: List<BidEntity>.from(json['bidEntities'].map((x) => BidEntity.fromJson(x))),
    );
  }
}

class AutionProductEntity {
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final DateTime? deletedAt;
  final String productId;
  final String producName;
  final int instock;
  final double price;
  final String description;
  final double diameter;
  final bool isWaterproof;
  final String gender;
  final String image;
  final int totalBuy;
  // final List<ProductImageEntity> productImageEntities;
  // final List<OrderDetailEntity> orderDetailEntities;
  // final List<FeedbackEntity> feedbackEntities;
  final bool status;

  AutionProductEntity({
    required this.createdAt,
    required this.modifiedAt,
    required this.deletedAt,
    required this.productId,
    required this.producName,
    required this.instock,
    required this.price,
    required this.description,
    required this.diameter,
    required this.isWaterproof,
    required this.gender,
    required this.image,
    required this.totalBuy,
    // required this.productImageEntities,
    // required this.orderDetailEntities,
    // required this.feedbackEntities,
    required this.status,
  });

  factory AutionProductEntity.fromJson(Map<String, dynamic> json) {
    return AutionProductEntity(
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: json['modifiedAt'] != null
          ? DateTime.parse(json['modifiedAt'])
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      productId: json['productId'],
      producName: json['produc_name'],
      instock: json['instock'],
      price: json['price'],
      description: json['description'],
      diameter: json['diameter'],
      isWaterproof: json['isWaterproof'],
      gender: json['gender'],
      image: json['image'],
      totalBuy: json['totalBuy'],
      // productImageEntities: List<ProductImageEntity>.from(json['productImageEntities'].map((x) => ProductImageEntity.fromJson(x))),
      // orderDetailEntities: List<OrderDetailEntity>.from(json['orderDetailEntities'].map((x) => OrderDetailEntity.fromJson(x))),
      // feedbackEntities: List<FeedbackEntity>.from(json['feedbackEntities'].map((x) => FeedbackEntity.fromJson(x))),
      status: json['status'],
    );
  }
}

class ProductImageEntity {
  final int imageId;
  final String imageUrl;

  ProductImageEntity({
    required this.imageId,
    required this.imageUrl,
  });

  factory ProductImageEntity.fromJson(Map<String, dynamic> json) {
    return ProductImageEntity(
      imageId: json['imageId'],
      imageUrl: json['image_url'],
    );
  }
}

class OrderDetailEntity {
  final int detailId;
  final int quantity;
  final double price;
  final String producName;
  final String image;
  final bool? canFeedBack;

  OrderDetailEntity({
    required this.detailId,
    required this.quantity,
    required this.price,
    required this.producName,
    required this.image,
    required this.canFeedBack,
  });

  factory OrderDetailEntity.fromJson(Map<String, dynamic> json) {
    return OrderDetailEntity(
      detailId: json['detailId'],
      quantity: json['quantity'],
      price: json['price'],
      producName: json['produc_name'],
      image: json['image'],
      canFeedBack: json['canFeedBack'],
    );
  }
}

class FeedbackEntity {
  final DateTime createdAt;
  final DateTime modifiedAt;
  final DateTime? deletedAt;
  final int id;
  final String title;
  final String content;
  final int start;

  FeedbackEntity({
    required this.createdAt,
    required this.modifiedAt,
    required this.deletedAt,
    required this.id,
    required this.title,
    required this.content,
    required this.start,
  });

  factory FeedbackEntity.fromJson(Map<String, dynamic> json) {
    return FeedbackEntity(
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      id: json['id'],
      title: json['title'],
      content: json['content'],
      start: json['start'],
    );
  }
}

class BidEntity {
  final String createdAt;
  final String modifiedAt;
  final String deletedAt;
  final int id;
  final double price;
  final String userId;
  final int autionId;

  BidEntity({
    required this.createdAt,
    required this.modifiedAt,
    required this.deletedAt,
    required this.id,
    required this.price,
    required this.userId,
    required this.autionId,
  });

  factory BidEntity.fromJson(Map<String, dynamic> json) {
    return BidEntity(
      createdAt: json['createdAt'],
      modifiedAt: json['modifiedAt'],
      deletedAt: json['deletedAt'],
      id: json['id'],
      price: json['price'],
      userId: json['userId'],
      autionId: json['autionId'],
    );
  }
}

