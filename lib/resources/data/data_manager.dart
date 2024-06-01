import 'db/db_helper.dart';
import 'network/api_helper.dart';
import 'prefs/shared_prefs_helper.dart';

abstract class DataManager implements ApiHelper, SharedPrefsHelper, DbHelper {
  setAccessToken(token);
  getAccessToken();
}
