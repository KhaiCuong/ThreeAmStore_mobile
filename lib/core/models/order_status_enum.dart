enum OrderStatus {
  Preparing,
  Completed,
  Delivery,
  Canceled,
}

extension OrderStatusExtension on OrderStatus {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
