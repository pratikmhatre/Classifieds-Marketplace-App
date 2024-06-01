import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/db/db_helper.dart';
import 'package:digigad/resources/data/network/api_helper.dart';
import 'package:digigad/resources/data/network/request/seller_registration_pojo.dart';
import 'package:digigad/resources/data/network/response/item_category.dart';
import 'package:digigad/resources/data/prefs/shared_prefs_helper.dart';
import 'package:dio/dio.dart';
import 'network/response/master_response.dart';

class DataManagerClass implements DataManager {
  final DbHelper _dbHelper;
  final SharedPrefsHelper _prefsHelper;
  final ApiHelper _apiHelper;
  String? _accessToken;

  DataManagerClass(this._dbHelper, this._prefsHelper, this._apiHelper);

  @override
  Future<Response> performAdAction(
      {adId, userId, actionId,required bool isAdding,int? value}) {
    return _apiHelper.performAdAction(
        adId: adId,
        userId: userId,
        actionId: actionId,
        isAdding: isAdding,
        value: value);
  }

  @override
  Future<Response> getLikedAds(String userId) {
    return _apiHelper.getLikedAds(userId);
  }

  @override
  Future<Response> getMyPostedAds(userId) {
    return _apiHelper.getMyPostedAds(userId);
  }



  @override
  Future<Response> getAdsFromServer(
      {required String userId,required  String categoryId, String? searchQuery,required  int page}) {
    return _apiHelper.getAdsFromServer(
        categoryId: categoryId,
        userId: userId,
        searchQuery: searchQuery,
        page: page);
  }

  @override
  Future<Response> getLatestAds() {
    return _apiHelper.getLatestAds();
  }

  @override
  Future<Response> getMastersFromServer() {
    return _apiHelper.getMastersFromServer();
  }

  @override
  Future<Response> updateProfile(userId, fullName, emailId, locality, taluka) {
    return _apiHelper.updateProfile(
        userId, fullName, emailId, locality, taluka);
  }

  @override
  Future<Response> verifyOtp(userId, phone, otp) {
    return _apiHelper.verifyOtp(userId, phone, otp);
  }

  @override
  clearPrefs() {
    _prefsHelper.clearPrefs();
  }

  @override
  saveOccupation(String occupation) {
    _prefsHelper.saveOccupation(occupation);
  }

  @override
  Future<String?> getOccupation() {
    return _prefsHelper.getOccupation();
  }

  @override
  Future<String?> getFirebaseToken() {
    return _prefsHelper.getFirebaseToken();
  }

  @override
  saveFirebaseToken(String token) {
    _prefsHelper.saveFirebaseToken(token);
  }

  @override
  Future<bool> getGender() {
    return _prefsHelper.getGender();
  }

  @override
  saveGender(bool isMale) {
    _prefsHelper.saveGender(isMale);
  }

  @override
  Future<String?> getAddress() {
    return _prefsHelper.getAddress();
  }

  @override
  saveAddress(String address) {
    return _prefsHelper.saveAddress(address);
  }

  @override
  Future<String?> getPhone() {
    return _prefsHelper.getPhone();
  }

  @override
  savePhone(String phone) {
    return _prefsHelper.savePhone(phone);
  }

  @override
  Future<String?> getEmail() {
    return _prefsHelper.getEmail();
  }

  @override
  saveEmail(String? email) {
    _prefsHelper.saveEmail(email);
  }

  @override
  Future<String?> getFullName() {
    return _prefsHelper.getFullName();
  }

  @override
  saveFullName(String? fullName) {
    _prefsHelper.saveFullName(fullName);
  }

  @override
  Future<String?> getUserId() {
    return _prefsHelper.getUserId();
  }

  @override
  saveUserId(String userId) {
    _prefsHelper.saveUserId(userId);
  }

  @override
  Future<List<MasterData>> getOptionMaster(int? type) {
    return _dbHelper.getOptionMaster(type);
  }

  @override
  Future<dynamic> addMasters(List<Map<String, dynamic>> list) {
    return _dbHelper.addMasters(list);
  }

  @override
  Future<Response> searchAds(String userId, String searchQuery,
      {String? categoryId}) {
    return _apiHelper.searchAds(userId, searchQuery, categoryId: categoryId);
  }

  @override
  Future<Response> getSingleAdFromServer(String userId, String adId) {
    return _apiHelper.getSingleAdFromServer(userId, adId);
  }

  @override
  Future<String?> getAvatar() {
    return _prefsHelper.getAvatar();
  }

  @override
  saveAvatar(String? avatarUrl) {
    _prefsHelper.saveAvatar(avatarUrl);
  }

  @override
  saveDateCreated(String? date) {
    _prefsHelper.saveDateCreated(date);
  }

  @override
  Future<String?> getDateCreated() {
    return _prefsHelper.getDateCreated();
  }

