import 'package:get/get.dart';
import 'package:ttpmn/controllers/baocao/baocao_controller.dart';
import 'package:ttpmn/controllers/khach/khach_controller.dart';
import 'package:ttpmn/controllers/quanlytin/quanlytin_controller.dart';
import 'package:ttpmn/controllers/xuly/tinhtoan_controller.dart';
import '../controllers/login/dangnhap_controller.dart';
import '../controllers/xuly/tukhoa_controller.dart';
import '../controllers/xuly/xuly_controller.dart';

class InitialBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(KhachController());
    Get.put(XulyController());
    Get.put(QuanlytinController());
    Get.put(TinhToanController());
    Get.put(TuKhoaController());
    Get.put(BaocaoController());
    Get.put(DangNhapController());
  }

}