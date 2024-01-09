// class UserModel {
//   UserModel({
//     required this.received,
//     required this.data,
//   });
//   late final bool received;
//   late final UserData data;

//   UserModel.fromJson(Map<String, dynamic> json) {
//     received = json['received'];
//     data = UserData.fromJson(json['data']);
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['received'] = received;
//     _data['data'] = data.toJson();
//     return _data;
//   }
// }

// class UserData {
//   UserData({
//     required this.email,
//     required this.username,
//     required this.iat,
//     required this.exp,
//   });
//   late final String email;
//   late final String username;
//   late final int iat;
//   late final int exp;

//   UserData.fromJson(Map<String, dynamic> json) {
//     email = json['email'];
//     username = json['username'];
//     iat = json['iat'];
//     exp = json['exp'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['email'] = email;
//     _data['username'] = username;
//     _data['iat'] = iat;
//     _data['exp'] = exp;
//     return _data;
//   }
// }

class RegisterModel {
  final String fullname;
  final String email;
  final String password;
  final String phone;
  final String address;

  RegisterModel(
      {required this.fullname,
      required this.email,
      required this.password,
      required this.phone,
      required this.address});

  get data => null;

  get received => null;
  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
    };
  }

  factory RegisterModel.fromJson(Map<String, dynamic> data) {
    return RegisterModel(
      fullname: data['fullname'] ?? "",
      email: data['email'] ?? "",
      password: data['password'] ?? "",
      phone: data['phone'] ?? "",
      address: data['address'] ?? "",
    );
  }
}
