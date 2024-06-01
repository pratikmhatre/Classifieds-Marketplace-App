import 'dart:async';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/master_response.dart';
import 'package:digigad/resources/data/network/response/update_profile_response.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/transformers.dart';

extension on String? {
  bool isValueValid() {
    return this != null && this!.trim().isNotEmpty && !this!.contains('null');
  }
}

class EditProfileViewmodel extends ExtendedViewModel {
  StreamController<String> _nameController = StreamController.broadcast();
  StreamController<String> _emailController = StreamController.broadcast();
  var _dataManager = locator<DataManager>();
  MasterData? _talukaSelected;
  String? _phone, _fullName, _email, _locality, _avatar;

  String? get getPhone => _phone;

  String? get getFullName => _fullName;

  String? get getEmail => _email;

  String? get getLocality => _locality;

  String? get getAvatar => _avatar;

  String? get getSelectedTaluka => _talukaSelected?.title;
  List<MasterData>? _allTalukaList;

  onTalukaChanged(MasterData taluka) {
    _talukaSelected = taluka;
    notifyListeners();
  }

  Stream<String> get nameStream =>
      _nameController.stream.transform(nameTransformer);

  Stream<String> get emailStream =>
      _emailController.stream.transform(emailTransformer);

  onNameChanged(String name) {
    _nameController.sink.add(name);
  }

  onEmailChanged(String email) {
    _emailController.sink.add(email);
  }

  void onDestroy() {
    _nameController.close();
    _emailController.close();
  }

  fetchProfileDetails() async {
    _phone = await _dataManager.getPhone();

    String? fullName = await _dataManager.getFullName();
    if (fullName.isValueValid()) {
      _fullName = fullName;
    }

    var email = await _dataManager.getEmail();
    if (email.isValueValid()) {
      _email = email;
    }

    var locality = await _dataManager.getLocality();
    if (locality.isValueValid()) {
      _locality = locality;
    }

    var talukaId = await _dataManager.getTalukaId();
    var taluka = await _dataManager.getTaluka();
    _allTalukaList =
    await _dataManager.getOptionMaster(AppConstants.masterTypeTaluka);
    var userTaluka = _allTalukaList?.firstWhere((element) =>
    element.id.toString() == talukaId &&
        element.title.toString() == taluka);

    _talukaSelected = userTaluka;
    notifyListeners();
  }

  onAvatarChanged() async {
    this._avatar = await _dataManager.getAvatar();
    notifyListeners();
  }

  Future<List<MasterData>> getAllTaluka() async {
    if (_allTalukaList != null) {
      return Future.value(_allTalukaList);
    } else {
      return _dataManager.getOptionMaster(AppConstants.masterTypeTaluka);
    }
  }

  onSubmitDetailsClicked(
      String name, email, locality, Function onComplete) async {
    var userId = await _dataManager.getUserId();

    var updateProfile = await safeAwait(
        future: _dataManager.updateProfile(
            userId, name, email, locality, _talukaSelected?.id),
        mapping: (map) => UpdateProfileResponse.fromJson(map));

    if (updateProfile != null) {
      _dataManager.saveFullName(name);
      _dataManager.saveEmail(email);

      _dataManager.saveLocality(locality);
      _dataManager.saveTaluka(_talukaSelected?.title??'');
      _dataManager.saveTalukaId(_talukaSelected?.id.toString()??'');

      showToast('Pofile Data Updated');
      onComplete.call();
    } else {
      onSomethingWentWrong();
    }
  }
}
