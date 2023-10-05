// ignore_for_file: non_constant_identifier_names

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/controllers/xuly/xuly_controller.dart';
import 'package:ttpmn/database/tinnhan_db.dart';
import 'package:ttpmn/function/extension.dart';
import '../../database/khach_db.dart';
import '../../database/kqxs_db.dart';
import '../../function/kiem_loi/hamDB.dart';
import '../../function/tinhtoan_function.dart';
import '../../models/giakhach_model.dart';
import '../../models/khach_model.dart';
import '../../models/kqxs_model.dart';
import '../../models/madai_model.dart';
import '../../models/tinnhan_ptct_model.dart';
import '../../server.dart';
import '../kqxs/kqxs_controller.dart';
List<Map> lstSoHang = [];
List<String> CumTu = [];
class TinhToanController extends GetxController {
  RxDouble TienXac = 0.0.obs;
  RxDouble TienVon = 0.0.obs;
  RxDouble TienTrung = 0.0.obs;
  RxDouble LaiLo = 0.0.obs;
  List<GiaKhachModel> giaKhach = const <GiaKhachModel>[];
  KhachModel khachModel = KhachModel();

  TinhToanController get to => Get.find();


  /// false-tat  true-mo
  RxBool ktra_tinhtoan = false.obs;
  KqxsData kqxsData = KqxsData();
  KhachData khachData = KhachData();
  TinNhanData tinNhanData = TinNhanData();

  List<KqxsModel> kqxs = const <KqxsModel>[];
  List<String> maDai = [];
  List<String> daiSo = ["2d", "3d", "4d"];
  String mien = "";
  String ngay = "";
  bool Bkxc = true;

  onLoadTienPhieu({Map<String, dynamic> tp =const {}}) {
    if(tp.isNotEmpty){
      TienXac.value = tp["Xac"] ?? 0;
      TienVon.value = tp["Von"] ?? 0;
      TienTrung.value = tp["Trung"] ?? 0;
      LaiLo.value =  tp["ThuBu"] ?? 0;
    }else{
      TienXac.value =  0;
      TienVon.value =  0;
      TienTrung.value =  0;
      LaiLo.value =  0;
    }

    update();
  }

  @override
  void onInit() async{
    super.onInit();
    lstSoHang.clear();
    CumTu.clear();
    lstSoHang = await layTable("SELECT CumTu, ThayThe FROM T01_TuKhoa WHERE SoDanhHang='1'");
    print(lstSoHang);
    for(var x in lstSoHang){
      CumTu.add(x["CumTu"]);
    }
    List tuychon = await layTable("SELECT * FROM T00_TuyChon Where Ma = 'kxc'  ");
    Bkxc = tuychon[0]["GiaTri"].toString().toBool;
  }
  onTinhToan() async {
    ClearText();
    ChoPhepTinhToan(false);
    EasyLoading.show(status: "Đang tính toán...",maskType: EasyLoadingMaskType.clear);
    await tinNhanData
        .deleteTinNhanPTCT(XulyController().to.idTinNhan.value);
    maDai.clear();
    int keyDai = -1;
    giaKhach = await khachData
        .loadGiaKhachID(XulyController().to.tinnhan.KhachID);
    khachModel =
        await khachData.getKhachID(XulyController().to.tinnhan.KhachID);
    String tinXl = XulyController().to.tinXLController.value.text;
    ngay = DateFormat("yyyy-MM-dd").format(XulyController().to.ngaylam.value);
    mien = XulyController().to.mien.value[0];

    kqxs = await kqxsData.getKqxs(ngay, mien);

    if (kqxs.isEmpty) {
      Get.lazyPut(() => KqxsController());
      await KqxsController().to.getKq(mien, DateTime.parse(ngay));
      kqxs = await kqxsData.getKqxs(ngay, mien);
      KqxsController().onClose();
    }

    List<MaDaiModel> getMaDai = await kqxsData.getMaDai(mien, ngay);
    // for (var item in getMaDai) {
    //   maDai.add(item.MaDai);
    // }
    maDai = getMaDai.map((e) => e.MaDai).toList();
    List<String> listTinGoc = tinXl.split(".");
    List<String> daiPhu = ["sb","dl","qn","bd","bt","dn"];
    List<String> listFullDai = [...daiSo, ...maDai,...daiPhu];

    List<String> listTin = [];
    for (int i = 0; i < listTinGoc.length; i++) {
      listTin.add(listTinGoc[i]);
      if (mien != "B") {
        if ((i > 1 && i < listTinGoc.length - 1 && listFullDai.contains(listTinGoc[i + 1]) && keyDai != i && i - keyDai > 2) || (i == listTinGoc.length - 1)) {
          tachTinSoDanh(listTin.join("."), listFullDai).forEach((i) {
            List<String> tin = i.split(".");
             tin.removeWhere((element) => element=="");
            var tien =
                TinhToan_Nam_Trung(tin: tin, listFullDai: listFullDai);
            TienXac.value += tien["TongXac"]!;
            TienVon.value += tien["TongVon"]!;
            TienTrung.value += tien["TongTrung"]!;
          });
          listTin.clear();
          keyDai = i;
        }
      }
      else {
        if (((i < listTinGoc.length - 1 && !listTinGoc[i][0].isNumeric && (listTinGoc[i].lastChars(1).isNumeric || listTinGoc[i].lastChars(1)=="n"))  && (listTinGoc[i + 1][0].isNumeric|| CumTu.contains(listTinGoc[i+1]) || listTinGoc[i+1]=="mb" || listTinGoc[i + 1].isNumeric)) || (i == listTinGoc.length - 1)) {
          var tien = TinhToan_Bac(tin: listTin);
          // print(listTin);
          TienXac.value += tien["TongXac"]!;
          TienVon.value += tien["TongVon"]!;
          TienTrung.value += tien["TongTrung"]!;
          listTin.clear();
        }
      }
    }
    await tinNhanData.updateTin(XulyController().to.idTinNhan.value, "DauTren", khachModel.KDauTren?1:0);
    LaiLo.value = TienVon.value - TienTrung.value;
    if(khachModel.HoiTong!=0 && LaiLo.value>0){
      double tongtien = LaiLo.value - (LaiLo.value*khachModel.HoiTong)/100;
      LaiLo.value = tongtien;
      await tinNhanData.updateTin(XulyController().to.idTinNhan.value, "TongTien", tongtien.toStringAsFixed(0));
    }else if(khachModel.Hoi2s!=0 || khachModel.Hoi3s!=0){
      var Von = await layTable("Select Von2s, Von3s, Trung2s, Trung3s From V_Ptich_Von Where TinNhanID = ${XulyController().to.idTinNhan.value}");
      double von2s = Von[0]["Von2s"]??0;
      double von3s = Von[0]["Von3s"]??0;
      double Trung2s = Von[0]["Trung2s"]??0;
      double Trung3s = Von[0]["Trung3s"]??0;
      double lailo2s = von2s-Trung2s;
      double lailo3s = von3s-Trung3s;
      if(lailo2s>0)lailo2s =lailo2s- (lailo2s*khachModel.Hoi2s)/100;
      if(lailo3s>0)lailo3s =lailo3s- (lailo3s*khachModel.Hoi3s)/100;

      await tinNhanData.updateTin(XulyController().to.idTinNhan.value, "TongTien", (lailo2s+lailo3s).toStringAsFixed(0));
      LaiLo.value = lailo2s+lailo3s;
    }else{
      await tinNhanData.updateTin(XulyController().to.idTinNhan.value, "TongTien", LaiLo.value);
    }

    EasyLoading.dismiss();
    if(kqxs.isEmpty){EasyLoading.showToast("Chưa có kết quả xổ số");}
    update();
  }

