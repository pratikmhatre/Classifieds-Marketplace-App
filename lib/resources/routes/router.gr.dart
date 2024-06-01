// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;

import '../../ui/ad_details/addetails_view.dart' as _i8;
import '../../ui/adlist/adlist_view.dart' as _i7;
import '../../ui/all_categories/all_categories_view.dart' as _i11;
import '../../ui/create_ad/createad_view.dart' as _i9;
import '../../ui/dashboard/dashboard_view.dart' as _i12;
import '../../ui/edit_avatar/edit_avatar_view.dart' as _i13;
import '../../ui/edit_profile/edit_profile_view.dart' as _i5;
import '../../ui/home/home_view.dart' as _i3;
import '../../ui/login/login_view.dart' as _i4;
import '../../ui/my_ads/my_ads_view.dart' as _i15;
import '../../ui/otp/otp_view.dart' as _i6;
import '../../ui/search/search_view.dart' as _i10;
import '../../ui/splash/splash_view.dart' as _i2;
import '../../ui/store_details/store_details_view.dart' as _i24;
import '../../ui/stores/item_registration/item_registration_view.dart' as _i22;
import '../../ui/stores/resto_list/store_list_view.dart' as _i17;
import '../../ui/stores/select_item_category/item_category_view.dart' as _i23;
import '../../ui/stores/seller_dashboard/store_menu_view.dart' as _i20;
import '../../ui/stores/seller_menu.dart' as _i18;
import '../../ui/stores/seller_registration/seller_registration_view.dart'
    as _i19;
import '../../ui/stores/strore_pdp/StorePdpView.dart' as _i21;
import '../../ui/view_images/view_images_view.dart' as _i14;
import '../../ui/youtube_play/youtube_player_view.dart' as _i16;
import '../app_constants.dart' as _i26;
import '../data/network/response/ads.dart' as _i27;
import '../data/network/response/images.dart' as _i28;
import '../data/network/response/login_response.dart' as _i25;
import '../data/network/response/store_list.dart' as _i29;

