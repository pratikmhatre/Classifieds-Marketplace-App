import 'package:digigad/resources/data/network/response/master_response.dart';

abstract class DbHelper {
  Future<dynamic> addMasters(List<Map<String, dynamic>> list);

  Future<List<MasterData>> getOptionMaster(int? type);

  Future deleteMaster();
}
