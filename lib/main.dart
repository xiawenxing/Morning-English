import "package:flutter/material.dart";
import "BottomNavi.dart";
import 'package:flutter/services.dart';
import 'dart:async';
import 'wordpart/util/WordDatabaseHelper.dart';
import 'package:leancloud_flutter_plugin/leancloud_flutter_plugin.dart';
import 'wordpart/Globals.dart' as Globals;
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(new MyApp());
}


void init() async{
  if(Globals.DB.WordDB==null){
    Globals.DB.WordDB=WordDatabaseHelper.instance;
  }
  LeancloudFlutterPlugin leancloudFlutterPlugin = LeancloudFlutterPlugin.getInstance();
  String appId = "EovsOGWqLF2GjebRb75WVBqJ-MdYXbMMI";//"""QAWcNjepPy81eAAoSKGwIgvW-gzGzoHsz";
  String appKey = "XVhCoNOYsBimajcg4RIz9qKb";//"""Ac3XvwgKKSDnbfF29D8zn3tk";
  leancloudFlutterPlugin.setLogLevel(LeancloudLoggerLevel.DEBUG);
  leancloudFlutterPlugin.setRegion(LeancloudCloudRegion.NorthChina);
  leancloudFlutterPlugin.initialize(appId, appKey);
  if(Globals.Storage.prefs==null){
    Globals.Storage.prefs = await SharedPreferences.getInstance();
  }
  for(int i=0;i<Globals.Books.isDownloaded.length;i++){
    if(Globals.Storage.prefs.getBool('isDownloaded'+(i+1).toString())==null){
      await Globals.Storage.prefs.setBool('isDownloaded'+(i+1).toString(), Globals.Books.isDownloaded[i]);
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      initialRoute: '/',
      theme:new ThemeData(
          brightness:Brightness.light,
          backgroundColor: Colors.white),
      home:new SplashScreen(),
      routes:{
        '/home':(BuildContext context)=>new homeBottomNavigation(),//new Index()
      },
    );
  }
}

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreenState createState()=>new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  startTimer() async{
    var _duration=new Duration(seconds:1);
    return new Timer(_duration,navigationPage);
  }
  void navigationPage(){
    setState(() {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }
  @override
  void initState(){
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context){
    return new Scaffold(
        body:ConstrainedBox(child:
        new Image.asset('images/welcomepage.png',fit:BoxFit.cover),
          constraints:new BoxConstraints.expand(),
        )
    );
  }
}

