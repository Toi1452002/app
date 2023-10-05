import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/controllers/quanlytin/quanlytin_controller.dart';
import 'package:ttpmn/routers.dart';
import 'package:ttpmn/widgets/wgt_drawer.dart';

import '../../controllers/xuly/xuly_controller.dart';

class V_Quanlytin extends StatelessWidget {
  const V_Quanlytin({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Wgt_Drawer(),
      appBar: AppBar(
        title: const Text("Quản lý tin"),
        actions: [
          ElevatedButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                locale: const Locale("vi", ""),
                context: context,
                initialEntryMode: DatePickerEntryMode.calendar,
                initialDate: QuanlytinController().to.ngaylam.value,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                fieldHintText: "Ngày/Tháng/Năm",
                helpText: "Chọn ngày",
              );
              if (newDate != null) {
                QuanlytinController().to.thay_doi_ngaylam(newDate);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[200],
                shape: const BeveledRectangleBorder()),
            child: Obx(() => Text(
                  DateFormat("dd/MM/yyyy")
                      .format(QuanlytinController().to.ngaylam.value),
                  style: const TextStyle(color: Colors.black),
                )),
          ),
        ],
      ),
      body: GetBuilder<QuanlytinController>(
        builder: (controller) {
          List<Map<String,dynamic>> khach = controller.lstKhach.value;
          return ListView.builder(
              itemCount: khach.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).primaryColor))),
                  child: ListTile(
                    onTap: () {
                      Get.toNamed(routerName.v_chitiettinXL,
                          arguments: true,
                          parameters: {
                            "KhachID": khach[index]["ID"].toString(),
                            "Makhach": khach[index]["MaKhach"]
                          })?.then((value) => XulyController().to.loadTinNhan());
                    },
                    leading: Icon(Icons.mail),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: khach[index]["MaKhach"],style: TextStyle(color: Colors.black,fontSize: 20)),
                          TextSpan(text: " (${khach[index]["sotin"].toString()} tin)",style: TextStyle(color: Colors.grey, fontSize: 20)),
                        ]
                      ),
                    ),
                    // subtitle: Text("${khach[index]["sotin"].toString()} tin"),
                  ),
                );
              });
        },
      ),
    );
  }
}
