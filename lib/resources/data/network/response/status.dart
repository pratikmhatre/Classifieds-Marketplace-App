class Status {
  int id;
  bool is_active = true;
  bool is_approved = true;
  int ad;
  String? reason;

  Status.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        is_active = map["is_active"],
        is_approved = map["is_approved"],
        ad = map["ad"],
        reason = map["reason"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['is_active'] = is_active;
    data['is_approved'] = is_approved;
    data['ad'] = ad;
    data['reason'] = reason;
    return data;
  }
}
