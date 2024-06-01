import 'dart:convert';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/network/request/seller_registration_pojo.dart';
import 'package:digigad/resources/data/network/response/item_category.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../app_functions.dart';
import 'api_helper.dart';

class Repository implements ApiHelper {
  static var _dio = AppFunctions.getDio();
  var _analytica = FirebaseAnalytics();

  Future<Response> verifyOtp(userId, phone, otp) async {
    var map = {'userId': userId, 'phone': phone, 'otp': otp};
    return await _dio.post('users/verify_otp/', data: json.encode(map));
  }

  Future<Response> updateProfile(
      userId, fullName, emailId, locality, taluka) async {
    var map = {
      'user': userId,
      'fullName': fullName,
      'email': emailId,
      'locality': locality,
      'taluka': taluka
    };
    return await _dio.patch('users/profile/$userId/', data: json.encode(map));
  }

  getMastersFromServer() async {
    return await _dio.get('admin/option_master/');
  }

  Future<Response> getLatestAds() async {
    return await _dio.get('classifieds/get_latest_ads/');
  }

  @override
  Future<Response> getAdsFromServer(
      {required String userId,
      required String categoryId,
      String? searchQuery,
      required int page}) async {
    return await _dio.get('classifieds/get_selected_ads/', queryParameters: {
      'userId': userId,
      'category_id': categoryId,
      'page': page
    });
  }

  @override
  Future<Response> getSingleAdFromServer(String userId, String adId) {
    var map = {'userId': userId, 'ad_id': adId};
    return _dio.get('classifieds/get_selected_ads/', queryParameters: map);
  }

  @override
  Future<Response> searchAds(String userId, String searchQuery,
      {String? categoryId}) async {
    _analytica.logEvent(name: 'User has searched for "$searchQuery"');

    var map = {'userId': userId, 'search_query': searchQuery};

    if (categoryId != null) {
      map['category_id'] = categoryId;
    }

    return await _dio.get('classifieds/get_selected_ads/',
        queryParameters: map);
  }

  Future<Response> getMyPostedAds(userId) async {
    var query = {'userId': userId};
    return await _dio.get('classifieds/get_selected_ads/',
        queryParameters: query);
  }

  Future<Response> getLikedAds(String userId) async {
    var query = {'userId': userId};
    return await _dio.get('classifieds/get_liked_ads/', queryParameters: query);
  }

  @override
  Future<Response> performAdAction(
      {adId, userId, actionId, required bool isAdding, int? value}) async {
    if (actionId == AppConstants.ACTION_LIKE) {
      _analytica.logEvent(name: 'Ad ${isAdding ? 'Liked' : 'Unliked'}');
    }

    if (actionId == AppConstants.ACTION_SHARE) {
      _analytica.logEvent(name: 'Ad Shared');
    }

    if (actionId == AppConstants.ACTION_REPORT) {
      _analytica.logEvent(name: 'Ad Reported');
    }

    var map = {
      'user': userId,
      'ad': adId,
      'action': actionId,
      'is_adding': isAdding ? '1' : '0',
    };

    if (value != null) {
      map['value'] = value;
    }

    return await _dio.post('classifieds/perform_ad_action/',
        data: jsonEncode(map));
  }

  @override
  Future<Response> updateUserAvatar(
      bool isAdding, String userId, String avatarFile) {
    var formData = FormData();
    formData.fields.add(MapEntry('user', userId));
    formData.fields.add(MapEntry('is_adding', isAdding ? '1' : '0'));

    if (avatarFile != null) {
      formData.files
          .add(MapEntry('image', MultipartFile.fromFileSync(avatarFile)));
    }

    return _dio.post('users/user_avatar/',
        data: formData, options: Options(contentType: 'multipart/form-data'));
  }

  @override
  Future<Response> requestAccessToken() {
    var map = {
      'username': AppConstants.user,
      'password': AppConstants.password,
      'client_id': AppConstants.clientId,
      'grant_type': AppConstants.grantType,
      'client_secret': AppConstants.clientSecret,
      'scope': AppConstants.scopes,
    };

    return _dio.post('${AppConstants.baseUrl}/o/token/',
        data: map,
        options: Options(contentType: Headers.formUrlEncodedContentType));
  }

  @override
  Future<Response> sendFeedback(userId, feedback) {
    var map = {'user': userId, 'feedback': feedback};
    return _dio.post('users/feedback/', data: jsonEncode(map));
  }

  @override
  Future<Response> deactivateAd(userId, adId) {
    _analytica.logEvent(name: 'Ad deleted');

    var map = {'user_id': userId, 'ad_id': adId};
    return _dio.post('admin/ad_activation/', data: jsonEncode(map));
  }

