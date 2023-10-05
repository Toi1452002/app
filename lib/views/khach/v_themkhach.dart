import 'package:flutter/material.dart';
import 'package:ttpmn/controllers/khach/khach_controller.dart';
import 'package:ttpmn/views/khach/cau_hinh.dart';
import '../../widgets/wgt_button.dart';
import 'chinh_gia.dart';

class V_ThemKhach extends StatelessWidget {
  const V_ThemKhach({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Giá khách"),
            actions: [
              Wgt_button(
                onPressed: () {
                  KhachController().to.insert_khach();
                },
                width: 100,
                text: "Lưu",
                color: Colors.lightBlue.withOpacity(.8),
              )
            ],
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  text: "Chỉnh giá",
                ),
                Tab(
                  text: "Cấu hình",
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              ChinhGia(),
              CauHinh(),
            ],
          ),
        ),
      ),
    );
  }
}
