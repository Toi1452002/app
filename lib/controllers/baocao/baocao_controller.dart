// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/database/hamchung_db.dart';

class BaocaoController extends GetxController{

  BaocaoController get to=> Get.find();
  Rx<DateTime> ngaylam = DateTime.now().obs;
  RxList<String> lstMaKhach = const <String>[].obs;

  List<Map> baocaoBase = [] ;
  RxList<Map> baocao = <Map>[].obs;
  RxList<Map> baocaoctk1 = <Map>[].obs;
  RxString makhach = "".obs;
  RxString mien = "".obs;
  RxDouble TongXac = 0.0.obs;
  RxDouble TongVon = 0.0.obs;
  RxDouble TongTrung = 0.0.obs;
  RxDouble TongThuBu = 0.0.obs;
  RxDouble TongXac2 = 0.0.obs;
  RxDouble TongXac3 = 0.0.obs;
  RxDouble Tong2s = 0.0.obs;
  RxDouble Tong3s = 0.0.obs;
  RxDouble Tong4s = 0.0.obs;
  RxDouble Tongdt = 0.0.obs;
  RxDouble Tongdx = 0.0.obs;

  HamChungDB hamChungDB = HamChungDB();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  thay_doi_ngaylam(DateTime value){
    ngaylam.value = value;
    loadBaoCao();
    update();
  }
  loadBaoCao() async{
    ResetText();
    lstMaKhach.clear();
    mien.value = "";
    makhach.value = "";
    baocaoBase = await hamChungDB.layTable("SELECT * FROM VBC_TongHop_k1 WHERE Ngay = '${DateFormat("yyyy-MM-dd").format(ngaylam.value)}'");
    if(baocaoBase.isNotEmpty){
      for(var x in baocaoBase){
        TongXac.value+=x["Xac"]??0;
        TongVon.value+=x["Von"]??0;
        TongTrung.value+=x["Trung"]??0;
        if(x["Đầu dưới"]!=null){
          TongThuBu.value+=x["Đầu dưới"]??0;
        }else{
          TongThuBu.value+=x["Đầu trên"]??0;
        }
          TongXac2.value += x["Xác 2s"]??0;
          TongXac3.value += x["Xác 3s"]??0;
          Tong2s.value += x["Trung2s"]??0;
          Tong3s.value += x["Trung3s"]??0;
          Tong4s.value += x["Trung4s"]??0;
          Tongdt.value += x["TrungDt"]??0;
          Tongdx.value += x["TrungDx"]??0;

        lstMaKhach.value.add(x["MaKhach"]);
      }
    }
    lstMaKhach.value = lstMaKhach.value.toSet().toList();
    List<String> m = ["N","T","B"];
    for(var x in lstMaKhach.value){
      baocao.value.add({"MaKhach": x,"Mien":""});
      List<Map> a = baocaoBase.where((e) => e["MaKhach"]==x).toList();
      // print(a);
      for(String i in m){
        List<Map> b = a.where((e) => e["Mien"]==i).toList();
        if(b.isNotEmpty) baocao.value.add(b.first);
      }
    }
    update();
  }
  thay_doi_khach(String value){
    ResetText();
    makhach.value = value;
    List<String> m = ["N","T","B"];
    List<Map> a = baocaoBase.where((e) => e["MaKhach"]==value).toList();
    if(mien.value!=""){
      a = a.where((e) => e["Mien"]==mien.value[0]).toList();
    }
    baocao.value.add({"MaKhach": value,"Mien":""});
    for(String i in m){
      List<Map> b = a.where((e) => e["Mien"]==i).toList();
      if(b.isNotEmpty)baocao.value.add(b.first);
    }
    for(var x in baocao.value){
      TongXac.value+=x["Xac"]??0;
      TongVon.value+=x["Von"]??0;
      TongTrung.value+=x["Trung"]??0;
      if(x["Đầu dưới"]!=null){
        TongThuBu.value+=x["Đầu dưới"]??0;
      }else{
        TongThuBu.value+=x["Đầu trên"]??0;
      }
      TongXac2.value += x["Xác 2s"]??0;
      TongXac3.value += x["Xác 3s"]??0;
      Tong2s.value += x["Trung2s"]??0;
      Tong3s.value += x["Trung3s"]??0;
      Tong4s.value += x["Trung4s"]??0;
      Tongdt.value += x["TrungDt"]??0;
      Tongdx.value += x["TrungDx"]??0;
    }
    update();
  }

  thay_doi_mien(String value){
    ResetText();
    mien.value = value;
    List<Map> a = baocaoBase.where((e) => e["Mien"]==value[0]).toList();
    if(makhach.value!=""){
      a = a.where((e) => e["MaKhach"]==makhach.value).toList();
    }
    for(var x in a){
      baocao.value.add({"MaKhach": x["MaKhach"],"Mien":""});
      baocao.value.add(x);
      TongXac.value+=x["Xac"]??0;
      TongVon.value+=x["Von"]??0;
      TongTrung.value+=x["Trung"]??0;
      if(x["Đầu dưới"]!=null){
        TongThuBu.value+=x["Đầu dưới"]??0;
      }else{
        TongThuBu.value+=x["Đầu trên"]??0;
      }
      TongXac2.value += x["Xác 2s"]??0;
      TongXac3.value += x["Xác 3s"]??0;
      Tong2s.value += x["Trung2s"]??0;
      Tong3s.value += x["Trung3s"]??0;
      Tong4s.value += x["Trung4s"]??0;
      Tongdt.value += x["TrungDt"]??0;
      Tongdx.value += x["TrungDx"]??0;
    }

    update();
  }
  loadTinCT(String Ngay, String KhachID,String Mien) async{
    baocaoctk1.value = await hamChungDB.layTable("Select * From VBC_ChiTiet_k1 WHERE Ngay = '$Ngay' AND Mien = '$Mien' And KhachID = '$KhachID'");
    update();
  }
  ResetText(){

    baocao.clear();
    TongXac.value=0;
    TongVon.value=0;
    TongTrung.value=0;
    TongXac2.value =0;
    TongXac3.value =0;
    Tong2s.value =0;
    Tong3s.value =0;
    Tong4s.value =0;
    Tongdt.value =0;
    Tongdx.value =0;
    TongThuBu.value=0;
    update();
  }
}