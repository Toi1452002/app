import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpmn/controllers/kqxs/kqxs_controller.dart';

import 'kqxs_table.dart';

class V_Kqxs extends StatelessWidget {
  const V_Kqxs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KqxsController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Kqxs"),
          actions: [
            ElevatedButton(
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                  locale: const Locale("vi", ""),
                  context: context,
                  initialEntryMode: DatePickerEntryMode.calendar,
                  initialDate: controller.ngaylam.value,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  fieldHintText: "Ngày/Tháng/Năm",
                  helpText: "Chọn ngày",
                );
                if (newDate != null) {
                  controller.thay_doi_ngaylam(newDate);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[200],
                  shape: const BeveledRectangleBorder()),
              child: Text(
                "${controller.ngaylam.value.day.toString().padLeft(2, '0')}/${controller.ngaylam.value.month.toString().padLeft(2, '0')}/${controller.ngaylam.value.year}",
                style: const TextStyle(color: Colors.black),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  textStyle: TextStyle(fontSize: 13, color: Colors.black),
                  value: 1,
                  child: Row(
                    children: const [
                      Text("Xóa KQXS"),
                    ],
                  ),
                )
              ],
              onSelected: (value) {
                if (value == 1) {
                  controller.xoa_kqxs();
                }
              },
            )
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(child: gr_button_mien("Nam", "N")),
                Expanded(child: gr_button_mien("Trung", "T")),
                Expanded(child: gr_button_mien("Bắc", "B")),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (controller.thongbao.value!="") {
                  return  Center(
                    child: Text(
                      controller.thongbao.value,
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  );
                } else {
                  return KqxsTable(listKqxs: controller.lstKqxs.value);
                }
              }),
            )
          ],
        ),
      );
    });
  }
}

Widget gr_button_mien(String text, String selectbutton) {
  return SizedBox(
    height: 50,
    child: ElevatedButton(
        onPressed: () {
          if(!KqxsController().to.danglaykqxs.value){
            KqxsController().to.thay_doi_mien(selectbutton);
          }

        },
        style: ElevatedButton.styleFrom(
            backgroundColor:
                selectbutton == KqxsController().to.mien.value
                    ? Colors.grey
                    : Colors.white70,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        child: Text(
          text,
          style: TextStyle(
              color: selectbutton == KqxsController().to.mien.value
                  ? Colors.white
                  : Colors.black),
        )),
  );
}
