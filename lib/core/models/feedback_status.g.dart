// import 'package:hive/hive.dart';
part of 'feedback_status.dart';

class FeedbackStatusAdapter extends TypeAdapter<FeedbackStatus> {
  @override
  final int typeId = 4; // Đặt typeId của FeedbackStatusAdapter

  @override
  FeedbackStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeedbackStatus(
      orderDetailId: fields[0] as int,
      hasFeedback: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FeedbackStatus obj) {
    writer
      ..writeByte(2) // Đã thêm một trường, nên là 2
      ..writeByte(0)
      ..write(obj.orderDetailId)
      ..writeByte(1)
      ..write(obj.hasFeedback);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
