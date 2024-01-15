// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderDataAdapter extends TypeAdapter<OrderData> {
  @override
  final int typeId = 1;

  @override
  OrderData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderData(
      orderId: fields[0] as int,
      username: fields[1] as String,
      address: fields[2] as String,
      phoneNumber: fields[3] as String,
      userId: fields[4] as int,
      quantity: fields[5] as int, // Thêm đọc trường mới: quantity
      price: fields[6] as double,  // Thêm đọc trường mới: price
      productName: fields[7] as String,  // Thêm đọc trường mới: productName
      productId: fields[8] as String,  // Thêm đọc trường mới: productId
      image: fields[9] as String,  // Thêm đọc trường mới: image
    );
  }

  @override
  void write(BinaryWriter writer, OrderData obj) {
    writer
      ..writeByte(10) // Tăng số lượng trường lên 10
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.quantity)  // Thêm ghi trường mới: quantity
      ..writeByte(6)
      ..write(obj.price)  // Thêm ghi trường mới: price
      ..writeByte(7)
      ..write(obj.productName)  // Thêm ghi trường mới: productName
      ..writeByte(8)
      ..write(obj.productId)  // Thêm ghi trường mới: productId
      ..writeByte(9)
      ..write(obj.image);  // Thêm ghi trường mới: image
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

