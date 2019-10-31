
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csxy/wordpart/model/Word.dart';
import 'BookView.dart';
import 'WordPage.dart';
import 'BookUnitView.dart';
import 'package:csxy/wordpart/Globals.dart' as Globals;
import 'package:csxy/wordpart/util/Downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookListView extends StatefulWidget{

  int Bookid;

  Downloader downloader;

  BookListView(int i){
    this.Bookid=i;
    this.downloader=new Downloader(1,'Book'+(Bookid+1).toString());
  }

  int CalculateListNum(int tmp){
    if(tmp!=0){
      print("CalculateListNum()");
      return (tmp/100).ceil();
    }
  }

  @override
  State<StatefulWidget> createState()=>new _BookListViewState();

}

class _BookListViewState extends State<BookListView>{
  final bgcolor=0xFFEFF5FC;
  int ListNum=null;
  int entryNum=null;


  loadAsyncData() async{
    if(Globals.Storage.prefs.getBool('isDownloaded'+(widget.Bookid+1).toString())!=null&&Globals.Storage.prefs.getBool('isDownloaded'+(widget.Bookid+1).toString())){
      this.entryNum=1+await Globals.DB.WordDB.getTotalNum("Book"+(widget.Bookid+1).toString());
      //print("this.entryNum="+this.entryNum.toString());
      this.ListNum=widget.CalculateListNum(this.entryNum);
      return null;
    }else{
      List<dynamic> res=new List<dynamic>();
      int tmp=await widget.downloader.Start();
      res.add(tmp);
      res.add(widget.CalculateListNum(tmp));
      return res;
    }
  }

  @override
  void initState(){
    loadAsyncData().then((res){
      setState(() {
        if(res!=null){
          this.entryNum=res[0];
          this.ListNum=res[1];
        }
        print("entryNum:"+this.entryNum.toString());
        print("ListNum:"+this.ListNum.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ListNum == null||entryNum==null) {
      // This is what we show while we're loading
      return new MaterialApp(
        home:new Scaffold(
          body:new Container(
            width:MediaQuery.of(context).size.width,
            color: Color(bgcolor),
            child: new Center(
              child: new Text("Downloading...Please wait...",textAlign:TextAlign.center,
                  style:TextStyle(fontFamily:'FlamanteRoma',fontSize:20.0,fontWeight: FontWeight.bold)),
            ),
          ),
          ),
        theme:new ThemeData(
            brightness:Brightness.light,
            backgroundColor: Colors.white),
      );
    }

    // Do something with the `_result`s here
    // TODO: implement build
    return new MaterialApp(
      home:new Scaffold(
        appBar: AppBar(
          title: Text("Libro"+(widget.Bookid+1).toString()),
          elevation:0.5,
          flexibleSpace: Container(color:Colors.grey),
          leading:Builder(
            builder:(BuildContext context){
              return IconButton(icon:new Icon(Icons.home),
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder:
                      (context)=>BookView())
                  );
                },); //add onPress later
            },
          ),
        ),
        body:new Container(
        decoration:new BoxDecoration(
        color: Color(bgcolor),
        ),
          child: _buildLists(ListNum,context),
        ),
      ),
      theme:new ThemeData(
          brightness:Brightness.light,
          backgroundColor: Colors.white),
    );
  }


  Widget _buildLists(int length,BuildContext context) {
    int templength=length*2;
    return new ListView.builder(
      itemCount: templength,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          // add the divider line
          if (i.isOdd) return new Divider();
          int index=i~/2;
          return _buildRow("Lista "+(index+1).toString(),index+1,context);
        }
    );
  }

  Widget _buildRow(String text,int id,BuildContext context) {

    return new ListTile(
      title: new Text(
        text,
        style:TextStyle(color: Colors.black.withOpacity(1.0),fontSize:18.0)
      ),
      onTap:(){
        //await ;
        Navigator.push(context,MaterialPageRoute(builder:
            (context)=>BookUnitView(id,widget.Bookid,entryNum))
        );
      },
    );
  }

}
