import 'dart:io';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/ui/create_ad/createad_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

enum DataInputType { title, price, details, locality }

class CreateAdView extends StatefulWidget {
  final String? cameraImage;

  CreateAdView({this.cameraImage});

  @override
  _CreateAdViewState createState() =>
      _CreateAdViewState(cameraImage: cameraImage);
}

class _CreateAdViewState extends State<CreateAdView> {
  late CreateAdViewModel _createAdViewModel;
  final String? cameraImage;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _localityController = TextEditingController();

  _CreateAdViewState({this.cameraImage});

  @override
  void initState() {
    super.initState();
    _createAdViewModel = locator<CreateAdViewModel>();
    _createAdViewModel.addImage(cameraImage, notify: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewModelBuilder<CreateAdViewModel>.nonReactive(
          builder: (context, viewModel, child) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: Colors.black,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ImageSelectionList(_createAdViewModel),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tap the image to change or edit it',
                            style: TextStyle(
                                fontSize: 14, color: AppConstants.colorText),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _getTitleTextView('Category'),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        _onSelectCategoryClicked(context),
                                    child: StreamBuilder<String>(
                                        stream: viewModel.categoryStream,
                                        builder: (context, snapshot) {
                                          _isCategoryValid = snapshot.hasData &&
                                              snapshot.data
                                                  .toString()
                                                  .trim()
                                                  .isNotEmpty;

                                          return Text(
                                            snapshot.hasData
                                                ? snapshot.data.toString()
                                                : 'Select Category',
                                            style: TextStyle(
                                                color:
                                                    AppConstants.colorPrimary,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          _getInputTextView(
                              'Product Name', 'Enter Product Name',
                              maxLength: 50,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              onChanged: _createAdViewModel.onTitleChanged,
                              stream: _createAdViewModel.titleStream,
                              controller: _titleController,
                              type: DataInputType.title),
                          SizedBox(
                            height: 40,
                          ),
                          _getTitleTextView('Product Condition'),
                          SizedBox(
                            height: 6,
                          ),
                          StreamBuilder<bool>(
                              stream: _createAdViewModel.conditionStream,
                              builder: (context, snapshot) {
                                _isConditionValid = snapshot.hasData;
                                return Row(
                                  children: [
                                    _getConditionButton(
                                        'Used',
                                        (snapshot.hasData)
                                            ? snapshot.data as bool
                                            : false),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    _getConditionButton(
                                        'New',
                                        (snapshot.hasData)
                                            ? !snapshot.data!
                                            : false),
                                  ],
                                );
                              }),
                          SizedBox(
                            height: 40,
                          ),
                          _getInputTextView(
                              'Selling Price', 'Enter Selling Price',
                              maxLength: 7,
                              keyboardType: TextInputType.number,
                              onChanged:
                                  _createAdViewModel.onSellingPriceChanged,
                              stream: _createAdViewModel.sellingPriceStream,
                              isSellingPrice: true,
                              controller: _priceController,
                              type: DataInputType.price),
                          SizedBox(
                            height: 40,
                          ),
                          _getInputTextView(
                              'Product Details', 'Enter Product Details',
                              maxLines: 5,
                              minLines: 3,
                              maxLength: 250,
                              keyboardType: TextInputType.multiline,
                              inputAction: TextInputAction.newline,
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: _createAdViewModel.onDetailsChange,
                              stream: _createAdViewModel.detailsStream,
                              controller: _detailsController,
                              type: DataInputType.details),
                          SizedBox(
                            height: 40,
                          ),
                          _getInputTextView(
                              'Your Locality', 'Enter Village/Locality Name',
                              maxLines: 1,
                              minLines: 1,
                              maxLength: 50,
                              keyboardType: TextInputType.text,
                              inputAction: TextInputAction.done,
                              textCapitalization: TextCapitalization.words,
                              onChanged: _createAdViewModel.onLocalityChanged,
                              stream: _createAdViewModel.localityStream,
                              controller: _localityController,
                              type: DataInputType.details),
                          SizedBox(
                            height: 60,
                          ),
                          AppFunctions.getBigButton(
                              title: 'Submit',
                              onClick: () => _onSubmitDataClicked(context)),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          viewModelBuilder: () => _createAdViewModel),
    );
  }

  _onSelectCategoryClicked(context) {
    var bottomsheetHeight = MediaQuery.of(context).size.height - 100;

    AppFunctions.showMasterSelectionBottomSheet(null,
        context: context,
        onMasterSelected: _createAdViewModel.onCategorySelected,
        isReporting: false,
        title: 'Select Category',
        bottomsheetHeight: bottomsheetHeight,
        masterListFuture: _createAdViewModel.getCategoriesFromDb());
  }

  _getInputTextView(String title, String hint,
          {maxLines = 1,
          minLines = 1,
          keyboardType = TextInputType.text,
          inputAction: TextInputAction.done,
          maxLength,
          textCapitalization = TextCapitalization.none,
          Stream<String>? stream,
          Function? onChanged,
          bool isSellingPrice = false,
          controller,
          DataInputType? type}) =>
      StreamBuilder<String>(
          stream: stream,
          builder: (context, snapshot) {
            var textColor = snapshot.hasError
                ? Colors.redAccent[700]
                : AppConstants.colorText;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getTitleTextView(title, textColor: textColor!),
                Container(
                  margin: EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                      color: Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Visibility(
                          visible: isSellingPrice,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Center(
                              child: Text(
                                '\u{20B9}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            /*onChanged: onChanged!,*/
                            textCapitalization: textCapitalization,
                            textAlign: TextAlign.start,
                            maxLength: maxLength,
                            keyboardType: keyboardType,
                            textInputAction: inputAction,
                            maxLines: maxLines,
                            minLines: minLines,
                            controller: controller,
                            decoration: InputDecoration(
                                counterStyle: TextStyle(fontSize: 0),
                                counterText: '',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                fillColor: Colors.grey,
                                hintText: hint,
                                hintStyle: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          });

  _getConditionButton(String s, bool isSelected) {
    return InkWell(
      onTap: () => _createAdViewModel.onConditionSelected(s == 'Used'),
      child: Container(
        height: 42,
        width: 80,
        child: Center(
          child: Text(
            s,
            style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppConstants.colorPrimary
                    : AppConstants.colorText),
          ),
        ),
        decoration: BoxDecoration(
            color:
                isSelected ? AppConstants.colorPrimaryGrey : Colors.transparent,
            border: Border.all(
                color: isSelected
                    ? AppConstants.colorPrimary
                    : AppConstants.colorDarkGrey,
                width: 1),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  _getTitleTextView(String s, {Color textColor = AppConstants.colorText}) {
    return Text(
      s,
      style: TextStyle(
          color: textColor, fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  _showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircularProgressIndicator(
                        strokeWidth: 6,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Hold on, we are creating your advertisement.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  _onSubmitDataClicked(context) async {
    if (!_validateInput()) {
      return;
    }
    _showProgressDialog(context);

    await _createAdViewModel.postAd(() => _showOnAddSuccessDialog(context),
        productName: _titleController.text,
        details: _detailsController.text,
        sellingPrice: _priceController.text,
        locality: _localityController.text);
  }

  bool _validateInput() {
    if (_createAdViewModel.getImageList != null) {
      bool isListEmpty =
          _createAdViewModel.getImageList!.every((element) => element == null);
      if (isListEmpty) {
        _showToast('Please select atleast one image of product');
        return false;
      }
    }

    if (!_isCategoryValid) {
      _showToast('Please select product category');
      return false;
    }

    if (_titleController.text.length < 6) {
      _showToast('Please provide product name');
      return false;
    }

    if (!_isConditionValid) {
      _showToast('Please select if product is used or new');
      return false;
    }

    if (_priceController.text.length < 3) {
      _showToast('Please provide approximate selling price');
      return false;
    }

    if (_detailsController.text.length < 30) {
      _showToast('Please describe your product in minimum of 30 charecters');
      return false;
    }
    if (_localityController.text.length < 4) {
      _showToast('Please provide Village/Locality name');
      return false;
    }

    _isCategoryValid = true;
    _isConditionValid = true;
    return true;
  }

  var _isCategoryValid = false;
  var _isConditionValid = false;

  _showToast(message) {
    Fluttertoast.showToast(msg: message);
  }

  _showOnAddSuccessDialog(BuildContext context) async {
    var screenWidth = MediaQuery.of(context).size.width;
    await showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: 400,
                width: screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'images/img_share.png',
                      width: 250,
                    ),
                    Text(
                      'Great, Your Advertisement\nIs Now LIVE.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Share the deal across your network and let people know what you are selling.',
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        _createAdViewModel.onShareAdClicked();
                      },
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        child: Center(
                            child: Text(
                          'Share Now',
                          style: TextStyle(
                              color: AppConstants.colorPrimary, fontSize: 16),
                        )),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppConstants.colorPrimary, width: 1.5)),
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          );
        }).then((value) {
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    });
  }
}

class ImageSelectionList extends StatelessWidget {
  late final CreateAdViewModel _createAdViewModel;
  final ImagePicker imagePicker = ImagePicker();
  late double _widthPerItem;

  ImageSelectionList(this._createAdViewModel);

  @override
  Widget build(BuildContext context) {
    _widthPerItem = (MediaQuery.of(context).size.width - (16 * 3)) * (2 / 5);

    return ViewModelBuilder<CreateAdViewModel>.reactive(
        builder: (context, viewModel, child) {
          return Container(
            height: _widthPerItem,
            child: ListView.builder(
                itemCount: viewModel.getImageList?.length ?? 0,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, position) {
                  var path = viewModel.getImageList?[position];
                  return (path == null)
                      ? _getEmptyImageView(position, context)
                      : _getValidImageView(context, path, position);
                }),
          );
        },
        viewModelBuilder: () => _createAdViewModel);
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

  _getEmptyImageView(int position, BuildContext context) => InkWell(
        onTap: () => _showImageSourceDialog(context),
        child: Container(
          child: Center(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 35,
                )),
          ),
          margin: EdgeInsets.only(left: 16, right: (position == 4) ? 16 : 0),
          width: _widthPerItem,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFAAAAAA), width: 1.5),
              borderRadius: BorderRadius.circular(6)),
        ),
      );

  _getValidImageView(BuildContext context, path, int position) {
    return GestureDetector(
      onTap: () => _showImageOptionDialog(context, path, position),
      child: Container(
        margin: EdgeInsets.only(left: 16, right: (position == 4) ? 16 : 0),
        width: _widthPerItem,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: FileImage(File(path)), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  _onEditImageClicked(path, int position) async {/*
    var croppedFile =
        await ImageCrop.cropImage(sourcePath: path, compressQuality: 80);
    _createAdViewModel.updateImage(croppedFile?.path, position);
  */}

  _onSelectImageClicked(ImageSource imageSource, BuildContext context) async {
    Navigator.pop(context);
    var pick =
        await imagePicker.getImage(source: imageSource, imageQuality: 100);
    if (pick?.path != null) {
      _createAdViewModel.addImage(pick!.path);
    }
  }

  _showImageOptionDialog(BuildContext context, String path, int position) {
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
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        _onEditImageClicked(path, position);
                      },
                      child: ListTile(
                        title: Text('Edit This Image'),
                        leading: Icon(Icons.brightness_medium),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _createAdViewModel.deleteImage(position);
                      },
                      child: ListTile(
                        title: Text('Remove This Image'),
                        leading: Icon(Icons.delete_forever),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
