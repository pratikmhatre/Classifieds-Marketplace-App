import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/request/seller_registration_pojo.dart';
import 'package:digigad/resources/data/network/response/master_response.dart';
import 'package:digigad/resources/data/network/response/seller_registration_response.dart';
import 'package:digigad/resources/extended_viewmodel.dart';
import 'package:digigad/resources/locator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class SellerRegistrationViewModel extends ExtendedViewModel {
  var _sellerPojo = SellerRegistrationPojo();
  String? _coodrinates, _phone;
  int _pagerPosition = 0;
  String? _logoPath;
  bool _isFoodCategory = false;
  var _userId;

  String? get getPrimaryPhone => _phone;
  List<String> _workHoursList = [];
  bool _isHomeDelivery = false;
  bool _isVerificationCodeSent = false;

  bool get getIsFoodCategory => _isFoodCategory;

  String? get getCoordinates => _coodrinates;
  final DataManager _dataManager = locator<DataManager>();
  bool _isPureVeg = false;

  int get getPagerPosition => _pagerPosition;

  String? get getLogoPath => _logoPath;

  setPagerPosition(int position) {
    _pagerPosition = position;
    notifyListeners();
  }

  setLogoPath(String path) {
    _logoPath = path;
    notifyListeners();
  }

  bool get getIsPureVeg => _isPureVeg;

  MasterData? _storeCategory;
  MasterData? _storeTaluka;
  List<MasterData>? _allTalukaList;

  bool get isOtpSent => _isVerificationCodeSent;

  String? get getStoreCategoryTitle => _storeCategory?.title;

  String? get getStoreTaluka => _storeTaluka?.title;

  onStoreTalukaSelected(taluka) {
    _storeTaluka = taluka;
    notifyListeners();
  }

  onVerificationCodeSent() {
    _isVerificationCodeSent = true;
    notifyListeners();
  }

  setStoreCategory(MasterData master) {
    _storeCategory = master;
    _isFoodCategory = master.value.contains('food') == true;
    notifyListeners();
  }

  setIsPureVeg(isVeg) {
    _isPureVeg = isVeg;
    notifyListeners();
  }

  List<String> get getWorkHoursList => _workHoursList;

  addWorkHours(String hours) {
    _workHoursList.add(hours);
    notifyListeners();
  }

  bool get getIsHomeDelivery => _isHomeDelivery;

  setIsHomeDelivery(bool isAvailable) {
    _isHomeDelivery = isAvailable;
    notifyListeners();
  }

  fetchData(fetchLocation) async {
    var phone = await _dataManager.getPhone();
    _phone = phone;
    _userId = await _dataManager.getUserId();
    var talukaId = await _dataManager.getTalukaId();
    var taluka = await _dataManager.getTaluka();
    _allTalukaList =
        await _dataManager.getOptionMaster(AppConstants.masterTypeTaluka);
    var userTaluka = _allTalukaList?.firstWhere((element) =>
        element.id.toString() == talukaId &&
        element.title.toString() == taluka);

    _storeTaluka = userTaluka;

    notifyListeners();

    if (fetchLocation) {
      _checkLocationServices();
    }
  }

  _setCoordinates(String coordinates) {
    this._coodrinates = coordinates;
    notifyListeners();
  }

  _checkLocationServices() async {
    var geoLocationStatus =
        await Geolocator.checkPermission();

    if (geoLocationStatus == LocationPermission.always) {
      _fetchCoordinates();
    } else {
      var permission = await Permission.location.request();
      if (permission.isGranted) {
        _fetchCoordinates();
      } else {
        showToast('Location Access Denied');
      }
    }
  }

  _fetchCoordinates() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
    if (position != null) {
      _setCoordinates('${position.latitude},${position.longitude}');
    }
  }

  Future<List<MasterData>> getAllTalukas() async {
    if (_allTalukaList != null) {
      return Future.value(_allTalukaList);
    } else {
      return _dataManager.getOptionMaster(AppConstants.masterTypeTaluka);
    }
  }

  Future<List<MasterData>> getStoreCategories() async {
    return await _dataManager
        .getOptionMaster(AppConstants.masterTypeStoreCategory);
  }

  saveStoreDetails(String storeName, String deliveryNote, String locality, String address, additionalPhone) {
    _sellerPojo.userId = int.parse(_userId);
    _sellerPojo.storeName = storeName;
    _sellerPojo.storeCategory = _storeCategory?.id;
    _sellerPojo.isPureVeg = _isPureVeg;
    _sellerPojo.isHomeDelivery = _isHomeDelivery;
    _sellerPojo.deliveryNote = deliveryNote;
    _sellerPojo.workingHours = _workHoursList.toString();
    _sellerPojo.coordinates = _coodrinates;
    _sellerPojo.locality = locality;
    _sellerPojo.address = address;
    _sellerPojo.additionalPhone = additionalPhone;
    _sellerPojo.taluka = _storeTaluka?.id;
    _onFinalSubmit();
  }

    _onFinalSubmit() async {
    _sellerPojo.image = _logoPath;

    var safeCall = await safeAwait(
        future: _dataManager.registerSeller(_sellerPojo),
        mapping: (m) => SellerRegistrationResponse.fromJson(m));
    if (safeCall == null) {
      Fluttertoast.showToast(msg: 'Failed');
    } else {
      Fluttertoast.showToast(msg: 'Success');
    }
  }

  onPreviousClicked() {
    var finalPosition = _pagerPosition == 0 ? 0 : _pagerPosition - 1;
    setPagerPosition(finalPosition);
  }
}
