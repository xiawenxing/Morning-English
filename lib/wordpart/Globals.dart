// ignore: library_names
library flutter_app.Globals;
import 'util/WordDatabaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
* 2--aniaml
3-modern vocabulary
4-Law
5-primary
6-fruit
7-电器
8-职业
9-football*/

class Books{
  static int bookNum=9;
  static List bookNames=['Spanish Syllabus VIII Vocabulary','动物词汇','现代西班牙语',
  '法律词汇', '初学必备', '水果词汇', '电器词汇','职业词汇','足球词汇'];
  static List bookImages=['SpanishSyllabusVIIIVocabulary.png','animal.png',
  'modernspanish.png','law.png','primaryvocabulary.png',
    'fruit.png','utility.png','vocation.png','football.png'];
  static List<bool> isDownloaded=[false,false,false,false,false,false,false,false,false];//,false];
}

class DB{
  static WordDatabaseHelper WordDB=null;
}

class Storage{
  static SharedPreferences prefs=null;
}


final List booksname=['Book1','Book2','Book3','Book4','Book5','Book6','Book7','Book8','Book9'];//,'Book2'];
final List WordNum=[6566,34,8796,75,2344,20,86,56,58];//,0];

