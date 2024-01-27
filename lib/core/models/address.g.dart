// import 'package:hive/hive.dart';
// import 'address.dart';

part of 'address.dart';

class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 2;

  @override
  Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Address(
      address: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer
      ..writeByte(1) // Số lượng trường trong đối tượng Address
      ..writeByte(0)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
