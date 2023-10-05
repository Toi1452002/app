import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpmn/database/hamchung_db.dart';

class BaocaoTongKetController extends GetxController{
  Rx<DateTime> tungay = DateTime.now().obs;
  Rx<DateTime> denngay = DateTime.now().obs;
  List<Map> baocaoBase = [];
  RxString makhach = "".obs;
  Rx<double> tongNam = 0.0.obs;
  Rx<double> tongTrung = 0.0.obs;
  Rx<double> tongBac = 0.0.obs;
  Rx<double> tongThubu = 0.0.obs;
  RxList<String> lstKhach = <String>[].obs;
  RxList<Map> baocao = <Map>[].obs;
  List<String> lstNgay = [];
  BaocaoTongKetController get to =>Get.find();
  HamChungDB hamChungDB = HamChungDB();
  @override
  void onInit() {
    // TODO: implement onInit
    loadBaoCaoTong();
    super.onInit();
  }

  thay_doi_khach(String value){
    ResetText();
    baocao.clear();
    lstNgay.clear();
    makhach.value = value;
    List<Map> a = baocaoBase.where((e) => e["Khách"]==value).toList();
    for(var x in a){
      lstNgay.add(x["Ngay"]);
      tongNam.value+=x["Nam"]??0;
      tongTrung.value+=x["Trung"]??0;
      tongBac.value+=x["Bắc"]??0;
      tongThubu.value+=x["Thu Bù"]??0;
    }
    lstNgay = lstNgay.toSet().toList();
    lstNgay.sort((a,b)=>a.compareTo(b));
    for(String n in lstNgay){
      baocao.value.add({"ID": "title", "Ngay": n});
      baocao.value.addAll(a.where((e) => e["Ngay"]==n));
    }
    update();
  }


  loadBaoCaoTong()async{
    lstKhach.clear();
    baocao.clear();
    lstNgay.clear();
    ResetText();
    baocaoBase = await hamChungDB.layTable("Select * From VBC_TongTienKhach Where Ngay BETWEEN '${DateFormat('yyyy-MM-dd').format(tungay.value)}' AND '${DateFormat('yyyy-MM-dd').format(denngay.value)}'");
    for(var x in baocaoBase){
      lstKhach.value.add(x["Khách"]);
      lstNgay.add(x["Ngay"]);
      tongNam.value+=x["Nam"]??0;
      tongTrung.value+=x["Trung"]??0;
      tongBac.value+=x["Bắc"]??0;
      tongThubu.value+=x["Thu Bù"]??0;
    }
    lstNgay = lstNgay.toSet().toList();
    lstNgay.sort((a,b)=>a.compareTo(b));
    for(String n in lstNgay){
      baocao.value.add({"ID": "title", "Ngay": n});
      baocao.value.addAll(baocaoBase.where((e) => e["Ngay"]==n));
    }
    lstKhach.value = lstKhach.value.toSet().toList();
    update();
  }

  thay_doi_tungay(DateTime value){
    tungay.value = value;
    loadBaoCaoTong();
    update();
  }

  thay_doi_denngay(DateTime value){
    denngay.value = value;
    loadBaoCaoTong();
    update();
  }

  ResetText(){
    tongNam.value = 0;
    tongTrung.value = 0;
    tongBac.value = 0;
    tongThubu.value = 0;
    makhach.value = "";
    update();

  }





}