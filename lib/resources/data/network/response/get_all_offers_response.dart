import 'package:digigad/resources/data/network/response/user_info.dart';

class AdResponse {
  int id;
  FromUser fromUser;
  String offer;
  Object message;
  String dateCreated;
  int ad;

  AdResponse.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        fromUser = FromUser.fromJsonMap(map["fromUser"]),
        offer = map["offer"],
        message = map["message"],
        dateCreated = map["dateCreated"],
        ad = map["ad"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['fromUser'] = fromUser == null ? null : fromUser.toJson();
    data['offer'] = offer;
    data['message'] = message;
    data['dateCreated'] = dateCreated;
    data['ad'] = ad;
    return data;
  }
}

class FromUser {
  int userId;
  String phone;
  String avatar;
  UserInfo userInfo;

  FromUser.fromJsonMap(Map<String, dynamic> map)
      : userId = map["userId"],
        phone = map["phone"],
        avatar = map["avatar"],
        userInfo = UserInfo.fromJsonMap(map["userInfo"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = userId;
    data['phone'] = phone;
    data['avatar'] = avatar;
    data['userInfo'] = userInfo == null ? null : userInfo.toJson();
    return data;
  }
}
