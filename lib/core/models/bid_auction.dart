class Bid {
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final DateTime? deletedAt;
  final int bidId;
  final double pidPrice;
  final int? autionId;
  final int? userId;
  final String? userName;

  Bid({
    this.createdAt,
    this.modifiedAt,
    this.deletedAt,
    required this.bidId,
    required this.pidPrice,
    required this.autionId,
    required this.userId,
    required this.userName,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      modifiedAt: json['modifiedAt'] != null ? DateTime.parse(json['modifiedAt']) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      bidId: json['bidId'],
      pidPrice: json['pidPice'].toDouble(),
      autionId: json['autionId']??3,
      userId: json['userId']??1,
      userName: json['userName']??'demo',
    );
  }
}