  ChoPhepTinhToan(bool value){
    ktra_tinhtoan.value = value;
    DateTime ngaylam = DateTime.parse(Server.ngayLamviec);
    DateTime ngayhethan = DateTime.parse(Server.ngayHetHan);
    if(ngayhethan.compareTo(ngaylam)<0){
      ktra_tinhtoan.value = false;
      EasyLoading.showToast("App đã hết hạn!\n Không thể tính toán",dismissOnTap: true,duration: const Duration(seconds: 3));
    }
    if(Server.trangthai=="0"){
      ktra_tinhtoan.value = false;
      EasyLoading.showInfo("Không thể tính toán",dismissOnTap: true,duration: const Duration(seconds: 3));
    }

    update();
  }
  bool ktra_dodai_sodanh(List<String> lstSoDanh,{required int length}){
    for(String x in lstSoDanh){
      if(x.length>=length)return true;
    }
    return false;
  }



  Map<String, double> TinhToan_Nam_Trung(
      {required List<String> tin, required List<String> listFullDai}) {
    List<String> listDai = getDaiFunc(tin, maDai, listFullDai,mien: mien,ngay: ngay);
    List<String> listKieuDanh = getKieuDanh(tin, listFullDai);
    List<String> listSoDanh = getSoDanh(tin, listFullDai);
    double tongXac = 0;
    double tongVon = 0;
    double tongTrung = 0;
    int k = 0;
    List<String> lstKD = [];
    for (String kd in listKieuDanh) {
      Map<String, dynamic> kieudanhTien = layKieuDanhVaTien(kd);
      String kieudanh = kieudanhTien["kieudanh"];
      if(kieudanh[0]=="d" && Bkxc && ktra_dodai_sodanh(listSoDanh,length: 4)) {
        lstKD.add(kieudanh);
      }else if(Bkxc){
        lstKD.add(thayDoiKieuDanh(kieudanh, listDai.length));
      }
      if(kieudanh=="dx" && ktra_dodai_sodanh(listSoDanh,length: 3)) kieudanh ="dxc";
      double tien = kieudanhTien["sotien"];
      List<String> listSoDanhChiTiet = getSoDanhCt(kieudanh, listSoDanh,lstKD: lstKD);
      if ((kieudanh=="dx"|| (["da","dv"].contains(kieudanh) && khachModel.tkDa==1)) && listDai.length > 1) {
        for (int i = 0; i < listDai.length; i++) {
          for (int j = i + 1; j < listDai.length; j++) {
            for (String sodanh in listSoDanhChiTiet) {
              int soLo = lay_so_lo_mn_mt(kieudanh: "dx", sodanh: sodanh);
              double tienXac = tien * soLo;
              double tienVon = tienXac * tien_von(kieudanh: "dx", sodanh: sodanh);
              tongXac += tienXac;
              tongVon += tienVon;
              var trung = doSoTrung_NT(sodanh: sodanh, kieudanh: "dx", listDai: [listDai[i], listDai[j]]);
              double tienTrung = 0;
              if (trung["status"]) {
                tienTrung = tien * trung["tientrung"] * trung["solantrung"];
                tongTrung += tienTrung;
              }
              tinNhanData.insertTinNhanPTCT(TinNhanPhanTichCTModel(
                  TinNhanID:  XulyController().to.idTinNhan.value,
                  KhachID: XulyController().to.tinnhan.KhachID,
                  MaKieu: "dx",
                  MaDai: listDai.join("."),
                  SoDai: listDai.length,
                  SoDanh: sodanh,
                  SoLanTrung: trung["solantrung"] ?? 0,
                  SoTien: tien,
                  TienTrung: tienTrung,
                  TienVon: tienVon,
                  TienXac: tienXac));
              // print(
              //     "Đài: ${listDai[i]}.${listDai[j]} | Số đánh: $sodanh | Kiểu đánh: $replaceKieuDanh | Số tiền: $tien | Xác: $tienXac ");
            }
          }
        }
      }
      else if (listDai.length > 1 && (kieudanh == "dt" || (["da","dv"].contains(kieudanh) && khachModel.tkDa==0))) {
        for (String dai in listDai) {
          for (String sodanh in listSoDanhChiTiet) {
            int soLo =
                lay_so_lo_mn_mt(kieudanh: "dt", sodanh: sodanh );
            double tienXac = tien * soLo  ;
            double tienVon = tienXac * tien_von(kieudanh: "dt", sodanh: sodanh);
            tongXac += tienXac;
            tongVon += tienVon;
            var trung =
                doSoTrung_NT(sodanh: sodanh, kieudanh: "dt", listDai: [dai]);
            double tienTrung = 0;
            if (trung["status"]) {
              tienTrung = tien * trung["tientrung"] * trung["solantrung"];
              tongTrung += tienTrung;
            }
            tinNhanData.insertTinNhanPTCT(TinNhanPhanTichCTModel(
                TinNhanID: XulyController().to.idTinNhan.value,
                MaKieu: "dt",
                MaDai: dai,
                KhachID: XulyController().to.tinnhan.KhachID,
                SoDai: 1,
                SoDanh: sodanh,
                SoLanTrung: trung["solantrung"] ?? 0,
                SoTien: tien,
                TienTrung: tienTrung,
                TienVon: tienVon,
                TienXac: tienXac));
            // print(tienXac);
            // print(
            //     "Đài: $dai | Số đánh: $sodanh | Kiểu đánh: $replaceKieuDanh | Số tiền: $tien | Xác: $tienXac ");
          }
        }
      } else {
        for (String sodanh in listSoDanhChiTiet) {
          if(listKieuDanh.length>1 && k>0 && [3,4].contains(sodanh.length) && Bkxc){
            if(sodanh.length==4){
              if(["b","xc","b7l"].contains(lstKD[k]) && ![k,-1].contains(lstKD.indexOf("b"))  ){
                sodanh = sodanh.substring(1);
              }
              else if(lstKD[k][0]=="d" && ( lstKD.where((e) => e=="b").length>1 || lstKD.where((e) => e=="xc").isNotEmpty)){
                sodanh = sodanh.substring(1);
              }
            }
            if(sodanh.length==3 || sodanh.length ==4){
              if(lstKD[k] =="dd" && ![k,-1].contains(lstKD.indexOf("xc")) ){
                sodanh = sodanh.substring(sodanh.length-2);
              }
            }
          }

          String replaceKieuDanh = thayDoiKieuDanh(kieudanh, listDai.length);
          int soLo = lay_so_lo_mn_mt(
              kieudanh: replaceKieuDanh, sodanh: sodanh );
          double tienXac = tien * soLo * listDai.length;
          double tienVon =
              tienXac * tien_von(kieudanh: replaceKieuDanh, sodanh: sodanh);
          tongXac += tienXac;
          tongVon += tienVon;
          var trung = doSoTrung_NT(
              sodanh: sodanh, kieudanh: replaceKieuDanh, listDai: listDai);
          double tienTrung = 0;
          if (trung["status"]) {
            tienTrung = tien * trung["tientrung"] * trung["solantrung"];
            tongTrung += tienTrung;
          }
          // print(sodanh);
          if(replaceKieuDanh=="xc" && [2,4].contains(sodanh.length) ) replaceKieuDanh="dd";
          if(replaceKieuDanh=="dd" && sodanh.length==3) replaceKieuDanh= "xc";
          tinNhanData.insertTinNhanPTCT(TinNhanPhanTichCTModel(
              TinNhanID: XulyController().to.idTinNhan.value,
              MaKieu: replaceKieuDanh,
              KhachID: XulyController().to.tinnhan.KhachID,
              MaDai: listDai.join("."),
              SoDai: listDai.length,
              SoDanh: sodanh,
              SoLanTrung: trung["solantrung"] ?? 0,
              SoTien: tien,
              TienTrung: tienTrung,
              TienVon: tienVon,

              TienXac: tienXac));

          // print(tienXac);
          // print(
          //     "Đài: ${listDai.join(".")} | Số đánh: $sodanh | Kiểu đánh: $replaceKieuDanh | Số tiền: $tien | Xác: $tienXac ");
        }
      }
      k+=1;
    }
    return {"TongXac": tongXac, "TongVon": tongVon, "TongTrung": tongTrung};
  }

