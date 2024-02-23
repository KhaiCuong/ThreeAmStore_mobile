import 'package:hive/hive.dart';

part 'feedback_status.g.dart'; // Phần tử này làm việc với Hive TypeAdapter

@HiveType(typeId: 4) // TypeId của FeedbackStatus
class FeedbackStatus {
  @HiveField(0)
  late int orderDetailId; // Id của orderDetail

  @HiveField(1)
  late bool hasFeedback; // Trạng thái feedback của orderDetail

  FeedbackStatus({required this.orderDetailId, required this.hasFeedback});
}
