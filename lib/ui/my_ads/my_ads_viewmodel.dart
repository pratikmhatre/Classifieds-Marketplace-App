import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/adlist_response.dart';
import 'package:digigad/resources/data/network/response/ads.dart';
import 'package:digigad/resources/data/network/response/plain_response.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';

class MyAdsViewModel extends ExtendedViewModel {
  var _dataManager = locator<DataManager>();
  List<Ads> _adsList = [];

  List<Ads> get getAdList => _adsList;
  String? _userId;

  String? get getMyUserId => _userId;

  fetchMyAds() async {
    setBusy(true);
    var userId = await _dataManager.getUserId();
    this._userId = userId;
    var adListResponse = await safeAwait(
        future: _dataManager.getMyPostedAds(userId),
        mapping: (map) => AdlistResponse.fromJsonMap(map));

    setBusy(false);
    if (adListResponse !=null &&  adListResponse.status == 200) {

      _adsList = adListResponse.data;
      notifyListeners();
    }
  }

  onLikeAdClicked(int position) async {
    if (!busy(_adsList)) {
      setBusyForObject(_adsList, true);


      var adItem = _adsList[position];
      var userId = await _dataManager.getUserId();

      var plainResponse = await safeAwait(future: _dataManager.performAdAction(
          adId: adItem.id,
          userId: userId,
          actionId: AppConstants.ACTION_LIKE,
          isAdding: !adItem.isLiked), mapping: (map)=> PlainResponse.fromJsonMap(map));

      setBusyForObject(_adsList, false);

      if (plainResponse !=null &&  plainResponse.status == 200) {
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

  onAdListResumed(int position, bool isLiked) {
    try {
      var ad = _adsList[position];
      ad.isLiked = isLiked;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
