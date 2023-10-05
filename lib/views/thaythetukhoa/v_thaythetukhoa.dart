import 'package:flutter/material.dart';
import 'package:ttpmn/widgets/wgt_button.dart';
import 'package:ttpmn/widgets/wgt_textfiled.dart';
import 'package:get/get.dart';
import '../../controllers/xuly/tukhoa_controller.dart';

import '../../widgets/wgt_alert.dart';
import '../../widgets/wgt_table.dart';

class V_ThayTheTuKhoa extends StatelessWidget {
  const V_ThayTheTuKhoa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: GetBuilder<TuKhoaController>(
        builder: (controller){
          return Scaffold(
            appBar: AppBar(
              title: const Text("Từ khóa"),
              actions: [
                IconButton(
                    onPressed: () {
                      controller.ResetText();
                      Get.bottomSheet(Container(
                        height: 160,
                        padding: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Obx(()=>Wgt_TextField(
                                      labelText: "Mô tả",
                                      controller: controller.motaController,
                                      errorText: controller.motaErr.value==""?null:controller.motaErr.value,
                                      autofocus: true,
                                      onChanged: (value){
                                        controller.motaErr.value="";
                                      },
                                    ))),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Wgt_TextField(
                                      labelText: "Từ khóa",
                                      controller: controller.tukhoaController,
                                    )),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Wgt_button(
                              onPressed: () {
                                controller.them_tu_khoa();
                              },
                              text: "Thêm",
                              width: Get.width,
                            ),
                          ],
                        ),
                      ));
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    HeaderTable("", Get.width * .1),
                    HeaderTable("Mô tả", Get.width * .45),
                    HeaderTable("Từ khóa", Get.width * .45),
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: controller.lstTuKhoa.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Theme.of(context).primaryColor))),
                            child: InkWell(
                              onLongPress: () {
                                Wgt_Alert(
                                  title: "Thông báo",
                                  text: "Có chắc muốn xóa?",
                                  onConfirm: (){
                                    controller.xoa_tukhoa(controller.lstTuKhoa[index]);
                                  }
                                );
                              },
                              onTap: () {
                                controller.editTukhoa(controller.lstTuKhoa[index]);
                                Get.bottomSheet(Container(
                                  height: 150,
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Obx(()=>Wgt_TextField(
                                              labelText: "Mô tả",
                                              controller: controller.motaController,
                                              errorText: controller.motaErr.value==""?null:controller.motaErr.value,
                                              autofocus: true,
                                              onChanged: (value){
                                                controller.motaErr.value="";
                                              },
                                            ))
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Wgt_TextField(
                                                controller: controller.tukhoaController,
                                                labelText: "Từ khóa",
                                              )),
                                        ],
                                      ),
                                      Wgt_button(
                                        onPressed: () {
                                          controller.updateTuKhoa();
                                        },
                                        text: "Sửa",
                                        width: Get.width,
                                      ),
                                    ],
                                  ),
                                ));
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor))),
                                      width: Get.width * .1,
                                      alignment: Alignment.center,
                                      height: 40,
                                      child: Text((index + 1).toString()),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor))),
                                      width: Get.width * .45,
                                      height: 40,
                                      child:  Text(controller.lstTuKhoa[index].CumTu),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: Get.width * .45,
                                      height: 40,
                                      child:  Text(controller.lstTuKhoa[index].ThayThe),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
              ],
            ),
          );
        },
      ),
    );
  }
}

