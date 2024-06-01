import 'package:auto_route/auto_route.dart';
import 'package:digigad/resources/app_constants.dart';
import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/network/response/master_response.dart';
import 'package:digigad/resources/locator.dart';
import 'package:stacked/stacked.dart';

class AllCategoriesViewmodel extends BaseViewModel {
  DataManager _dataManager = locator<DataManager>();

  Future<List<MasterData>> fetchCategoriesFromDb() async {

    var allCategories = await _dataManager.getOptionMaster(
        AppConstants.masterTypeCategory);

    allCategories.sort((MasterData a, MasterData b) {
      return int.parse(a.value).compareTo(int.parse(b.value));
    });

    return allCategories;
  }

  onCategorySelected(MasterData data) {
  }
}