  @override
  Future<Response> updateUserAvatar(
      bool isAdding, String userId, String avatarFile) {
    return _apiHelper.updateUserAvatar(isAdding, userId, avatarFile);
  }

  @override
  getAccessToken() => _accessToken;

  @override
  setAccessToken(token) => _accessToken = token;

  @override
  Future<Response> requestAccessToken() {
    return _apiHelper.requestAccessToken();
  }

  @override
  Future<Response> sendFeedback(userId, feedback) {
    return _apiHelper.sendFeedback(userId, feedback);
  }

  @override
  Future<Response> deactivateAd(userId, adId) {
    return _apiHelper.deactivateAd(userId, adId);
  }

  @override
  Future<Response> doLogin(String number, String fcmToken,
      {bool isResend = false}) {
    return _apiHelper.doLogin(number, fcmToken, isResend: isResend);
  }

  @override
  Future<String?> getSafetyNote() {
    return _prefsHelper.getSafetyNote();
  }

  @override
  saveSafetyNote(String note) {
    _prefsHelper.saveSafetyNote(note);
  }

  @override
  Future<String?> getLatestVersion() {
    return _prefsHelper.getLatestVersion();
  }

  @override
  saveLatestVersion(String version) {
    _prefsHelper.saveLatestVersion(version);
  }

  @override
  Future<Response> getAllAdResponses(adId) {
    return _apiHelper.getAllAdResponses(adId);
  }

  @override
  Future<Response> makeOffer(adId, fromUserId, offer, message) {
    return _apiHelper.makeOffer(adId, fromUserId, offer, message);
  }

  @override
  Future deleteMaster() {
    return _dbHelper.deleteMaster();
  }

  @override
  Future<int> getTotalBackpresses() {
    return _prefsHelper.getTotalBackpresses();
  }

  @override
  registerBackPress() {
    _prefsHelper.registerBackPress();
  }

  @override
  Future<String> getLocality() => _prefsHelper.getLocality();

  @override
  Future<String> getTaluka() => _prefsHelper.getTaluka();

  @override
  Future<String> getTalukaId() => _prefsHelper.getTalukaId();

  @override
  saveLocality(String? locality) => _prefsHelper.saveLocality(locality);

  @override
  saveTaluka(String? taluka) => _prefsHelper.saveTaluka(taluka);

  @override
  saveTalukaId(String? talukaId) => _prefsHelper.saveTalukaId(talukaId);

  @override
  Future<Response> registerSeller(SellerRegistrationPojo registrationPojo) =>
      _apiHelper.registerSeller(registrationPojo);

  @override
  Future<Response> getItemCategories(String storeCategory) =>
      _apiHelper.getItemCategories(storeCategory);

  @override
  Future<Response> registerStoreItem(
          {sellerId,
          itemCategory,
          name,
          price,
          details,
          image,
          bool isVeg = true,
          variants}) =>
      _apiHelper.registerStoreItem(
          sellerId: sellerId,
          image: image,
          price: price,
          name: name,
          details: details,
          isVeg: isVeg,
          itemCategory: itemCategory,
          variants: variants);

  @override
  Future<String> getStoreCategoryId() => _prefsHelper.getStoreCategoryId();

  @override
  Future<String> getStoreId() => _prefsHelper.getStoreId();

  @override
  Future<String> getStoreImage() => _prefsHelper.getStoreImage();

  @override
  Future<String> getStoreName() => _prefsHelper.getStoreName();

  @override
  saveStoreCategoryId(String storeCategoryId) =>
      _prefsHelper.saveStoreCategoryId(storeCategoryId);

  @override
  saveStoreId(String storeId) => _prefsHelper.saveStoreId(storeId);

  @override
  saveStoreImage(String storeImage) => _prefsHelper.saveStoreImage(storeImage);

  @override
  saveStoreName(String storeName) => _prefsHelper.saveStoreName(storeName);

  @override
  Future<Response> registerItemCategory(ItemCategory category) =>
      _apiHelper.registerItemCategory(category);

  @override
  Future<Response> getStoreList(String types) => _apiHelper.getStoreList(types);

  @override
  Future<Response> getStoreMenu(String sellerId) {
    return _apiHelper.getStoreMenu(sellerId);
  }

  @override
  Future<Response> createAdvertisement({required String userId, required String title, required String details, isUsed, required String categoryId, String? latitude, String? longitude, required String sellingPrice, required List<String> images, required String locality, required Function(String progress) calculate}) {
    return _apiHelper.createAdvertisement(
        userId: userId,
        title: title,
        details: details,
        isUsed: isUsed,
        latitude: latitude,
        longitude: longitude,
        sellingPrice: sellingPrice,
        images: images,
        categoryId: categoryId,
        locality: locality, calculate: calculate);
  }
}
