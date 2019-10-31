import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DiscoveryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>new _DiscoveryPageState();
}
class _DiscoveryPageState extends State<DiscoveryPage>{

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