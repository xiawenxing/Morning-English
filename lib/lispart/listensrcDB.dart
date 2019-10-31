import "package:sqflite/sqflite.dart";
import "dart:io";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";
import "dart:async";
import "resource.dart";
import "package:shared_preferences/shared_preferences.dart";

class ListenBookDB{
  static SharedPreferences isdownloaded = null;
  static Database _listenbookdb;
  static String dbname = "ListenBookDB.db";
  static String dbpath = "";

  ListenBookDB(){
    init();
  }

  void init() async {
    // 初始化数据库的路径信息  清空目录
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    dbpath = join(documentsDirectory.path, dbname);

      try{
        await new Directory(dirname(dbpath)).create(recursive: true);
      }catch(e){
        print(e.toString());
      }

    // 初始化sharedpref路径信息
    if(isdownloaded == null){
      isdownloaded = await SharedPreferences.getInstance();
      for(int i=0; i<ListenBookList.booknum;i++){
        isdownloaded.setBool("isdownlistenBook"+(i+1).toString(), false);
      }
    }
  }

  void setDownloadTrue(int index){
    isdownloaded.setBool("isdownlistenBook"+(index+1).toString(), true);
  }

  void setDownloadFalse(int index){
    isdownloaded.setBool("isdownlistenBook"+(index+1).toString(), false);
  }

  bool isBookDownDB(int index){
    return isdownloaded.getBool("isdownlistenBook"+(index+1).toString());
  }

  void opendb() async{
    _listenbookdb = await openDatabase(dbpath);
  }

  void closedb() async{
    await _listenbookdb.close();
  }


  Future<void> createTable(String tablename) async{
    List<Map> maplist;
    try{
      maplist = await queryrowAll(tablename);
      if(maplist!=null)
      {
        await _listenbookdb.execute("DROP TABLE $tablename");
      }
    }catch(e){
      print(e);
    }
    await _listenbookdb.execute('''CREATE TABLE $tablename (name TEXT PRIMARY KEY,audiourl TEXT,fileurl TEXT, audioLocalurl TEXT, fileLocalurl TEXT
      )''');
    print("creating table $tablename");
  }

  Future<void> addrow(String tablename,ListenResource src) async {
//    await _listenbookDB.rawInsert('''
//      INSERT INTO $tablename VALUES(?,?,?,?,?)
//    ''');
    await _listenbookdb.insert(tablename, src.toMap());
  }

  Future<void> deleteByname(String tablename, String name) async {
//    await _listenbookDB.rawDelete(''' 
//      DELETE FROM $tablename WHERE $condition
//    ''');
    await _listenbookdb.delete(tablename, where: "name=?", whereArgs: [name]);
  }

  Future<void> updaterow(String tablename, String name, ListenResource newsrc) async {
//    await _listenbookDB.rawUpdate('''
//      UPDATE $tablename SET audiourl=?, fileurl=?, audioLocalurl =?, fileLocalurl=? WHERE name = '$name'
//    ''',[audiourl,fileurl,audioLocalurl,fileLocalurl]);
    await _listenbookdb.update(tablename, newsrc.toMap(), where: "name=?", whereArgs: [name]);
  }

  Future<List> queryrowAll(String tablename) async {
    List<Map> list = await _listenbookdb.rawQuery('''
      SELECT * FROM $tablename
    ''');
    return list;
  }

  Future<Map> querySrcB(String tablename, String name)async{
    var res = await _listenbookdb.rawQuery(''' 
      SELECT * FROM $tablename WHERE name=?
    ''',[name]);

    if(res.length==0)return null;
    else return res.first;
  }
}