import 'package:flutter/material.dart';
List<int> indexError = [];

class CustomTextController extends TextEditingController {
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<TextSpan> children = [];
    List<String> textList = text.split(".");
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
    return TextSpan(children: children, style: style);
  }
}
