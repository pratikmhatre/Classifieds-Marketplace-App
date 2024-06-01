import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/data/network/response/login_response.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:digigad/ui/login/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:digigad/resources/locator.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginViewModel _loginViewModel;
  TextEditingController _phoneTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginViewModel = locator<LoginViewModel>();
  }

  @override
  Widget build(BuildContext buildContext) {
    _phoneTextController.text = '9405518774';
    return ViewModelBuilder<LoginViewModel>.reactive(
        builder: (context, model, child) {
          var screenHeight = MediaQuery.of(context).size.height;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                height: screenHeight,
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'images/iv_logo.png',
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AppFunctions.getHeaderTextView(
                                'Enter Mobile Number To Proceed'),
                            SizedBox(
                              height: 60,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _phoneTextController,
                                    maxLength: 10,
                                    maxLines: 1,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: 'Enter mobile number',
                                    ),
                                    style: TextStyle(),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        _onLoginClicked(
                                            _phoneTextController.text,
                                            buildContext);
                                      },
                                      child: Text('Submit'))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Made with '),
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          Text(' in Alibag'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => _loginViewModel);
  }

  _showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Center(
              child: CircularProgressIndicator(
                strokeWidth: 6,
              ),
            ));
  }

  _onLoginClicked(String data, BuildContext context) async {
    await _loginViewModel.onLoginClicked(
        data,
        () => Navigator.pop(context),
        (LoginResponse loginResponse, String phone) => AutoRouter.of(context)
            .push(OtpViewRoute(phone: phone, loginResponse: loginResponse)));
  }
}
