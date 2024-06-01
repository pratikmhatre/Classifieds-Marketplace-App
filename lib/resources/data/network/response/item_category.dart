class ItemCategory {
  int? id;
  String? name;
  int? storeCategory;

  ItemCategory({this.name, this.storeCategory});

  ItemCategory.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        storeCategory = map["store_category"];
}