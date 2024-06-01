import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/plain_response.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditAvatarViewModel extends ExtendedViewModel {
  var _dataManager = locator<DataManager>();

  String? _currentAvatar;

  String? _newAvatarPath;

  String? get getNewAvatarPath => _newAvatarPath;

  String? get getCurrentAvatar => _currentAvatar;

  setNewAvatarPath(avatarPath) {
    _newAvatarPath = avatarPath;
    _setCurrentAvatar(null);
  }

  _setCurrentAvatar(avatar) {
    _currentAvatar = avatar;
    notifyListeners();
  }

  fetchCurrentAvatar() async {
    var avatar = await _dataManager.getAvatar();
    _setCurrentAvatar(avatar);
  }

  onDeleteAvatarClicked() {
    onUpdateAvatarClicked(false, null);
    _setCurrentAvatar(null);
  }

  onUpdateAvatarClicked(bool isAdding, Function? onComplete) async {
    if (_newAvatarPath != null) {
      setBusy(true);
      var userId = await _dataManager.getUserId();
      var plainResponse = await safeAwait(
          future:
              _dataManager.updateUserAvatar(isAdding, userId??'', _newAvatarPath!),
          mapping: (map) => PlainResponse.fromJsonMap(map));
      setBusy(false);
      if (plainResponse != null) {
        if (plainResponse.status == 201) {
          _dataManager.saveAvatar(plainResponse.message);
          Fluttertoast.showToast(msg: 'Profile Picture Updated');
        } else if (plainResponse.status == 200) {
          _dataManager.saveAvatar(null);
          Fluttertoast.showToast(msg: 'Profile Picture Removed');
        }
        onComplete?.call();
      }
    }
  }
}
