import 'dart:ui';
import 'package:flutter/material.dart';

class sizeAdapter{
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static double _width = mediaQuery.size.width;
  static double _height = mediaQuery.size.height;
  static double _topbarH = mediaQuery.padding.top;
  static double _botbarH = mediaQuery.padding.bottom;

  static const double orgwid = 360;
  static const double orgheight = 604;

  sizeAdapter()
  {
    print("width:"+_width.toString());
    print("height:"+_height.toString());
    print("top height:"+_topbarH.toString());
    print("bottom  height:"+_botbarH.toString());
  }

  static adaptfitWid(){
    return _width;
  }
  static adaptfitHeight(){
    return _height;
  }

  static adaptbyWid(double wid){
    return wid/orgwid*_width;
  }

  static adaptbyHeight(double hei){
    return hei/orgheight*_height;
  }

  static adaptbySize(double size){
    return size/(orgheight*orgwid)*(_width*_height);
  }

  static adaptbyMin(double size){
    if(size/orgheight*_height>size/orgwid*_width)
      return size/orgwid*_width;
    else
      return size/orgheight*_height;
  }

  static adaptbyMax(double size){
    if(size/orgheight*_height<size/orgwid*_width)
      return size/orgwid*_width;
    else
      return size/orgheight*_height;
  }
}