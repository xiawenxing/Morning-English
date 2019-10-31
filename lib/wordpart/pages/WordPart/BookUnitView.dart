import 'package:csxy/wordpart/model/Word.dart';
import 'package:flutter/material.dart';
import 'package:csxy/wordpart/Globals.dart' as Globals;
import 'WordPage.dart';
import 'BookListView.dart';


//this is for the detailed word part
class BookUnitView extends StatefulWidget{
  int Listid;
  int Bookid;
  int entryNum;

  int CalculateUnitNum(int tmp){
      if(tmp!=0){
        print("CalculateUnitNum()");
        return (tmp/10).ceil();
      }
  }

  BookUnitView(this.Listid,this.Bookid,this.entryNum);
  @override
  State<StatefulWidget> createState() =>new _BookUnitViewState();
}

class _BookUnitViewState extends State<BookUnitView>{
  final bgcolor=0xFFEFF5FC;
  int wordNum=null;
  int UnitNum=null;

  @override
  Widget build(BuildContext context) {
  if(widget.Listid*100<=widget.entryNum){
        wordNum=100;
        UnitNum=10;
  }else{
        wordNum=widget.entryNum-(widget.Listid-1)*100;
        UnitNum=widget.CalculateUnitNum(wordNum);
  }
    return new MaterialApp(
      home:new Scaffold(
        appBar: AppBar(
            title: Text("Libro"+(widget.Bookid+1).toString()+" Lista"+widget.Listid.toString()),
            elevation:0.5,
            flexibleSpace: Container(color:Colors.grey),
            leading:Builder(
              builder:(BuildContext context){
                return IconButton(icon:new Icon(Icons.home),
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder:
                      //this.Listid,this.Bookid,this.entryNum
                      (context)=>BookListView(widget.Bookid))
                  );
                },); //add onPress later
              },
            ),
          ),
        body:new Container(
        decoration:new BoxDecoration(
        color: Color(bgcolor),
        ),
          child: _buildUnits(UnitNum,context),
        ),
      ),
      theme:new ThemeData(
          brightness:Brightness.light,
          backgroundColor: Colors.white),
    );
  }


  Widget _buildUnits(int length,BuildContext context) {
    int templength=length*2;
    return new ListView.builder(
      itemCount: templength,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          // add the divider line
          if (i.isOdd) return new Divider();
          int index=i~/2;
          return _buildRow("Unidad "+(index+1).toString(),index+1,context);
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
            (context)=>DetailView(widget.Listid,id,widget.Bookid,widget.entryNum))
        );
      },
    );
  }

}