class AppRouter extends _i1.RootStackRouter {
  AppRouter();

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashViewRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i2.SplashView());
    },
    HomeViewRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i3.HomeView());
    },
    LoginViewRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i4.LoginView());
    },
    EditProfileViewRoute.name: (entry) {
      var args = entry.routeData.argsAs<EditProfileViewRouteArgs>();
      return _i1.MaterialPageX(
          entry: entry, child: _i5.EditProfileView(args.isFromMenu));
    },
    OtpViewRoute.name: (entry) {
      var args = entry.routeData.argsAs<OtpViewRouteArgs>();
      return _i1.MaterialPageX(
          entry: entry, child: _i6.OtpView(args.phone, args.loginResponse));
    },
    AdlistViewRoute.name: (entry) {
      var args = entry.routeData.argsAs<AdlistViewRouteArgs>();
      return _i1.MaterialPageX(
          entry: entry,
          child: _i7.AdlistView(
              categoryId: args.categoryId,
              searchQuery: args.searchQuery,
              adListType: args.adListType));
    },
    AdDetailsViewRoute.name: (entry) {
      var args = entry.routeData.argsAs<AdDetailsViewRouteArgs>();
      return _i1.MaterialPageX(
          entry: entry,
          child: _i8.AdDetailsView(args.adData, args.adId, args.position));
    },
    CreateAdViewRoute.name: (entry) {
      var args = entry.routeData
          .argsAs<CreateAdViewRouteArgs>(orElse: () => CreateAdViewRouteArgs());
      return _i1.MaterialPageX(
          entry: entry, child: _i9.CreateAdView(cameraImage: args.cameraImage));
    },
    SearchViewRoute.name: (entry) {
      var args = entry.routeData
          .argsAs<SearchViewRouteArgs>(orElse: () => SearchViewRouteArgs());
      return _i1.MaterialPageX(
          entry: entry,
          child: _i10.SearchView(
              isFromDashboard: args.isFromDashboard,
              searchQuery: args.searchQuery));
    },
    AllCategoriesViewRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i11.AllCategoriesView());
    },
    DashboardViewRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i12.DashboardView());
    },
    EditAvatarViewRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i13.EditAvatarView());
    },
    ViewImagesViewRoute.name: (entry) {
      var args = entry.routeData.argsAs<ViewImagesViewRouteArgs>();
      return _i1.MaterialPageX(
          entry: entry, child: _i14.ViewImagesView(args.imageList));
    },
    MyAdsViewRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i15.MyAdsView());
    },
    YoutubePlayerViewRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i16.YoutubePlayerView());
    },
    StoreListViewRoute.name: (entry) {
      var args = entry.routeData.argsAs<StoreListViewRouteArgs>();
      return _i1.MaterialPageX(
          entry: entry, child: _i17.StoreListView(args.categoryId));
    },
    SellerMenuRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i18.SellerMenu());
    },
    SellerRegistrationViewRoute.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: _i19.SellerRegistrationView());
    },
    StoreMenuViewRoute.name: (entry) {
      var args = entry.routeData.argsAs<StoreMenuViewRouteArgs>();
      return _i1.MaterialPageX(
          entry: entry, child: _i20.StoreMenuView(args.storeList));
    },
    StorePdpViewRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i21.StorePdpView());
    },
    ItemRegistrationViewRoute.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: _i22.ItemRegistrationView());
    },
    ItemCategoryViewRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i23.ItemCategoryView());
    },
    StoreDetailsViewRoute.name: (entry) {
      var args = entry.routeData.argsAs<StoreDetailsViewRouteArgs>();
      return _i1.MaterialPageX(
          entry: entry, child: _i24.StoreDetailsView(args.storeList));
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashViewRoute.name, path: '/'),
        _i1.RouteConfig(HomeViewRoute.name, path: '/home-view'),
        _i1.RouteConfig(LoginViewRoute.name, path: '/login-view'),
        _i1.RouteConfig(EditProfileViewRoute.name, path: '/edit-profile-view'),
        _i1.RouteConfig(OtpViewRoute.name, path: '/otp-view'),
        _i1.RouteConfig(AdlistViewRoute.name, path: '/adlist-view'),
        _i1.RouteConfig(AdDetailsViewRoute.name, path: '/ad-details-view'),
        _i1.RouteConfig(CreateAdViewRoute.name, path: '/create-ad-view'),
        _i1.RouteConfig(SearchViewRoute.name, path: '/search-view'),
        _i1.RouteConfig(AllCategoriesViewRoute.name,
            path: '/all-categories-view'),
        _i1.RouteConfig(DashboardViewRoute.name, path: '/dashboard-view'),
        _i1.RouteConfig(EditAvatarViewRoute.name, path: '/edit-avatar-view'),
        _i1.RouteConfig(ViewImagesViewRoute.name, path: '/view-images-view'),
        _i1.RouteConfig(MyAdsViewRoute.name, path: '/my-ads-view'),
        _i1.RouteConfig(YoutubePlayerViewRoute.name,
            path: '/youtube-player-view'),
        _i1.RouteConfig(StoreListViewRoute.name, path: '/store-list-view'),
        _i1.RouteConfig(SellerMenuRoute.name, path: '/seller-menu'),
        _i1.RouteConfig(SellerRegistrationViewRoute.name,
            path: '/seller-registration-view'),
        _i1.RouteConfig(StoreMenuViewRoute.name, path: '/store-menu-view'),
        _i1.RouteConfig(StorePdpViewRoute.name, path: '/store-pdp-view'),
        _i1.RouteConfig(ItemRegistrationViewRoute.name,
            path: '/item-registration-view'),
        _i1.RouteConfig(ItemCategoryViewRoute.name,
            path: '/item-category-view'),
        _i1.RouteConfig(StoreDetailsViewRoute.name, path: '/store-details-view')
      ];
}

class SplashViewRoute extends _i1.PageRouteInfo {
  const SplashViewRoute() : super(name, path: '/');

