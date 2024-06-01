import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/ui/edit_avatar/edit_avatar_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class EditAvatarView extends StatefulWidget {
  @override
  _EditAvatarViewState createState() => _EditAvatarViewState();
}

class _EditAvatarViewState extends State<EditAvatarView> {
  late EditAvatarViewModel _editAvatarViewModel;

  @override
  void initState() {
    super.initState();
    _editAvatarViewModel = locator<EditAvatarViewModel>();
    _editAvatarViewModel.fetchCurrentAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: ViewModelBuilder<EditAvatarViewModel>.reactive(
          builder: (context, viewModel, child) {
            var screenWidth = MediaQuery.of(context).size.width;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  'Profile Picture',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () => _showImageSourceDialog(context)),
                  IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                      onPressed: () => _onDeleteAvatarClicked(context)),
                ],
              ),
              floatingActionButton: Visibility(
                visible: viewModel.getNewAvatarPath != null,
                child: FloatingActionButton(
                  onPressed: () => viewModel.onUpdateAvatarClicked(
                      true, () => Navigator.pop(context, true)),
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                ),
              ),
              body: Container(
                color: Colors.black,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      (viewModel.getCurrentAvatar == null)
                          ? _getEmptyAvatarFrame(screenWidth)
                          : Container(
                              height: screenWidth,
                              child: CachedNetworkImage(
                                  imageUrl: viewModel.getCurrentAvatar!),
                            ),
                      (viewModel.getNewAvatarPath == null)
                          ? Container()
                          : Container(
                              height: screenWidth,
                              child: Image(
                                image: FileImage(
                                    File(viewModel.getNewAvatarPath!)),
                              ),
                            ),
                      Visibility(
                        visible: viewModel.isBusy,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Color(0xCC000000),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          viewModelBuilder: () => _editAvatarViewModel),
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
                    InkWell(
                      onTap: () => _pickImage(true, context),
                      child: ListTile(
                        title: Text('Click New Image'),
                        leading: Icon(Icons.camera),
                      ),
                    ),
                    InkWell(
                      onTap: () => _pickImage(false, context),
                      child: ListTile(
                        title: Text('Choose From Gallery'),
                        leading: Icon(Icons.insert_drive_file),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _getEmptyAvatarFrame(screenWidth) {
    return Container(
      height: screenWidth,
      color: AppConstants.colorLightGrey,
      child: Image(
        image: AssetImage('icons/ic_empty_avatar.png'),
        color: AppConstants.colorDarkGrey,
      ),
    );
  }

  _onDeleteAvatarClicked(context) {
    var alertDialog = AlertDialog(
      title: Text('Sign Out'),
      content:
          Text('Are you sure you want to remove your current profile picture?'),
      actions: [
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _editAvatarViewModel.onDeleteAvatarClicked();
            },
            child: Text('Confirm Delete')),
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  _pickImage(bool isCamera, BuildContext context) async {
    Navigator.pop(context);

    var imagePicker = ImagePicker();
    var image = await imagePicker.getImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery);

    if (image != null) {/*
      var croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          compressQuality: 60,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
      if (croppedFile != null) {
        _editAvatarViewModel.setNewAvatarPath(croppedFile.path);
      }
    */}
  }
}
