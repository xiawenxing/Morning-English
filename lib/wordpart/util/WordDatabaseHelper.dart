import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/Word.dart';
import 'package:csxy/wordpart/Globals.dart' as Globals;
import 'package:path_provider/path_provider.dart';


final String columnId = 'id';
final String columnChinese = 'Chinese';
final String columnType = 'Type';
final String columnSpanish= 'Spanish';

class WordDatabaseHelper{

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "Words.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  WordDatabaseHelper._privateConstructor();
  static final WordDatabaseHelper instance = WordDatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {

    Globals.booksname.forEach((bookname)  {

      String temp=bookname;

      db.execute('''
      CREATE TABLE $temp($columnId INTEGER PRIMARY KEY,$columnSpanish TEXT,$columnType TEXT,$columnChinese TEXT
      )
      ''');

    });
  }

  // Database helper methods:
  Future<int> insert(Word word,String tablename) async {
    Database db = await database;
    int id = await db.insert(tablename, word.toMap());
    //print("Insert data!");
    return id;
  }

  Future<List<Word>> queryWord(String tablename,int Listid,int Unitid) async {
    Database db = await database;
    List<Map> res =await db.query(tablename,
        columns: [columnId, columnSpanish, columnType, columnChinese],
        where: '$columnId >= ? and $columnId <= ?',
        whereArgs: [((Listid-1)*100+10*(Unitid-1)+1).toString(),((Listid-1)*100+10*Unitid).toString()]);
    List<Word> list=new List<Word>();
    if(res.length==0){
      return null;
    }else{
      for(int i=0;i<res.length;i++){
        list.add(Word.fromMap(res[i]));
      }
      return list;
    }
  }

  Future<int> getTotalNum(String tablename) async {
    Database db = await database;
    int res = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM "+tablename));
    return res;
  }

//
//  Future<int> getNum(String tablename,int Listid) async {
//    Database db = await database;
//    int res = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM ? WHERE Id >=? AND Id <= ?"
//        ,[tablename,((Listid-1)*100+1).toString(),(Listid*100).toString()]));
//    return res;
//  }

}