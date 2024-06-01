import 'package:digigad/resources/data/prefs/shared_prefs_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs implements SharedPrefsHelper {
  final String _userId = 'userid';
  final String _fullName = 'fullname';
  final String _avatar = 'avatar';
  final String _email = 'email';
  final String _phone = 'phone';
  final String _address = 'address';
  final String _gender = 'gender';
  final String _occupation = 'occupation';
  final String _dateCreated = 'datecreated';

  final String _locality = 'locality';
  final String _taluka = 'taluka';
  final String _talukaId = 'talukaid';

  final String _latestVersion = 'version';
  final String _backPresses = 'backpress';
  final String _safeTyNote = 'safetynote';
  final String _firebaseToken = 'firebasetoken';

  //stores
  final String _storeId = 'storeid';
  final String _storeName = 'storename';
  final String _storeImage = 'storeimage';
  final String _storeCategoryId = 'storecategoryid';

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<String?> getFirebaseToken() async {
    var prefs = await _getPrefs();
    return prefs.getString(_firebaseToken);
  }

  @override
  saveFirebaseToken(String token) async {
    var prefs = await _getPrefs();
    prefs.setString(_firebaseToken, token);
  }

  @override
  Future<bool> getGender() async {
    var prefs = await _getPrefs();
    return prefs.getBool(_gender) ?? false;
  }

  @override
  saveGender(bool isMale) async {
    var prefs = await _getPrefs();
    prefs.setBool(_gender, isMale);
  }

  @override
  Future<String?> getAddress() async {
    var prefs = await _getPrefs();
    return prefs.getString(_address);
  }

  @override
  saveAddress(String address) async {
    var prefs = await _getPrefs();
    prefs.setString(_address, address);
  }

  @override
  Future<String?> getPhone() async {
    var prefs = await _getPrefs();
    return prefs.getString(_phone);
  }

  @override
  savePhone(String phone) async {
    var prefs = await _getPrefs();
    prefs.setString(_phone, phone);
  }

  @override
  Future<String?> getEmail() async {
    var prefs = await _getPrefs();
    return prefs.getString(_email);
  }

  @override
  saveEmail(String? email) async {
    var prefs = await _getPrefs();
    prefs.setString(_email, email ?? '');
  }

  @override
  Future<String?> getUserId() async {
    var prefs = await _getPrefs();
    return prefs.getString(_userId);
  }

  @override
  saveUserId(String userId) async {
    var prefs = await _getPrefs();
    prefs.setString(_userId, userId);
  }

  @override
  saveOccupation(String occupation) async {
    var prefs = await _getPrefs();
    prefs.setString(_occupation, occupation);
  }

  @override
  Future<String?> getOccupation() async {
    var prefs = await _getPrefs();
    return prefs.getString(_occupation);
  }

  @override
  Future<String?> getFullName() async {
    var prefs = await _getPrefs();
    return prefs.getString(_fullName);
  }

  @override
  saveFullName(String? fullName) async {
    var prefs = await _getPrefs();
    prefs.setString(_fullName, fullName ?? '');
  }

  @override
  Future<String?> getAvatar() async {
    var prefs = await _getPrefs();
    return prefs.getString(_avatar);
  }

  @override
  saveAvatar(String? avatarUrl) async {
    var prefs = await _getPrefs();
    prefs.setString(_avatar, avatarUrl ?? '');
  }

  @override
  saveDateCreated(String? date) async {
    var prefs = await _getPrefs();
    prefs.setString(_dateCreated, date ?? '');
  }

  @override
  Future<String?> getDateCreated() async {
    var prefs = await _getPrefs();
    return prefs.getString(_dateCreated);
  }

  @override
  Future<String?> getSafetyNote() async {
    var prefs = await _getPrefs();
    return prefs.getString(_safeTyNote);
  }

  @override
  saveSafetyNote(String note) async {
    var prefs = await _getPrefs();
    prefs.setString(_safeTyNote, note);
  }

  @override
  Future<String?> getLatestVersion() async {
    var prefs = await _getPrefs();
    return prefs.getString(_latestVersion);
  }

  @override
  saveLatestVersion(String version) async {
    var prefs = await _getPrefs();
    prefs.setString(_latestVersion, version);
  }

  @override
  Future<int> getTotalBackpresses() async {
    var prefs = await _getPrefs();
    return prefs.getInt(_backPresses) ?? 0;
  }

  @override
  registerBackPress() async {
    var prefs = await _getPrefs();
    var currentBackPress = await getTotalBackpresses();
    prefs.setInt(_backPresses, currentBackPress + 1);
  }

  @override
  clearPrefs() async {
    var prefs = await _getPrefs();
    prefs.remove(_userId);
    prefs.remove(_fullName);
    prefs.remove(_avatar);
    prefs.remove(_email);
    prefs.remove(_phone);
    prefs.remove(_address);
    prefs.remove(_gender);
    prefs.remove(_occupation);
    prefs.remove(_dateCreated);
    prefs.remove(_taluka);
    prefs.remove(_talukaId);
    prefs.remove(_locality);
    prefs.remove(_storeName);
    prefs.remove(_storeImage);
    prefs.remove(_storeId);
    prefs.remove(_storeCategoryId);
  }

  @override
  Future<String> getLocality() async {
    var prefs = await _getPrefs();
    return prefs.getString(_locality) ?? '';
  }

  @override
  Future<String> getTaluka() async {
    var prefs = await _getPrefs();
    return prefs.getString(_taluka) ?? '';
  }

  @override
  Future<String> getTalukaId() async {
    var prefs = await _getPrefs();
    return prefs.getString(_talukaId) ?? '';
  }

  @override
  saveLocality(String? locality) async {
    var prefs = await _getPrefs();
    prefs.setString(_locality, locality ?? '');
  }

  @override
  saveTaluka(String? taluka) async {
    var prefs = await _getPrefs();
    prefs.setString(_taluka, taluka ?? '');
  }

  @override
  saveTalukaId(String? talukaId) async {
    var prefs = await _getPrefs();
    prefs.setString(_talukaId, talukaId ?? '');
  }

  @override
  Future<String> getStoreCategoryId() async {
    var prefs = await _getPrefs();
    return prefs.getString(_storeCategoryId) ?? '';
  }

  @override
  Future<String> getStoreId() async {
    var prefs = await _getPrefs();
    return prefs.getString(_storeId) ?? '';
  }

  @override
  Future<String> getStoreImage() async {
    var prefs = await _getPrefs();
    return prefs.getString(_storeImage) ?? '';
  }

  @override
  Future<String> getStoreName() async {
    var prefs = await _getPrefs();
    return prefs.getString(_storeName) ?? '';
  }

  @override
  saveStoreCategoryId(String storeCategoryId) async {
    var prefs = await _getPrefs();
    return prefs.setString(_storeCategoryId, storeCategoryId);
  }

  @override
  saveStoreId(String storeId) async {
    var prefs = await _getPrefs();
    return prefs.setString(_storeId, storeId);
  }

  @override
  saveStoreImage(String storeImage) async {
    var prefs = await _getPrefs();
    return prefs.setString(_storeImage, storeImage);
  }

  @override
  saveStoreName(String storeName) async {
    var prefs = await _getPrefs();
    return prefs.setString(_storeName, storeName);
  }
}

/**ToDo: For any user specific fields added in prefs, you must add entry for same in clearPrefs() callback **/
