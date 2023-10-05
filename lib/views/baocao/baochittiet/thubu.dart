import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/controllers/baocao/baocao_controller.dart';

import '../../../widgets/wgt_table.dart';


class ThuBu extends StatelessWidget {
  const ThuBu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaocaoController>(
      builder: (controller) {
        List<Map> bc = controller.baocao.value;
        // print(bc);
        return Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  HeaderTable("Miền", Get.width*.1),
                  HeaderTable("Xác", Get.width*.225),
                  HeaderTable("Vốn", Get.width*.225),
                  HeaderTable("Trúng", Get.width*.225),
                  HeaderTable("ThuBu", Get.width*.225),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BodyTable("", Get.width*.1,color:  Colors.blueGrey[100]),
                  BodyTable(NumberFormat("#,###").format(controller.TongXac.value).toString(), Get.width*.225,color: Colors.blueGrey[100]),
                  BodyTable(NumberFormat("#,###").format(controller.TongVon.value).toString(), Get.width*.225,color: Colors.blueGrey[100]),
                  BodyTable(NumberFormat("#,###").format(controller.TongTrung.value).toString(), Get.width*.225,color: Colors.blueGrey[100]),
                  BodyTable(NumberFormat("#,###").format(controller.TongThuBu.value).toString(), Get.width*.225,color: Colors.blueGrey[100],textColor:controller.TongThuBu<0  ?Colors.red:Colors.blue ),
                ],
              ),

              Expanded(child: ListView.builder(
                itemCount: bc.length,
                itemBuilder: (context, i){
                  if(controller.baocao.value[i]["Mien"]==""){
                    List a = bc.where((e) => e["MaKhach"]==bc[i]["MaKhach"]).where((e) => e["Mien"]!="").toList();
                    String txt_baocao = "";
                    txt_baocao += "Khách: ${bc[i]["MaKhach"]}";
                    double tongtien = 0.0;
                    for (var e in a) {
                      tongtien+=e["Đầu dưới"]??0;
                      txt_baocao+="\n - ${e['Mien']}: \n   + Xác: ${NumberFormat("#,###").format(e['Xac']??0)} (";
                      if(e['Xác 2s']!=null){
                        txt_baocao+="2s: ${NumberFormat("#,###").format(e['Xác 2s'])}";
                        if(e['Xác 3s']!=null){
                          txt_baocao+=" | ";
                        }
                      }
                      if(e['Xác 3s']!=null){
                        txt_baocao+="3s: ${NumberFormat("#,###").format(e['Xác 3s'])}";
                      }
                      txt_baocao+=")";
                      if(e["Trung"]!=0.0){
                        txt_baocao+="\n   + Trúng: ";
                        if(![null,0.0].contains(e["Trung2s"])) txt_baocao+="2s ${NumberFormat("#,###").format(e['Trung2s'])}. ";
                        if(![null,0.0].contains(e["Trung3s"])) txt_baocao+="3s ${NumberFormat("#,###").format(e['Trung3s'])}. ";
                        if(![null,0.0].contains(e["Trung4s"])) txt_baocao+="4s ${NumberFormat("#,###").format(e['Trung4s'])}. ";
                        if(![null,0.0].contains(e["TrungDt"])) txt_baocao+="Dt ${NumberFormat("#,###").format(e['TrungDt'])}. ";
                        if(![null,0.0].contains(e["TrungDx"])) txt_baocao+="Dx ${NumberFormat("#,###").format(e['TrungDx'])}. ";
                      }
                      txt_baocao += !e['Đầu dưới'].toString().contains("-")?"\n   + Thu: ${NumberFormat("#,###").format(e['Đầu dưới']??0)}":"\n   + Bù: ${NumberFormat("#,###").format(e['Đầu dưới'])}";

                    }
                    txt_baocao+=tongtien>-1 ? "\nTổng Thu: ${NumberFormat("#,###").format(tongtien)}": "\nTổng Bù: ${NumberFormat("#,###").format(tongtien)}";
                    return InkWell(
                      onLongPress: (){
                        Get.dialog(
                          Dialog(
                            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              height: 400,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      style: TextStyle(color: Colors.black,fontSize: 15),
                                         txt_baocao
                                  ),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(onPressed: (){
                                        Clipboard.setData(ClipboardData(text: txt_baocao.toString()));
                                        EasyLoading.showToast("Sao chép thành công", toastPosition: EasyLoadingToastPosition.bottom);
                                      }, child: Text("Sao chép",style: TextStyle(fontSize: 16),)),
                                    ],
                                  )

                                ],
                              ),
                            ),
                          )
                        );
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10),
                        height: 25,
                        width: Get.width,
                        color: Colors.red[200],
                        child: Text(bc[i]["MaKhach"],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ),
                    );
                  }
                  String ThuBu = bc[i]["Đầu dưới"]!=null?NumberFormat("#,###").format(bc[i]["Đầu dưới"]).toString():NumberFormat("#,###").format(bc[i]["Đầu trên"]??0).toString();
                  return InkWell(
                    splashColor: Colors.grey,
                    onLongPress: (){
                      BaocaoController().to.loadTinCT(bc[i]["Ngay"], bc[i]["KhachID"].toString(), bc[i]["Mien"]);
                      Get.toNamed("/baocaochitiet_k1_view",parameters: {
                        "MaKhach": bc[i]["MaKhach"],
                        "Mien":bc[i]["Mien"],
                      });
                    },
                    child: Row(
                      children: [
                        BodyTable(bc[i]["Mien"].toString(),  Get.width*.1,alignment: Alignment.center),
                        BodyTable(NumberFormat("#,###").format(bc[i]["Xac"]??0).toString(),  Get.width*.225, ),
                        BodyTable(NumberFormat("#,###").format(bc[i]["Von"]??0).toString(),  Get.width*.225),
                        BodyTable(NumberFormat("#,###").format(bc[i]["Trung"]??0).toString(),  Get.width*.225),
                        BodyTable(ThuBu,  Get.width*.225,textColor: ThuBu.contains("-")?Colors.red:Colors.blue),
                      ],
                    ),
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
