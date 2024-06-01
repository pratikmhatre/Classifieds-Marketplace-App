class LoginResponse {
  int status;
  String message;
  Data data;

  LoginResponse.fromJsonMap(Map<String, dynamic> map)
      : status = map["status"],
        message = map["message"],
        data = Data.fromJsonMap(map["data"]);
}

class Data {
  int userId;
  String? name;
  String? emailId;
  String? date_created;
  String? locality;
  String? taluka;
  String? avatar;
  String? talukaId;
  StoreData? storeData;

  Data.fromJsonMap(Map<String, dynamic> map)
      : userId = map["userId"],
        name = map["name"],
        emailId = map["emailId"],
        date_created = map["date_created"],
        locality = map["locality"],
        taluka = map["taluka"],
        talukaId = map["taluka_id"].toString(),
        avatar = map["avatar"],
        storeData =
            map['store'] == null ? null : StoreData.fromJsonMap(map['store']);
}

class StoreData {
  int id;
  String name;
  String? image;
  int storeCategory;

  StoreData.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        image = map["image"],
        storeCategory = map["storeCategory"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['storeCategory'] = storeCategory;
    return data;
  }
}
