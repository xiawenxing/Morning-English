class timemarker {
  Duration time;
  int posindex;
  timemarker(String time,int posindex){
    this.time = new Duration(minutes:int.parse(time.substring(1, time.indexOf(":"))) ,
        seconds:int.parse(time.substring(time.indexOf(":")+1,time.indexOf("]"))) );
    this.posindex = posindex;
  }
}