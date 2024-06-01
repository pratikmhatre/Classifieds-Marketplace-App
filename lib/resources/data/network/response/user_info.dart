
import 'package:digigad/resources/app_constants.dart';

class UserInfo {

  String? fullName;
  String? email;
  int taluka;
  int gender;

	UserInfo.fromJsonMap(Map<String, dynamic> map): 
		fullName = map["fullName"],
		email = map["email"],
		taluka = map["taluka"],
		gender = map["gender"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['fullName'] = fullName;
		data['email'] = email;
		data['taluka'] = taluka;
		data['gender'] = gender;
		return data;
	}
}
