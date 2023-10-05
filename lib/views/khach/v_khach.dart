import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpmn/controllers/khach/khach_controller.dart';
import 'package:ttpmn/function/extension.dart';
import 'package:ttpmn/routers.dart';

import '../../models/khach_model.dart';
import '../../widgets/wgt_alert.dart';

class V_Khach extends StatelessWidget {
  const V_Khach({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Khách"),
        actions: [
          IconButton(onPressed: (){
            KhachController().to.ResetText();
            Get.toNamed(routerName.v_addKhach);
          }, icon: const Icon(Icons.add))
        ],
      ),
      body: Obx((){
        List<KhachModel> lstKhach = KhachController().to.listKhachModel.value;
        if(lstKhach.isEmpty){
          return const Center(child: Text("Chưa có khách hàng\n Nhấn (+) để thêm khách hàng",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 20),),);
        }else{
          return ListView.builder(
            itemCount: lstKhach.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                        BorderSide(color: Theme.of(context).primaryColor))),
                child: ListTile(
                  leading: Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title:  Text(lstKhach[index].MaKhach),
                  // subtitle: const Text("kjalsdjkl"),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 1,
                        child: Text("Sửa"),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text("Sao chép"),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text("Xóa"),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 1:
                          Get.toNamed(routerName.v_addKhach);
                          KhachController().to.onEditKhach(lstKhach[index]);

                          break;
                        case 2:
                          Get.toNamed(routerName.v_addKhach);
                          KhachController().to.onEditKhach(lstKhach[index],copy: true);
                          break;
                        case 3:
                          Wgt_Alert(title: "Có chắc muốn xóa?",text:  "Sau khi xóa toàn bộ dữ liệu của người này sẽ mất!",onConfirm: (){
                            KhachController().to.xoa_khach(lstKhach[index]);
                            Get.back();
                          });
                          break;
                      }
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
