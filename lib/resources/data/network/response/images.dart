
class Images {

  int id;
  String imgKey;

	Images.fromJsonMap(Map<String, dynamic> map): 
		id = map["id"],
		imgKey = map["imgKey"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['imgKey'] = imgKey;
		return data;
	}
}
