import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/login_response.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/transformers.dart';

class LoginViewModel extends ExtendedViewModel {
  var _phoneController = StreamController<String>.broadcast();
  var _dataManager = locator<DataManager>();

  CallStatus _callStatus = CallStatus.Idle;

  CallStatus get getCallStatus => _callStatus;

  Stream<String> get phoneStream =>
      _phoneController.stream.transform(phoneTransformer);

  onPhoneChanged(String s) {
    _phoneController.add(s);
  }

  void onDestroy() {
    _phoneController.close();
  }

  onLoginClicked(
      String phone,
      Function onComplete,
      Future<void> navigation(
          LoginResponse loginResponse, String phone)) async {
    _dataManager.clearPrefs();
    var fcmToken = await _dataManager.getFirebaseToken();
    var loginResponse = await safeAwait(
        future: _dataManager.doLogin(phone, fcmToken??''),
        mapping: (map) => LoginResponse.fromJsonMap(map));

    onComplete.call();

    if (loginResponse != null && loginResponse.status == 200 ||
        loginResponse!.status == 201) {
      await navigation(loginResponse, phone);
    }
  }
}
