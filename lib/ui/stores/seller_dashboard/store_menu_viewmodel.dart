import 'package:digigad/resources/data/network/response/store_list.dart';
import 'package:digigad/resources/data/network/response/store_menu.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreMenuViewModel extends ExtendedViewModel {
  int _pagerPosition = 0;
  StoreList? _storeData;

  int get getPagerPosition => _pagerPosition;
  List<StoreMenu>? _storeMenu;

  List<StoreMenu>? get getStoreMenu => _storeMenu;

  setStoreData(StoreList data) async {
    _storeData = data;
    await _fetchStoreMenu();
  }

  List<StoreItem>? getStoreItems(String type) =>
      _storeMenu?.firstWhere((element) => element.name == type).items;

  onTabChanged(int i) {
    this._pagerPosition = i;
    notifyListeners();
  }

  _fetchStoreMenu() async {
    if (_storeData != null) {
      var storeMenu = await safeAwait(
          future: dataManager.getStoreMenu(_storeData!.id.toString()),
          mapping: (map) => (map as List)
              .map<StoreMenu>((e) => StoreMenu.fromJson(e))
              .toList());

      if (storeMenu != null) {
        _storeMenu = storeMenu;
        notifyListeners();
      }
    }
  }

  callStore() async {
    if (_storeData != null) {
      await launch('tel:${_storeData!.contactNumber}');
    }
  }
}
