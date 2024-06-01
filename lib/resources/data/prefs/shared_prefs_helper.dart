abstract class SharedPrefsHelper {
  saveUserId(String userId);

  Future<String?> getUserId();

  saveFullName(String? fullName);

  Future<String?> getFullName();

  saveEmail(String? email);

  Future<String?> getEmail();

  saveLocality(String? locality);

  Future<String> getLocality();

  saveTaluka(String? taluka);

  Future<String> getTaluka();

  saveTalukaId(String? talukaId);

  Future<String> getTalukaId();

  savePhone(String phone);

  Future<String?> getPhone();

  saveAddress(String address);

  Future<String?> getAddress();

  saveGender(bool isMale);

  Future<bool> getGender();


  Future<String?> getOccupation();

  saveOccupation(String occupation);

  Future<String?> getDateCreated();

  saveDateCreated(String? date);

  saveAvatar(String? avatarUrl);

  Future<String?> getAvatar();

  clearPrefs();

  saveSafetyNote(String note);

  Future<String?> getSafetyNote();

  saveLatestVersion(String version);

  Future<String?> getLatestVersion();

  registerBackPress();

  Future<int> getTotalBackpresses();

  saveFirebaseToken(String token);

  Future<String?> getFirebaseToken();

  //stores
  saveStoreId(String storeId);

  Future<String> getStoreId();

  saveStoreName(String storeName);

  Future<String> getStoreName();

  saveStoreImage(String storeImage);

  Future<String> getStoreImage();

  saveStoreCategoryId(String storeCategoryId);

  Future<String> getStoreCategoryId();
}
