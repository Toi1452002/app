import 'package:flutter/material.dart';
List<int> indexError = [];
String textBefore = "";
class CustomTextController extends TextEditingController {
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<TextSpan> children = [];
    List<String> textList = text.split(".");
    List<String> textbfList = textBefore.split(".");
    if(text.isEmpty) indexError.clear();
    if(textBefore.isNotEmpty && textbfList.length!=textList.length){
      int i = value.selection.start;
      int index = text.substring(0,i).split(".").length-1;
      if(textbfList.length<textList.length){
        indexError = indexError.map((e)=>index <= e ? e+=1 : e).toList();
      }else{
        indexError = indexError.map((e)=>index < e ? e-=1 : e).toList();
      }
    }
    if(indexError.isNotEmpty){
      for(int k = 0;k<textList.length;k++){
        if(indexError.contains(k)){
          children.add(TextSpan(text: textList[k],style: TextStyle(color: Colors.red)));
          if(textList.isNotEmpty && k>0 && textList[k]==""){
            indexError.remove(k);
          }
        }else{
          children.add(TextSpan(text: textList[k],style: style));
        }
        if(k<textList.length-1){
          children.add(TextSpan(text: ".",style: style));
        }
      }
    }else{
      children.add(TextSpan(text: text,style: style));
    }
    textBefore = text;
    return TextSpan(children: children, style: style);
  }
}
