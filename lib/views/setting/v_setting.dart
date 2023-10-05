// ignore_for_file: non_constant_identifier_names

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ttpmn/controllers/baocao/baocao_controller.dart';
import 'package:ttpmn/controllers/login/dangnhap_controller.dart';
import 'package:ttpmn/controllers/quanlytin/quanlytin_controller.dart';
import 'package:ttpmn/controllers/setting_controller.dart';
import 'package:ttpmn/controllers/xuly/tinhtoan_controller.dart';
import 'package:ttpmn/controllers/xuly/xuly_controller.dart';
import 'package:ttpmn/database/hamchung_db.dart';
import 'package:ttpmn/server.dart';
import 'package:ttpmn/widgets/wgt_alert.dart';
import 'package:ttpmn/widgets/wgt_textfiled.dart';

import '../../widgets/wgt_button.dart';

class V_Setting extends StatelessWidget {
  V_Setting({Key? key}) : super(key: key);
  static String v_settingRouter = "/v_setting";
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SettingController());
    RxBool kxc = TinhToanController().to.Bkxc.obs;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt"),
      ),
      body: Column(
        children: [
          Container(
            // height: 50,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Theme.of(context).primaryColor))),
            child: ListTile(
              title: const Text("Lấy 3 con"),
              subtitle:
                  const Text("1234b1.b1.xc1.dd1=1234b1.234b1.234.xc1.34dd1"),
              trailing: Obx(() => Switch(
                    onChanged: (value) async {
                      kxc.value = value;
                      TinhToanController().to.Bkxc = value;
                      await HamChungDB().layTable(
                          "Update T00_TuyChon Set GiaTri = ${value ? 1 : 0} Where Ma = 'kxc'");
                      // print(value);
                    },
                    value: kxc.value,
                  )),
            ),
          ),
          Container(
            // height: 50,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Theme.of(context).primaryColor))),
            child: ListTile(
              title: const Text("Lấy KQXS Minh Ngọc"),
              trailing: Obx(() => Switch(
                onChanged: (value) async {
                  // kxc.value = value;
                  SettingController().to.xcMN.value = value;
                  // TinhToanController().to.Bkxc = value;
                  await HamChungDB().layTable(
                      "Update T00_TuyChon Set GiaTri = ${value ? 1 : 0} Where Ma = 'xsMN'");
                  // print(value);
                },
                value: SettingController().to.xcMN.value,
              )),
            ),
          ),

          itemSetting(context,
              text: "Đổi mật khẩu",
              icon: const Icon(Icons.change_circle_outlined), onTap: () {
            DangNhapController().to.clearError();
            Get.dialog(Dialog(
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 320,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Obx(() => Column(
                      children: [
                        Wgt_TextField(
                          labelText: "Mật khẩu cũ",
                          controller: DangNhapController().to.matkhaucu,
                          obscureText: true,
                          errorText:
                              DangNhapController().to.err_matkhaucu.value == ""
                                  ? null
                                  : DangNhapController().to.err_matkhaucu.value,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Wgt_TextField(
                            labelText: "Mật khẩu mới",
                            controller: DangNhapController().to.matkhaumoi,
                            obscureText: true,
                            errorText: DangNhapController()
                                        .to
                                        .err_matkhaumoi
                                        .value ==
                                    ""
                                ? null
                                : DangNhapController().to.err_matkhaumoi.value),
                        const SizedBox(
                          height: 15,
                        ),
                        Wgt_TextField(
                            labelText: "Xác nhận mật khẩu mới",
                            controller: DangNhapController().to.xn_matkhaumoi,
                            obscureText: true,
                            errorText: DangNhapController()
                                        .to
                                        .err_xn_matkhaumoi
                                        .value ==
                                    ""
                                ? null
                                : DangNhapController()
                                    .to
                                    .err_xn_matkhaumoi
                                    .value),
                        const SizedBox(
                          height: 15,
                        ),
                        Wgt_button(
                          onPressed: () {
                            DangNhapController().to.onChangePassword();
                          },
                          text: "Ok",
                        )
                      ],
                    )),
              ),
            ));
          }),
          itemSetting(context,
              text: "Sao lưu dữ liệu",
              icon: const Icon(Icons.cloud_upload),
              onTap: () {
                Wgt_Alert(title: "Thông báo", text: "Sao lưu dữ liệu?", onConfirm: (){
                  SettingController().to.onSaoLuu();
                  Get.back();
                }
                );

              }),
          itemSetting(context,
              text: "Khôi phục dữ liệu",
              icon: const Icon(Icons.cloud_download),
              onTap: () {
                Wgt_Alert(title: "Thông báo", text: "Khôi phục dữ liệu?", onConfirm: (){
                  SettingController().to.onKhoiPhuc();
                  Get.back();
                });
              }),
          itemSetting(context,
              text: "Xóa tất cả tin nhắn",
              icon: const Icon(Icons.delete),
              colorText: Colors.red, onTap: () {
            Wgt_Alert(title: "Thông báo",text: "Có chắc muốn xóa?",onConfirm: () async {
              await HamChungDB().layTable("Delete From TXL_TinNhan");
              await HamChungDB()
                  .layTable("Delete From TXL_TinPhanTichCT");

              XulyController().to.loadTinNhan();
              QuanlytinController().to.lay_danhsachkhach();
              BaocaoController().to.loadBaoCao();
              EasyLoading.showSuccess("Xóa thành công");
              Get.back();
            });


          }),
          const Spacer(),
          const Divider(),
          Text(
            "Version: ${Server.version}",
            style: const TextStyle(fontSize: 20, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

Widget itemSetting(BuildContext context,
    {required String text,
    void Function()? onTap,
    required Icon icon,
    Color? colorText}) {
  return Container(
    decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Theme.of(context).primaryColor))),
    child: ListTile(
      leading: icon,
      title: Text(
        text,
        style: TextStyle(color: colorText ?? Colors.black),
      ),
      onTap: onTap,
    ),
  );
}
