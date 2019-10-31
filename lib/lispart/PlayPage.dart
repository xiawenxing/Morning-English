import "package:flutter/material.dart";
import "dart:ui";
import "Player.dart";
import "resource.dart";
import "Lyric.dart";
import "valueshare.dart";
import 'sizeAdapter.dart';

/*
* 播放界面
* */
class ListenPlayerPage extends StatelessWidget{
  Key key =  Key("_audioplay_");

  ListenResource resource;
  static ValueNotifierData posi = new ValueNotifierData(new Duration(minutes: 0,seconds: 0));
  ListenPlayerPage(ListenResource res){
    resource = res;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
      },
      child: Scaffold(
          key: key,
          backgroundColor: Color.fromRGBO(239, 245, 252, 1),//背景颜色
          body: _playview(context)
      ),
    );
  }
  
  Widget _playview(BuildContext context){
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        new Expanded(
            child: new Container(
                alignment: Alignment.center,
//            color: Colors.black54,
                child:new LyricPart(posi,resource)
            )
        ),// 歌词与图片部分
        new Padding(
          key: key,
          padding: EdgeInsets.only(
              bottom: sizeAdapter.adaptbyHeight(5)
          ),
          child:new Player(resource),// 调用player组件，按键+进度条+时间 部分
        ),
      ]
    );// 列：图片+播放相关（控制、进度、时间）
  }

}