  Map<String, double> TinhToan_Bac({required List<String> tin}) {
    List<String> listDai = getDaiFunc(tin, maDai, ["mb"]);
    List<String> listKieuDanh = getKieuDanh(tin, ["mb"]);
    List<String> listSoDanh = getSoDanh(tin, ["mb"]);
    double tongXac = 0;
    double tongVon = 0;
    double tongTrung = 0;
    int k = 0;
    List<String> lstKD = [];
    for (String kd in listKieuDanh) {
      Map<String, dynamic> kieudanhTien = layKieuDanhVaTien(kd);
      String kieudanh = kieudanhTien["kieudanh"];
      if(kieudanh[0]=="d" && Bkxc && ktra_dodai_sodanh(listSoDanh,length: 4)) {
        lstKD.add(kieudanh);
      }else if(Bkxc){
        lstKD.add(thayDoiKieuDanh(kieudanh, listDai.length));
      }
      if(kieudanh=="dx")kieudanh = "dxc";
      String replaceKieuDanh = thayDoiKieuDanh(kieudanh, 1);
      double tien = kieudanhTien["sotien"];
      List<String> listSoDanhChiTiet = getSoDanhCt(kieudanh, listSoDanh ,lstKD: lstKD);
      for (String sodanh in listSoDanhChiTiet) {
        if(listKieuDanh.length>1 && k>0 && [3,4].contains(sodanh.length) && Bkxc){
          if(sodanh.length==4){
            if(["b","xc","b7l"].contains(lstKD[k]) && ![k,-1].contains(lstKD.indexOf("b"))  ){
              sodanh = sodanh.substring(1);
            }
            else if(lstKD[k][0]=="d" && ( lstKD.where((e) => e=="b").length>1 || lstKD.where((e) => e=="xc").isNotEmpty)){
              sodanh = sodanh.substring(1);
            }
          }
          if(sodanh.length==3 || sodanh.length ==4){
            if(lstKD[k] =="dd" && ![k,-1].contains(lstKD.indexOf("xc")) ){
              sodanh = sodanh.substring(sodanh.length-2);
            }
          }
        }
        int soLo = lay_so_lo_mb(kieudanh: replaceKieuDanh, sodanh: sodanh);
        double tienXac = tien * soLo * listDai.length;
        double tienVon = tienXac *
            tien_von(
              kieudanh: replaceKieuDanh,
              sodanh: sodanh,
            );
        // print("$kieudanh---$sodanh--$tien");
        tongXac += tienXac;
        tongVon += tienVon;
        var trung = doSoTrung_MB(sodanh: sodanh, kieudanh: replaceKieuDanh);
        double tienTrung = 0;
        if (trung["status"]) {
          tienTrung = tien * trung["tientrung"] * trung["solantrung"];
          tongTrung += tienTrung;
        }
        if(replaceKieuDanh=="dd" && sodanh.length==3) replaceKieuDanh= "xc";
        tinNhanData.insertTinNhanPTCT(TinNhanPhanTichCTModel(
            TinNhanID: XulyController().to.idTinNhan.value,
            MaKieu: replaceKieuDanh,
            MaDai: "mb",
            KhachID: XulyController().to.tinnhan.KhachID,
            SoDai: 1,
            SoDanh: sodanh,
            SoLanTrung: trung["solantrung"] ?? 0,
            SoTien: tien,
            TienTrung: tienTrung,
            TienVon: tienVon,
            TienXac: tienXac));

      }
      k+=1;
    }
    return {"TongXac": tongXac, "TongVon": tongVon, "TongTrung": tongTrung};
  }

