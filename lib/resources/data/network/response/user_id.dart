
import 'package:digigad/resources/data/network/response/user_info.dart';

class UserId {

  int userId;
  String? phone;
  String? avatar;
  UserInfo userInfo;

	UserId.fromJsonMap(Map<String, dynamic> map): 
		userId = map["userId"],
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
