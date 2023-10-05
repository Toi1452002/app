// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:ttpmn/controllers/login/dangky_controller.dart';
import 'package:ttpmn/routers.dart';
import 'package:ttpmn/views/login/v_kichhoat.dart';
import 'package:ttpmn/widgets/wgt_textfiled.dart';
import 'package:get/get.dart';
import '../../widgets/wgt_button.dart';

class V_DangKy extends StatelessWidget {
  const V_DangKy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DangKyController());
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blueGrey[100],
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                height: 450,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey,
                          blurRadius: 10,
                          offset: Offset(3, 3))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),

                    const Text(
                      "Đăng ký tài khoản",
                      style: TextStyle(color: Colors.blue, fontSize: 25,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Obx(() => Wgt_TextField(
                      labelText: "Họ và tên",
                      icon: Icon(Icons.account_circle_rounded),
                      controller: DangKyController().to.hoten,
                      errorText: DangKyController().to.errHoten.value==""?null:DangKyController().to.errHoten.value,
                    ),),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() =>  Wgt_TextField(
                      labelText: "Tên tài khoản",
                      icon: Icon(Icons.person),
                      controller: DangKyController().to.taikhoan,
                      errorText: DangKyController().to.errTaikhoan.value==""?null:DangKyController().to.errTaikhoan.value,
                    ),),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() =>  Wgt_TextField(
                      labelText: "Mật khẩu",
                      icon: Icon(Icons.lock),
                      controller: DangKyController().to.matkhau,
                      obscureText: true,
                      errorText: DangKyController().to.errMatkhau.value==""?null:DangKyController().to.errMatkhau.value,

                    ),),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() => Wgt_TextField(
                      labelText: "Xác nhận mật khẩu",
                      icon: Icon(Icons.lock_outline),
                      errorText: DangKyController().to.errXacnhanmatkhau.value==""?null:DangKyController().to.errXacnhanmatkhau.value,
                      controller: DangKyController().to.xacnhanmatkhau,
                      obscureText: true,
                    ),),
                    const SizedBox(height: 10,),
                    Wgt_button(
                      onPressed: (){
                        FocusScope.of(context).requestFocus(FocusNode());
                        DangKyController().to.onSubmit();
                      },
                      width: Get.width,
                      height: 40,
                      text: "Đăng ký",
                    ),
                    TextButton(onPressed: (){
                      Get.toNamed(routerName.v_kichhoat);
                    }, child: Text("Đã có tài khoản?"))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
