import 'dart:io';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/data/network/response/master_response.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/ui/stores/seller_registration/seller_registration_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

class SellerRegistrationView extends StatefulWidget {
  @override
  _SellerRegistrationViewState createState() => _SellerRegistrationViewState();
}

class _SellerRegistrationViewState extends State<SellerRegistrationView>
    with SingleTickerProviderStateMixin {
  var _isAdditionalPhoneVerified = false;
  var _storeNameController = TextEditingController();
  var _primaryPhoneController = TextEditingController();
  var _deliveryNoteController = TextEditingController();
  var _additionalPhoneController = TextEditingController();
  var _otpController = TextEditingController();
  var _coordController = TextEditingController();
  var _localityController = TextEditingController();
  var _addressController = TextEditingController();
  var _storeNameFocus = FocusNode();
  var _deliveryFocus = FocusNode();
  var _additionalPhoneFocus = FocusNode();
  var _localityFocus = FocusNode();
  var _addressFocus = FocusNode();
  late SellerRegistrationViewModel _storeRegistrationViewModel;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, vsync: this, length: 3);
    _storeRegistrationViewModel = locator<SellerRegistrationViewModel>();
    _checkForLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SellerRegistrationViewModel>.reactive(
        builder: (context, viewModel, child) {
          var screenWidth = MediaQuery.of(context).size.width;
          _tabController.index = viewModel.getPagerPosition;
          _coordController.text = viewModel.getCoordinates ?? '';
          _primaryPhoneController.text = viewModel.getPrimaryPhone ?? '';
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Seller Registration',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _getStoreDetailsView(context),
                  _getAddressView(context),
                  _getStoreImageView(context),
                  TextButton(
                      onPressed: () => _runStoreDetailsValidation(),
                      child: Container(
                        width: screenWidth,
                        margin: EdgeInsets.only(bottom: 50),
                        height: 50,
                        child: Center(child: Text('Submit')),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppConstants.colorButton),
                      ))
                ],
              ),
            ),
          );
        },
        viewModelBuilder: () => _storeRegistrationViewModel);
  }

  _getStoreDetailsView(BuildContext context) {
    var isHomeDelivery = _storeRegistrationViewModel.getIsHomeDelivery;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          _getTextInputField(
              controller: _storeNameController,
              hintText: 'Store Name',
              inputType: TextInputType.text,
              capitalization: TextCapitalization.words,
              maxLength: 100,
              focusNode: _storeNameFocus,
              nextFocus: _additionalPhoneFocus),
          SizedBox(
            height: 30,
          ),
          Text(
            'Select Store Category',
            style: TextStyle(color: AppConstants.colorDarkGrey, fontSize: 13),
          ),
          InkWell(
            onTap: () => _showStoreCategoryDialog(context),
            child: Container(
              height: 35,
              child: Align(
                child: Text(
                  _storeRegistrationViewModel.getStoreCategoryTitle ??
                      'Store Category',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppConstants.colorText, fontSize: 16),
                ),
                alignment: Alignment.centerLeft,
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: AppConstants.colorDarkGrey, width: 1))),
            ),
          ),
          Visibility(
            visible: _storeRegistrationViewModel.getIsFoodCategory,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Food Type',
                  style: TextStyle(
                      color: AppConstants.colorDarkGrey, fontSize: 13),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    _getSelectionBox(
                        'Pure Veg',
                        _storeRegistrationViewModel.getIsPureVeg,
                        () => _storeRegistrationViewModel.setIsPureVeg(true),
                        false),
                    _getSelectionBox(
                        'Veg & Non Veg',
                        !_storeRegistrationViewModel.getIsPureVeg,
                        () => _storeRegistrationViewModel.setIsPureVeg(false),
                        true),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Item Delivery',
            style: TextStyle(color: AppConstants.colorDarkGrey, fontSize: 13),
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: <Widget>[
              _getSelectionBox(
                  'Only Take Away',
                  !isHomeDelivery,
                  () => _storeRegistrationViewModel.setIsHomeDelivery(false),
                  false),
              _getSelectionBox(
                  'Home Delivery',
                  isHomeDelivery,
                  () => _storeRegistrationViewModel.setIsHomeDelivery(true),
                  true),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Visibility(
            visible: _storeRegistrationViewModel.getIsHomeDelivery,
            child: Column(
              children: [
                _getTextInputField(
                    hintText: 'Add Delivery Note',
                    controller: _deliveryNoteController,
                    maxLength: 100,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    focusNode: _deliveryFocus,
                    capitalization: TextCapitalization.sentences),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Text(
            'Work Hours',
            style: TextStyle(color: AppConstants.colorDarkGrey, fontSize: 13),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            height: 30,
            child: Row(
              children: <Widget>[
                ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        _storeRegistrationViewModel.getWorkHoursList.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      var workHour =
                          _storeRegistrationViewModel.getWorkHoursList[index];

                      return Container(
                        height: 30,
                        margin: EdgeInsets.only(left: index == 0 ? 0 : 16),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: AppConstants.colorText),
                            borderRadius: BorderRadius.circular(4)),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                workHour,
                                style: TextStyle(
                                    color: AppConstants.colorText,
                                    fontSize: 12),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.delete_forever,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                InkWell(
                  onTap: () => _showTimePicker(context, true),
                  child: Container(
                    height: 30,
                    margin: EdgeInsets.only(left: 0),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Add',
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.colorLightGrey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  _getAddressView(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            _getTextInputField(
                controller: _coordController,
                hintText: 'Store Location',
                inputType: TextInputType.text,
                isEnabled: false,
                maxLength: 50),
            SizedBox(
              height: 26,
            ),
            _getTextInputField(
                controller: _localityController,
                hintText: 'Locality / Village Name',
                inputType: TextInputType.text,
                isEnabled: true,
                maxLength: 50,
                capitalization: TextCapitalization.words,
                focusNode: _localityFocus,
                nextFocus: _addressFocus),
            SizedBox(
              height: 26,
            ),
            _getTextInputField(
                controller: _addressController,
                hintText: 'Full Address',
                capitalization: TextCapitalization.sentences,
                inputType: TextInputType.text,
                isEnabled: true,
                maxLength: 150,
                focusNode: _addressFocus,
                nextFocus: null,
                inputAction: TextInputAction.done),
            SizedBox(
              height: 30,
            ),
            Text(
              'Select Taluka',
              style: TextStyle(color: AppConstants.colorDarkGrey, fontSize: 13),
            ),
            InkWell(
              onTap: () => _showTalukaDialog(context),
              child: Container(
                height: 35,
                width: 250,
                child: Align(
                  child: Text(
                    _storeRegistrationViewModel.getStoreTaluka ??
                        'Select Taluka',
                    style:
                        TextStyle(color: AppConstants.colorText, fontSize: 16),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: AppConstants.colorText, width: 0.5))),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _getTextInputField(
              hintText: 'Primary Phone Number',
              controller: _primaryPhoneController,
              maxLength: 10,
              inputType: TextInputType.number,
              isEnabled: false,
            ),
            SizedBox(
              height: 26,
            ),
            _getTextInputField(
                controller: _additionalPhoneController,
                hintText: 'Additional Phone Number',
                inputType: TextInputType.number,
                maxLength: 10,
                inputAction: TextInputAction.done,
                focusNode: _additionalPhoneFocus),
            Visibility(
              visible: _storeRegistrationViewModel.isOtpSent,
              child: Container(
                width: 150,
                margin: EdgeInsets.only(top: 30),
                child: _getTextInputField(
                    controller: _otpController,
                    hintText: 'Verification code',
                    inputType: TextInputType.number,
                    maxLength: 4),
              ),
            ),
          ],
        ),
      );

  _getStoreImageView(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Select Store Image',
            style: TextStyle(color: AppConstants.colorText, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          _storeRegistrationViewModel.getLogoPath == null
              ? DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(6),
                  strokeWidth: 1,
                  color: AppConstants.colorDarkGrey,
                  dashPattern: [10],
                  child: Container(
                    width: 200,
                    height: 200,
                    child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: AppConstants.colorDarkGrey,
                          size: 100,
                        ),
                        onPressed: () => _showImageSourceDialog(context)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
              : Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                          image: FileImage(
                            File(_storeRegistrationViewModel.getLogoPath!),
                          ),
                          fit: BoxFit.cover)),
                ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Upload your business logo or a visiting card',
            style: TextStyle(color: AppConstants.colorDarkGrey, fontSize: 14),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  _showImageSourceDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.symmetric(vertical: 16),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: Text('Click New Image'),
                      leading: Icon(Icons.camera),
                      onTap: () =>
                          _onSelectImageClicked(ImageSource.camera, context),
                    ),
                    ListTile(
                      title: Text('Choose From Gallery'),
                      leading: Icon(Icons.insert_drive_file),
                      onTap: () =>
                          _onSelectImageClicked(ImageSource.gallery, context),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _onSelectImageClicked(ImageSource imageSource, BuildContext context) async {
    Navigator.pop(context);
    final ImagePicker imagePicker = ImagePicker();
    var pick =
        await imagePicker.getImage(source: imageSource, imageQuality: 100);
    if (pick?.path != null) {
      _storeRegistrationViewModel.setLogoPath(pick!.path);
    }
  }

  _getSelectionBox(
          String title, bool isSelected, Function onSelected, bool isSecond) =>
      InkWell(
        onTap: () => onSelected(),
        child: Container(
          height: 40,
          margin: EdgeInsets.only(left: isSecond ? 16 : 0),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
              child: Text(
            title,
            style: TextStyle(
                color: isSelected ? Colors.white : AppConstants.colorText,
                fontSize: 13),
          )),
          decoration: BoxDecoration(
              color: isSelected
                  ? AppConstants.colorPrimary
                  : AppConstants.colorLightGrey,
              borderRadius: BorderRadius.circular(4)),
        ),
      );

  _showTimePicker(BuildContext context, bool isStart) async {
    var startTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: 'Select Start Time');
    Future.delayed(Duration(milliseconds: 500));
    var endTime = await showTimePicker(
        context: context, initialTime: startTime!, helpText: 'Select End Time');

    var workHours =
        '${startTime.format(context)} : ${endTime!.format(context)}';

    _storeRegistrationViewModel.addWorkHours(workHours);
  }

  Widget _getTextInputField(
      {required int maxLength,
      required String hintText,
      int maxLines = 1,
      TextInputType inputType = TextInputType.text,
      TextCapitalization capitalization = TextCapitalization.none,
      required TextEditingController controller,
      TextEditingController? nextController,
      bool isEnabled = true,
      FocusNode? focusNode,
      FocusNode? nextFocus,
      TextInputAction inputAction = TextInputAction.next}) {
    return TextField(
      controller: controller,
      textInputAction: inputAction,
      maxLines: maxLines,
      focusNode: focusNode,
      enabled: isEnabled,
      maxLength: maxLength,
      onSubmitted: (s) => nextFocus?.requestFocus(),
      style:
          TextStyle(color: AppConstants.colorText, fontSize: 16, height: 1.5),
      keyboardType: inputType,
      textCapitalization: capitalization,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppConstants.colorDarkGrey)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppConstants.colorPrimary)),
        contentPadding: EdgeInsets.all(0),
        counterStyle: TextStyle(fontSize: 0),
        labelText: hintText,
        labelStyle: TextStyle(
          color: AppConstants.colorHint,
        ),
      ),
    );
  }

  _runStoreDetailsValidation() {
    var storeName = _storeNameController.text.trim();
    if (!storeName.contains(" ") || storeName.length < 5) {
      _showToast('Please provide valid store name');
      return;
    }

    if (_storeRegistrationViewModel.getStoreCategoryTitle == null) {
      _showToast('Please select store category');
      return;
    }

    if (_storeRegistrationViewModel.getIsHomeDelivery &&
        _deliveryNoteController.text.trim().length < 10) {
      _showToast('Delivery note must contain atleast 10 charecters');
      return;
    }

    if (_storeRegistrationViewModel.getWorkHoursList.isEmpty) {
      _showToast('Please select work hours');
      return;
    }

    _storeRegistrationViewModel.saveStoreDetails(
        storeName,
        _deliveryNoteController.text,
        _localityController.text,
        _addressController.text,
        _additionalPhoneController.text);
  }

  _onSubmitClicked(BuildContext context) {
    switch (_tabController.index) {
      case 0:
        _runStoreDetailsValidation();
        break;
      case 1:
        _runStoreContactDetailsValidation();
        break;
      default:
        _runImageValidation(context);
        break;
    }
  }

  _showToast(message, {isLong = false}) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT);
  }

  void _checkForLocation(BuildContext context) async {
    var status = await Permission.location.status;
    if (status == PermissionStatus.denied) {
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return AlertDialog(
              title: Text(('Location')),
              content: Text(
                  'Your location data will help nearby users to find you easily'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Ignore'),
                    onPressed: () {
                      _storeRegistrationViewModel.fetchData(false);
                      Navigator.pop(context);
                    }),
                FlatButton(
                    onPressed: () {
                      _storeRegistrationViewModel.fetchData(true);
                      Navigator.pop(context);
                    },
                    child: Text('Ok')),
              ],
            );
          });
    } else {
      _storeRegistrationViewModel.fetchData(true);
    }
  }

  _showTalukaDialog(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 3 / 4;
    AppFunctions.showMasterSelectionBottomSheet(null,
        context: context,
        title: 'Select Taluka',
        isReporting: false,
        masterListFuture: _storeRegistrationViewModel.getAllTalukas(),
        bottomsheetHeight: height,
        onMasterSelected: (MasterData s) =>
            _storeRegistrationViewModel.onStoreTalukaSelected(s));
  }

  _showStoreCategoryDialog(BuildContext context) {
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    AppFunctions.showMasterSelectionBottomSheet(null,
        context: context,
        title: 'Select Store Category',
        isReporting: false,
        masterListFuture: _storeRegistrationViewModel.getStoreCategories(),
        bottomsheetHeight: height,
        onMasterSelected: (MasterData s) =>
            _storeRegistrationViewModel.setStoreCategory(s));
  }

  void _runStoreContactDetailsValidation() {
    if (_localityController.text.length < 3) {
      _showToast('Please provide Locality / Village name');
      return;
    }

    if (_addressController.text.length < 10) {
      _showToast('Please provide store address with minimum 10 charecters');
      return;
    }

    if (_additionalPhoneController.text.length < 10) {
      _showToast('Please provide alternate mobile number');
      return;
    }

/*    _storeRegistrationViewModel.saveStoreContactDetails(
        _localityController.text,
        _addressController.text,
        _additionalPhoneController.text);*/
  }

  void _runImageValidation(context) {
    if (_storeRegistrationViewModel.getLogoPath == null) {
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return AlertDialog(
              title: Text('Continue without image ?'),
              content: Text(
                  'You can select your business logo or a visiting card as your store image.'),
              actions: [
                FlatButton(
                  child: Text('Select Image'),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text('Ignore'),
                  onPressed: () {
                    // _storeRegistrationViewModel.onFinalSubmit();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return;
    }

    // _storeRegistrationViewModel.onFinalSubmit();
  }
}