  Map<String, double> layVonTrung({required String kieu}) {
    double von = 0.0;
    double trung = 0.0;
    if (mien == "N") {
      von = giaKhach.firstWhere((element) => element.MaKieu == kieu).CoMN / 100;
      trung = giaKhach.firstWhere((element) => element.MaKieu == kieu).TrungMN;
    } else if (mien == "T") {
      von = giaKhach.firstWhere((element) => element.MaKieu == kieu).CoMT / 100;
      trung = giaKhach.firstWhere((element) => element.MaKieu == kieu).TrungMT;
    } else if (mien == "B") {
      von = giaKhach.firstWhere((element) => element.MaKieu == kieu).CoMB / 100;
      trung = giaKhach.firstWhere((element) => element.MaKieu == kieu).TrungMB;
    }
    return {"von": von, "trung": trung};
  }

  double tien_von({required String kieudanh, required String sodanh}) {
    double result = 0;

    switch (kieudanh) {
      case "b":
        result = layVonTrung(kieu: "${sodanh.length}s")["von"]!;
        break;
      case "xc":
      case "dd":
        result = 2;
        result = layVonTrung(kieu: "${sodanh.length}s")["von"]!;
        break;
      case "dau":
        result = layVonTrung(kieu: "${sodanh.length}s")["von"]!;

        break;
      case "dui":
        result = layVonTrung(kieu: "${sodanh.length}s")["von"]!;
        break;
      case "dt":
        result = layVonTrung(kieu: "dt")["von"]!;
        break;
      case "dx":
        result = layVonTrung(kieu: "dx")["von"]!;
        break;

      //b1l---b9l
      default:
        result = layVonTrung(kieu: "${sodanh.length}s")["von"]!;
        break;
    }
    return result;
  }

