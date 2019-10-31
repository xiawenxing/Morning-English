import "package:flutter/material.dart";
import "dart:async";
import "dart:io";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";
import "package:leancloud_flutter_plugin/leancloud_flutter_plugin.dart";
import 'package:dio/dio.dart';
import 'sizeAdapter.dart';

class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _testPage();
}

class _testPage extends State<TestPage> {

  String url = "http://lc-UFDnsMis.cn-n1.lcfile.com/23c6ffeaf6d596b7cb59/unidad%2011.txt";
  String content = "";
  String filepath;
  List<String> filecont;
  int contentindex = 0;

  Future<void> down() async {
    Directory documentdir = await getApplicationDocumentsDirectory();
    filepath = join(documentdir.path, "docfile","unidad 11.txt");
    print(filepath);
    print(dirname(filepath));
    Directory filedir = new Directory(dirname(filepath));
    if (await filedir.exists() == false)
      await filedir.create(recursive: true);


    Dio filedowner = new Dio();
    filedowner.options.connectTimeout = 10000;
    filedowner.options.receiveTimeout = 10000;
    Response res = await filedowner.download(url, filepath);
    if(res.statusCode == 200)
      {
        print("isdown");
      }else{

        print("failed");
    }

    File file = new File(filepath);
    filecont = await file.readAsLines();
  }

  void show(){
    setState(() {
      content = filecont[contentindex++];
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(title: new Text("testdownload"),),
      body: new Column(
          children:<Widget>[
            new RaisedButton(
            onPressed: (){
              down();
            },
            color: Colors.amberAccent,
            child: Text("down")
             ),
    new RaisedButton(
    onPressed: (){
      new sizeAdapter();
    },
    color: Colors.amberAccent,
    child: Text("next")
    ),

          new Text(this.content)
          ]
    ));
  }
}