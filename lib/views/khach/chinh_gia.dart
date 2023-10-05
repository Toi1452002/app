import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpmn/views/khach/giakhach.dart';
import 'package:ttpmn/widgets/wgt_button.dart';
import 'package:ttpmn/widgets/wgt_textfiled.dart';

import '../../controllers/khach/giakhach_controller.dart';
import '../../controllers/khach/khach_controller.dart';

class ChinhGia extends StatelessWidget {
  const ChinhGia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Obx(()=>Wgt_TextField(
            labelText: "Tên khách",
            controller: KhachController().to.makhachController,
            onChanged: (value){
              KhachController().to.makhachErr.value="";
            },
            errorText: KhachController().to.makhachErr.value!=""?KhachController().to.makhachErr.value:null,
          )),
          const SizedBox(
            height: 10,
          ),
          //SDT


          //Kieu ti le
          // Container(
          //   padding: const EdgeInsets.all(5),
          //   decoration:
          //       BoxDecoration(border: Border.all(color: Colors.blueGrey)),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Obx(() => Container(
          //               color: GiaKhachController().to.rdo_KieuTl.value == 1 ? Colors.grey[300] : null,
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   const Text("Kiểu 1-70/100"),
          //                   Radio(
          //                       value: 1,
          //                       groupValue: GiaKhachController().to.rdo_KieuTl.value,
          //                       onChanged: (value) {
          //                         GiaKhachController().to.thay_doi_kieuTl();
          //                       })
          //                 ],
          //               ),
          //             )),
          //       ),
          //       // Expanded(
          //       //   child: Obx(() => Container(
          //       //         color: GiaKhachController().to.rdo_KieuTl.value == 2 ? Colors.grey[300] : null,
          //       //         child: Row(
          //       //           mainAxisAlignment: MainAxisAlignment.center,
          //       //           crossAxisAlignment: CrossAxisAlignment.center,
          //       //           children: [
          //       //             const Text("Kiểu 2-12.6/18"),
          //       //             Radio(
          //       //                 value: 2,
          //       //                 groupValue: GiaKhachController().to.rdo_KieuTl.value,
          //       //                 onChanged: null,)
          //       //                 // onChanged: (value) {
          //       //                 //   GiaKhachController().to.thay_doi_kieuTl();
          //       //                 // })
          //       //           ],
          //       //         ),
          //       //       )),
          //       // ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 10,),
          Obx(() => Row(children: [
            Expanded(child: gr_button_mien("Nam", "N")),
            Expanded(child: gr_button_mien("Trung", "T")),
            Expanded(child: gr_button_mien("Bắc", "B")),
          ],)),
          Expanded(child: GiaKieu1()),

        ],
      ),
    );
  }
}
// ignore: non_constant_identifier_names
Widget gr_button_mien(String text, String selectbutton) {
  return SizedBox(
    height: 50,
    child: ElevatedButton(
        onPressed: () {
          GiaKhachController().to.thay_doi_mien(selectbutton);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor:
            selectbutton == GiaKhachController().to.mien.value
                ? Colors.grey
                : Colors.white70,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero)),
        child: Text(
          text,
          style: TextStyle(
              color:
              selectbutton == GiaKhachController().to.mien.value
                  ? Colors.white
                  : Colors.black),
        )),
  );
}