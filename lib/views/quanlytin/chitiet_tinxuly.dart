import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/controllers/quanlytin/quanlytin_controller.dart';
import 'package:ttpmn/controllers/xuly/xuly_controller.dart';
import 'package:ttpmn/routers.dart';
import 'package:ttpmn/views/quanlytin/tin_sms.dart';
import 'package:ttpmn/widgets/wgt_alert.dart';

import '../../controllers/xuly/tinhtoan_controller.dart';

class ChiTietTinXuLY extends StatelessWidget {
  const ChiTietTinXuLY({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.arguments ?? false) {
      QuanlytinController()
          .to
          .loadTinNhanChiTiet(Get.parameters["KhachID"].toString());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.parameters["Makhach"] ?? "Tin chi tiet"),
      ),
      body: GetBuilder<QuanlytinController>(builder: (controller) {
        int i = 0;
        double tongXacMN = 0;
        double tongXacMT = 0;
        double tongXacMB = 0;
        List<Map> tin = controller.tinct.value;
        List<Map> tinFixed = [];
        var mn = tin.where((e) => e["Mien"] == "N").toList();
        for(var x in mn){
          tongXacMN+=x["Xac"]??0;
        }
        tinFixed.add({"Mien": "Miền Nam","Xac": tongXacMN});
        tinFixed.addAll(mn);
        var mt = tin.where((e) => e["Mien"] == "T").toList();
        for(var x in mt){
          tongXacMT+=x["Xac"]??0;
        }
        tinFixed.add({"Mien": "Miền Trung","Xac": tongXacMT});
        tinFixed.addAll(tin.where((e) => e["Mien"] == "T").toList());
        var mb = tin.where((e) => e["Mien"] == "B").toList();
        for(var x in mb){
          tongXacMB+=x["Xac"]??0;
        }
        tinFixed.add({"Mien": "Miền Bắc","Xac": tongXacMB});
        tinFixed.addAll(mb);
        return ListView.builder(
            itemCount: tinFixed.length,
            itemBuilder: (context, index) {
              if (tinFixed[index]["Mien"].toString().length > 1) {
                return titileTin(tinFixed[index]["Mien"].toString(),NumberFormat("#,###").format(tinFixed[index]["Xac"]).toString() );
              }
              i += 1;
              return PopupMenuButton(
                offset: const Offset(100, 20),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 1, child: Text("Sửa")),
                  const PopupMenuItem(
                    value: 2,
                    child: Text("Xóa"),
                  )
                ],
                onSelected: (value) {
                  switch (value) {
                    case 1:
                      TinhToanController().to.ChoPhepTinhToan(false);
                      XulyController().to.clearError();
                      Get.toNamed(
                        routerName.v_xuly,
                        arguments: true,
                        parameters: {
                          "id": tinFixed[index]["ID"].toString(),
                          "KhachID": Get.parameters["KhachID"].toString(),
                          "Makhach": Get.parameters["Makhach"].toString()
                        },
                      )?.then((value) {

                        QuanlytinController().to.loadTinNhanChiTiet(Get.parameters["KhachID"].toString());
                        QuanlytinController().to.lay_danhsachkhach();
                        // TinNhanController().to.checkUpdate = false;
                      });
                      break;
                    case 2:
                      Wgt_Alert(title: "Thông báo", text: "Có chắc muốn xóa?", onConfirm: (){
                        controller.xoatin(tinFixed[index]["ID"], Get.parameters["KhachID"].toString());
                      });
                      break;
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey))),
                  child: ListTile(
                    leading: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        i.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(tinFixed[index]["TinXL"] != ""
                        ? tinFixed[index]["TinXL"]??''
                        : tinFixed[index]["TinGoc"]??"",maxLines: 5,overflow: TextOverflow.ellipsis,),
                    trailing: Container(
                        padding: const EdgeInsets.all(5),
                        color: Colors.grey[300],
                        child: Text(tinFixed[index]["Xac"]!=null?NumberFormat.decimalPattern().format(tinFixed[index]["Xac"]).toString():"0")),
                  ),
                ),
              );
            });
      }),
    );
  }
}

Container titileTin(String text, String txac) {
  return Container(
    padding: const EdgeInsets.only(left: 5, right: 10),
    height: 40,
    alignment: Alignment.center,
    decoration:  BoxDecoration(
        color: Colors.blueGrey[200],
        border: const Border(bottom: BorderSide(color: Colors.white))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style:  TextStyle(
              color: Colors.blueGrey[800], fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: RichText(
              text: TextSpan(children: [
            const TextSpan(
                text: "Tổng xác: ",
                style: TextStyle(color: Colors.black, fontSize: 15)),
            TextSpan(
                text: txac,
                style: const TextStyle(color: Colors.blue, fontSize: 15))
          ])),
        )
      ],
    ),
  );
}
