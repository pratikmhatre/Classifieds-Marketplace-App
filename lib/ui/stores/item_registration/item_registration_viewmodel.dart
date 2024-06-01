import 'package:digigad/resources/extended_viewmodel.dart';

class ItemRegistrationViewModel extends ExtendedViewModel {
  List<ItemVariantPojo> _variants = [];
  var _isFoodItem = false;
  var _isVegFoodItem = true;
  String? _itemImagePath;

  String? get getItemImagePath => _itemImagePath;

  List<ItemVariantPojo> get getVariants => _variants;

  bool get getIsFoodItem => _isFoodItem;

  bool get getIsVegFoodItem => _isVegFoodItem;

  setIsFoodItem(isFood) {
    _isFoodItem = isFood;
    notifyListeners();
  }

  setItemImage(String path) {
    _itemImagePath = path;
    notifyListeners();
  }

  setIsVegFoodItem(isVeg) {
    _isVegFoodItem = isVeg;
    notifyListeners();
  }

  removeVariant(index) {
    _variants.removeAt(index);
    notifyListeners();
  }

  addVariant(name, price) {
    var variant = ItemVariantPojo(name: name, price: price);
    _variants.add(variant);
    notifyListeners();
  }

  saveProduct(name, price) {}

  void updateImage(String path) {
    _itemImagePath = path;
    notifyListeners();
  }

  void deleteImage() {
    _itemImagePath = null;
    notifyListeners();
  }
}

class ItemVariantPojo {
  String? name, price;
  ItemVariantPojo({this.name, this.price});
}
