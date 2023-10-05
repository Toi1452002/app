import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/controllers/khach/khach_controller.dart';
import 'package:ttpmn/controllers/xuly/tinhtoan_controller.dart';
import 'package:ttpmn/controllers/xuly/xuly_controller.dart';
import 'package:ttpmn/models/khach_model.dart';
import 'package:ttpmn/routers.dart';
import 'package:ttpmn/views/xuly/xem_chi_tiet.dart';
import 'package:ttpmn/widgets/wgt_alert.dart';
import 'package:ttpmn/widgets/wgt_button.dart';
import 'package:ttpmn/widgets/wgt_drawer.dart';
import 'package:ttpmn/widgets/custom_dropdown_widget.dart';
import 'package:ttpmn/widgets/wgt_textfiled.dart';
class V_XuLy extends StatelessWidget {
  V_XuLy({Key? key}) : super(key: key);
  bool checkUpdate = false;
  @override
  Widget build(BuildContext context) {
    if (Get.arguments ?? false) {
      checkUpdate = true;
      var x = Get.parameters["id"];
      if (x != null) {
        XulyController().to.onEditTinNhan(x);
      }
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        drawer: checkUpdate ? null : const Wgt_Drawer(),
        appBar: AppBar(
          title: Obx(() => Text(
              "Mã tin: ${XulyController().to.idTinNhan.value.toString()}")),
          actions: [
            ElevatedButton(
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                  locale: const Locale("vi", ""),
                  context: context,
                  initialEntryMode: DatePickerEntryMode.calendar,
                  initialDate: XulyController().to.ngaylam.value,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  fieldHintText: "Ngày/Tháng/Năm",
                  helpText: "Chọn ngày",
                );
                if (newDate != null) {
                  XulyController().to.thay_doi_ngaylam(newDate);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[200],
                  shape: const BeveledRectangleBorder()),
              child: Obx(() => Text(
                    DateFormat("dd/MM/yyyy")
                        .format(XulyController().to.ngaylam.value),
                    style: const TextStyle(color: Colors.black),
                  )),
            ),
            // PopupMenuButton(
            //   itemBuilder: (context) => [
            //     PopupMenuItem(
            //       child: Text("Lấy tin SMS"),
            //       value: 1,
            //     )
            //   ],
            //   onSelected: (value) {
            //     if(value == 1){
            //       Get.toNamed("tin_sms",parameters: {"MaKhach": XulyController().to.makhach.value});
            //     }
            //   },
            // )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Khách: ",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Obx(() => InkWell(
                            onLongPress: () {
                              if (checkUpdate) {
                                Get.toNamed(routerName.v_addKhach,
                                    arguments: true,
                                    parameters: {
                                      "id": XulyController()
                                          .to
                                          .idTinNhan
                                          .value
                                          .toString(),
                                      "KhachID":
                                          Get.parameters["KhachID"].toString(),
                                      "Makhach":
                                          Get.parameters["Makhach"].toString()
                                    });
                              } else {
                                Get.toNamed(routerName.v_addKhach);
                              }

                              KhachModel khach = KhachController()
                                  .to
                                  .listKhachModel
                                  .value
                                  .where((e) =>
                                      e.ID ==
                                      XulyController().to.tinnhan.KhachID)
                                  .first;
                              KhachController().to.onEditKhach(khach);
                            },
                            child: CustomDropDown(
                                widh: 180,
                                hint: XulyController().to.makhach.value == ""
                                    ? "Chọn khách"
                                    : "",
                                value: XulyController().to.makhach.value == ""
                                    ? null
                                    : XulyController().to.makhach.value,
                                items: XulyController().to.lst_cbb_khach.value,
                                onChange: (value) {
                                  XulyController().to.thay_doi_makhach(value!);
                                }),
                          ))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Miền: ",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Obx(() => CustomDropDown(
                          widh: 150,
                          value: XulyController().to.mien.value,
                          items: const ["Nam", "Trung", "Bắc"],
                          onChange: (value) {
                            XulyController().to.thay_doi_mien(value!);
                          }))
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: Obx(() => Wgt_button(
                            text: "Kiểm lỗi",
                            onPressed: XulyController().to.idTinNhan.value == 0
                                ? null
                                : () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    XulyController().to.kiemloi();
                                  },
                            height: 50,
                          ))),
                  Expanded(
                    child: Obx(
                      () => Wgt_button(
                        text: "Tính toán",
                        onPressed: !TinhToanController().to.ktra_tinhtoan.value
                            ? null
                            : () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                TinhToanController().to.onTinhToan();
                              },
                        color: Colors.red[400],
                        height: 50,
                      ),
                    ),
                  ),
                ],
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
                          child: Obx(() => Text(NumberFormat("#,###")
                              .format(TinhToanController().to.TienXac.value)
                              .toString())),
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
                          child: Obx(() => Text(NumberFormat("#,###")
                              .format(TinhToanController().to.TienVon.value)
                              .toString())),
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
                          child: Obx(() => Text(NumberFormat("#,###")
                              .format(TinhToanController().to.TienTrung.value)
                              .toString())),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Thu bù :",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          alignment: Alignment.center,
                          width: 75,
                          height: 30,
                          color: Colors.white,
                          child: Obx(() => Text(
                                NumberFormat("#,###")
                                    .format(TinhToanController().to.LaiLo.value)
                                    .toString(),
                                style: TextStyle(
                                    color:
                                        TinhToanController().to.LaiLo.value >= 0
                                            ? Colors.blue
                                            : Colors.red),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Obx(() => Wgt_TextField(
                    controller: XulyController().to.tinXLController.value,
                    maxLines: 10,
                    errorText: XulyController().to.textError.value == ""
                        ? null
                        : XulyController().to.textError.value,
                    hintText: "Tin xử lý...",
                    onChanged: (value) {
                      TinhToanController().to.ChoPhepTinhToan(false);
                      XulyController().to.updateTinGoc(value);
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Wgt_button(
                        onPressed: XulyController().to.idTinNhan.value == 0
                            ? null
                            : () {
                              Wgt_Alert(title: "Khôi phục tin gốc?", text: "Khôi phục lại tin chưa xử lý", onConfirm: (){
                                XulyController().to.khoiphuctin();

                              });
                              },
                        text: "Khôi phục tin gốc",
                        color: Theme.of(context).primaryColor,
                      )),
                  Obx(() => Wgt_button(
                      onPressed: XulyController().to.idTinNhan.value == 0
                          ? null
                          : () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              XulyController().to.xemchitiet();

                              Get.bottomSheet(
                                  barrierColor: null,
                                  backgroundColor: null,
                                  const XemChiTietXuLy());
                            },
                      text: "Xem chi tiết",
                      color: Theme.of(context).primaryColor)),
                  Wgt_button(
                      onPressed: checkUpdate
                          ? null
                          : () => XulyController().to.them_tin(),
                      text: "Thêm tin",
                      color: Theme.of(context).primaryColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
