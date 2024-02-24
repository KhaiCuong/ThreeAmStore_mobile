class Category {
  String? createdAt;
  String? modifiedAt;
  String? deletedAt;
  String categoryId;
  String categoryName;
  String description;
  bool status;

  Category({
    this.createdAt,
    this.modifiedAt,
    this.deletedAt,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      createdAt: json['createdAt']??'',
      modifiedAt: json['modifiedAt']??'',
      deletedAt: json['deletedAt']??'',
      categoryId: json['categoryId'],
      categoryName: json['category_name'],
      description: json['description'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['modifiedAt'] = this.modifiedAt;
    data['deletedAt'] = this.deletedAt;
    data['categoryId'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}
