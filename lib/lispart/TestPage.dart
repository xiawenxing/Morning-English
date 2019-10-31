import 'package:flutter/material.dart';
import 'PlayPage.dart';
import 'LyricLoad.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:ui';
import 'dart:math';
import 'resource.dart';
import 'listenTapbar.dart';
import 'timemarker.dart';
import 'sizeAdapter.dart';



class TestPage extends StatefulWidget{
  ListenResource resource;
  TestPage(ListenResource src){
    resource = src;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _testPage();
  }
}

class _testPage extends State<TestPage>{
  AudioPlayer audioPlayer;
  double volume = 1.0;
  int currentindex;
  bool isplaying;
  bool isstarted = false;
  bool isshowans = false;

  List<String> testCompleteLines;
  List<String> testLines;
  List<String> answers;


  void prepareTest(){
    testLines = new List<String>(LisOrTestPage.timepoints.length);
    testCompleteLines = new List<String>(LisOrTestPage.timepoints.length);
    answers = new List<String>(LisOrTestPage.timepoints.length);

    int i;
    for(i=0; i<LisOrTestPage.timepoints.length-1; i++){
      testCompleteLines[i]="";
      for(int j=LisOrTestPage.timepoints[i].posindex; j<LisOrTestPage.timepoints[i+1].posindex; j++)
        {
          testCompleteLines[i]+=(LisOrTestPage.lyriclines[j]+" \n");
        }
    }
    testCompleteLines[i]="";
    for(int j=LisOrTestPage.timepoints[i].posindex; j<LisOrTestPage.lyriclines.length; j++){
      testCompleteLines[i]+=(LisOrTestPage.lyriclines[j]+" \n");
    }


    testLines = new List<String>(testCompleteLines.length);
    answers = new List<String>(testCompleteLines.length);
    List<String> lyriwords;
    List<String> answords;
    List<int> posi;


    for(int i=0; i<testCompleteLines.length;i++ ){
        lyriwords = testCompleteLines[i].split(' ');
        posi = new List<int>();
        int blanknum =  9;
        answords = new List<String>();
        int maxtimes = 200;
        while(posi.length<blanknum&& maxtimes>=0){
          int r = Random().nextInt(lyriwords.length);
          if((!lyriwords[r].contains("\n")) && !posi.contains(r)
            && !lyriwords[r].contains(r'[0-9]')&& !lyriwords[r].contains(r'[/u4e00-/u9fa5]')
          ){
//            answords.add(lyriwords[r]);
//            lyriwords[r]="----";
            posi.add(r);
          }
          maxtimes--;
        }

        posi.sort();
        for(int j=0; j<posi.length; j++)
        {
            answords.add(lyriwords[posi[j]]);
            lyriwords[posi[j]]="_____";
        }

        testLines[i]="";
        answers[i]="";
        for(int j=0; j<lyriwords.length; j++){
          testLines[i]+=(lyriwords[j]+" ");
        }
        for(int j=0; j<answords.length; j++){
          answers[i]+=(answords[j]+" ");
        }
//        print(testLines[i]);
//        print(answers[i]);
    }
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    audioPlayer = new AudioPlayer();
    currentindex=0;
    isstarted = false;
    isplaying = false;
    isshowans = false;
    audioPlayer.setUrl(widget.resource.audiourl);
    audioPlayer.setVolume(volume);
    audioPlayer
      ..positionHandler = ((position){
        if(mounted){
          setState(() {
            if(currentindex+1<LisOrTestPage.timepoints.length)
            if(position != null&&position.inSeconds>LisOrTestPage.timepoints[currentindex+1].time.inSeconds){
              audioPlayer.pause();
            }
          });
        }
      });
  }

