import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/controllers/baocao/baocao_controller.dart';

import '../../../widgets/wgt_table.dart';

class TienTrung extends StatelessWidget {
  const TienTrung({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaocaoController>(
      builder: (controller) {
        List<Map> bc = controller.baocao.value;
        return Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  HeaderTable("Miền", Get.width*.1),
                  HeaderTable("2s", Get.width*.18),
                  HeaderTable("3s", Get.width*.18),
                  HeaderTable("4s", Get.width*.18),
                  HeaderTable("dt", Get.width*.18),
                  HeaderTable("dx", Get.width*.18),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BodyTable("", Get.width*.1,color: Colors.blueGrey[100]),
                  BodyTable(NumberFormat.decimalPattern().format(controller.Tong2s.value).toString(), Get.width*.18,color: Colors.blueGrey[100]),
                  BodyTable(NumberFormat.decimalPattern().format(controller.Tong3s.value).toString(), Get.width*.18,color: Colors.blueGrey[100]),
                  BodyTable(NumberFormat.decimalPattern().format(controller.Tong4s.value).toString(), Get.width*.18,color: Colors.blueGrey[100]),
                  BodyTable(NumberFormat.decimalPattern().format(controller.Tongdt.value).toString(), Get.width*.18,color: Colors.blueGrey[100]),
                  BodyTable(NumberFormat.decimalPattern().format(controller.Tongdx.value).toString(), Get.width*.18,color: Colors.blueGrey[100]),
                ],
              ),
              Expanded(child: ListView.builder(
                itemCount: bc.length,
                itemBuilder: (context, i){
                  if(controller.baocao.value[i]["Mien"]==""){
                    return Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      height: 25,
                      width: Get.width,
                      color: Colors.red[200],
                      child: Text(bc[i]["MaKhach"],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    );
                  }
                  return Row(
                    children: [
                      BodyTable(bc[i]["Mien"].toString(),  Get.width*.1, alignment: Alignment.center),
                      BodyTable(![null,0.0].contains(bc[i]["Trung2s"])?NumberFormat.decimalPattern().format(bc[i]["Trung2s"]).toString():"",  Get.width*.18,textColor: Colors.red),
                      BodyTable(![null,0.0].contains(bc[i]["Trung3s"])?NumberFormat.decimalPattern().format(bc[i]["Trung3s"]).toString():"",  Get.width*.18,textColor: Colors.red),
                      BodyTable(![null,0.0].contains(bc[i]["Trung4s"])?NumberFormat.decimalPattern().format(bc[i]["Trung4s"]).toString():"",  Get.width*.18,textColor: Colors.red),
                      BodyTable(![null,0.0].contains(bc[i]["TrungDt"])?NumberFormat.decimalPattern().format(bc[i]["TrungDt"]).toString():"",  Get.width*.18,textColor: Colors.red),
                      BodyTable(![null,0.0].contains(bc[i]["TrungDx"])?NumberFormat.decimalPattern().format(bc[i]["TrungDx"]).toString():"",  Get.width*.18, textColor: Colors.red),
                    ],
                  );
                }
                ,
              ))
            ],
          ),
        );
      }
    );
  }
}
