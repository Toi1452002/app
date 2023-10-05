// ignore_for_file: non_constant_identifier_names, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:ttpmn/controllers/quanlytin/quanlytin_controller.dart';
import 'package:ttpmn/controllers/xuly/tinhtoan_controller.dart';
import 'package:ttpmn/database/hamchung_db.dart';
import 'package:ttpmn/function/extension.dart';
import '../../database/khach_db.dart';
import '../../database/tinnhan_db.dart';
import '../../function/kiem_loi/hamSoDanh.dart';
import '../../function/kiem_loi/kiemloi_function.dart';
import '../../function/kiem_loi/hamXL.dart';
import '../../function/thaydoimien.dart';
import '../../models/khach_model.dart';
import '../../models/tinnhan_model.dart';
import '../../widgets/custom_text_controller.dart';

class XulyController extends GetxController{
  Rx<DateTime> ngaylam = DateTime.now().obs;
  Rx<String> makhach = "".obs;
  Rx<String> mien = "Nam".obs;
  KhachData khachData = KhachData();
  RxList<String> lst_cbb_khach = const <String>[].obs;
  TinNhanModel tinnhan = TinNhanModel();
  RxList<Map> lstXemChiTiet = <Map>[].obs;
  RxInt idTinNhan = 0.obs;
  Rx<TextEditingController> tinXLController = CustomTextController().obs;
  TinNhanData tinNhanData = TinNhanData();
  HamChungDB hamChungDB = HamChungDB();
  RxString textError = "".obs;
  // RxList<SmsMessage> tinSMS = <SmsMessage>[].obs;
  XulyController get to => Get.find();
  String ss_sdt = "";
  @override
  void onInit(){
    load_cbb_khach();
    loadTinNhan();
    // Capquyentruycap_SMS();
    super.onInit();
  }

  kiemloi() async{
    String tin = tinXLController.value.text;
    EasyLoading.show(status: "Đang xử lý...",maskType: EasyLoadingMaskType.clear);
    tin = ThayKyTu_TV(tin.toLowerCase());
    List<Map> lstDThayThe = await hamChungDB.layTable("SELECT CumTu, ThayThe From T01_TuKhoa Where SoDanhHang!='1'  Order by length(CumTu) desc");
    for (var x in lstDThayThe) {
      tin = tin.replaceAll(x['CumTu'], x['ThayThe']??' ');
    }
    tin =thayTuKhoa(tin).trim()
        .replaceAll(RegExp(r'[^\w\s]+'),' ')
        .replaceAll(RegExp(' +'), '.');
    bool kiemloi = false;
    if(tin!=""){

      tin = await hamXL(tin,ngaylam.value,mien.value[0]);
      tin = await hamXL(tin,ngaylam.value,mien.value[0]);
      kiemloi = await func_kiemloi(MaTin: idTinNhan.value,
          tin: tin,
          ngay: DateFormat("yyyy-MM-dd").format(ngaylam.value),
          mien: mien.value[0]);
    }else{
      EasyLoading.showError("Không có tin");
    }
    if(tin==""){
      tinXLController.value = CustomTextController();
      textError.value = '';
    }
    if(kiemloi && tin!=""){
      indexError = gl_list_index_loi;
      tinXLController.value = CustomTextController();
      textError.value = gl_loitin;
      EasyLoading.dismiss();
    }else if(!kiemloi && tin!=""){
      EasyLoading.dismiss();
      TinhToanController().to.ChoPhepTinhToan(true);

      tinXLController.value = CustomTextController();
      clearError();
    }
    await tinNhanData.updateTin(idTinNhan.value, "TinXL", tin);
    tinXLController.value.text = tin;

    update();
  }

  load_cbb_khach()async{
    List<KhachModel> lstKhach = await khachData.getListKhach();
    lst_cbb_khach.value = lstKhach.map((e) => e.MaKhach).toList();
    lst_cbb_khach.sort((a,b)=>a.compareTo(b));
    update();
  }

  thay_doi_ngaylam(DateTime dateTime){
    ngaylam.value = dateTime;
    updateTinNhan();
    QuanlytinController().to.lay_danhsachkhach();
    update();
  }

