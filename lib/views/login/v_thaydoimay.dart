import 'package:flutter/material.dart';
import 'package:ttpmn/controllers/login/kichhoat_controller.dart';
import 'package:ttpmn/widgets/wgt_textfiled.dart';
import 'package:get/get.dart';
import '../../widgets/wgt_button.dart';

class V_DoiMay extends StatelessWidget {
  const V_DoiMay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => KichHoatController());
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 440,
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
                  const SizedBox(height: 15,),
                  const Text(
                    "Thay đổi máy",
                    style: TextStyle(color: Colors.blue, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Wgt_TextField(
                    labelText: "Tài khoản",
                    controller: KichHoatController().to.taikhoan,
                  ),
                  const SizedBox(height: 5,),
                  Wgt_TextField(
                    labelText: "Mật khẩu",
                    controller: KichHoatController().to.matkhau,
                    obscureText: true,
                  ),
                  const SizedBox(height: 5,),
                  Wgt_TextField(
                    labelText: "Tên máy cũ",
                    controller: KichHoatController().to.tenmaycu,
                  ),
                  const SizedBox(height: 5,),
                  Wgt_TextField(
                    labelText: "Mã kích hoạt thay đổi",
                    controller: KichHoatController().to.mathaydoi,
                  ),
                  const SizedBox(height: 5,),
                  Wgt_button(
                    onPressed: (){
                      KichHoatController().to.onDoiMay();
                    },
                    width: 100,
                    text: "Chấp nhận",
                  ),
                  const SizedBox(height: 5,),
                  SizedBox(
                    width: 100,
                    child: TextButton(onPressed: ()=>Get.back(), child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.arrow_back,),
                        Text("Quay lại")
                      ],
                    )),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