  static const String name = 'SplashViewRoute';
}

class HomeViewRoute extends _i1.PageRouteInfo {
  const HomeViewRoute() : super(name, path: '/home-view');

  static const String name = 'HomeViewRoute';
}

class LoginViewRoute extends _i1.PageRouteInfo {
  const LoginViewRoute() : super(name, path: '/login-view');

  static const String name = 'LoginViewRoute';
}

class EditProfileViewRoute extends _i1.PageRouteInfo<EditProfileViewRouteArgs> {
  EditProfileViewRoute({required bool isFromMenu})
      : super(name,
            path: '/edit-profile-view',
            args: EditProfileViewRouteArgs(isFromMenu: isFromMenu));

  static const String name = 'EditProfileViewRoute';
}

class EditProfileViewRouteArgs {
  const EditProfileViewRouteArgs({required this.isFromMenu});

  final bool isFromMenu;
}

class OtpViewRoute extends _i1.PageRouteInfo<OtpViewRouteArgs> {
  OtpViewRoute(
      {required String phone, required _i25.LoginResponse loginResponse})
      : super(name,
            path: '/otp-view',
            args: OtpViewRouteArgs(phone: phone, loginResponse: loginResponse));

  static const String name = 'OtpViewRoute';
}

class OtpViewRouteArgs {
  const OtpViewRouteArgs({required this.phone, required this.loginResponse});

  final String phone;

  final _i25.LoginResponse loginResponse;
}

class AdlistViewRoute extends _i1.PageRouteInfo<AdlistViewRouteArgs> {
  AdlistViewRoute(
      {String? categoryId,
      String? searchQuery,
      required _i26.AdListType adListType})
      : super(name,
            path: '/adlist-view',
            args: AdlistViewRouteArgs(
                categoryId: categoryId,
                searchQuery: searchQuery,
                adListType: adListType));

  static const String name = 'AdlistViewRoute';
}

class AdlistViewRouteArgs {
  const AdlistViewRouteArgs(
      {this.categoryId, this.searchQuery, required this.adListType});

  final String? categoryId;

  final String? searchQuery;

  final _i26.AdListType adListType;
}

class AdDetailsViewRoute extends _i1.PageRouteInfo<AdDetailsViewRouteArgs> {
  AdDetailsViewRoute(
      {required _i27.Ads? adData,
      required String? adId,
      required int? position})
      : super(name,
            path: '/ad-details-view',
            args: AdDetailsViewRouteArgs(
                adData: adData, adId: adId, position: position));

  static const String name = 'AdDetailsViewRoute';
}

class AdDetailsViewRouteArgs {
  const AdDetailsViewRouteArgs(
      {required this.adData, required this.adId, required this.position});

  final _i27.Ads? adData;

  final String? adId;

  final int? position;
}

class CreateAdViewRoute extends _i1.PageRouteInfo<CreateAdViewRouteArgs> {
  CreateAdViewRoute({String? cameraImage})
      : super(name,
            path: '/create-ad-view',
            args: CreateAdViewRouteArgs(cameraImage: cameraImage));

  static const String name = 'CreateAdViewRoute';
}

class CreateAdViewRouteArgs {
  const CreateAdViewRouteArgs({this.cameraImage});

  final String? cameraImage;
}

class SearchViewRoute extends _i1.PageRouteInfo<SearchViewRouteArgs> {
  SearchViewRoute({bool isFromDashboard = true, String? searchQuery})
      : super(name,
            path: '/search-view',
            args: SearchViewRouteArgs(
                isFromDashboard: isFromDashboard, searchQuery: searchQuery));

  static const String name = 'SearchViewRoute';
}

class SearchViewRouteArgs {
  const SearchViewRouteArgs({this.isFromDashboard = true, this.searchQuery});

  final bool isFromDashboard;

  final String? searchQuery;
}

class AllCategoriesViewRoute extends _i1.PageRouteInfo {
  const AllCategoriesViewRoute() : super(name, path: '/all-categories-view');

