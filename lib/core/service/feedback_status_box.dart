
import 'package:hive/hive.dart';

import '../models/feedback_status.dart';

class FeedbackManager {
  static const boxName = 'feedback_status';

  static Future<void> initHive() async {
    await Hive.openBox<FeedbackStatus>(boxName);
  }

  static Box<FeedbackStatus> get feedbackBox =>
      Hive.box<FeedbackStatus>(boxName);

  static Future<void> setFeedbackStatus(int orderDetailId, bool hasFeedback) async {
    await feedbackBox.put(orderDetailId, FeedbackStatus(orderDetailId: orderDetailId, hasFeedback: hasFeedback));
  }

  static bool hasFeedback(int orderDetailId) {
    final status = feedbackBox.get(orderDetailId);
    return status != null ? status.hasFeedback : false;
  }
   static List<FeedbackStatus> getAllFeedback() {
    return feedbackBox.values.toList();
  }
}
