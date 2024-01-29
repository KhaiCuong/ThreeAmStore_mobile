import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scarvs/core/notifiers/address.notifiter.dart';
import 'package:scarvs/core/models/address.dart';

class EditAddressDialog extends StatefulWidget {
  final BuildContext context;
  final String field;

  EditAddressDialog({required this.context, required this.field});

  @override
  _EditAddressDialogState createState() => _EditAddressDialogState();
}

class _EditAddressDialogState extends State<EditAddressDialog> {
  late TextEditingController _textEditingController;
  late List<Address> addresses;
  late AddressNotifier addressNotifier;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    var addressesBox = await Hive.openBox<Address>('addresses');
    addresses = addressesBox.values.toList();
    addressNotifier = AddressNotifier();
  }

  deleteAdressFromHive(String address) async {
  Box<Address> _addressesBox = Hive.box<Address>('addresses');

    final Map<dynamic, Address> deliveriesMap = _addressesBox.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.address == address) {
        desiredKey = key;
      }
    });
    print(">>>>>>>>>>>>>>>>desiredKey : $desiredKey");
    if (desiredKey != null) {
      _addressesBox.delete(desiredKey);
      setState(() {
        // Cập nhật state hoặc thực hiện bất kỳ hành động nào cần thiết sau khi xoá
      });
      return true; // Trả về true nếu xóa thành công
    } else {
      print('$address not found in Hive Box.');
      return false; // Trả về false nếu không tìm thấy đối tượng cần xóa
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onAddressSelected(String selectedAddress) {
    print('Selected Address: $selectedAddress');
    Navigator.pop(context);
  }

  void _saveNewAddress() {
    String newAddress = _textEditingController.text;
    if (newAddress.isNotEmpty) {
      addressNotifier.addAddress(newAddress);
      Navigator.pop(context);
    } else {
      _showSnackBar('Please enter a valid address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(addresses[index].address),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteAdressFromHive(addresses[index].address);
                  },
                ),
                onTap: () {
                  _onAddressSelected(addresses[index].address);
                },
              );
            },
          ),
          SizedBox(height: 20),
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(labelText: "Enter new address:"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveNewAddress,
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