  static const String name = 'AllCategoriesViewRoute';
}

class DashboardViewRoute extends _i1.PageRouteInfo {
  const DashboardViewRoute() : super(name, path: '/dashboard-view');

  static const String name = 'DashboardViewRoute';
}

class EditAvatarViewRoute extends _i1.PageRouteInfo {
  const EditAvatarViewRoute() : super(name, path: '/edit-avatar-view');

  static const String name = 'EditAvatarViewRoute';
}

class ViewImagesViewRoute extends _i1.PageRouteInfo<ViewImagesViewRouteArgs> {
  ViewImagesViewRoute({required List<_i28.Images> imageList})
      : super(name,
            path: '/view-images-view',
            args: ViewImagesViewRouteArgs(imageList: imageList));

  static const String name = 'ViewImagesViewRoute';
}

class ViewImagesViewRouteArgs {
  const ViewImagesViewRouteArgs({required this.imageList});

  final List<_i28.Images> imageList;
}

class MyAdsViewRoute extends _i1.PageRouteInfo {
  const MyAdsViewRoute() : super(name, path: '/my-ads-view');

  static const String name = 'MyAdsViewRoute';
}

class YoutubePlayerViewRoute extends _i1.PageRouteInfo {
  const YoutubePlayerViewRoute() : super(name, path: '/youtube-player-view');

  static const String name = 'YoutubePlayerViewRoute';
}

class StoreListViewRoute extends _i1.PageRouteInfo<StoreListViewRouteArgs> {
  StoreListViewRoute({required String categoryId})
      : super(name,
            path: '/store-list-view',
            args: StoreListViewRouteArgs(categoryId: categoryId));

  static const String name = 'StoreListViewRoute';
}

class StoreListViewRouteArgs {
  const StoreListViewRouteArgs({required this.categoryId});

  final String categoryId;
}

class SellerMenuRoute extends _i1.PageRouteInfo {
  const SellerMenuRoute() : super(name, path: '/seller-menu');

  static const String name = 'SellerMenuRoute';
}

class SellerRegistrationViewRoute extends _i1.PageRouteInfo {
  const SellerRegistrationViewRoute()
      : super(name, path: '/seller-registration-view');

  static const String name = 'SellerRegistrationViewRoute';
}

class StoreMenuViewRoute extends _i1.PageRouteInfo<StoreMenuViewRouteArgs> {
  StoreMenuViewRoute({required _i29.StoreList storeList})
      : super(name,
            path: '/store-menu-view',
            args: StoreMenuViewRouteArgs(storeList: storeList));

  static const String name = 'StoreMenuViewRoute';
}

class StoreMenuViewRouteArgs {
  const StoreMenuViewRouteArgs({required this.storeList});

  final _i29.StoreList storeList;
}

class StorePdpViewRoute extends _i1.PageRouteInfo {
  const StorePdpViewRoute() : super(name, path: '/store-pdp-view');

  static const String name = 'StorePdpViewRoute';
}

class ItemRegistrationViewRoute extends _i1.PageRouteInfo {
  const ItemRegistrationViewRoute()
      : super(name, path: '/item-registration-view');

  static const String name = 'ItemRegistrationViewRoute';
}

class ItemCategoryViewRoute extends _i1.PageRouteInfo {
  const ItemCategoryViewRoute() : super(name, path: '/item-category-view');

  static const String name = 'ItemCategoryViewRoute';
}

class StoreDetailsViewRoute
    extends _i1.PageRouteInfo<StoreDetailsViewRouteArgs> {
  StoreDetailsViewRoute({required _i29.StoreList storeList})
      : super(name,
            path: '/store-details-view',
            args: StoreDetailsViewRouteArgs(storeList: storeList));

  static const String name = 'StoreDetailsViewRoute';
}

class StoreDetailsViewRouteArgs {
  const StoreDetailsViewRouteArgs({required this.storeList});

  final _i29.StoreList storeList;
}
