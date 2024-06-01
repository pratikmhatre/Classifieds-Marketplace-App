class CreateAdResponse {
  int status;
  String message;
  CreatedAd? ad;

  CreateAdResponse.fromJsonMap(Map<String, dynamic> map)
      : status = map["status"],
        message = map["message"],
        ad = (map['ad'] == null) ? null : CreatedAd.fromJsonMap(map['ad']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class CreatedAd {
  int id;
  String title;
  String details;
  String sellingPrice;

  CreatedAd.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        details = map["details"],
        sellingPrice = map["sellingPrice"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['details'] = details;
    data['sellingPrice'] = sellingPrice;
    return data;
  }
}
