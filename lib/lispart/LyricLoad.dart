import 'PlayPage.dart';
import 'listensrcDB.dart';
import 'resource.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class LyricLoad{
  String filepath;
  String filename;
  ListenResource resource;
  List<String> content;

  LyricLoad(ListenResource res){
    resource = res;
    filename = resource.title+".txt";
  }

  Future<List> down(bool isDownFileAnyWay) async{
    Directory documentdir = await getApplicationDocumentsDirectory();
    filepath = await join(documentdir.path, "docfile",ListenBookList.booknames_en[resource.bookid],filename);
    try{
      await new Directory(dirname(filepath)).create(recursive: true);
    }catch(e){
      print(e);
    }

    File file = new File(filepath);
    if(await file.exists()==false || isDownFileAnyWay == true){
      Dio downer = new Dio();
      downer.options.connectTimeout = 10000;
      downer.options.receiveTimeout = 10000;
      Response res = await downer.download(resource.fileurl, filepath);
      if(res.statusCode == 200){
        print("success");
      }else{
        content = null;
      }
    }

    content =await file.readAsLinesSync();
    return content;
  }

}