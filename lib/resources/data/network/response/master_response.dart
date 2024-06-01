class MasterResponse {
  int status;
  List<MasterData> data;
  Meta meta;

  MasterResponse.fromJsonMap(Map<String, dynamic> map)
      : status = map["status"],
        data = List<MasterData>.from(
            map["data"].map((it) => MasterData.fromJsonMap(it))),
        meta = Meta.fromJson(map['meta']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['data'] =
        data != null ? this.data.map((v) => v.toJson()).toList() : null;
    return data;
  }
}

class MasterData {
  int id;
  String title;
  String title_mar;
  String value;
  String? icon;
  String? image;
  int type;

  MasterData.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        title_mar = map["title_mar"],
        value = map["value"],
        image = map["image"],
        icon = map["icon"],
        type = map["type"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['title_mar'] = title_mar;
    data['value'] = value;
    data['icon'] = icon;
    data['image'] = image;
    data['type'] = type;
    return data;
  }
}

class Version {
  String versionName;
  bool isMandatory;

  Version.fromJson(Map<String, dynamic> map)
      : versionName = map['version_name'],
        isMandatory = map['is_mandatory'];
}

class Meta {
  String safetyNote;
  Version version;

  Meta.fromJson(Map<String, dynamic> map)
      : safetyNote = map['safety_note'],
        version = Version.fromJson(map['app_version']);
}
