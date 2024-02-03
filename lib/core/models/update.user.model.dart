import 'package:scarvs/core/models/userDetails.model.dart';

class UpdateUser {
  UpdateUser({
    required this.added,
    required this.updated,
    required this.data,
  });
  late final bool added;
  late final bool updated;
  late final UpdatedData data;

  UpdateUser.fromJson(Map<String, dynamic> json) {
    added = json['added'];
    updated = json['updated'];
    data = UpdatedData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['added'] = added;
    _data['updated'] = updated;
    _data['data'] = data.toJson();
    return _data;
  }
}

class UpdatedData {
  UpdatedData({
    required this.generatedMaps,
    required this.raw,
    required this.affected,
  });
  late final List<dynamic> generatedMaps;
  late final List<dynamic> raw;
  late final int affected;

  UpdatedData.fromJson(Map<String, dynamic> json) {
    generatedMaps = List.castFrom<dynamic, dynamic>(json['generatedMaps']);
    raw = List.castFrom<dynamic, dynamic>(json['raw']);
    affected = json['affected'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['generatedMaps'] = generatedMaps;
    _data['raw'] = raw;
    _data['affected'] = affected;
    return _data;
  }
}

class ForgetUserPassword {
  ForgetUserPassword({
    required this.userEmail,
    required this.data,
  });
  late final String userEmail;

  late final Data data;

  ForgetUserPassword.fromJson(Map<String, dynamic> json) {
    userEmail = json['userEmail'] ?? '';

    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['useremail'] = userEmail;

    _data['data'] = data;
    return _data;
  }
}
