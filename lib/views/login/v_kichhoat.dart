import 'package:flutter/material.dart';
import 'package:ttpmn/controllers/login/kichhoat_controller.dart';
import 'package:ttpmn/routers.dart';
import 'package:ttpmn/views/login/v_thaydoimay.dart';
import 'package:ttpmn/widgets/wgt_textfiled.dart';
import 'package:get/get.dart';
import '../../widgets/wgt_button.dart';

class V_KichHoat extends StatelessWidget {
  const V_KichHoat({Key? key}) : super(key: key);
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
              height: 250,
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
                    "Nhập mã kích hoạt app",
                    style: TextStyle(color: Colors.blue, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Wgt_TextField(
                    textAlign: TextAlign.center,
                    controller: KichHoatController().to.makichhoat,
                  ),
                  const SizedBox(height: 5,),
                  Wgt_button(
                    onPressed: (){
                      KichHoatController().to.onKichHoat();
                    },
                    width: 100,
                    text: "Kích hoạt",
                  ),
                  TextButton(onPressed: ()=>Get.toNamed(routerName.v_doimay), child: Text("Thay đổi máy?"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
