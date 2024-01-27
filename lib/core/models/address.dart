import 'package:hive_flutter/hive_flutter.dart';

part  'address.g.dart';

@HiveType(typeId: 2)
class Address {
  @HiveField(0)
  late String address;

  Address( {required this.address});
}
