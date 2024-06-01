import 'package:digigad/resources/data/data_manager.dart';
import 'package:digigad/resources/data/data_manager_class.dart';
import 'package:digigad/resources/data/fcm_helper.dart';
import 'package:digigad/ui/all_categories/all_categories_viewmodel.dart';
import 'package:digigad/ui/edit_avatar/edit_avatar_viewmodel.dart';
import 'package:digigad/ui/edit_profile/edit_profile_viewmodel.dart';
import 'package:digigad/ui/my_ads/my_ads_viewmodel.dart';
import 'package:digigad/ui/store_details/store_details_view.dart';
import 'package:digigad/ui/store_details/store_details_viewmodel.dart';
import 'package:digigad/ui/stores/item_registration/item_registration_viewmodel.dart';
import 'package:digigad/ui/stores/resto_list/store_list_viewmodel.dart';
import 'package:digigad/ui/stores/select_item_category/item_category_viewmodel.dart';
import 'package:digigad/ui/stores/seller_dashboard/store_menu_viewmodel.dart';
import 'package:digigad/ui/stores/seller_registration/seller_registration_viewmodel.dart';
import 'package:digigad/ui/stores/strore_pdp/StorePdpViewModel.dart';

import 'data/db/db_class.dart';
import 'data/network/repository.dart';
import 'data/prefs/shared_prefs.dart';
import 'package:digigad/ui/ad_details/addetails_viewmodel.dart';
import 'package:digigad/ui/adlist/adlist_viewmodel.dart';
import 'package:digigad/ui/create_ad/createad_viewmodel.dart';
import 'package:digigad/ui/dashboard/dashboard_view.dart';
import 'package:digigad/ui/dashboard/dashboard_viewmodel.dart';
import 'package:digigad/ui/home/home_viewmodel.dart';
import 'package:digigad/ui/login/login_viewmodel.dart';
import 'package:digigad/ui/menu/menu_view.dart';
import 'package:digigad/ui/menu/menu_viewmodel.dart';
import 'package:digigad/ui/otp/otp_viewmodel.dart';
import 'package:digigad/ui/splash/splash_viewmodel.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<DataManager>(
      () => DataManagerClass(DbClass(), SharedPrefs(), Repository()));

  locator.registerFactory(() => AdlistViewModel());
  locator.registerFactory(() => AdDetailsViewModel());
  locator.registerFactory(() => CreateAdViewModel());
  locator.registerFactory(() => SplashViewmodel());
  locator.registerFactory(() => LoginViewModel());
  locator.registerFactory(() => EditProfileViewmodel());
  locator.registerFactory(() => OtpViewModel());
  locator.registerFactory(() => DashboardViewmodel());
  locator.registerFactory(() => HomeViewModel());
  locator.registerFactory(() => MenuViewModel());
  locator.registerFactory(() => DashboardView());
  locator.registerFactory(() => MenuView());
  locator.registerFactory(() => AllCategoriesViewmodel());
  locator.registerFactory(() => EditAvatarViewModel());
  locator.registerFactory(() => MyAdsViewModel());
  locator.registerFactory(() => SellerRegistrationViewModel());
  locator.registerFactory(() => StoreMenuViewModel());
  locator.registerFactory(() => StorePdpViewModel());
  locator.registerFactory(() => ItemRegistrationViewModel());
  locator.registerFactory(() => ItemCatgoryViewModel());
  locator.registerFactory(() => StoreListViewModel());
  locator.registerFactory(() => StoreDetailsViewModel());
}
