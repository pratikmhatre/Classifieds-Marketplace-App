import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/adlist_response.dart';
import 'package:digigad/resources/data/network/response/ads.dart';
import 'package:digigad/resources/data/network/response/master_response.dart';
import 'package:digigad/resources/data/network/response/plain_response.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';
import 'package:dio/dio.dart';

class AdlistViewModel extends ExtendedViewModel {
  var _dataManager = locator<DataManager>();
  List<Ads> _adsList = [];
  String? _myUserId, _categoryId, _searchQuery;
  bool _hasEndReached = false;
  Response<dynamic>? _fetchAdsResponse;
  var _pageNumber = 1;

  Response? get fetchAdsResponse => _fetchAdsResponse;

  List<Ads> get getAdsList => _adsList;

  String? get getSearchQuery => _searchQuery;

  String? get getMyUserId => _myUserId;

  set(String? categoryId) {
    this._categoryId = categoryId;
  }

  fetchAdlist({searchQuery, adListType, bool isInitial = true}) async {
    if (isInitial || adListType != AdListType.CategoryAds) {
      _hasEndReached = false;
      _pageNumber = 1;
      _adsList = [];
      notifyListeners();
    } else {
      _pageNumber += 1;
    }

    if (_hasEndReached) {
      return;
    }

    setBusy(true);
    var userId = await _dataManager.getUserId();
    _myUserId = userId;

    Future<Response<dynamic>>? call;
    try {
      switch (adListType) {
        case AdListType.CategoryAds:
          _searchQuery = null;
          call = _dataManager.getAdsFromServer(
              userId: userId ?? '',
              categoryId: _categoryId ?? '',
              page: _pageNumber);
          break;
        case AdListType.LikedAds:
          _searchQuery = null;
          call = _dataManager.getLikedAds(userId ?? '');
          break;
        case AdListType.SearchAds:
          _searchQuery = searchQuery;
          call = _dataManager.searchAds(userId ?? '', searchQuery,
              categoryId: _categoryId ?? '');
          break;
        default:
          break;
      }
//      _fetchAdsResponse = call;

      if (call != null) {
        var response = await safeAwait(
            future: call, mapping: (map) => AdlistResponse.fromJsonMap(map));

        if (response != null &&
            response.status == 200 &&
            response.data.isNotEmpty) {
          if (adListType != AdListType.CategoryAds) {
            //no pagination for other ad types
            _hasEndReached = true;
          } else {
            if (response.data.length < 10) {
              _hasEndReached = true;
            }
          }
          if (_pageNumber == 1) {
            _adsList = response.data;
          } else {
            _adsList.addAll(response.data);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      print(e);
    } finally {
      setBusy(false);
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

  Future<List<MasterData>> getReportReasons() async {
    return await _dataManager
        .getOptionMaster(AppConstants.masterTypeReportReasons);
  }

  onLikeAdClicked(int position) async {
    if (!busy(_adsList)) {
      setBusyForObject(_adsList, true);

      var adItem = _adsList[position];

      var plainResponse = await safeAwait(
          future: _dataManager.performAdAction(
              adId: adItem.id,
              userId: _myUserId,
              actionId: AppConstants.ACTION_LIKE,
              isAdding: !adItem.isLiked),
          mapping: (map) => PlainResponse.fromJsonMap(map));

      setBusyForObject(_adsList, false);
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

  Future<Response<dynamic>> onReportReasonSelected(
      MasterData reasonObject, adId) {
    return _dataManager.performAdAction(
        adId: adId,
        actionId: AppConstants.ACTION_REPORT,
        value: reasonObject.id,
        isAdding: true);
  }
}
