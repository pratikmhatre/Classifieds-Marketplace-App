import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/routes/router.gr.dart';
import 'package:digigad/ui/stores/item_registration/item_registration_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class ItemRegistrationView extends StatefulWidget {
  @override
  _ItemRegistrationViewState createState() => _ItemRegistrationViewState();
}

class _ItemRegistrationViewState extends State<ItemRegistrationView> {
  var _nameController = TextEditingController();
  var _itemCategoryController = TextEditingController();
  var _priceController = TextEditingController();
  late ItemRegistrationViewModel _itemRegVieModel;

  @override
  void initState() {
    super.initState();
    _itemRegVieModel = locator<ItemRegistrationViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ItemRegistrationViewModel>.reactive(
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: Text('Item Registration'),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () => _showImageSourceDialog(context),
                        child: viewModel.getItemImagePath == null
                            ? Container(
                                child: Center(
                                  child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey,
                                        size: 35,
                                      )),
                                ),
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFAAAAAA), width: 1.5),
                                    borderRadius: BorderRadius.circular(6)),
                              )
                            : InkWell(
                                onTap: () => _showImageOptionDialog(context),
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(
                                              File(viewModel.getItemImagePath!)),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () => _onSelectCategoryClicked(context),
                      child: _getTextInputField(maxLength: 20,
                          capitalization: TextCapitalization.words,
                          hintText: 'Select Category',
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          isEnabled: false,
                          controller: _itemCategoryController),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _getTextInputField(
                        maxLength: 100,
                        capitalization: TextCapitalization.words,
                        hintText: 'Product Name',
                        inputType: TextInputType.text,
                        inputAction: TextInputAction.done,
                        controller: _nameController),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 200,
                      child: _getTextInputField(
                          maxLength: 7,
                          hintText: 'Minimum Price',
                          inputType: TextInputType.number,
                          inputAction: TextInputAction.done,
                          controller: _priceController),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Food Item',
                      style: TextStyle(
                          color: AppConstants.colorDarkGrey, fontSize: 13),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        _getSelectionBox('Yes', viewModel.getIsFoodItem,
                            () => viewModel.setIsFoodItem(true), false),
                        _getSelectionBox('No', !viewModel.getIsFoodItem,
                            () => viewModel.setIsFoodItem(false), true),
                      ],
                    ),
                    Visibility(
                      visible: viewModel.getIsFoodItem,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Veg Food Item',
                            style: TextStyle(
                                color: AppConstants.colorDarkGrey,
                                fontSize: 13),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: <Widget>[
                              _getSelectionBox(
                                  'Yes',
                                  viewModel.getIsVegFoodItem,
                                  () => viewModel.setIsVegFoodItem(true),
                                  false),
                              _getSelectionBox(
                                  'No',
                                  !viewModel.getIsVegFoodItem,
                                  () => viewModel.setIsVegFoodItem(false),
                                  true),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        AppFunctions.getHeaderTextView('Add Variants',
                            fontSize: 18.0),
                        SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () => _showAddVariantDialog(context),
                          child: Container(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: AppConstants.colorPrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: viewModel.getVariants.length,
                        itemBuilder: (context, index) {
                          var variant = viewModel.getVariants[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(variant.name??''),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text('Rs.${variant.price}'),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: () =>
                                          viewModel.removeVariant(index))
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: 200,
                                height: 1,
                                color: AppConstants.colorDarkGrey,
                              )
                            ],
                          );
                        }),
                    SizedBox(
                      height: 50,
                    ),
                    AppFunctions.getBigButton(
                        title: 'Save Product',
                        onClick: () => _onSaveProductClicked())
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => _itemRegVieModel);
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
                  : AppConstants.colorPrimaryGrey,
              borderRadius: BorderRadius.circular(4)),
        ),
      );

  _showAddVariantDialog(BuildContext context) {
    var vNameController = TextEditingController();
    var vPriceController = TextEditingController();

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                padding: MediaQuery.of(context).viewInsets,
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppFunctions.getHeaderTextView('Provide Details',
                        fontSize: 16),
                    SizedBox(
                      height: 16,
                    ),
                    _getVariantInput(
                        hintText:
                            'add quantity like 100 gm, 100 ml, 200 ml etc',
                        labelText: 'Variant Name',
                        maxLength: 10,
                        controller: vNameController),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: 150,
                      child: _getVariantInput(
                          hintText: 'Price',
                          labelText: 'Variant Price',
                          maxLength: 6,
                          controller: vPriceController,
                          inputType: TextInputType.number),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        var name = vNameController.text.trim();
                        if (name.length < 3) {
                          _showToast('Please provide valid variant name');
                          return;
                        }
                        var price = vPriceController.text.trim();
                        if (price.length < 2) {
                          _showToast('Please provide variant price');
                          return;
                        }
                        _itemRegVieModel.addVariant(name, price);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        child: Center(
                            child: Text(
                          'Save',
                          style: TextStyle(color: AppConstants.colorPrimary),
                        )),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppConstants.colorPrimary, width: 1),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _getVariantInput(
      {required int maxLength,
        required String hintText,
        required String labelText,
      TextInputType inputType = TextInputType.text,
        required TextEditingController controller}) {
    return TextField(
      controller: controller,
      maxLines: 1,
      maxLength: maxLength,
      style:
          TextStyle(color: AppConstants.colorText, fontSize: 16, height: 1.5),
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppConstants.colorDarkGrey)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppConstants.colorPrimary)),
        contentPadding: EdgeInsets.all(0),
        counterStyle: TextStyle(fontSize: 0),
        labelText: labelText ,
        labelStyle: TextStyle(
          color: AppConstants.colorHint,
        ),
      ),
    );
  }

  _onEditImageClicked() async {/*
    var croppedFile = await ImageCropper.cropImage(
        sourcePath: _itemRegVieModel.getItemImagePath, compressQuality: 80);
    _itemRegVieModel.updateImage(croppedFile.path);
  */}

  _showImageOptionDialog(BuildContext context) {
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
                        _onEditImageClicked();
                      },
                      child: ListTile(
                        title: Text('Edit This Image'),
                        leading: Icon(Icons.brightness_medium),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _itemRegVieModel.deleteImage();
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

  _onSelectCategoryClicked(BuildContext buildContext) async {
    // TODO: Handle back data

    buildContext.router.push(ItemCategoryViewRoute());


    /*ItemCategory category =
        await ExtendedNavigator.ofRouter<RoutesHolder>().pushItemCategoryView();
    _itemCategoryController.text = category?.name;*/
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
    var imagePicker = ImagePicker();
    var pick =
        await imagePicker.getImage(source: imageSource, imageQuality: 100);
    if (pick?.path != null) {
      _itemRegVieModel.setItemImage(pick!.path);
    }
  }

  Widget _getTextInputField(
      {required int maxLength,
        required String hintText,
      int maxLines = 1,
        required TextInputType inputType,
      TextCapitalization capitalization = TextCapitalization.none,
      TextEditingController? controller,
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

  void _showToast(String s) {
    Fluttertoast.showToast(msg: s);
  }

  _onSaveProductClicked() {
    if (_itemRegVieModel.getItemImagePath == null) {
      _showToast('Please select product image');
      return;
    }

    var name = _nameController.text.trim();
    if (name.length < 5) {
      _showToast('Please provide valid product name');
      return;
    }

    var price = _priceController.text.trim();
    if (price.length < 2) {
      _showToast('Please provide valid product price');
      return;
    }

    _itemRegVieModel.saveProduct(name, price);
  }
}
