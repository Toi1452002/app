import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/views/baocao/baochittiet/thubu.dart';
import 'package:ttpmn/widgets/wgt_drawer.dart';

import '../../controllers/baocao/baocao_controller.dart';
import '../../widgets/custom_dropdown_2.dart';
import 'baochittiet/tientrung.dart';
import 'baochittiet/tienxac.dart';

class BaoCaoView extends StatelessWidget {
  const BaoCaoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: const Wgt_Drawer(),
      appBar: AppBar(
        title: const Text("Báo cáo"),
        actions: [
          ElevatedButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                locale: const Locale("vi", ""),
                context: context,
                initialEntryMode: DatePickerEntryMode.calendar,
                initialDate: BaocaoController().to.ngaylam.value,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                fieldHintText: "Ngày/Tháng/Năm",
                helpText: "Chọn ngày",
              );
              if (newDate != null) {
                BaocaoController().to.thay_doi_ngaylam(newDate);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[200],
                shape: const BeveledRectangleBorder()),
            child: Obx(() => Text(
              DateFormat("dd/MM/yyyy").format(BaocaoController().to.ngaylam.value),
              style: const TextStyle(color: Colors.black),
            )),
          ),
          IconButton(onPressed: (){
            BaocaoController().to.loadBaoCao();
          }, icon: const Icon(Icons.refresh_outlined))
        ],
      ),
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 2))
          ]),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Obx((){
                  List<String> maKhach = BaocaoController().to.lstMaKhach.value;
                  maKhach.sort((a,b)=>a.compareTo(b));
                  return CustomDropdownButton2(
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      iconSize: 20,
                      buttonDecoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.zero),
                      hint: "",
                      dropdownWidth: 240,
                      dropdownDecoration:
                      const BoxDecoration(borderRadius: BorderRadius.zero),
                      value: BaocaoController().to.makhach.value==""?null:BaocaoController().to.makhach.value,
                      dropdownItems: maKhach,
                      onChanged: (value) {
                        BaocaoController().to.thay_doi_khach(value!);
                      });
                }),
              ),
              Expanded(
                flex: 1,
                child: Obx(()=>CustomDropdownButton2(
                    icon: const Icon(Icons.arrow_drop_down_sharp),
                    iconSize: 20,
                    buttonDecoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.zero),
                    hint: "",
                    dropdownWidth: 120,
                    dropdownDecoration:
                    const BoxDecoration(borderRadius: BorderRadius.zero),
                    value: BaocaoController().to.mien.value==""?null:BaocaoController().to.mien.value,
                    dropdownItems: const ["Nam", "Trung", "Bắc"],
                    onChanged: (value) {
                      BaocaoController().to.thay_doi_mien(value!);
                    })),
              ),
            ],
          ),
        ),
        Expanded(
          child: DefaultTabController(length: 3, child: Column(children: [
            Container(
              color: Theme.of(context).primaryColor,

              child: const TabBar(indicatorColor: Colors.white,tabs: [
                Tab(text: "Thu bù"),
                Tab(text: "Tiền xác"),
                Tab(text: "Tiền trúng"),
              ]),
            ),
            const Expanded(
              child: TabBarView(children: [
                ThuBu(),
                TienXac(),
                TienTrung()
              ]),
            )
          ],)),
        ),

      ],),
    );
  }
}
