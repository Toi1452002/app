// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpmn/controllers/khach/giakhach_controller.dart';
import 'package:ttpmn/controllers/quanlytin/quanlytin_controller.dart';
import 'package:ttpmn/controllers/xuly/xuly_controller.dart';
import 'package:ttpmn/database/khach_db.dart';
import 'package:ttpmn/models/sdt_model.dart';

import '../../models/giakhach_model.dart';
import '../../models/khach_model.dart';

class KhachController extends GetxController{
  RxList<KhachModel> listKhachModel = const <KhachModel>[].obs;
  RxList<SdtModel> lstSdt = const <SdtModel>[].obs;
  RxString makhachErr = "".obs;
  KhachModel khachUpdate = KhachModel();
  TextEditingController makhachController = TextEditingController();
  TextEditingController sdtController = TextEditingController();
  TextEditingController hoiTongController = TextEditingController();
  TextEditingController hoi2SoController = TextEditingController();
  TextEditingController hoi3SoController = TextEditingController();
  KhachController get to => Get.find();

  KhachData khachData = KhachData();

  @override
  void onInit(){
    super.onInit();
    loadDanhSachKhach();

  }

  insert_khach() async{
    if(makhachController.text.isEmpty) {
      makhachErr.value="Tên khách không được bỏ trống!";
      update();
      return;
    }
    if(await khachData.ktra_makhach(makhachController.text, khachUpdate.ID!)){
      makhachErr.value="Tên khách đã tồn tại!";
      update();
      return;
    }
    //Insert
    if([null,0].contains(khachUpdate.ID) || khachUpdate.copy){
      int idInsert = await khachData.InsertKhach(KhachModel(
          ID: null,
          MaKhach: makhachController.text,
          ThuongMN: GiaKhachController().to.ck_thuongMN.value,
          ThemChiMN: GiaKhachController().to.ck_themchiMN.value,
          ThuongMT: GiaKhachController().to.ck_thuongMT.value,
          ThemChiMT: GiaKhachController().to.ck_themchiMT.value,
          ThuongMB: GiaKhachController().to.ck_thuongMB.value,
          ThemChiMB: GiaKhachController().to.ck_themchiMB.value,
          Hoi2s: hoi2SoController.text.isEmpty?0: double.parse(hoi2SoController.text),
          Hoi3s: hoi3SoController.text.isEmpty?0:double.parse(hoi3SoController.text),
          HoiTong:hoiTongController.text.isEmpty?0: double.parse(hoiTongController.text),
          KDauTren: GiaKhachController().to.b_dautren.value,
          tkDa: GiaKhachController().to.b_daxien2d.value?1:0
      ));
      if(idInsert!=0){
        XulyController().to.them_khach_cbb(makhachController.text);
        for (var sdt in lstSdt) {
          await khachData.insertSDT(SdtModel(KhachID: idInsert, SoDT: sdt.SoDT));
        }
        List<GiaKhachModel> listGia =
            GiaKhachController().to.lstGiaKhach.value;
        for (var item in listGia) {
          item.KhachID = idInsert;
          item.ID = null;
          await khachData.insertGiaKhach(item);
        }
      }
    }
    //Update
    else{

      await khachData.updateKhach(KhachModel(
          ID: khachUpdate.ID,
          MaKhach: makhachController.text,
          ThuongMN: GiaKhachController().to.ck_thuongMN.value,
          ThemChiMN: GiaKhachController().to.ck_themchiMN.value,
          ThuongMT: GiaKhachController().to.ck_thuongMT.value,
          ThemChiMT: GiaKhachController().to.ck_themchiMT.value,
          ThuongMB: GiaKhachController().to.ck_thuongMB.value,
          ThemChiMB: GiaKhachController().to.ck_themchiMB.value,
          Hoi2s: hoi2SoController.text.isEmpty?0: double.parse(hoi2SoController.text),
          Hoi3s: hoi3SoController.text.isEmpty?0:double.parse(hoi3SoController.text),
          HoiTong:hoiTongController.text.isEmpty?0: double.parse(hoiTongController.text),
          KDauTren: GiaKhachController().to.b_dautren.value,
          tkDa: GiaKhachController().to.b_daxien2d.value?1:0
      ));
      XulyController().to.sua_khach_cbb(khachUpdate.MaKhach, makhachController.text);
      for (var sdt in lstSdt) {
        await khachData.insertSDT(SdtModel(ID: sdt.ID, KhachID: khachUpdate.ID!, SoDT: sdt.SoDT));
      }
      List<GiaKhachModel> listGia =
          GiaKhachController().to.lstGiaKhach.value;
      for (var gia in listGia) {
        await khachData.updateGiaKhach(gia);
      }
    }

    loadDanhSachKhach();
    Get.back();
    ResetText();
  }

  loadDanhSachKhach() async{
    listKhachModel.value = await khachData.getListKhach();
    listKhachModel.sort((a,b)=> a.MaKhach.compareTo(b.MaKhach));
    update();
  }

  onEditKhach(KhachModel khachModel,{bool copy = false}) async {
    // ResetText();
    makhachErr.value = "";
    makhachController.text =copy ? "" : khachModel.MaKhach;
    hoiTongController.text = khachModel.HoiTong.toStringAsFixed(0);
    hoi2SoController.text = khachModel.Hoi2s.toStringAsFixed(0);
    hoi3SoController.text = khachModel.Hoi3s.toStringAsFixed(0);
    khachModel.copy = copy;
    khachUpdate = khachModel;
    // lstSdt.value =copy ? [] : await khachData.getSdtKhachID(khachUpdate.ID!);
    update();
  }

  // them_sdt(){
  //   if(sdtController.text.isNotEmpty){
  //     lstSdt.add(SdtModel(SoDT: sdtController.text));
  //     sdtController.clear();
  //   }
  //   update();
  // }

  xoa_khach(KhachModel khachModel) async{
    listKhachModel.remove(khachModel);
    await khachData.deleteKhach(khachModel);
    if(khachModel.MaKhach==XulyController().to.makhach.value){
      XulyController().loadTinNhan();

    }
    XulyController().to.xoa_khach_cbb(khachModel.MaKhach);
    QuanlytinController().to.lay_danhsachkhach();
    update();
  }
  xoa_sdt(SdtModel sdtModel) async {
    lstSdt.remove(sdtModel);
    if (sdtModel.ID != null) {
      await khachData.deleteSdtKhach(sdtModel.ID!);
    }
    update();
  }

  ResetText(){
    khachUpdate.ID = 0;
    makhachErr.value = "";
    makhachController.clear();
    sdtController.clear();
    hoi3SoController.clear();
    hoi2SoController.clear();
    hoiTongController.clear();
    lstSdt.clear();
    update();
  }
}