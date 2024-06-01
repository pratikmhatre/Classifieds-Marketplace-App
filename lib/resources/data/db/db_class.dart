import 'package:digigad/resources/data/network/response/master_response.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_helper.dart';

class DbClass implements DbHelper {
  final String _dbName = 'digigad.db';
  final String _tableOptionMaster = 'optionmaster';

  //master fields
  static String masterPk = 'pk';
  static String masterId = 'id';
  static String masterTitle = 'title';
  static String masterTitleMarathi = 'title_mar';
  static String masterValue = 'value';
  static String masterType = 'type';
  static String masterImage = 'image';
  static String masterIcon = 'icon';

  Database? _database;

  Future<Database> _getDataBase() async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_tableOptionMaster ($masterPk INTEGER PRIMARY KEY , $masterId INTEGER , $masterTitle TEXT , $masterTitleMarathi TEXT , $masterValue TEXT  , $masterImage TEXT  , $masterType INTEGER, $masterIcon TEXT)');
  }

  Future<dynamic> addMasters(List<Map<String, dynamic>> list) async {
    var db = await _getDataBase();
    var batch = db.batch();
    for (Map<String, dynamic> map in list) {
      batch.insert(_tableOptionMaster, map);
    }
    var result = await batch.commit(noResult: true);
    return result;
  }

  Future<List<MasterData>> getOptionMaster(int? type) async {
    var db = await _getDataBase();

    var data = await db.rawQuery((type == null)
        ? 'SELECT * FROM $_tableOptionMaster'
        : 'SELECT * FROM $_tableOptionMaster WHERE $masterType = $type');

    return data.map((e) => MasterData.fromJsonMap(e)).toList();
  }

  @override
  Future deleteMaster() async {
    var db = await _getDataBase();
    db.delete(_tableOptionMaster);
    return 0;
  }
}
