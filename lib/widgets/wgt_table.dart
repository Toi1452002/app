import 'package:flutter/material.dart';

Container HeaderTable(String text, double width){
  return Container(
    alignment: Alignment.center,
    width: width,
    height: 30,
    decoration: BoxDecoration(
        border: const Border(right: BorderSide(), bottom: BorderSide(),top: BorderSide(color: Colors.white),left:BorderSide(color: Colors.white) ),
        color: Colors.blue[200]
    ),
    child: Text(text,style: const TextStyle(fontSize: 15),),
  );
}

Container BodyTable(String text, double width,{Color? color, Alignment? alignment,Color? textColor,double? FontSize}){
  return Container(
    alignment: alignment??Alignment.centerRight,

    width: width,
    height: 35,
    padding: const EdgeInsets.only(right: 5,left: 5),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: color
    ),
    child: Text(text,style: TextStyle(fontSize: FontSize??15,color: textColor),maxLines: 1,overflow: TextOverflow.ellipsis),
  );
}