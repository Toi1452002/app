// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:ttpmn/controllers/baocao/baocaotongket_controller.dart';
import 'package:ttpmn/controllers/kqxs/kqxs_controller.dart';
import 'package:ttpmn/views/baocao/baochittiet/baocaochitiet_k1_view.dart';
import 'package:ttpmn/views/khach/v_themkhach.dart';
import 'package:ttpmn/views/khach/v_khach.dart';
import 'package:ttpmn/views/kqxs/v_kqxs.dart';
import 'package:ttpmn/views/login/v_dangky.dart';
import 'package:ttpmn/views/login/v_dangnhap.dart';
import 'package:ttpmn/views/login/v_kichhoat.dart';
import 'package:ttpmn/views/login/v_thaydoimay.dart';
import 'package:ttpmn/views/setting/v_setting.dart';
import 'package:ttpmn/views/thaythetukhoa/v_thaythetukhoa.dart';
import 'package:ttpmn/views/quanlytin/chitiet_tinxuly.dart';
import 'package:ttpmn/views/xuly/v_xuly.dart';
import 'package:ttpmn/widgets/tab_pages.dart';
import 'controllers/khach/giakhach_controller.dart';
import 'views/baocao/baocaotongtien_view.dart';


abstract class routerName{
  static const v_dangky = "/v_dangky";
  static const v_kichhoat = "/v_kichhoat";
  static const v_dangnhap = "/";
  static const v_doimay = "/v_doimay";
  static const tabs_page = "/tabpage";
  static const v_setting = "/v_setting";
  static const v_xuly = "/v_xuly";
  static const v_thaythetukhoa = "/v_thaythetukhoa";
  static const v_baocaotongtien = "/v_baocaotongtien";
  static const v_chitiettinXL = "/v_chitiettinXL";
  static  const v_baocaochitiet_k1 = "/v_baocaochitiet_k1";
  static const v_khach = "/v_khach";
  static const v_addKhach = "/v_addKhach";
  static const v_kqxs = "/v_kqxs";
}


List<GetPage> getRouter() {
  return [
    GetPage(name: routerName.v_dangky, page: () => V_DangKy()),
    GetPage(name: routerName.v_dangnhap, page: () => V_DangNhap()),
    GetPage(name: routerName.v_kichhoat, page: () => V_KichHoat()),
    GetPage(name: routerName.v_doimay, page: () => V_DoiMay()),
    GetPage(name: routerName.tabs_page, page: () => TabPage()),
    GetPage(name: routerName.v_setting, page: () =>   V_Setting()),
    GetPage(name: routerName.v_xuly, page: () =>  V_XuLy()),
    GetPage(name: routerName.v_thaythetukhoa, page: () => const V_ThayTheTuKhoa()),
    // GetPage(name: "/tin_sms", page: () => const TinSMS()),
    GetPage(name: routerName.v_baocaotongtien, page: () => const BaoCaoTongTienView(),binding: BindingsBuilder((){
      Get.lazyPut(() => BaocaoTongKetController());
    })),
    GetPage(name: routerName.v_chitiettinXL, page: () =>  const ChiTietTinXuLY()),
    GetPage(name: routerName.v_baocaochitiet_k1, page: () =>  const BaoCaoCTK1View()),
    GetPage(name: routerName.v_khach, page: () => const V_Khach()),
    GetPage(
        name: routerName.v_addKhach,
        page: () => const V_ThemKhach(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => GiaKhachController());
        })),
    GetPage(
        name:routerName.v_kqxs,
        page: () => const V_Kqxs(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => KqxsController());
        }))
  ];
}

