import 'dart:async';
import 'dart:io';
import 'package:digigad/resources/app_functions.dart';
import 'package:digigad/resources/data/network/response/createad_response.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:path_provider/path_provider.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/master_response.dart';
import 'package:digigad/resources/locator.dart';
import 'package:digigad/resources/transformers.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:share/share.dart';

class CreateAdViewModel extends ExtendedViewModel {
  var _dataManager = locator<DataManager>();
  CreatedAd? _adCreated;
  List<String?> _imageList = List<String?>.generate(5, (index) => null);
  int _categoryIdSelected = -1;
  bool _isUsedConditionSelected = false;

  StreamController<String> _titleStreamBuilder = StreamController.broadcast();
  StreamController<bool> _conditionStreamBuilder = StreamController.broadcast();
  StreamController<String> _categoryStreamBuilder =
      StreamController.broadcast();
  StreamController<String> _sellingPriceStreamBuilder =
      StreamController.broadcast();
  StreamController<String> _detailsStreamBuilder = StreamController.broadcast();
  StreamController<String> _localityStreamBuilder =
      StreamController.broadcast();

  Stream<String> get titleStream =>
      _titleStreamBuilder.stream.transform(titleTransformer);

  Stream<String> get localityStream =>
      _localityStreamBuilder.stream.transform(localityTransformer);

  Stream<String> get sellingPriceStream =>
      _sellingPriceStreamBuilder.stream.transform(sellingPriceTransformer);

  Stream<bool> get conditionStream => _conditionStreamBuilder.stream;

  Stream<String> get categoryStream => _categoryStreamBuilder.stream;

  Stream<String> get detailsStream =>
      _detailsStreamBuilder.stream.transform(detailsTransformer);

  onTitleChanged(s) => _titleStreamBuilder.sink.add(s);

  onSellingPriceChanged(s) => _sellingPriceStreamBuilder.sink.add(s);

  onLocalityChanged(s) => _localityStreamBuilder.sink.add(s);

  onConditionSelected(b) {
    _isUsedConditionSelected = b;
    _conditionStreamBuilder.sink.add(b);
  }

  onDetailsChange(s) => _detailsStreamBuilder.sink.add(s);

  onCategorySelected(MasterData data) {
    _categoryIdSelected = data.id;
    _categoryStreamBuilder.sink.add(data.title);
  }

  @override
  void dispose() {
    super.dispose();
    _categoryStreamBuilder.close();
    _localityStreamBuilder.close();
    _conditionStreamBuilder.close();
    _titleStreamBuilder.close();
    _sellingPriceStreamBuilder.close();
    _detailsStreamBuilder.close();
  }

  List<String?>? get getImageList => _imageList;

  addImage(path, {bool notify = true}) {
    for (int i = 0; i < _imageList.length; i++) {
      if (_imageList[i] == null) {
        _imageList[i] = path;
        break;
      }
    }
    if (notify) {
      notifyListeners();
    }
  }

  updateImage(path, position) {
    try {
      _imageList[position] = path;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<String> _getTempFilePath(userId, String path) async {
    var fileName =
        '${userId}_' + path.substring(path.lastIndexOf('/') + 1, path.length);
    var dir = await getTemporaryDirectory();

    return '${dir.path}/$fileName';
  }

  Future<List<String>> _getCompressedImageList(userId) async {
    List<String> compressedImages = [];
    _imageList.retainWhere((element) => element != null);

    for (String? path in _imageList) {
      if (path != null) {
        String tempFilePath = await _getTempFilePath(userId, path);

        File? compressedFile = await FlutterImageCompress.compressAndGetFile(
          path,
          tempFilePath,
          quality: 100,
          minWidth: 400,
          minHeight: 600,
        );
        if (compressedFile != null) {
          compressedImages.add(compressedFile.path);
        }
      }
    }
    return compressedImages;
  }

  postAd(Function onSuccess,
      {productName, sellingPrice, details, locality}) async {
    var userId = await _dataManager.getUserId();
    var finalImageList = await _getCompressedImageList(userId);

    var response = await safeAwait(
        future: _dataManager.createAdvertisement(
            userId: userId??'',
            title: productName,
            details: details,
            isUsed: _isUsedConditionSelected,
            sellingPrice: sellingPrice,
            categoryId: _categoryIdSelected.toString(),
            latitude: '0.0',
            longitude: '0.0',
            images: finalImageList,
            locality: locality,
            calculate: (String progress) => _onProgressChanged(progress)),
        mapping: (map) => CreateAdResponse.fromJsonMap(map));

    if (response != null) {
      _adCreated = response.ad;
      onSuccess.call();
    }
  }

  _onProgressChanged(String progress) {
    print('Progress : $progress');
  }

  Future<List<MasterData>> getCategoriesFromDb() async {
    var allList = await _dataManager.getOptionMaster(
        AppConstants.masterTypeCategory);

    allList.sort((MasterData a, MasterData b) {
      return int.parse(a.value).compareTo(int.parse(b.value));
    });

    return allList;
  }

  onShareAdClicked() async {
    if (_adCreated != null) {
      FirebaseAnalytics().logShare(
          contentType: _adCreated?.title??'',
          itemId: _adCreated?.id.toString()??'',
          method: 'Dynamic');

      var shortLink = AppFunctions.generateDynamicLink(DynamicLinkType.share_ad,
          adId: _adCreated!.id.toString(),
          title: _adCreated!.title,
          details: _adCreated!.title,
          image: '');

      shortLink.then((value) => Share.share(value));
    }
  }

  deleteImage(int index) {
    try {
      _imageList.removeAt(index);
      _imageList.add(null);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