  @override
  Future<Response> doLogin(String number, String fcmToken,
      {bool isResend = false}) async {
    _analytica.logLogin();

    var map = {
      "phone": number,
      "fcm": fcmToken,
      "resend": isResend ? '1' : '0',
    };
    return await _dio.post('users/user_auth/', data: json.encode(map));
  }

  @override
  Future<Response> getAllAdResponses(adId) async {
    var map = {
      'ad': adId,
    };
    return await _dio.get('classifieds/ad_offer/', queryParameters: map);
  }

  @override
  Future<Response> makeOffer(adId, fromUserId, offer, message) async {
    _analytica.logEvent(name: 'Offer is sent');

    var map = {
      'fromUser': fromUserId,
      'ad': adId,
      'offer': offer,
      'message': message,
    };
    return await _dio.post('classifieds/ad_offer/', data: jsonEncode(map));
  }

  @override
  Future<Response> createAdvertisement(
      {required String userId,
      required String title,
      required String details,
      isUsed,
      required String categoryId,
      String? latitude,
      String? longitude,
      required String sellingPrice,
      required List<String> images,
      required String locality,
      required Function(String progress) calculate}) async {
    var formData = FormData();
    formData.fields.add(MapEntry('category', categoryId));
    formData.fields.add(MapEntry('userId', userId));
    formData.fields.add(MapEntry('title', title));
    formData.fields.add(MapEntry('details', details));
    formData.fields.add(MapEntry('sellingPrice', sellingPrice));
    formData.fields.add(MapEntry('condition', isUsed ? '1' : '2'));
    formData.fields.add(MapEntry('latitude', latitude ?? ''));
    formData.fields.add(MapEntry('locality', locality));
    formData.fields.add(MapEntry('longitude', longitude ?? ''));

    var map = images
        .map((e) => MapEntry<String, MultipartFile>(
            'images', MultipartFile.fromFileSync(e)))
        .toList();
    formData.files.addAll(map);

    return await _dio.post(
      'classifieds/create_ad/',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
      onSendProgress: (int sent, int total) {
        if (sent != null && total != null) {
          var percent = (sent / total) * 100;
          calculate(percent.toString());
        }
      },
    );
  }

  @override
  Future<Response> registerSeller(SellerRegistrationPojo pojo) async {
    var map = {
      'user': pojo.userId,
      'name': pojo.storeName,
      'storeCategory': pojo.storeCategory,
      'locality': pojo.locality,
      'address': pojo.address,
      'taluka': pojo.taluka,
      'workingHours': pojo.workingHours,
      'isHomeDelivery': pojo.isHomeDelivery,
      'deliveryNote': pojo.deliveryNote,
      'coordinates': pojo.coordinates,
      'additional_phone': pojo.additionalPhone,
      'isPureVeg': pojo.isPureVeg,
    };
    var formData = FormData.fromMap(map);
    if (pojo.image != null) {
      formData.files
          .add(MapEntry('image', MultipartFile.fromFileSync(pojo.image!)));
    }

    return await _dio.post('stores/register_seller/',
        data: formData, options: Options(contentType: 'multipart/form-data'));
  }

  @override
  Future<Response> getItemCategories(String storeCategory) {
    var map = {
      'store_category': storeCategory,
    };
    return _dio.get('stores/item_category/', queryParameters: map);
  }

  @override
  Future<Response> registerStoreItem(
      {sellerId,
      itemCategory,
      name,
      price,
      details,
      image,
      bool isVeg = true,
      variants}) {
    var map = {
      'seller': sellerId,
      'category': itemCategory,
      'name': name,
      'details': details,
      'basePrice': price,
      'isVeg': isVeg,
      'variants': variants,
    };
    var formData = FormData.fromMap(map);
    formData.files.add(MapEntry<String, MultipartFile>(
        'image', MultipartFile.fromFileSync(image)));
    return _dio.post('stores/store_items/',
        data: formData, options: Options(contentType: 'multipart/form-data'));
  }

  @override
  Future<Response> registerItemCategory(ItemCategory category) {
    var map = {'store_category': category.storeCategory, 'name': category.name};
    return _dio.post('stores/item_category/', data: jsonEncode(map));
  }

  @override
  Future<Response> getStoreList(String types) {
    var map = {'type': types};
    return _dio.get('stores/get_stores', queryParameters: map);
  }

  @override
  Future<Response> getStoreMenu(String sellerId) {
    var map = {'seller_id': sellerId};
    return _dio.get('stores/get_store_menu', queryParameters: map);
  }
}
