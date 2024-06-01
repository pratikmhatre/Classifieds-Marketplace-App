import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/locator.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  int _pagerPosition = -1;
  var _dataManager = locator<DataManager>();

  int get getPagerPosition => _pagerPosition;
  int backPresses = 0;

  init() async {
    backPresses = await _dataManager.getTotalBackpresses();
  }

  onPagerPositionChanged(newPosition) {
    _pagerPosition = newPosition;
    notifyListeners();
  }

  registerBackPress() async {
    _dataManager.registerBackPress();
  }
}
