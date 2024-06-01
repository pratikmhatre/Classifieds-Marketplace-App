class StoreMenu {
  int id;
  String name;
  List<StoreItem> items;

  StoreMenu.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        items = (map['items'] as List)
            .map<StoreItem>((e) => StoreItem.fromJsonMap(e))
            .toList();
}

class StoreItem {
  String name;
  String? details;
  String basePrice;
  String? image;
  bool isVeg;
  List<Variant> variants;

  StoreItem.fromJsonMap(Map<String, dynamic> map)
      : name = map["name"],
        details = map["details"],
        basePrice = map["basePrice"],
        image = map["image"],
        isVeg = map["isVeg"],
        variants = (map["variants"] as List)
            .map<Variant>((e) => Variant.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['details'] = details;
    data['basePrice'] = basePrice;
    data['image'] = image;
    data['isVeg'] = isVeg;
    return data;
  }
}

class Variant {
  String name, price;
  Variant.fromJson(Map<String, dynamic> map)
      : name = map['name'],
        price = map['price'];
}
