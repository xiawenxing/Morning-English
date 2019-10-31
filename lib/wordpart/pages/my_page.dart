import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>new _MyPageState();
}
class _MyPageState extends State<MyPage>{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home:new Scaffold(
        body:new Center(
            child: null
        ),
      ),
      theme:new ThemeData(
          brightness:Brightness.light,
          backgroundColor: Colors.white),
    );
  }
}