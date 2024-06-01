import 'dart:io';

import 'package:digigad/resources/data/network/request/seller_registration_pojo.dart';
import 'package:digigad/resources/data/network/response/item_category.dart';
import 'package:dio/dio.dart';

abstract class ApiHelper {
  Future<Response> doLogin(String number, String fcmToken,
      {bool isResend = false});

  Future<Response> verifyOtp(userId, phone, otp);

  Future<Response> updateProfile(userId, fullName, emailId, locality, taluka);

  Future<Response> getMastersFromServer();

  Future<Response> getLatestAds();

  Future<Response> getAdsFromServer(
      {required String userId,
      required String categoryId,
      String? searchQuery,
      required int page});

  Future<Response> getSingleAdFromServer(String userId, String adId);

  Future<Response> searchAds(String userId, String searchQuery,
      {String? categoryId});

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
      required Function(String progress) calculate});

  Future<Response> getMyPostedAds(userId);

  Future<Response> getLikedAds(String userId);

  Future<Response> performAdAction(
      {adId, userId, actionId, required bool isAdding, int? value});

  Future<Response> updateUserAvatar(
      bool isAdding, String userId, String avatarFile);

  Future<Response> requestAccessToken();

  Future<Response> sendFeedback(userId, feedback);

  Future<Response> deactivateAd(userId, adId);

  Future<Response> makeOffer(adId, fromUserId, offer, message);

  Future<Response> getAllAdResponses(adId);

  //stores
  Future<Response> registerSeller(SellerRegistrationPojo registrationPojo);

  Future<Response> registerStoreItem({sellerId, itemCategory, name, price, details, image,bool isVeg, variants});

  Future<Response> getItemCategories(String storeCategory);

  Future<Response> registerItemCategory(ItemCategory category);

  Future<Response> getStoreList(String types);

  Future<Response> getStoreMenu(String sellerId);
}