  thay_doi_mien(String value){
    mien.value = value;
    updateTinNhan();
    update();
  }

  thay_doi_makhach(String value)async
  {
    makhach.value = value;
    var idKhach = await hamChungDB.dLookup("ID", "TDM_Khach", "MaKhach = '${makhach.value}'");
    tinnhan.KhachID = idKhach;
    updateTinNhan();
    QuanlytinController().to.lay_danhsachkhach();
    update();
  }

  them_tin() async{
    clearError();
    TinhToanController().to.ClearText();
    TinhToanController().to.ChoPhepTinhToan(false);
    if(lst_cbb_khach.isEmpty){
      EasyLoading.showInfo("Không có khách hàng",dismissOnTap: true);
      return;
    }
    if(makhach==""){
      makhach.value = lst_cbb_khach.first;
    }
    var idKhach = await hamChungDB.dLookup("ID", "TDM_Khach", "MaKhach = '${makhach.value}'");
    int idInsert = await tinNhanData.themTinNhan(TinNhanModel(
      Mien: mien.value[0],
      Ngay: DateFormat("yyyy-MM-dd").format(ngaylam.value),
      KhachID: int.parse(idKhach.toString()),
    ));

    if(idInsert>0){
      tinXLController.value.clear();
      idTinNhan.value = idInsert;
      tinnhan.ID = idInsert;
      tinnhan.KhachID = idKhach;
      QuanlytinController().to.lay_danhsachkhach();
    }
    update();
  }

  them_khach_cbb(String khach){
    lst_cbb_khach.add(khach);
    lst_cbb_khach.sort((a,b)=>a.compareTo(b));
    update();
  }


  sua_khach_cbb(String khachcu, String khachmoi){
    if(khachcu==makhach.value){
      makhach.value = khachmoi;
    }
    lst_cbb_khach.remove(khachcu);
    lst_cbb_khach.add(khachmoi);
    updateTinNhan();
    lst_cbb_khach.sort((a,b)=>a.compareTo(b));
    update();
  }

  xoa_khach_cbb(String khach){
    lst_cbb_khach.remove(khach);
    if(khach==makhach.value){
      makhach.value = lst_cbb_khach.isEmpty?"":lst_cbb_khach.first;
      loadTinNhan();
    }
    update();
  }

  loadTinNhan() async{
    clearError();
    tinXLController.value.clear();
    tinnhan = await tinNhanData.layTinNhanCuoi();
    if(tinnhan.ID!=null){
      idTinNhan.value = tinnhan.ID!;
      mien.value = MaMien_Thanh_Mien(tinnhan.Mien);
      makhach.value = tinnhan.MaKhach;
      ngaylam.value = DateTime.parse(tinnhan.Ngay);
      tinXLController.value.text = tinnhan.TinXL.toString().isEmpty?tinnhan.TinGoc.toString():tinnhan.TinXL.toString();
      List<Map<String, dynamic>> tienphieu = await hamChungDB.layTable("Select * From VXL_TongTienPhieu WHERE TinNhanID = ${tinnhan.ID!}");
      TinhToanController().to.onLoadTienPhieu(tp: tienphieu[0]);
    }else{
      TinhToanController().to.onLoadTienPhieu();
      idTinNhan.value = 0;
    }
    update();
  }

  updateTinNhan() async{
    TinNhanModel tnmd = TinNhanModel(
      ID: idTinNhan.value,
      Ngay: DateFormat("yyyy-MM-dd").format(ngaylam.value),
      Mien: mien.value[0],
      KhachID: tinnhan.KhachID,
    );
    await tinNhanData.updateTinNhan(tnmd);

    tinnhan = tnmd;
  }
  onEditTinNhan(String ID) async {
    TinNhanModel tinNhanModel = await tinNhanData.layTinNhanID(ID);
    ngaylam.value = DateTime.parse(tinNhanModel.Ngay);
    makhach.value = tinNhanModel.MaKhach;
    var idKhach = await hamChungDB.dLookup("ID", "TDM_Khach", "MaKhach = '${makhach.value}'");
    tinnhan.KhachID = idKhach;
    mien.value = MaMien_Thanh_Mien(tinNhanModel.Mien);
    idTinNhan.value = tinNhanModel.ID!;
    tinXLController.value.text = tinNhanModel.TinXL.toString().isEmpty?tinNhanModel.TinGoc.toString():tinNhanModel.TinXL.toString();
    List<Map<String, dynamic>> tienphieu = await hamChungDB.layTable("Select * From VXL_TongTienPhieu WHERE TinNhanID = $ID");
    TinhToanController().to.onLoadTienPhieu(tp: tienphieu[0]);
    update();
  }

