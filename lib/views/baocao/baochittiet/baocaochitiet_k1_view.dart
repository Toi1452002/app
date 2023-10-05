import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/controllers/baocao/baocao_controller.dart';
import '../../../widgets/wgt_table.dart';

class BaoCaoCTK1View extends StatelessWidget {
  const BaoCaoCTK1View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaocaoController>(builder: (controller) {
      List<Map> m = controller.baocaoctk1.value;
      return Scaffold(
        appBar: AppBar(
          title:
          Text("${Get.parameters['MaKhach']!}(${Get.parameters["Mien"]}) - ${m.length} Tin"),
        ),
        body:
        SizedBox(
          height: Get.height,
          width: Get.width,
          child: ListView.builder(scrollDirection: Axis.horizontal,itemCount: m.length, itemBuilder: (context, i) {
            return Container(
              width: Get.width,
              color: Colors.blueGrey[100],
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  InkWell(
                    onLongPress: (){
                      Get.dialog(
                        Dialog(
                          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                          backgroundColor: Colors.white,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: Get.width,
                            height: 400,
                            child: SingleChildScrollView(child: Text(m[i]["TinXL"]!=null?m[i]["TinXL"].toString():"",style: const TextStyle(fontSize: 20),)),
                          ),
                        )

                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      width: Get.width,
                      height: 200,
                      child: SingleChildScrollView(child: Text(m[i]["TinXL"].toString())),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                    ),
                    height: 90,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Tiền Xác :",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 12),
                              alignment: Alignment.center,
                              width: 80,
                              height: 30,
                              color: Colors.white,
                              child: Text(NumberFormat("#,###").format(m[i]["Xac"]).toString()),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Tiền vốn :",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              width: 75,
                              height: 30,
                              color: Colors.white,
                              child: Text(NumberFormat("#,###").format(m[i]["Von"]).toString()),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Tiền trúng :",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 2),
                              alignment: Alignment.center,
                              width: 80,
                              height: 30,
                              color: Colors.white,
                              child: Text(NumberFormat("#,###").format(m[i]["Trung"]).toString()),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Lãi lỗ :",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 30),
                              alignment: Alignment.center,
                              width: 75,
                              height: 30,
                              color: Colors.white,
                              child: Text(
                                NumberFormat("#,###").format(m[i]["LaiLo"]).toString(),
                                style: TextStyle(color:
                                NumberFormat("#,###").format(m[i]["LaiLo"]).toString().contains("-")?Colors.red:Colors.black
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(children: [
                    HeaderTable("", Get.width*.15),
                    HeaderTable("Số trúng", Get.width*.305),
                    HeaderTable("Điểm trúng", Get.width*.25),
                    HeaderTable("Tiền trúng", Get.width*.25),
                  ],),
                  Row(
                    children: [
                      HeaderTable("2s", Get.width*.15),
                      InkWell(
                        onLongPress: (){
                          Get.defaultDialog(
                            radius: 0,
                              title: "Số trúng 2s",
                              middleText: m[i]["SoTrung2s"]!=null?m[i]["SoTrung2s"].toString():""
                          );
                        },
                        child: BodyTable(m[i]["SoTrung2s"]!=null?m[i]["SoTrung2s"].toString():"", Get.width*.305,color: Colors.white),),
                      BodyTable(m[i]["DiemTrung2s"]!=null?NumberFormat("#,###").format(m[i]["DiemTrung2s"]).toString():"0", Get.width*.25,color: Colors.white),
                      BodyTable(m[i]["TienTrung2s"]!=null?NumberFormat("#,###").format(m[i]["TienTrung2s"]).toString():"0", Get.width*.25,color: Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      HeaderTable("3s", Get.width*.15),
                      InkWell(
                          onLongPress: (){
                            Get.defaultDialog(
                                radius: 0,
                                title: "Số trúng 3s",
                                middleText: m[i]["SoTrung3s"]!=null?m[i]["SoTrung3s"].toString():""
                            );
                          },
                          child: BodyTable(m[i]["SoTrung3s"]!=null?m[i]["SoTrung3s"].toString():"", Get.width*.305,color: Colors.white)),
                      BodyTable(m[i]["DiemTrung3s"]!=null?NumberFormat("#,###").format(m[i]["DiemTrung3s"]).toString():"0", Get.width*.25,color: Colors.white),
                      BodyTable(m[i]["TienTrung3s"]!=null?NumberFormat("#,###").format(m[i]["TienTrung3s"]).toString():"0", Get.width*.25,color: Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      HeaderTable("4s", Get.width*.15),
                      InkWell(
                          onLongPress: (){
                            Get.defaultDialog(
                                radius: 0,
                                title: "Số trúng 4s",
                                middleText: m[i]["SoTrung4s"]!=null?m[i]["SoTrung4s"].toString():""
                            );
                          },
                          child: BodyTable(m[i]["SoTrung4s"]!=null?m[i]["SoTrung4s"].toString():"", Get.width*.305,color: Colors.white)),
                      BodyTable(m[i]["DiemTrung4s"]!=null?NumberFormat("#,###").format(m[i]["DiemTrung4s"]).toString():"0", Get.width*.25,color: Colors.white),
                      BodyTable(m[i]["TienTrung4s"]!=null?NumberFormat("#,###").format(m[i]["TienTrung4s"]).toString():"0", Get.width*.25,color: Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      HeaderTable("Dt", Get.width*.15),
                      InkWell(
                          onLongPress: (){
                            Get.defaultDialog(
                                radius: 0,
                                title: "Số trúng Dt",
                                middleText: m[i]["SoTrungDt"]!=null?m[i]["SoTrungDt"].toString():""
                            );
                          },
                          child: BodyTable(m[i]["SoTrungDt"]!=null?m[i]["SoTrungDt"].toString():"", Get.width*.305,color: Colors.white)),
                      BodyTable(m[i]["DiemTrungDt"]!=null?NumberFormat("#,###").format(m[i]["DiemTrungDt"]).toString():"0", Get.width*.25,color: Colors.white),
                      BodyTable(m[i]["TienTrungDt"]!=null?NumberFormat("#,###").format(m[i]["TienTrungDt"]).toString():"0", Get.width*.25,color: Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      HeaderTable("Dx", Get.width*.15),
                      InkWell(
                          onLongPress: (){
                            Get.defaultDialog(
                                radius: 0,
                                title: "Số trúng Dx",
                                middleText: m[i]["SoTrungDx"]!=null?m[i]["SoTrungDx"].toString():""
                            );
                          },
                          child: BodyTable(m[i]["SoTrungDx"]!=null?m[i]["SoTrungDx"].toString():"", Get.width*.305,color: Colors.white)),
                      BodyTable(m[i]["DiemTrungDx"]!=null?NumberFormat("#,###").format(m[i]["DiemTrungDx"]).toString():"0", Get.width*.25,color: Colors.white),
                      BodyTable(m[i]["TienTrungDx"]!=null?NumberFormat("#,###").format(m[i]["TienTrungDx"]).toString():"0", Get.width*.25,color: Colors.white),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}
