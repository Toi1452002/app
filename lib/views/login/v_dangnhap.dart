import 'package:flutter/material.dart';
import 'package:ttpmn/controllers/login/dangnhap_controller.dart';
import 'package:ttpmn/widgets/wgt_button.dart';

import '../../widgets/wgt_textfiled.dart';
import 'package:get/get.dart';

class V_DangNhap extends StatelessWidget {
  const V_DangNhap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 300,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Wgt_TextField(
                    labelText: "Tài khoản",
                    icon: const Icon(Icons.person),
                    controller: DangNhapController().to.taikhoanController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wgt_TextField(
                    labelText: "Mật khẩu",
                    icon: Icon(Icons.lock_outline),
                    controller: DangNhapController().to.matkhauController,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wgt_button(
                      onPressed: () {
                        DangNhapController().to.onDangNhap();
                      },
                      text: "Đăng nhập"),
                  // SizedBox(height: 10,),
                  // TextButton(onPressed: (){}, child: Text("Đăng ký tài khoản"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