  void load(bool isDownFileAnyWay) async{

    // 下载歌词
    LyricLoad load = new LyricLoad(widget.resource);
    print("start load");
    LisOrTestPage.allines = await load.down(isDownFileAnyWay);

    // 初始化纯歌词列表、时间标记
    LisOrTestPage.lyriclines = new List<String>();
    LisOrTestPage.timepoints = new List<timemarker>();

    if(LisOrTestPage.allines == null){
      LisOrTestPage.lyriclines.add("文字加载失败...");
    }else{
      print("load success");
      RegExp timereg = new RegExp(r"\[[0-9]+:[0-9]+\]");
      String time;
      for(int i=0; i<LisOrTestPage.allines.length; i++)
      {
        time = timereg.stringMatch(LisOrTestPage.allines[i]);
        if(time!=null)
        {
          LisOrTestPage.timepoints.add(new timemarker(time.toString(), LisOrTestPage.lyriclines.length));
        }else{
          LisOrTestPage.lyriclines.add(LisOrTestPage.allines[i]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return new Scaffold(
        backgroundColor: Color.fromRGBO(239, 245, 252, 1),//背景颜色
        body: new GestureDetector(
          child:
          isstarted ? _testview(context) : _start(context),
          onTap: (){
                if(isstarted == false){
                setState(() {
                  prepareTest();
                  isstarted = true;
                });}
            },
        ),
    );
  }


  Future<void> _refreshLyric() async{
    await load(true);
    prepareTest();
    setState(() {

    });
  }

  Widget _testview(context){
    return
      new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Expanded(
            child:new RefreshIndicator(
            onRefresh: _refreshLyric,
            child:ListView.builder(
                padding: EdgeInsets.only(top: sizeAdapter.adaptbyHeight(50),
                    bottom: sizeAdapter.adaptbyHeight(50)
                ),
                itemCount: LisOrTestPage.timepoints.length,
                itemBuilder: (context,index){
                  return new ListTile(
                    leading: IconButton(
                      icon:Icon((isplaying&&currentindex==index)?Icons.pause:Icons.play_circle_outline,
                          color: Color.fromRGBO(125, 163, 206, 1)),
                      onPressed: (){
                        isplaying = !isplaying;
                        setState(() {
                          currentindex = index;
                          print(isplaying.toString());
                          if(isplaying){
                            audioPlayer.seek(LisOrTestPage.timepoints[index].time);
                            audioPlayer.resume();
                          }
                          else audioPlayer.pause();
                        });
                      },
                    ),
                    title:new Text(
                      testLines[index],
                      style: new TextStyle(
                          color: Color.fromRGBO(30, 62, 98, 1),
                          fontSize: sizeAdapter.adaptbySize(17),
                          letterSpacing: sizeAdapter.adaptbySize(0.6),
                          wordSpacing: 4,
                          height: 1.5
                      ),
                    )
                  );
                }
            ))),
            new Container(
              height: sizeAdapter.adaptbyHeight(120),
              child: new Row(
                children:<Widget>[
                  new Padding(
                    padding: EdgeInsets.all(sizeAdapter.adaptbyWid(16)),
                    child:new IconButton(
                        icon: Icon(Icons.remove_red_eye,
                            color: Color.fromRGBO(125, 163, 206, 1)
                        ),
                        onPressed: (){
                          setState(() {
                            isshowans = !isshowans;
                          });

                        })
                  ),
                  new Container(
                        width: sizeAdapter.adaptbyWid(250),
                        child:
                        isshowans?new Text(
                          answers[currentindex],
                          style: new TextStyle(
                            color: Color.fromRGBO(30, 62, 98, 1),
                            fontSize: sizeAdapter.adaptbySize(14)),
//                          overflow: TextOverflow.ellipsis,
                        ):new Text("查看答案",style: new TextStyle(
                            color: Color.fromRGBO(30, 62, 98, 1),
                            fontSize: sizeAdapter.adaptbySize(14)),),

                  )
                ]
              ),
            )
        ]
      );
  }

  @override
  void deactivate(){
    audioPlayer.pause();
  }


  Widget _start(context){
    return new Container(
          alignment: Alignment.center,
          child:new Icon(Icons.play_circle_outline,
                size: sizeAdapter.adaptbySize(200),
                color: Color.fromRGBO(125, 163, 206, 0.5),
          )
        );
  }


}