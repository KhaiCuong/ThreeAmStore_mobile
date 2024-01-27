import 'package:hive/hive.dart';

import '../models/address.dart';

class AddressNotifier {
  Box<Address> _addressesBox = Hive.box<Address>('addresses');

  List<Address> get addresses => _addressesBox.values.toList();

  Future<void> addAddress(String newAddress) async {
  try {
    var existingAddresses = _addressesBox.values.cast<Address>().toList();
    if (!existingAddresses.any((address) => address.address == newAddress)) {
      var address = Address(address: newAddress);
      await _addressesBox.add(address);
    } else {
      print('Address already exists in Hive: $newAddress');
      // Thực hiện các hành động cần thiết khi địa chỉ đã tồn tại trong Hive
    }
  } catch (error) {
    print('Error adding address to Hive: $error');
  }
}

 Future<void> removeAddress(Address addressToRemove) async {
    try {
      // Lọc qua danh sách địa chỉ và xóa địa chỉ có giá trị giống với địa chỉ muốn xoá
      final addressIndex = addresses.indexWhere((address) => address.address == addressToRemove);
      if (addressIndex != -1) {
        await _addressesBox.deleteAt(addressIndex);
      }
    } catch (error) {
      print('Error removing address from Hive: $error');
    }
  }
}

