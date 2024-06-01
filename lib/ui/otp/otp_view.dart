import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/data/network/response/login_response.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/ui/otp/otp_viewmodel.dart';
import 'package:flutter/material.dart';

class OtpView extends StatefulWidget {
  final LoginResponse loginResponse;
  final String phone;

  OtpView(this.phone, this.loginResponse);

  @override
  _OtpViewState createState() =>
      _OtpViewState(phone,
          loginResponse: loginResponse);
}

class _OtpViewState extends State<OtpView> {
  final LoginResponse? loginResponse;
  final String _phone;
  late OtpViewModel _otpViewModel;

  var _focusOne = FocusNode();
  var _focusTwo = FocusNode();
  var _focusThree = FocusNode();
  var _focusFour = FocusNode();

  var _textController1 = TextEditingController();
  var _textController2 = TextEditingController();
  var _textController3 = TextEditingController();
  var _textController4 = TextEditingController();

  _OtpViewState(this._phone, {this.loginResponse});

  @override
  void initState() {
    super.initState();
    _otpViewModel = locator<OtpViewModel>();
    _otpViewModel.set(loginResponse, _phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Enter 4 digit code sent to you on ',
                          children: [
                            TextSpan(
                                text: _phone,
                                style: TextStyle(
                                    color: AppConstants.colorPrimary))
                          ],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 26.0,
                              height: 1.5,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _getOtpInput(
                              null, _focusOne, _focusTwo, _textController1),
                          _getOtpInput(
                              _focusOne, _focusTwo, _focusThree,
                              _textController2),
                          _getOtpInput(
                              _focusTwo, _focusThree, _focusFour,
                              _textController3),
                          _getOtpInput(_focusThree, _focusFour, null,
                              _textController4),
                        ],
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      AppFunctions.getBigButton(
                          title: 'Verify',
                          onClick: () => _onSubmitOtpClicked(context)),
                      SizedBox(
                        height: 60,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Didn\'t received a verification code ?',
                          style: TextStyle(
                              color: AppConstants.colorHint, fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => _otpViewModel.onResendOtpClicked(),
                            child: Text(
                              'Resend Code',
                              style: TextStyle(
                                  color: AppConstants.colorPrimary,
                                  fontSize: 14),
                            ),
                          ),
                          Text(
                            ' | ',
                            style: TextStyle(
                                color: AppConstants.colorPrimary, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () =>
                                context.router.pop(),
                            child: Text(
                              'Change Number',
                              style: TextStyle(
                                  color: AppConstants.colorPrimary,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _onSubmitOtpClicked(BuildContext context) async {
    AppFunctions.showProgressDialog(context);
    var stringData = _textController1.text +
        _textController2.text +
        _textController3.text +
        _textController4.text;

    await _otpViewModel.performManualValidation(stringData, context.router);
        Navigator.pop(context);
  }
}

Widget _getOtpInput(FocusNode? previousNode, FocusNode focusNode,
    FocusNode? nextFocusNode, TextEditingController controller) {
  return Container(
    width: 50,
    height: 50,
    child: TextField(
      focusNode: focusNode,
      textAlign: TextAlign.center,
      controller: controller,
      maxLength: 1,
      onChanged: (s) {
        if (s.isNotEmpty) {
          nextFocusNode == null
              ? focusNode.unfocus()
              : nextFocusNode.requestFocus();
        } else {
          if (previousNode != null) {
            previousNode.requestFocus();
          }
        }
      },
      keyboardType: TextInputType.number,
      style: TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        counterStyle: TextStyle(fontSize: 0),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppConstants.colorPrimary),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
      ),
    ),
  );
}
