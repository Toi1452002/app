import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ttpmn/controllers/khach/giakhach_controller.dart';

import '../../controllers/khach/khach_controller.dart';
import '../../widgets/wgt_textfiled.dart';

class CauHinh extends StatelessWidget {
  const CauHinh({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).primaryColor))),
          child: ListTile(
            title: const Text("Đá 2 đài chuyển thành đá xiên"),
            trailing: Obx(() => Switch(
                  onChanged: (value) {
                    GiaKhachController().to.thay_doi_daxien2d(value);
                  },
                  value: GiaKhachController().to.b_daxien2d.value,
                )),
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //       border: Border(
        //           bottom: BorderSide(color: Theme.of(context).primaryColor))),
        //   child: ListTile(
        //     title: const Text("Đầu trên"),
        //     trailing: Obx(() => Switch(
        //           onChanged: (value) {
        //             GiaKhachController().to.thay_doi_dautren(value);
        //           },
        //           value: GiaKhachController().to.b_dautren.value,
        //         )),
        //   ),
        // ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Wgt_TextField(
                  labelText: "Hồi tổng",
                  textInputType: TextInputType.number,
                  controller: KhachController().to.hoiTongController,
                ),
              ),
              Expanded(
                child: Wgt_TextField(
                  labelText: "Hồi 2s",
                  textInputType: TextInputType.number,
                  controller: KhachController().to.hoi2SoController,
                ),
              ),
              Expanded(
                child: Wgt_TextField(
                  labelText: "Hồi 3s",
                  textInputType: TextInputType.number,
                  controller: KhachController().to.hoi3SoController,
                ),
              ),
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 8,right: 8),
        //   child: Container(
        //     padding: const EdgeInsets.all(5),
        //     decoration: BoxDecoration(
        //         border: Border.all(color: Theme.of(context).primaryColor)),
        //     child: Column(
        //       children: [
        //         Row(
        //           children: [
        //             Expanded(
        //               flex: 2,
        //               child: Wgt_TextField(
        //                 textInputType: TextInputType.number,
        //                 labelText: "SDT",
        //                 controller: KhachController().to.sdtController,
        //               ),
        //             ),
        //             const SizedBox(
        //               width: 5,
        //             ),
        //             Expanded(
        //               flex: 1,
        //               child: Wgt_button(
        //                 onPressed: () {
        //                   KhachController().to.them_sdt();
        //                 },
        //                 text: "Thêm",
        //                 height: 57,
        //                 color: Colors.blueGrey,
        //               ),
        //             )
        //           ],
        //         ),
        //         Container(
        //             width: Get.width,
        //             height: 50,
        //             alignment: Alignment.center,
        //             padding: const EdgeInsets.all(6),
        //             margin: const EdgeInsets.only(top: 5),
        //             color: Colors.blue[300],
        //             child: Obx(()=>ListView.builder(
        //               itemCount: KhachController().to.lstSdt.value.length,
        //               scrollDirection: Axis.horizontal,
        //               itemBuilder: (context, index) {
        //                 return Container(
        //                   alignment: Alignment.centerLeft,
        //                   padding: const EdgeInsets.all(5),
        //                   margin: const EdgeInsets.only(right: 10),
        //                   height: 30,
        //                   width: 120,
        //                   decoration: BoxDecoration(
        //                       color: Colors.white.withOpacity(.5),
        //                       borderRadius: BorderRadius.circular(5)),
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [
        //                       Expanded(
        //                         flex: 3,
        //                         child: Text(KhachController().to.lstSdt.value[index].SoDT),
        //                       ),
        //                       Expanded(
        //                         flex: 1,
        //                         child: InkWell(
        //                           onTap: (){
        //                             KhachController().to.xoa_sdt(KhachController().to.lstSdt[index]);
        //                           },
        //                           child: const Icon(Icons.close,color: Colors.blueGrey,size: 18),
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                 );
        //               },
        //             )))
        //       ],
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        Padding(
          padding: const EdgeInsets.only(left: 8,right: 8),
          child: GetBuilder<GiaKhachController>(builder: (controller) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor)),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Thưởng đá thẳng",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Text("Miền Nam"),
                          const SizedBox(
                            width: 3,
                          ),
                          Checkbox(
                              value: controller.ck_thuongMN.value,
                              onChanged: (value) =>
                                  controller.thay_doi_thuongDT(value!, "N"))
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Thêm chi"),
                          Checkbox(
                              fillColor: MaterialStateProperty.resolveWith(
                                  (states) => controller.ck_thuongMN.value
                                      ? null
                                      : Colors.grey[200]),
                              value: controller.ck_themchiMN.value,
                              onChanged: (value) => controller.ck_thuongMN.value
                                  ? controller.thay_doi_themchi(value!, "N")
                                  : null)
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Text("Miền Trung"),
                          Checkbox(
                              value: controller.ck_thuongMT.value,
                              onChanged: (value) =>
                                  controller.thay_doi_thuongDT(value!, "T"))
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Thêm chi"),
                          Checkbox(
                              fillColor: MaterialStateProperty.resolveWith(
                                  (states) => controller.ck_thuongMT.value
                                      ? null
                                      : Colors.grey[200]),
                              value: controller.ck_themchiMT.value,
                              onChanged: (value) => controller.ck_thuongMT.value
                                  ? controller.thay_doi_themchi(value!, "T")
                                  : null)
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Text("Miền Bắc"),
                          const SizedBox(
                            width: 12,
                          ),
                          Checkbox(
                              value: controller.ck_thuongMB.value,
                              onChanged: (value) =>
                                  controller.thay_doi_thuongDT(value!, "B"))
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Thêm chi"),
                          Checkbox(
                              fillColor: MaterialStateProperty.resolveWith(
                                  (states) => controller.ck_thuongMB.value
                                      ? null
                                      : Colors.grey[200]),
                              value: controller.ck_themchiMB.value,
                              onChanged: (value) => controller.ck_thuongMB.value
                                  ? controller.thay_doi_themchi(value!, "B")
                                  : null)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
