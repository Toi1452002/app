import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpmn/controllers/khach/giakhach_controller.dart';
import 'package:ttpmn/widgets/wgt_textfiled.dart';

import '../../models/giakhach_model.dart';

class GiaKieu1 extends StatelessWidget {
  const GiaKieu1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController co = TextEditingController();
    TextEditingController trung = TextEditingController();
    return GetBuilder<GiaKhachController>(builder: (controller) {
      List<GiaKhachModel> giakhach = controller.lstGiaKhach;
      return Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                "Mã kiểu",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              )),
              Expanded(
                  child: Text(
                "Cò M${controller.mien}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              )),
              Expanded(
                  child: Text(
                "Trúng M${controller.mien}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              )),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: giakhach.length,
              itemBuilder: (context, index) {
                if (controller.mien.value == "N") {
                  co.text = giakhach[index].CoMN.toString();
                  trung.text = giakhach[index].TrungMN.toString();
                } else if (controller.mien.value == "T") {
                  co.text = giakhach[index].CoMT.toString();
                  trung.text = giakhach[index].TrungMT.toString();
                } else {
                  co.text = giakhach[index].CoMB.toString();
                  trung.text = giakhach[index].TrungMB.toString();
                }
                return Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          giakhach[index].MaKieu,
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        flex: 2,
                        child: Wgt_TextField(
                          textAlign: TextAlign.center,
                          textInputType: TextInputType.number,
                          controller: TextEditingController(text: co.text),
                          onChanged: (value) {
                            if (value != "") {
                              if (controller.mien.value == "N") {
                                giakhach[index].CoMN = double.parse(value);
                              } else if (controller.mien.value ==
                                  "T") {
                                giakhach[index].CoMT = double.parse(value);
                              } else {
                                giakhach[index].CoMB = double.parse(value);
                              }
                            }
                          },
                        )),
                    Expanded(
                        flex: 2,
                        child: Wgt_TextField(
                          textAlign: TextAlign.center,
                          textInputType: TextInputType.number,
                          controller: TextEditingController(text: trung.text),
                          onChanged: (value) {
                            if (value != "") {
                              if (controller.mien.value == "N") {
                                giakhach[index].TrungMN = double.parse(value);
                              } else if (controller.mien.value ==
                                  "T") {
                                giakhach[index].TrungMT = double.parse(value);
                              } else {
                                giakhach[index].TrungMB = double.parse(value);
                              }
                            }
                          },
                        )),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
