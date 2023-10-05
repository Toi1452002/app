// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';
import 'package:ttpmn/function/extension.dart';

import '../../database/khach_db.dart';
import '../../models/giakhach_model.dart';
import '../../models/khach_model.dart';
import 'khach_controller.dart';

class GiaKhachController extends GetxController{
  List<GiaKhachModel> gia_ban_dau_k1 = [
      GiaKhachModel(MaKieu: "2s", CoMN: 70, TrungMN: 70, CoMT: 70, TrungMT: 70, CoMB: 70, TrungMB: 70),
      GiaKhachModel(MaKieu: "3s", CoMN: 70, TrungMN: 600, CoMT: 70, TrungMT: 600, CoMB: 70, TrungMB: 600),
      GiaKhachModel(MaKieu: "4s", CoMN: 70, TrungMN: 5000, CoMT: 70, TrungMT: 5000, CoMB: 70, TrungMB: 5000),
      GiaKhachModel(MaKieu: "dt", CoMN: 70, TrungMN: 500, CoMT: 70, TrungMT: 500, CoMB: 70, TrungMB: 500),
      GiaKhachModel(MaKieu: "dx", CoMN: 70, TrungMN: 500, CoMT: 70, TrungMT: 500, CoMB: 0, TrungMB: 0),
  ];
  List<GiaKhachModel> gia_ban_dau_k2 = [
    GiaKhachModel(MaKieu: "ab", CoMN: 12.6, TrungMN: 70, CoMT: 12.6, TrungMT: 70, CoMB: 18.9, TrungMB: 70),
    GiaKhachModel(MaKieu: "xc", CoMN: 12.6, TrungMN: 600, CoMT: 12.6, TrungMT: 600, CoMB: 18.9, TrungMB: 600),
    GiaKhachModel(MaKieu: "b2", CoMN: 12.6, TrungMN: 70, CoMT: 12.6, TrungMT: 70, CoMB: 18.9, TrungMB: 70),
    GiaKhachModel(MaKieu: "b3", CoMN: 11.9, TrungMN: 600, CoMT: 11.9, TrungMT: 600, CoMB: 16.1, TrungMB: 600),
    GiaKhachModel(MaKieu: "b4", CoMN: 11.2, TrungMN: 5000, CoMT: 11.2, TrungMT: 5000, CoMB: 14, TrungMB: 5000),
    GiaKhachModel(MaKieu: "dt", CoMN: 70, TrungMN: 500, CoMT: 70, TrungMT: 500, CoMB: 70, TrungMB: 500),
    GiaKhachModel(MaKieu: "dx", CoMN: 70, TrungMN: 500, CoMT: 70, TrungMT: 500, CoMB: 70, TrungMB: 500),
    GiaKhachModel(MaKieu: "d4", CoMN: 70, TrungMN: 5000, CoMT: 70, TrungMT: 5000, CoMB: 70, TrungMB: 5000),
  ];
  RxInt rdo_KieuTl = 1.obs;
  RxString mien = "N".obs;
  RxList<GiaKhachModel> lstGiaKhach = const <GiaKhachModel>[].obs;
  RxBool b_daxien2d = true.obs;
  RxBool b_dautren = false.obs;
  RxBool ck_thuongMN = false.obs;
  RxBool ck_themchiMN = false.obs;
  RxBool ck_thuongMB = false.obs;
  RxBool ck_themchiMB = false.obs;
  RxBool ck_thuongMT = false.obs;
  RxBool ck_themchiMT = false.obs;

  KhachData khachData = KhachData();

  GiaKhachController get to => Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    if(KhachController().to.khachUpdate.ID==null|| KhachController().to.khachUpdate.ID==0){
      lstGiaKhach.value = rdo_KieuTl.value==1?gia_ban_dau_k1:gia_ban_dau_k2;
    }
    else{
      onEditGiaKhach();
    }
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  thay_doi_mien(String value){
    mien.value = value;
    update();
  }

  thay_doi_thuongDT(bool value, String mien){
    if(mien=="N"){
      if(!value)ck_themchiMN.value = false;
      ck_thuongMN.value = value;
    }else if(mien=="T"){
      if(!value)ck_themchiMT.value = false;
      ck_thuongMT.value = value;
    }else{
      if(!value)ck_themchiMB.value = false;
      ck_thuongMB.value = value;
    }
    update();
  }

  thay_doi_themchi(bool value, String mien){
    if(mien=="N"){
      ck_themchiMN.value = value;
    }else if(mien=="T"){
      ck_themchiMT.value = value;
    }else{
      ck_themchiMB.value = value;
    }
    update();
  }

  thay_doi_kieuTl(){
    rdo_KieuTl.value = rdo_KieuTl.value==1?2:1;
    lstGiaKhach.value = rdo_KieuTl.value==1?gia_ban_dau_k1:gia_ban_dau_k2;
    update();
  }

  thay_doi_daxien2d(value){
    b_daxien2d.value = value;
    update();
  }

  thay_doi_dautren(value){
    b_dautren.value = value;
    update();
  }

  onEditGiaKhach() async {
    KhachModel khachModel = KhachController().to.khachUpdate;
    lstGiaKhach.value = await khachData.loadGiaKhachID(khachModel.ID!);
    ck_thuongMN.value = khachModel.ThuongMN;
    ck_themchiMN.value = khachModel.ThemChiMN;
    ck_thuongMT.value = khachModel.ThuongMT;
    ck_themchiMT.value = khachModel.ThemChiMT;
    ck_thuongMB.value = khachModel.ThuongMB;
    ck_themchiMB.value = khachModel.ThemChiMB;
    b_daxien2d.value = khachModel.tkDa.toString().toBool;
    b_dautren.value = khachModel.KDauTren;
    update();
  }

}