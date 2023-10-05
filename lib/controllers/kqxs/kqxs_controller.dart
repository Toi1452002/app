// ignore_for_file: non_constant_identifier_names

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:ttpmn/database/api.dart';
import 'package:ttpmn/database/hamchung_db.dart';
import 'package:ttpmn/database/kqxs_db.dart';
import 'package:ttpmn/server.dart';
import '../../function/extension.dart';
import '../../models/kqxs_model.dart';
import 'lay_kqxs_web.dart';
import 'package:http/http.dart' as http;

class KqxsController extends GetxController {
  RxString mien = "N".obs;
  Rx<DateTime> ngaylam = DateTime.now().obs;
  RxString thongbao = "".obs;
  RxList<KqxsModel> lstKqxs = const <KqxsModel>[].obs;
  RxBool danglaykqxs = false.obs;
  KqxsController get to => Get.find();
  KqxsData kqxsData = KqxsData();
  HamChungDB hamChungDB = HamChungDB();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  thay_doi_ngaylam(DateTime ngay) {
    ngaylam.value = ngay;
    getKq(mien.value, ngay);
    update();
  }

  @override
  void onClose() {
    // TODO: implement
    Get.delete<KqxsController>();
    super.onClose();
  }

  thay_doi_mien(String value) {
    mien.value = value;
    getKq(value, ngaylam.value);

    update();
  }

  xoa_kqxs() async {
    lstKqxs.clear();
    await kqxsData.deleteAllKqxs();
    update();
  }

  getKq(String mien, DateTime ngay) async {
    thongbao.value = "";
    List<String> listMaDai = [];
    List tuychon = await hamChungDB.layTable("Select GiaTri From T00_TuyChon Where Ma = 'xsMN'");
    bool xsMN = tuychon[0]["GiaTri"].toString().toBool;
    int tt = 0;
    int selectedMaDai = 0;
    var row =
        await kqxsData.getKqxs(DateFormat("yyyy-MM-dd").format(ngay), mien);
    if (row.isEmpty) {
      bool isOnline = await hasNetwork();
      if (isOnline) {
        var user = await hamChungDB.layTable('Select MaKichHoat From T00_User');
        var url = Uri.parse(API.hostLogin);
        try{
          final response =  await http.post(url,body: {
            "TAIKHOAN": Server.taikhoan,
            "MATKHAU": Server.matkhau,
            "MAKICHHOAT": user[0]["MaKichHoat"]
          });
          // print("${Server.taikhoan}---${Server.matkhau}---${Server.idDevice}");
          if(response.statusCode==200){
            var row = jsonDecode(response.body);
            var data = row["data"];
            // Future.delayed(const Duration(seconds: 2),(){
              if(row["status"]){
                Server.ngayHetHan = data["NGAYHETHAN"].toString();
                Server.trangthai = data["TRANGTHAI"].toString();
                Server.ngayLamviec = data["NGAYLAMVIEC"].toString();
                Server.taikhoan = data["TAIKHOAN"].toString();
                Server.matkhau = data["MATKHAU"].toString();
                Server.idDevice  = data["MATHIETBI"].toString();
                Server.ID = data["ID"].toString();
                EasyLoading.dismiss();
              }else{
                EasyLoading.showToast("Không thể sử dụng!");
                Server.trangthai = "0";
                // Future.delayed(const Duration(seconds: 3),()=>SystemNavigator.pop());
              }

            }
        }catch(e){
          EasyLoading.showInfo("Lỗi lấy KQXS");
          print("Lỗi lấy kqxs $e");
        }
        danglaykqxs.value = true;
        EasyLoading.show(
            status: 'Đang lấy kết quả xổ số...',
            maskType: EasyLoadingMaskType.black);
        Map<String, dynamic> kqxs = await getKqxs(ngay, mien,xsMinhNgoc: xsMN).timeout(const Duration(seconds: 15),onTimeout: (){
          return {};
        });
        if(kqxs.isEmpty){
          danglaykqxs.value = false;
          EasyLoading.showError("Mạng không ổn định.\nKiểm tra lại internet");
          // EasyLoading.dismiss();
          update();
          return;
        }
        int maSo = mien == "B" ? 27 : 18;
        if (kqxs["ngay"] == DateFormat("yyyy-MM-dd").format(ngay) &&
            kqxs["kqSo"].length == kqxs["listDai"].length * maSo) {
          listMaDai = (kqxs["listDai"]);
          for (int i = 0; i < kqxs["kqSo"].length; i++) {
            tt++;
            if (mien == "B") {
              await kqxsData.insertKqxs(KqxsModel(
                  Ngay: kqxs["ngay"],
                  Mien: mien,
                  MaDai: "mb",
                  MaGiai: giaiMB(tt),
                  TT: tt,
                  KqSo: kqxs["kqSo"][i]));
            } else {
              int stt = tt % 18 == 0 ? 18 : tt % 18;

              await kqxsData.insertKqxs(KqxsModel(
                  Ngay: kqxs["ngay"],
                  Mien: mien,
                  MaDai: listMaDai[selectedMaDai],
                  MaGiai: giaiMN(stt),
                  TT: stt,
                  KqSo: kqxs["kqSo"][i]));
              if (tt % 18 == 0) {
                selectedMaDai++;
              }
            }
          }
          lstKqxs.value = await kqxsData.getKqxs(
              DateFormat("yyyy-MM-dd").format(ngay), mien);
          danglaykqxs.value = false;
          EasyLoading.dismiss();
        } else {
          EasyLoading.dismiss();
          danglaykqxs.value = false;
          thongbao.value = "Chưa có kết quả xổ số";
          // EasyLoading.showToast("Chưa có kết qua xổ số");
          lstKqxs.clear();
        }
      } else {
        EasyLoading.showInfo("Không có Internet!");
      }
    } else {
      thongbao.value = "";
      lstKqxs.value = row;
      EasyLoading.dismiss();
    }
  }
}
