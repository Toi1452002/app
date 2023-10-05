import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/routers.dart';
import 'package:ttpmn/server.dart';

class Wgt_Drawer extends StatelessWidget {
  const Wgt_Drawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        // backgroundColor: Colors.blue,
        width: Get.width*.8,
        child: ListView(
          padding: EdgeInsets.zero,

          children: [
             SizedBox(
              height: 63,
              child:  DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child:  Text(
                  "Ngày hết hạn: ${DateFormat("dd/MM/yyyy").format(DateTime.parse(Server.ngayHetHan))}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.table_chart_sharp),
                title: const Text("Kết quả xổ số"),
                onTap: () {
                  Get.back();
                  Get.toNamed(routerName.v_kqxs);

                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                title: const Text("Danh sách khách"),
                onTap: () {
                  Get.back();
                  Get.toNamed(routerName.v_khach);

                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.change_circle),
                title: const Text("Thay thế từ khóa"),
                onTap: () {
                  Get.back();
                  Get.toNamed(routerName.v_thaythetukhoa);
                },
              ),
            ),Card(
              child: ListTile(
                leading: const Icon(Icons.table_view),
                title: const Text("Báo cáo tổng tiền"),
                onTap: () {
                  Get.back();
                  Get.toNamed(routerName.v_baocaotongtien);
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Cài đặt"),
                onTap: () {
                  Get.back();
                  Get.toNamed(routerName.v_setting);
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Thoát"),
                onTap: () {
                  SystemNavigator.pop();
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
