import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/ads.dart';
import 'package:digigad/resources/data/network/response/plain_response.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';

class MenuViewModel extends ExtendedViewModel {
  var _dataManager = locator<DataManager>();
  List<Ads> _adsList = [];
  String? _appVersion;
  bool _isUpdateAvailable = false;

  String? get getAppVersion => _appVersion;

  String? _fullName, _avatarUrl, _joinedAgo;

  List<Ads> get getAdList => _adsList;

  String? get getFullName => _fullName;

  String? get getAvatarUrl => _avatarUrl;

  String? get getJoinedAgo => _joinedAgo;

  bool get getIsUpdateAvailable => _isUpdateAvailable;

  fetchAppVersion() async {
    var latestVersion = await _dataManager.getLatestVersion();
    var packageInfo = await PackageInfo.fromPlatform();
    this._appVersion = packageInfo.version;
    this._isUpdateAvailable = this._appVersion != latestVersion;
    notifyListeners();
  }

  onSignOutClicked() {
    _dataManager.clearPrefs();
  }

  submitFeedback(String feedback, Function onComplete) async {
    setBusy(true);
    var userId = await _dataManager.getUserId();
    var plainResponse = await safeAwait(
        future: _dataManager.sendFeedback(userId, feedback),
        mapping: (map) => PlainResponse.fromJsonMap(map));
    setBusy(false);
    onComplete.call();
    Fluttertoast.showToast(msg: 'Thank You');
  }
}
