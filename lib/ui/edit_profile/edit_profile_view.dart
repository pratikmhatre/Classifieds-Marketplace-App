import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/data/network/response/master_response.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

import 'edit_profile_viewmodel.dart';

class EditProfileView extends StatefulWidget {
  final bool isFromMenu;

  EditProfileView(this.isFromMenu);

  @override
  _EditProfileViewState createState() => _EditProfileViewState(isFromMenu);
}

class _EditProfileViewState extends State<EditProfileView> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _localityController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  late EditProfileViewmodel _profileViewmodel;
  bool isFromMenu;

  _EditProfileViewState(this.isFromMenu);

  @override
  void initState() {
    super.initState();
    _profileViewmodel = locator<EditProfileViewmodel>();
    _profileViewmodel.fetchProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppConstants.colorText),
      ),
      body: ViewModelBuilder<EditProfileViewmodel>.reactive(
          builder: (context, model, child) {
            _phoneController.text = _profileViewmodel.getPhone ?? '';
            _nameController.text = _profileViewmodel.getFullName ?? '';
            _emailController.text = _profileViewmodel.getEmail ?? '';
            _localityController.text = _profileViewmodel.getLocality ?? '';
            ImageProvider backgroundImage;
            if (model.getAvatar != null) {
              backgroundImage = CachedNetworkImageProvider(model.getAvatar!);
            } else {
              backgroundImage = AssetImage('icons/ic_empty_avatar.png');
            }
            return SafeArea(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              AppFunctions.getHeaderTextView('Profile'),
                              GestureDetector(
                                onTap: () => _onAvatarClicked(),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppConstants.colorDarkGrey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: backgroundImage,
                                  ),
                                  padding: const EdgeInsets.all(2.0),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          StreamBuilder<String>(
                              stream: _profileViewmodel.nameStream,
                              builder: (context, snapshot) {
                                return AppFunctions.getTextInputField(
                                  hintText: 'Full Name',
                                  maxLength: 30,
                                  controller: _nameController,
                                  onChanged: _profileViewmodel.onNameChanged,
                                  errorText: snapshot.error as String,
                                  inputType: TextInputType.text,
                                  capitalization: TextCapitalization.words,
                                );
                              }),
                          SizedBox(
                            height: 30,
                          ),
                          StreamBuilder<String>(
                              stream: _profileViewmodel.emailStream,
                              builder: (context, snapshot) {
                                return AppFunctions.getTextInputField(
                                  hintText: 'Email',
                                  controller: _emailController,
                                  onChanged: _profileViewmodel.onEmailChanged,
                                  errorText: snapshot.error as String,
                                  maxLength: 30,
                                  inputType: TextInputType.emailAddress,
                                );
                              }),
                          SizedBox(
                            height: 30,
                          ),
                          AppFunctions.getTextInputField(
                            hintText: 'Mobile Number',
                            maxLength: 10,
                            isEnabled: false,
                            controller: _phoneController,
                            inputType: TextInputType.phone,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          AppFunctions.getTextInputField(
                            hintText: 'Village/Locality Name',
                            maxLength: 60,
                            errorText: null,
                            controller: _localityController,
                            inputType: TextInputType.text,
                            capitalization: TextCapitalization.words,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Select Taluka',
                            style: TextStyle(
                                color: AppConstants.colorDarkGrey,
                                fontSize: 13),
                          ),
                          InkWell(
                            onTap: () => _showTalukaDialog(context),
                            child: Container(
                              height: 35,
                              width: 250,
                              child: Align(
                                child: Text(
                                  _profileViewmodel.getSelectedTaluka ??
                                      'Select Taluka',
                                  style: TextStyle(
                                      color: AppConstants.colorText,
                                      fontSize: 16),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: AppConstants.colorText,
                                          width: 0.5))),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: AppFunctions.getBigButton(
                        title: 'Save Profile',
                        onClick: () => _onSaveProfileClicked(context)),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ));
          },
          viewModelBuilder: () => _profileViewmodel),
    );
  }

  _onSaveProfileClicked(BuildContext context) async {
    AppFunctions.showProgressDialog(context);

    var name = _nameController.text.trim();

    if (!name.contains(' ')) {
      Fluttertoast.showToast(msg: 'Please provide first & last name');
      return;
    }

    _profileViewmodel.onSubmitDetailsClicked(
        _nameController.text,
        _emailController.text,
        _localityController.text,
        () => isFromMenu
            ? Navigator.pop(context)
            : context.router.navigate(HomeViewRoute()));
  }

  _onAvatarClicked() async {
    //TODO: Handle back data
    context.router.push(EditAvatarViewRoute());

/*    var isAvatarChanged =
    await ExtendedNavigator.ofRouter<Router>().pushEditAvatarView();
    if (isAvatarChanged) {
      _profileViewmodel.onAvatarChanged();
    }*/
  }

  _showTalukaDialog(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 3 / 4;
    AppFunctions.showMasterSelectionBottomSheet(null,
        context: context,
        title: 'Select Taluka',
        isReporting: false,
        masterListFuture: _profileViewmodel.getAllTaluka(),
        bottomsheetHeight: height,
        onMasterSelected: (MasterData s) =>
            _profileViewmodel.onTalukaChanged(s));
  }
}
