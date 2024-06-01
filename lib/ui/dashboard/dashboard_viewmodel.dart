import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/adlist_response.dart';
import 'package:digigad/resources/data/network/response/ads.dart';
import 'package:digigad/resources/data/network/response/master_response.dart';
import 'package:digigad/resources/data/network/response/plain_response.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension on String {
  bool isValueValid() {
    return this != null && this.trim().isNotEmpty && !this.contains('null');
  }
}

class DashboardViewmodel extends ExtendedViewModel {
  List<Ads> _adList = [];
  List<MasterData> _storeCategoryList = [];
  var _dataManager = locator<DataManager>();

  List<Ads> get getAdList => _adList;


  List<MasterData> get getStoreCategories => _storeCategoryList;

  fetchStoreCategories() async {

    var allList = await _dataManager.getOptionMaster(
        AppConstants.masterTypeStoreCategory);
    _storeCategoryList = allList;

    notifyListeners();
    fetchLatestAds();
  }


  fetchLatestAds() async {
    var response = await safeAwait(
        future: _dataManager.getLatestAds(),
        mapping: (map) => AdlistResponse.fromJsonMap(map));
    if (response != null && response.status == 200) {
      _adList = response.data;
      notifyListeners();
    } else {
      Fluttertoast.showToast(msg: AppConstants.somethingWentWrong);
    }
  }

  onLikeAdClicked(int position) async {
    if (!busy(_adList)) {
      setBusyForObject(_adList, true);


      var adItem = _adList[position];

      var userId = await _dataManager.getUserId();
      var plainResponse = await safeAwait(
          future: _dataManager.performAdAction(
              adId: adItem.id,
              userId: userId,
              actionId: AppConstants.ACTION_LIKE,
              isAdding: !adItem.isLiked),
          mapping: (map) => PlainResponse.fromJsonMap(map));

      setBusyForObject(_adList, false);

      if (plainResponse != null && plainResponse.status == 200) {
        if (!adItem.isLiked) {
          adItem.likes += 1;
        } else {
          var newCount = adItem.likes - 1;
          adItem.likes = (newCount >= 0) ? newCount : 0;
        }
        adItem.isLiked = !adItem.isLiked;
        notifyListeners();
      }
    }
  }

  Future<List<MasterData>> getReportReasons() async {
    return await _dataManager.getOptionMaster(
        AppConstants.masterTypeReportReasons);
  }

  Future<Response<dynamic>> onReportReasonSelected(
      MasterData reasonObject, adId) {
    return _dataManager.performAdAction(
        adId: adId,
        actionId: AppConstants.ACTION_REPORT,
        value: reasonObject.id,
        isAdding: true);
  }


  void onAdListResumed(int position, bool isLiked) {
    try {
      _adList[position].isLiked = isLiked;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  /*//dummy data
  var icons = ['icons/ic_restaurant.png','icons/ic_cafe.png','icons/ic_cake.png','icons/ic_icecream.png'];
  var titles = ['Restaurants','Cafes','Cake Shops', 'Ice Cream Shops'];*/

}
