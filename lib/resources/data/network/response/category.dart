
class Category {

  int id;
  String title;
  String? title_mar;
  String? value;
  String? image;
  int type;

	Category.fromJsonMap(Map<String, dynamic> map): 
		id = map["id"],
		title = map["title"],
		title_mar = map["title_mar"],
		value = map["value"],
		image = map["image"],
		type = map["type"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['title'] = title;
		data['title_mar'] = title_mar;
		data['value'] = value;
		data['image'] = image;
		data['type'] = type;
		return data;
	}
}