  updateTinGoc(String value) async{
    if(value==""){
      clearError();
    }
    var a = await hamChungDB.layTable("Select TinXL From TXL_TinNhan WHERE ID = ${idTinNhan.value}");
    if(a[0]["TinXL"]==""){
      await tinNhanData.updateTin(idTinNhan.value,"TinGoc", value);
    }else{
      await tinNhanData.updateTin(idTinNhan.value,"TinXL", value);
    }
  }

  khoiphuctin() async{
    TinhToanController().to.ChoPhepTinhToan(false);
    var a = await hamChungDB.layTable("Select TinGoc From TXL_TinNhan WHERE ID = ${idTinNhan.value}");
    await tinNhanData.updateTin(idTinNhan.value,"TinXL", "");
    clearError();
    tinXLController.value.text = a[0]["TinGoc"];
    Get.back();
  }

  clearError(){
    indexError.clear();
    textError.value = "";
    update();
  }

  xemchitiet() async{
    lstXemChiTiet.value = await hamChungDB.layTable('Select * From TXL_TinPhanTichCT Where TinNhanID = ${idTinNhan.value}');
    update();
  }
  // SmsQuery query =  SmsQuery();
  // Future getAllMessages() async {
  //   // tinSMS.clear();
  //   final status = await Permission.sms.request();
  //
  //   List<SmsMessage> messages= [];
  //   if(status.isPermanentlyDenied){
  //     Get.defaultDialog(
  //       radius: 10,
  //       middleText: "Chưa cấp quyền truy cập SMS.\n Đến cài đặt để cấp quyền?",
  //       title: "Thông báo!",
  //       cancel: OutlinedButton(onPressed: ()=>Get.back(), child: Text("Hủy")),
  //       confirm: ElevatedButton(onPressed: (){
  //         openAppSettings();
  //         Get.back();
  //       }, child: Text("Chấp nhận")),
  //     );
  //    // await Permission.notification.request();
  //   }
  //   if(status.isGranted){
  //      messages = await query.getAllSms;
  //   }
  //   List<Map<String, dynamic>> SoDT = await hamChungDB.layTable("SELECT * FROm TDM_SoDT Where KhachID = '${tinnhan.KhachID}'");
  //
  //   for(var x in SoDT){
  //     // print(tinSMS);
  //     if(ss_sdt==x["SoDT"].toString() && tinSMS.isNotEmpty){
  //       break;
  //     }
  //     EasyLoading.show(status: "Loading...",maskType: EasyLoadingMaskType.black);
  //     if(x["SoDT"].toString().length>=9 ){
  //
  //       tinSMS.clear();
  //       String sdt = "+84${x["SoDT"].toString().lastChars(9)}";
  //       messages = messages.where((e) => DateFormat("dd-MM-yyyy").format(e.date!)==DateFormat("dd-MM-yyyy").format(ngaylam.value)).toList();
  //       tinSMS.value = messages.where((e) => e.address==sdt).toList();
  //       tinSMS.value.sort((a,b)=>a.date!.compareTo(b.date!));
  //       ss_sdt = x["SoDT"].toString();
  //       // break;
  //     }
  //
  //   }
  //   EasyLoading.dismiss();
  //   update();
  // }
  // Capquyentruycap_SMS ()async {
  //   final status = await Permission.sms.request();
  //   if (status.isGranted) {
  //     // Open the camera
  //     print("Người dùng đã cấp quyền...");
  //   } else {
  //     // Permission denied
  //     print('Người dùng đã từ chối cấp quyền...');
  //   }
  // }
}