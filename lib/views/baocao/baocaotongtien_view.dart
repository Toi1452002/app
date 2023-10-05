import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/baocao/baocaotongket_controller.dart';
import '../../widgets/custom_dropdown_2.dart';
import '../../widgets/wgt_table.dart';
class BaoCaoTongTienView extends StatelessWidget {
  const BaoCaoTongTienView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaocaoTongKetController>(
      builder: (controller) {
        List<Map> bc = controller.baocao.value;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Báo cáo tổng tiền"),
            actions: [
              IconButton(onPressed: (){
                BaocaoTongKetController().to.loadBaoCaoTong();
              }, icon: const Icon(Icons.refresh_outlined))
            ],
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 290,
                child: Obx(()=>CustomDropdownButton2(
                    icon: const Icon(Icons.arrow_drop_down_sharp),
                    iconSize: 20,
                    offset: const Offset(110, 0),
                    buttonDecoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.zero),
                    hint: "Khách",
                    dropdownWidth: 180,
                    dropdownDecoration: const BoxDecoration(borderRadius: BorderRadius.zero),
                    value: controller.makhach.value==""?null:controller.makhach.value,
                    dropdownItems: controller.lstKhach.value,
                    onChanged: (value) {
                      controller.thay_doi_khach(value!);
                    })),
              ),
              const SizedBox(height: 10,),
              Row(
                children: [

                  Expanded(
                    child: Column(
                      children: [
                        const Text("Từ ngày: "),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                              locale: const Locale("vi", ""),
                              context: context,
                              initialEntryMode: DatePickerEntryMode.calendar,
                              initialDate: controller.tungay.value,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              fieldHintText: "Ngày/Tháng/Năm",
                              helpText: "Chọn ngày",
                            );
                            if (newDate != null) {
                              controller.thay_doi_tungay(newDate);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey[200],
                              shape: const BeveledRectangleBorder()),
                          child: Obx(() => Text(
                            DateFormat("dd/MM/yyyy").format(controller.tungay.value),
                            style: const TextStyle(color: Colors.black),
                          )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text("Đến ngày: "),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                              locale: const Locale("vi", ""),
                              context: context,
                              initialEntryMode: DatePickerEntryMode.calendar,
                              initialDate: controller.denngay.value,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              fieldHintText: "Ngày/Tháng/Năm",
                              helpText: "Chọn ngày",
                            );
                            if (newDate != null) {
                              controller.thay_doi_denngay(newDate);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey[200],
                              shape: const BeveledRectangleBorder()),
                          child: Obx(() => Text(
                            DateFormat("dd/MM/yyyy").format(controller.denngay.value),
                            style: const TextStyle(color: Colors.black),
                          )),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              Row(children: [
                HeaderTable("Khách", Get.width*.2),
                HeaderTable("Nam", Get.width*.2),
                HeaderTable("Trung", Get.width*.2),
                HeaderTable("Bắc", Get.width*.2),
                HeaderTable("ThuBu", Get.width*.2),

              ],),
              Row(
                children: [
                  BodyTable("Tổng", Get.width*.2, color: Colors.blueGrey[100],alignment: Alignment.center),
                  BodyTable(NumberFormat("#,###").format(controller.tongNam.value), Get.width*.2, color: Colors.blueGrey[100]),
                  BodyTable(NumberFormat("#,###").format(controller.tongTrung.value), Get.width*.2, color: Colors.blueGrey[100]),
                  BodyTable(NumberFormat("#,###").format(controller.tongBac.value), Get.width*.2, color: Colors.blueGrey[100]),
                  BodyTable(NumberFormat("#,###").format(controller.tongThubu.value), Get.width*.2, color: Colors.blueGrey[100],textColor: controller.tongThubu.value>-1?Colors.blue:Colors.red),
                ],
              ),
              Expanded(child: ListView.builder(
                itemCount: bc.length,
                itemBuilder: (context,i){
                  if(bc[i]["ID"]=="title"){
                    return Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: Get.width,
                      color: Colors.red[200],
                      child: Text("Ngày: ${DateFormat("dd/MM/yyyy").format(DateTime.parse(bc[i]["Ngay"]))}",style: TextStyle(fontWeight: FontWeight.bold),),
                    );
                  }
                  return Row(children: [
                    BodyTable(bc[i]["Khách"], Get.width*.2, color: Colors.blueGrey[100],alignment: Alignment.center),
                    BodyTable(bc[i]["Nam"]!=null?NumberFormat("#,###").format(bc[i]["Nam"]):"", Get.width*.2),
                    BodyTable(bc[i]["Trung"]!=null?NumberFormat("#,###").format(bc[i]["Trung"]):"", Get.width*.2),
                    BodyTable(bc[i]["Bắc"]!=null?NumberFormat("#,###").format(bc[i]["Bắc"]):"", Get.width*.2),
                    BodyTable(bc[i]["Thu Bù"]!=null?NumberFormat("#,###").format(bc[i]["Thu Bù"]):"", Get.width*.2,textColor: bc[i]["Thu Bù"].toString().contains("-")?Colors.red:Colors.blue),
                  ],);
                },
              ))
            ],
          ),
        );
      }
    );
  }
}
