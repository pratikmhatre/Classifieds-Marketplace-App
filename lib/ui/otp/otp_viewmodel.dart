import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/login_response.dart';
import 'package:digigad/resources/data/network/response/plain_response.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OtpViewModel extends ExtendedViewModel {
  LoginResponse? _loginResponse;
  String? _phone;
  var _dataManager = locator<DataManager>();

  set(LoginResponse? loginResponse, String? phone) {
    _loginResponse = loginResponse;
    _phone = phone;
    showToast('Verification code sent');
  }

  onResendOtpClicked() async {
    setBusy(true);
    var fcmToken = await _dataManager.getFirebaseToken();

    var plainResponse = await safeAwait(
        future: _dataManager.doLogin(_phone??'', fcmToken??'', isResend: true),
        mapping: (map) => PlainResponse.fromJsonMap(map));
    setBusy(false);
    if (plainResponse != null && plainResponse.status == 200) {
      Fluttertoast.showToast(msg: 'Verification code sent');
    }
  }

  _saveData(StackRouter router) async {
    if (_loginResponse != null && _phone != null) {
      _dataManager.saveUserId(_loginResponse!.data.userId.toString());
      _dataManager.savePhone(_phone!);

      if (_loginResponse!.status == 200) {
        _dataManager.saveFullName(_loginResponse!.data.name);
        _dataManager.saveEmail(_loginResponse!.data.emailId);
        _dataManager.saveAvatar(_loginResponse!.data.avatar);
        _dataManager.saveDateCreated(_loginResponse?.data.date_created);
        _dataManager.saveLocality(_loginResponse?.data.locality);
        _dataManager.saveTaluka(_loginResponse?.data.taluka);
        _dataManager.saveTalukaId(_loginResponse?.data.talukaId);

        router.navigate(HomeViewRoute());
      } else {
        _dataManager.saveDateCreated(_loginResponse!.data.date_created);

        router.navigate(EditProfileViewRoute(isFromMenu: false));
      }
    }
  }

  performManualValidation(String otp, StackRouter router) async {
    setBusy(true);
    if (_loginResponse != null) {
      var plainResponse = await safeAwait(
          future:
              _dataManager.verifyOtp(_loginResponse!.data.userId, _phone, otp),
          mapping: (map) => PlainResponse.fromJsonMap(map));
      setBusy(false);
      if (plainResponse != null && plainResponse.status == 200) {
        _saveData(router);
      } else {
        Fluttertoast.showToast(
            msg: 'Verification failed, please enter correct verification code');
      }
    }
  }
}
