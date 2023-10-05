// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/controllers/xuly/xuly_controller.dart';
import 'package:ttpmn/function/extension.dart';

class XemChiTietXuLy extends StatelessWidget {
  const XemChiTietXuLy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<XulyController>(builder: (controller){
      List<Map> ptct = controller.lstXemChiTiet.value;
      return Container(
        height: 500,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                HeaderTable("Tin",Get.width*.35),
                HeaderTable("Xac",Get.width*.19),
                HeaderTable("Von",Get.width*.18),
                HeaderTable("Trung",Get.width*.18),
                HeaderTable("SLT",Get.width*.1),
              ],
            ),
            Expanded(
              // height: 390,
              child: ListView.builder(
                itemCount: ptct.length,
                itemBuilder: (context,i){
                  String tienxac = ptct[i]["TienXac"]!=null?NumberFormat("#,###").format(ptct[i]["TienXac"]).toString():"0";
                  String nhanve = ptct[i]["TienVon"]!=null?NumberFormat("#,###").format(ptct[i]["TienVon"]).toString():"0";
                  String trung = ptct[i]["TienTrung"]!=null?NumberFormat("#,###").format(ptct[i]["TienTrung"]).toString():"0";
                  String slTrung = "";
                  if(ptct[i]["SoLanTrung"]!=null && ptct[i]["SoLanTrung"].toString()!="0.0")
                    {
                      if(ptct[i]["SoLanTrung"].toString().lastChars(2)==".0"){
                        slTrung = ptct[i]["SoLanTrung"].toString().substring(0,ptct[i]["SoLanTrung"].toString().length-2);
                      }else{
                        slTrung =  ptct[i]["SoLanTrung"].toString();
                      }
                    }
                  String sotien = ptct[i]["SoTien"].toString();
                  if(sotien.lastChars(2)==".0"){
                    sotien = sotien.substring(0,sotien.length-2);
                  }
                  else if(sotien.lastChars(2)!=".0"){
                    sotien = sotien.replaceAll(".", ",");
                  }
                  String tin = "${ptct[i]["MaDai"]}.${ptct[i]["SoDanh"]}.${ptct[i]["MaKieu"]}$sotien";
                  return Row(
                    children: [
                      BodyTable(tin, Get.width*.35,i%2==0?Colors.grey[200]:Colors.white30,alignment: Alignment.centerLeft,textColor: slTrung!=""?Colors.red:null),
                      BodyTable(tienxac, Get.width*.19,i%2==0?Colors.grey[200]:Colors.white30,textColor: slTrung!=""?Colors.red:null),
                      BodyTable(nhanve, Get.width*.18,i%2==0?Colors.grey[200]:Colors.white30,textColor: slTrung!=""?Colors.red:null),
                      BodyTable(trung, Get.width*.18,i%2==0?Colors.grey[200]:Colors.white30,textColor: slTrung!=""?Colors.red:null),
                      BodyTable(slTrung, Get.width*.1,i%2==0?Colors.grey[200]:Colors.white30,textColor: slTrung!=""?Colors.red:null),
                    ],

                  );
                },
              ),
            ),

          ],
        ),
      );
    });
  }
}

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

Container BodyTable(String text, double width,Color? color,{ Alignment? alignment,Color? textColor}){
  return Container(
    alignment: alignment??Alignment.centerRight,
    width: width,
    height: 35,
    padding: const EdgeInsets.only(right: 5),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: color
    ),
    child: Text(text,style: TextStyle(fontSize: 15,color: textColor),),
  );
}
Container FooterTable(String text, double width){
  return Container(
    alignment: Alignment.center,
    width: width,
    height: 30,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white
    ),
    child: Text(text,style: const TextStyle(fontSize: 15),),
  );
}