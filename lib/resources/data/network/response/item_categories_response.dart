import 'item_category.dart';

class ItemCategoriesResponse {
  List<ItemCategory> itemCategories;

  ItemCategoriesResponse.fromJson(List<dynamic> list)
      : itemCategories =
            list.map<ItemCategory>((e) => ItemCategory.fromJsonMap(e)).toList();
}
