import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/store_list.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';

class StoreListViewModel extends ExtendedViewModel {
  final DataManager _dataManager = locator<DataManager>();
  List<StoreList> _storeList = [];
  var currentCoord = "18.6876108,72.8581053";

  List<StoreList> get getRestoList => _storeList;

  getStoreList(String categoryId) async {
    var safeCall = await safeAwait<List<StoreList>>(
        future: _dataManager.getStoreList(categoryId),
        mapping: (map) => _getListFromMap(map));
    if (safeCall != null) {
      print(safeCall);
      _setStoreList(safeCall);
    }
  }

  _setStoreList(List<StoreList> list) async {
    _storeList = await _getSortedList(list);
    notifyListeners();
  }

  Future<List<StoreList>> _getSortedList(List<StoreList> list) async {
   /* var distancedList = list.map((e) {
      e.distance =
          AppFunctions.calculateDistance(currentCoord, e.coordinates ?? '');
      return e;
    }).toList();

    distancedList.sort((s1, s2) => s1.distance.compareTo(s2.distance));
    return distancedList;*/
    return list;
  }

  List<StoreList> _getListFromMap(List map) {
    var list = map.map<StoreList>((e) => StoreList.fromJsonMap(e)).toList();
    return list;
  }
}
