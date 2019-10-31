import "package:flutter/material.dart";
import "dart:ui";
import "package:audioplayers/audioplayers.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "PlayPage.dart";
import 'valueshare.dart';
import 'listenTapbar.dart';
import 'sizeAdapter.dart';
import 'package:csxy/pageRouteChange.dart';
import 'resource.dart';
/*
* 播放器
* */
class Player extends StatefulWidget{
  Key key = new Key('_player_');
  ListenResource src;

  Player(ListenResource resource){
    src = resource;
  }

  @override
  State<StatefulWidget> createState(){
    return _PlayerState(key);
  }

}

/*
 * 播放对象的状态控件
 * */
class _PlayerState extends State<Player>{
  Key key;
  AudioPlayer audioPlayer;
  double volume = 1.0;
  bool isLoaded = false;// 是否在加载中
  Duration duration;// 总时长
  Duration position;// 现在的位置
  double sliderValue;// 进度条位置
  bool isPlaying = false;// 是否开始播放

  _PlayerState(Key key){
    this.key = key;
  }

  void onPrevious() async{
    isPlaying = false;
    audioPlayer.release();
    ListenPlayerPage.posi.value = new Duration(seconds: 0);
    ListenResource src = widget.src;
    ListenBook lisbook = ListenBookList.booklist[src.bookid];
    if(src.partid-1 >= lisbook.book[0].partid)
      Navigator.pushReplacement(context,
          fadePageRouteBuilder(new LisOrTestPage(lisbook.book[src.partid-1-lisbook.book[0].partid])));
  }

  void onNext() async{
    isPlaying = false;
    audioPlayer.release();
    ListenPlayerPage.posi.value = new Duration(seconds: 0);
    ListenResource src = widget.src;
    ListenBook lisbook = ListenBookList.booklist[src.bookid];
    print((lisbook.book[lisbook.book.length-1].partid).toString());
    if(src.partid+1 <= lisbook.book[lisbook.book.length-1].partid)
      Navigator.pushReplacement(context,
          fadePageRouteBuilder(new LisOrTestPage(lisbook.book[src.partid+1-lisbook.book[0].partid])));
  }

  void onCompleted(){
    if(mounted){
    setState(() {
      isPlaying = false;
      position = new Duration(minutes: 0,seconds: 0);
      sliderValue = (position.inSeconds/duration.inSeconds);
      audioPlayer.stop();
      ListenPlayerPage.posi.value = new Duration(minutes: position.inMinutes,
          seconds: (position.inSeconds>60)?(position.inSeconds%60):position.inSeconds);
  });
  }}


  @override
  void initState(){
    super.initState();

    audioPlayer = new AudioPlayer();
    audioPlayer
      ..completionHandler = onCompleted
      ..durationHandler = ((duration){
          setState(() {
            this.duration = duration;
            if(duration!=null){
              isLoaded = true;
            }
          });
        }
      )
      ..positionHandler = ((position){
          setState(() {
            this.position = position;
            ListenPlayerPage.posi.value = new Duration(minutes: position.inMinutes,
                seconds: (position.inSeconds>60)?(position.inSeconds%60):position.inSeconds);
            if(duration != null){
              double val = (position.inSeconds/duration.inSeconds);
              sliderValue = val>1? 1:val;
            }
          });
      });

    audioPlayer.setUrl(widget.src.audiourl);
    audioPlayer.setVolume(volume);
  }


  @override
  void deactivate(){
    audioPlayer.pause();
  }


  @override
  Widget build (BuildContext context){
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: _controllers(context),
    );// 列（控制、进度、时间）
  }

  List<Widget> _controllers(BuildContext context) {
    return [
      new Padding(padding: EdgeInsets.symmetric(horizontal: sizeAdapter.adaptbySize(32)),
        child: new Row( // 控制标签栏
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new IconButton(
              icon: new Icon( // previous icon
                  Icons.skip_previous,
                  size: sizeAdapter.adaptbySize(32),
              ),
              onPressed:isLoaded? () {
                onPrevious();
              }
              :null,
              color: Color.fromRGBO(30, 62, 98, 1),
              disabledColor: Color.fromRGBO(125, 163, 206, 1),
            ),
            new IconButton(
              icon:isLoaded? new Icon( // playing button
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: sizeAdapter.adaptbySize(48.0),
              ):
              new SpinKitCircle(
                  key: widget.key,
                  color: Color.fromRGBO(125, 163, 206, 1),
                  size: sizeAdapter.adaptbySize(48.0)),
              onPressed:isLoaded? () {
                if (isPlaying) {
                  audioPlayer.pause();
                } else {
                  audioPlayer.resume();
                }
                setState(() {
                  isPlaying = !isPlaying;
                  //widget.onPlaying(isPlaying);
                });

              }
              : null
              ,
              padding: EdgeInsets.all(sizeAdapter.adaptbySize(0.0)),
              color: Color.fromRGBO(30, 62, 98, 1),
              disabledColor: Color.fromRGBO(125, 163, 206, 1),
            ),
            new IconButton(
                icon: new Icon( // next button
                    Icons.skip_next,
                    size: sizeAdapter.adaptbySize(32.0),
                ),
              onPressed:isLoaded? () {
                    onNext();
                }
                :null,
              color: Color.fromRGBO(30, 62, 98, 1),
              disabledColor: Color.fromRGBO(125, 163, 206, 1),
            ),
          ], // row stack(three buttons)
        ), // row
      ), // 行：控制
    SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: sizeAdapter.adaptbySize(7),
          disabledThumbRadius: sizeAdapter.adaptbySize(7),
        ),
        disabledActiveTickMarkColor: Color.fromRGBO(125, 163, 206, 1),
        disabledActiveTrackColor: Color.fromRGBO(125, 163, 206, 1),
        disabledInactiveTickMarkColor: Color.fromRGBO(125, 163, 206, 1),
        disabledInactiveTrackColor: Color.fromRGBO(125, 163, 206, 1),
        disabledThumbColor: Color.fromRGBO(125, 163, 206, 1),
      ),
      child: Slider(
        value: sliderValue ?? 0.0,
        onChanged:isLoaded? (double newValue) {
          setState(() {
            sliderValue = newValue;
            if (duration != null) {
              int seconds = (duration.inSeconds * newValue).round();
              audioPlayer.seek(new Duration(seconds: seconds));
            }
          });
        }
        :null,
        activeColor: Color.fromRGBO(30, 62, 98, 1),
      )),// 进度
      new Padding(
        padding: EdgeInsets.symmetric(
            horizontal: sizeAdapter.adaptbyWid(16.0),
            vertical: sizeAdapter.adaptbyHeight(8.0)),
        child: _timer(context),
      ) // 行：时间
    ];
  }

  String _formatDuration(Duration d){
    int minute = d.inMinutes;
    int second = (d.inSeconds>60)?(d.inSeconds%60):d.inSeconds;
    String format = ((minute<10)? "0$minute":"$minute")+":"+(((second<10)?"0$second":"$second"));
    return format;
  }

  Widget _timer(BuildContext context){
    var style = new TextStyle(color:isLoaded? Color.fromRGBO(30, 62, 98, 1):Color.fromRGBO(125, 163, 206, 1));
    return new Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(
          position == null ?"--:--":_formatDuration(position),
          style: style,
        ),
        new Text(
          duration == null?"--:--":_formatDuration(duration),
          style: style,
        ),
      ],
    );
  }// 时间显示组件
}

