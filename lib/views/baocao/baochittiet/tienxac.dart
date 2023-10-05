import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/controllers/baocao/baocao_controller.dart';

import '../../../widgets/wgt_table.dart';
class TienXac extends StatelessWidget {
  const TienXac({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaocaoController>(
      builder: (controller) {
        List<Map> bc = controller.baocao.value;

        return Scaffold(
          body: Column(children: [
            Row(children: [
              HeaderTable("Miền", Get.width*.1),
              HeaderTable("Xác", Get.width*.3),
              HeaderTable("Xác 2s",Get.width*.3 ),
              HeaderTable("Xác 3s", Get.width*.3),
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BodyTable("", Get.width*.1,color: Colors.blueGrey[100]),
                BodyTable(NumberFormat("#,###").format(controller.TongXac.value).toString(), Get.width*.3,color: Colors.blueGrey[100]),
                BodyTable(NumberFormat("#,###").format(controller.TongXac2.value).toString(), Get.width*.3,color: Colors.blueGrey[100]),
                BodyTable(NumberFormat("#,###").format(controller.TongXac3.value).toString(), Get.width*.3,color: Colors.blueGrey[100]),
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
                    BodyTable(bc[i]["Mien"].toString(),  Get.width*.1,alignment: Alignment.center),
                    BodyTable(NumberFormat("#,###").format(bc[i]["Xac"]??0).toString(),  Get.width*.3),
                    BodyTable(bc[i]["Xác 2s"]!=null?NumberFormat("#,###").format(bc[i]["Xác 2s"]).toString():"0",  Get.width*.3),
                    BodyTable(bc[i]["Xác 3s"]!=null?NumberFormat("#,###").format(bc[i]["Xác 3s"]).toString():"0",  Get.width*.3),
                  ],
                );
              }
              ,
            ))
          ],),
        );
      }
    );
  }
}