  Map<String, dynamic> doSoTrung_NT(
      {required String sodanh,
      required String kieudanh,
      required List<String> listDai}) {
    int demSoDanh = sodanh.length;
    if (kieudanh == "dt" || kieudanh == "dx") {
      demSoDanh = 2;
    }
    dynamic solanTrung = 0;
    double tienTrung = 0;
    List<String> so1 = [];
    List<String> so2 = [];
    for (String dai in listDai) {
      List<KqxsModel> kqxsDai =
          kqxs.where((element) => element.MaDai == dai).toSet().toList();
      for (var kq in kqxsDai) {
        if (kq.KqSo.length >= demSoDanh) {
          String kqSo = kq.KqSo.lastChars(demSoDanh);
          switch (kieudanh) {
            case "b":
              if (sodanh == kqSo) {
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "${sodanh.length}s")["trung"]!;
              }
              break;
            case "xc":
            case "dd":
              if (kq.MaGiai == "G${10 - sodanh.length}" || kq.MaGiai == "DB") {
                if (sodanh == kqSo) {
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "${sodanh.length}s")["trung"]!;
                }
              }
              break;
            case "dau":
              if (kq.MaGiai == "G${10 - sodanh.length}") {
                if (kqSo == sodanh) {
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "${sodanh.length}s")["trung"]!;
                }
              }
              break;
            case "dui":
              if (kq.MaGiai == "DB") {
                if (kqSo == sodanh) {
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "${sodanh.length}s")["trung"]!;
                }
              }
              break;
            case "dt":
            case "dx":
              int tt = 0;
              List<String> listSoDa = sodanh.split(".");
              for (int i = 0; i < listSoDa.length; i++) {
                if (kqSo == listSoDa[i] && kq.TT != tt) {
                  if (kqSo == listSoDa.first) {
                    so1.add(kqSo);
                  } else if(kqSo == listSoDa.last){
                    so2.add(kqSo);
                  }
                  tt = kq.TT;
                }
              }

              break;

            case "b1l":
              if(sodanh==kqSo && kq.MaGiai=="DB"){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "${sodanh.length}s")["trung"]!;
              }
              break;
            case "b2l":
              if(sodanh.length==4 && sodanh==kqSo && ["DB","G6"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G6" && kq.TT==3){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
                }else if(kq.MaGiai=="DB"){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
                }
              }else if(sodanh.length==3 && sodanh==kqSo && ["DB","G7"].contains(kq.MaGiai)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "3s")["trung"]!;
              }else if(sodanh.length==2 && sodanh==kqSo && ["DB","G8"].contains(kq.MaGiai)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "2s")["trung"]!;
              }
              break;
            case "b3l":
              if(sodanh.length==4 && sodanh==kqSo && ["DB","G6"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G6" && [3,4].contains(kq.TT)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
                }else if(kq.MaGiai=="DB"){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
                }
              }else if(sodanh.length==3 && sodanh==kqSo && ["DB","G7","G6"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G6" && kq.TT==3){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "3s")["trung"]!;
                }else if(["DB","G7"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "3s")["trung"]!;
                }

              }else if(sodanh.length==2 && sodanh==kqSo && ["DB","G8","G7"].contains(kq.MaGiai)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "2s")["trung"]!;
              }
              break;
            case "b4l":
              if(sodanh.length==4 && sodanh==kqSo && ["DB","G6"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }else if(sodanh.length==3 && sodanh==kqSo && ["DB","G7","G6"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G6" && [3,4].contains(kq.TT)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "3s")["trung"]!;
                }else if(["DB","G7"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "3s")["trung"]!;
                }

              }else if(sodanh.length==2 && sodanh==kqSo && ["DB","G8","G7","G6"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G6" && kq.TT == 3){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "2s")["trung"]!;
                }else if(["DB","G8","G7"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "2s")["trung"]!;
                }
              }
              break;
            case "b5l":
              if(sodanh.length==4 && sodanh==kqSo && ["DB","G6","G5"].contains(kq.MaGiai)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }else if(sodanh.length==3 && sodanh==kqSo && ["DB","G7","G6"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "3s")["trung"]!;

              }else if(sodanh.length==2 && sodanh==kqSo && ["DB","G8","G7","G6"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G6" && [3,4].contains(kq.TT)  ){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "2s")["trung"]!;
                }else if(["DB","G8","G7"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "2s")["trung"]!;
                }
              }
              break;
            case "b6l":
              if(sodanh.length==4 && sodanh==kqSo && ["DB","G6","G5","G4"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G4" && kq.TT==7){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
                }else if(["DB","G6","G5"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
                }

              }else if(sodanh.length==3 && sodanh==kqSo && ["DB","G7","G6","G5"].contains(kq.MaGiai)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "3s")["trung"]!;

              }else if(sodanh.length==2 && sodanh==kqSo && ["DB","G8","G7","G6"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "2s")["trung"]!;
              }
              break;
            case "b7l":
              if(sodanh.length==4 && sodanh==kqSo && ["DB","G6","G5","G4"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G4" && [7,8].contains(kq.TT) ){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
                }else if(["DB","G6","G5"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
                }

              }else if(sodanh.length==3 && sodanh==kqSo && ["DB","G7","G6","G5","G4"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G4" && kq.TT==7 ){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "3s")["trung"]!;
                }else if(["DB","G7","G6","G5"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "3s")["trung"]!;
                }

              }else if(sodanh.length==2 && sodanh==kqSo && ["DB","G8","G7","G6","G5"].contains(kq.MaGiai)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "2s")["trung"]!;
              }
              break;
            case "b8l":
              if(sodanh.length==4 && sodanh==kqSo && ["DB","G6","G5","G4"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G4" && [7,8,9].contains(kq.TT) ){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
                }else if(["DB","G6","G5"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
                }

              }else if(sodanh.length==3 && sodanh==kqSo && ["DB","G7","G6","G5","G4"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G4" && [7,8].contains(kq.TT)  ){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "3s")["trung"]!;
                }else if(["DB","G7","G6","G5"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "3s")["trung"]!;
                }

              }else if(sodanh.length==2 && sodanh==kqSo && ["DB","G8","G7","G6","G5","G4"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G4" && kq.TT == 7){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "2s")["trung"]!;
                }else if(["DB","G8","G7","G6","G5"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "2s")["trung"]!;
                }

              }
              break;
            case "b9l":
              if(sodanh.length==4 && sodanh==kqSo && ["DB","G6","G5","G4"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G4" && [7,8,9,10].contains(kq.TT) ){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
                }else if(["DB","G6","G5"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "4s")["trung"]!;
                }

              }else if(sodanh.length==3 && sodanh==kqSo && ["DB","G7","G6","G5","G4"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G4" && [7,8,9].contains(kq.TT)  ){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "3s")["trung"]!;
                }else if(["DB","G7","G6","G5"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "3s")["trung"]!;
                }

              }else if(sodanh.length==2 && sodanh==kqSo && ["DB","G8","G7","G6","G5","G4"].contains(kq.MaGiai)){
                if(kq.MaGiai=="G4" &&  [7,8].contains(kq.TT)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "2s")["trung"]!;
                }else if(["DB","G8","G7","G6","G5"].contains(kq.MaGiai)){
                  solanTrung += 1;
                  tienTrung = layVonTrung(kieu: "2s")["trung"]!;
                }

              }
              break;
          }
        }
      }
    }

    // print("$so1---$so2");
    /// Dò số đá thẳng
    if (so1.isNotEmpty && so2.isNotEmpty && kieudanh == "dt") {
      bool thuongda = false;
      bool themchi = false;
      if (mien == "N") {
        thuongda = khachModel.ThuongMN;
        themchi = khachModel.ThemChiMN;
      } else if (mien == "T") {
        thuongda = khachModel.ThuongMT;
        themchi = khachModel.ThemChiMT;
      }
      if (so1.length == so2.length && so1.isNotEmpty) {
        solanTrung = so2.length;
        tienTrung = layVonTrung(kieu: "dt")["trung"]!;
      } else if ((so1.length - so2.length == 1) ||
          (so2.length - so1.length == 1)) {
        if (thuongda) {
          solanTrung = so1.length - so2.length == 1
              ? so2.length + 0.5
              : so1.length + 0.5;
          tienTrung = layVonTrung(kieu: "dt")["trung"]!;
        } else {
          solanTrung = so1.length - so2.length == 1 ? so2.length : so1.length;
          tienTrung = layVonTrung(kieu: "dt")["trung"]!;
        }
      } else if ((so2.length - so1.length > 1) ||
          (so1.length - so2.length > 1)) {
        if (themchi) {
          solanTrung = so2.length - so1.length > 1
              ? so2.length - so1.length
              : so1.length - so2.length;
          tienTrung = layVonTrung(kieu: "dt")["trung"]!;
        } else if (thuongda) {
          solanTrung =
              so2.length - so1.length > 1 ? so1.length + 0.5 : so2.length + 0.5;
          tienTrung = layVonTrung(kieu: "dt")["trung"]!;
        } else {
          solanTrung = so2.length - so1.length > 1 ? so1.length : so2.length;
          tienTrung = layVonTrung(kieu: "dt")["trung"]!;
        }
      }
    }

    /// Dò số đá xiên
    else if (so1.isNotEmpty && so2.isNotEmpty && kieudanh == "dx") {
      if (so1.length == so2.length) {
        solanTrung = so1.length;
        tienTrung = layVonTrung(kieu: "dx")["trung"]!;
      } else {
        solanTrung = so1.length > so2.length ? so2.length : so1.length;
        tienTrung = layVonTrung(kieu: "dx")["trung"]!;
      }
    }


    return solanTrung > 0
        ? {"status": true, "solantrung": solanTrung, "tientrung": tienTrung}
        : {"status": false};
  }

  Map<String, dynamic> doSoTrung_MB(
      {required String sodanh, required String kieudanh}) {
    int demSoDanh = sodanh.length;
    double tienTrung = 0;
    if (kieudanh == "dt") {
      demSoDanh = 2;
    }
    List<String> so1 = [];
    List<String> so2 = [];
    dynamic solanTrung = 0;
    List<KqxsModel> kqxsMB =
        kqxs.where((element) => element.MaDai == "mb").toList();
    for (var kq in kqxsMB) {
      if (kq.KqSo.length >= demSoDanh) {
        String kqSo = kq.KqSo.lastChars(demSoDanh);
        switch (kieudanh) {
          case "b":
            if (sodanh == kqSo) {
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "${sodanh.length}s")["trung"]!;
            }
            break;
          case "xc":
            if (kq.MaGiai == "DB" || kq.MaGiai == "G6") {
              if (sodanh == kqSo) {
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "3s")["trung"]!;
              }
            }
            break;
          case "dd":
            String giai = "G${9 - sodanh.length}";
            if (kq.MaGiai == "DB" || kq.MaGiai == giai) {
              if (sodanh == kqSo) {
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "${sodanh.length}s")["trung"]!;
              }
            }
            break;
          case "dau":
            String giai = "G${9 - sodanh.length}";
            if (kq.MaGiai == giai) {
              if (kqSo == sodanh) {
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "${sodanh.length}s")["trung"]!;
              }
            }
            break;
          case "dui":
            if (kq.MaGiai == "DB") {
              if (kqSo == sodanh) {
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "${sodanh.length}s")["trung"]!;
              }
            }
            break;

          case "dt":
            int tt = 0;
            List<String> listSoDa = sodanh.split(".");
            for (int i = 0; i < listSoDa.length; i++) {
              if (kqSo == listSoDa[i] && kq.TT != tt) {
                if (listSoDa[i] == listSoDa.first) {
                  so1.add(listSoDa[i]);
                } else {
                  so2.add(listSoDa[i]);
                }
                tt = kq.TT;
              }
            }
            break;
          case "b1l":
            if(sodanh.length==4 && sodanh==kqSo && kq.MaGiai=="DB"){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "4s")["trung"]!;
            }else if(sodanh.length==3 && sodanh==kqSo && kq.MaGiai=="G6"){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "3s")["trung"]!;
            }else if(sodanh.length==2 && sodanh==kqSo && kq.MaGiai=="G7"){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "2s")["trung"]!;
            }
            break;
          case "b2l":
            if(sodanh.length==4 && sodanh==kqSo && ["DB","G5"].contains(kq.MaGiai)){
              if(kq.MaGiai=="G5" && [18,19,20].contains(kq.TT)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }else if(kq.MaGiai=="DB"){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }
            }else if(sodanh.length==3 && sodanh==kqSo && kq.MaGiai=="G6"){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "3s")["trung"]!;
            }else if(sodanh.length==2 && sodanh==kqSo && ["G7","G6"].contains(kq.MaGiai)){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "2s")["trung"]!;
            }
            break;
          case "b3l":
            if(sodanh.length==4 && sodanh==kqSo && ["DB","G5"].contains(kq.MaGiai)){
              if(kq.MaGiai=="G5" && [17,18,19,20].contains(kq.TT)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }else if(kq.MaGiai=="DB"){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }
            }else if(sodanh.length==3 && sodanh==kqSo && kq.MaGiai=="G6"){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "3s")["trung"]!;
            }else if(sodanh.length==2 && sodanh==kqSo && ["G7","G6"].contains(kq.MaGiai)){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "2s")["trung"]!;
            }
            break;
          case "b4l":
            if(sodanh.length==4 && sodanh==kqSo && ["DB","G5"].contains(kq.MaGiai)){
              if(kq.MaGiai=="G5" && [16,17,18,19,20].contains(kq.TT)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }else if(kq.MaGiai=="DB"){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }
            }else if(sodanh.length==3 && sodanh==kqSo && ["G6","DB"].contains(kq.MaGiai)  ){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "3s")["trung"]!;
            }else if(sodanh.length==2 && sodanh==kqSo && ["G7","G6"].contains(kq.MaGiai)){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "2s")["trung"]!;
            }
            break;
          case "b5l":
            if(sodanh.length==4 && sodanh==kqSo && ["DB","G5"].contains(kq.MaGiai)){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "4s")["trung"]!;
            }else if(sodanh.length==3 && sodanh==kqSo && ["G6","DB","G1"].contains(kq.MaGiai)  ){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "3s")["trung"]!;
            }else if(sodanh.length==2 && sodanh==kqSo && ["G7","G6"].contains(kq.MaGiai)){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "2s")["trung"]!;
            }
            break;
          case "b6l":
            if(sodanh.length==4 && sodanh==kqSo && ["DB","G5","G4"].contains(kq.MaGiai)){
              if(kq.MaGiai=="G4" && kq.TT==14){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }else if(["DB","G5"].contains(kq.MaGiai)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }
            }else if(sodanh.length==3 && sodanh==kqSo && ["G6","DB","G1","G2"].contains(kq.MaGiai)  ){
              if(kq.MaGiai=="G2" && [3,4].contains(kq.TT)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "3s")["trung"]!;
              }else if(["G6","DB","G1"].contains(kq.MaGiai))
              {
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "3s")["trung"]!;
              }

            }else if(sodanh.length==2 && sodanh==kqSo && ["G7","G6"].contains(kq.MaGiai)){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "2s")["trung"]!;
            }
            break;
          case "b7l":
            if(sodanh.length==4 && sodanh==kqSo && ["DB","G5","G4"].contains(kq.MaGiai)){
              if(kq.MaGiai=="G4" && [14,13].contains(kq.TT)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }else if(["DB","G5"].contains(kq.MaGiai)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }
            }else if(sodanh.length==3 && sodanh==kqSo && ["G6","DB","G1","G2"].contains(kq.MaGiai)  ){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "3s")["trung"]!;

            }else if(sodanh.length==2 && sodanh==kqSo && ["G7","G6"].contains(kq.MaGiai)){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "2s")["trung"]!;
            }
            break;
          case "b8l":
            if(sodanh.length==4 && sodanh==kqSo && ["DB","G5","G4"].contains(kq.MaGiai)){
              if(kq.MaGiai=="G4" && [14,13,12].contains(kq.TT)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }else if(["DB","G5"].contains(kq.MaGiai)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "4s")["trung"]!;
              }
            }else if(sodanh.length==3 && sodanh==kqSo && ["G6","DB","G1","G2","G3"].contains(kq.MaGiai)  ){
              if(kq.MaGiai=="G3" && kq.TT==5){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "3s")["trung"]!;
              }else if(["G6","DB","G1","G2"].contains(kq.MaGiai) ){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "3s")["trung"]!;
              }
            }else if(sodanh.length==2 && sodanh==kqSo && ["G7","G6","DB"].contains(kq.MaGiai)){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "2s")["trung"]!;
            }
            break;
          case "b9l":
            if(sodanh.length==4 && sodanh==kqSo && ["DB","G5","G4"].contains(kq.MaGiai)){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "4s")["trung"]!;
            }else if(sodanh.length==3 && sodanh==kqSo && ["G6","DB","G1","G2","G3"].contains(kq.MaGiai)  ){
              if(kq.MaGiai=="G3" && [5,6].contains(kq.TT)){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "3s")["trung"]!;
              }else if(["G6","DB","G1","G2"].contains(kq.MaGiai) ){
                solanTrung += 1;
                tienTrung = layVonTrung(kieu: "3s")["trung"]!;
              }
            }else if(sodanh.length==2 && sodanh==kqSo && ["G7","G6","DB","G1"].contains(kq.MaGiai)){
              solanTrung += 1;
              tienTrung = layVonTrung(kieu: "2s")["trung"]!;
            }
            break;
          default:
            print("Không có kiểu đánh phù hợp");
            break;
        }
      }
    }
    if (so1.isNotEmpty && so2.isNotEmpty && kieudanh == "dt") {
      bool thuongda = khachModel.ThuongMB;
      bool themchi = khachModel.ThemChiMB;
      if (so1.length == so2.length && so1.isNotEmpty) {
        solanTrung = so2.length;
        tienTrung = layVonTrung(kieu: "dt")["trung"]!;
      } else if ((so1.length - so2.length == 1) ||
          (so2.length - so1.length == 1)) {
        if (thuongda) {
          solanTrung = so1.length - so2.length == 1
              ? so2.length + 0.5
              : so1.length + 0.5;
          tienTrung = layVonTrung(kieu: "dt")["trung"]!;
        } else {
          solanTrung = so1.length - so2.length == 1 ? so2.length : so1.length;
          tienTrung = layVonTrung(kieu: "dt")["trung"]!;
        }
      } else if ((so2.length - so1.length > 1) ||
          (so1.length - so2.length > 1)) {
        if (themchi) {
          solanTrung = so2.length - so1.length > 1
              ? so2.length - so1.length
              : so1.length - so2.length;
          tienTrung = layVonTrung(kieu: "dt")["trung"]!;
        } else if (thuongda) {
          solanTrung =
              so2.length - so1.length > 1 ? so1.length + 0.5 : so2.length + 0.5;
          tienTrung = layVonTrung(kieu: "dt")["trung"]!;
        } else {
          solanTrung = so2.length - so1.length > 1 ? so1.length : so2.length;
          tienTrung = layVonTrung(kieu: "dt")["trung"]!;
        }
      }
    }
    return solanTrung > 0
        ? {"status": true, "solantrung": solanTrung, "tientrung": tienTrung}
        : {"status": false};
  }

  ClearText() {
    TienXac.value = 0;
    TienVon.value = 0;
    TienTrung.value = 0;
    LaiLo.value = 0;
    update();
  }

}
