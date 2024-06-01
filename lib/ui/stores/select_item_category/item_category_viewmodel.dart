import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/item_categories_response.dart';
import 'package:digigad/resources/data/network/response/item_category.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';

class ItemCatgoryViewModel extends ExtendedViewModel {
  var _dataManager = locator<DataManager>();
  List<ItemCategory> _itemCategories = [];
  List<ItemCategory> _displayCategories = [];

  List<ItemCategory> get getItemCategories => _displayCategories;

  fetchData() async {
    var storeCategory = await _dataManager.getStoreCategoryId();
    var data = await safeAwait(
        future: _dataManager.getItemCategories(storeCategory),
        mapping: (map) => ItemCategoriesResponse.fromJson(map));
    if (data != null) {
      _itemCategories = data.itemCategories;
      _displayCategories = data.itemCategories;
      notifyListeners();
    }
  }

  onCategoryAdded(String name) async {
    var categories = _itemCategories
        .where((element) => element.name?.toLowerCase() == name.toLowerCase())
        .toList();

    if (categories.isNotEmpty) {
      showToast('Category Already Present');
    } else {
      var storeCategory = await _dataManager.getStoreCategoryId();
      var itemCategory =
          ItemCategory(name: name, storeCategory: int.parse(storeCategory));

      ItemCategory? data = await safeAwait(
          future: _dataManager.registerItemCategory(itemCategory),
          mapping: (map) => ItemCategory.fromJsonMap(map));
      if (data != null) {
        showToast('Category Added');

        resetSearch();
        _itemCategories.add(data);
      }
    }
  }

  resetSearch() {
    _displayCategories = _itemCategories;
    notifyListeners();
  }

  searchCategory(String query) {
    _displayCategories = _itemCategories.where((value) {
      return (value.name ?? '').toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }
}
