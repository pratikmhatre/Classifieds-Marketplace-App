import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/adlist_response.dart';
import 'package:digigad/resources/data/network/response/ads.dart';
import 'package:digigad/resources/data/network/response/get_all_offers_response.dart';
import 'package:digigad/resources/data/network/response/make_offer_response.dart';
import 'package:digigad/resources/data/network/response/master_response.dart';
import 'package:digigad/resources/data/network/response/plain_response.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AdDetailsViewModel extends ExtendedViewModel {
  Ads? ad;
  var _dataManager = locator<DataManager>();
  bool _isMyPostedAd = false;
  String? _myUserId;
  String? _safetyNote;

  String? get getSafetyNote => _safetyNote;
  List<AdResponse>? responseList;

  set({Ads? data, String? adId}) async {
    _safetyNote = await _dataManager.getSafetyNote();
    _myUserId = await _dataManager.getUserId();

    if (data != null) {
      _isMyPostedAd = _myUserId == data.userId.userId.toString();
      ad = data;
      notifyListeners();

      if (_isMyPostedAd) {
        _fetchResponses();
      }

      FirebaseAnalytics().logViewItem(
          itemId: ad!.id.toString(),
          itemName: ad!.title??'',
          itemCategory: ad!.category?.title??'');
    } else {
      _fetchAdDetailsFromServer(adId ?? '');
    }
  }

  get isMyPostedAd => _isMyPostedAd;

  Ads? get getAdData => ad;

  bool get isLiked => ad?.isLiked ?? false;

  _fetchAdDetailsFromServer(String adId) async {
    setBusyForObject(ad, true);
    _dataManager.getSingleAdFromServer(_myUserId ?? '', adId);

    var adResponse = await safeAwait<AdlistResponse>(
        future: _dataManager.getSingleAdFromServer(_myUserId ?? '', adId),
        mapping: (m) => AdlistResponse.fromJsonMap(m));
    setBusyForObject(ad, false);

    if (adResponse != null &&
        adResponse.status == 200 &&
        adResponse.data.isNotEmpty) {
      var adFound = adResponse.data[0];
      set(data: adFound);
    } else {
      Fluttertoast.showToast(msg: AppConstants.somethingWentWrong);
    }
  }

  onShareAdClicked() async {
    FirebaseAnalytics().logShare(
        contentType: ad?.title??'', itemId: ad?.id.toString()??'', method: 'Dynamic');

/*    var shortLink = AppFunctions.generateDynamicLink(DynamicLinkType.share_ad,
        adId: _ad?.id.toString()??'',
        title: '${_ad.title} @${_ad.locality}',
        details: 'Rs.${_ad.sellingPrice}/-',
        image: _ad.images[0].imgKey);

    shortLink.then((value) => Share.share(value));*/
  }

  onLikeAdClicked() async {
    if (ad != null && !this.busy(ad)) {
      setBusyForObject(ad, true);
      var plainResponse = await safeAwait(
          future: _dataManager.performAdAction(
              adId: ad!.id,
              userId: _myUserId,
              actionId: AppConstants.ACTION_LIKE,
              isAdding: !ad!.isLiked),
          mapping: (map) => PlainResponse.fromJsonMap(map));

      if (plainResponse != null && plainResponse.status == 200) {
        if (!ad!.isLiked) {
          ad!.likes += 1;
        } else {
          var newCount = ad!.likes - 1;
          ad!.likes = (newCount >= 0) ? newCount : 0;
        }
        ad!.isLiked = !ad!.isLiked;
        notifyListeners();
      }
      setBusyForObject(ad, false);
    }
  }

  Future<List<MasterData>> getReportReasons() async {
    return await _dataManager.getOptionMaster(
        AppConstants.masterTypeReportReasons);
  }

  Future<Response<dynamic>> onReportReasonSelected(
      MasterData reasonObject, int adId) {
    return _dataManager.performAdAction(
        adId: adId,
        actionId: AppConstants.ACTION_REPORT,
        value: reasonObject.id,
        isAdding: true);
  }

  submitOffer(String offerPrice) async {
    var makeOfferResponse = await safeAwait(
        future: _dataManager.makeOffer(ad?.id, _myUserId, offerPrice, ''),
        mapping: (map) => MakeOfferResponse.fromJsonMap(map));
    if (makeOfferResponse != null) {
      showToast('Offer Sent To The Seller');
    }
  }

  onDeleteAdConfirmed(Function onComplete) async {
    var plainResponse = await safeAwait(
        future: _dataManager.deactivateAd(_myUserId, ad?.id),
        mapping: (map) => PlainResponse.fromJsonMap(map));
    if (plainResponse != null && plainResponse.status == 200) {
      onComplete.call();
    } else {
      showToast(AppConstants.somethingWentWrong);
    }
  }

  callUser(number) async {
    await launch('tel:$number');
  }

  void _fetchResponses() async {
    var responses = await safeAwait(
        future: _dataManager.getAllAdResponses(ad?.id),
        mapping: (map) => _getListFromMap(map));
    if (responses != null && responses.isNotEmpty) {
      responseList = responses;
      notifyListeners();
    }
  }

  List<AdResponse> _getListFromMap(List map) {
    var list = map.map<AdResponse>((e) => AdResponse.fromJsonMap(e)).toList();
    return list;
  }
}
