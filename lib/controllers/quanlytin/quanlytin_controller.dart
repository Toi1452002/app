import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../database/hamchung_db.dart';
import '../xuly/xuly_controller.dart';

class QuanlytinController extends GetxController{
  QuanlytinController get to => Get.find();
  Rx<DateTime> ngaylam = DateTime.now().obs;
  RxList<Map<String,dynamic>> lstKhach = <Map<String,dynamic>>[].obs;
  RxList<Map> tinct = <Map>[].obs;
  HamChungDB hamChungDB = HamChungDB();
  Map<String,List<SmsMessage>> m_tinnhan = {};
  RxList<Map> lstSMS = <Map>[].obs;
  SmsQuery query =  SmsQuery();
  @override
  void onInit() {
    // TODO: implement onInit
   lay_danhsachkhach();
    super.onInit();
  }
  thay_doi_ngaylam(DateTime dateTime){
    ngaylam.value = dateTime;
    lay_danhsachkhach();

    update();
  }
  lay_danhsachkhach() async{

      lstKhach.value = await hamChungDB.layTable('''
      Select  TDM_Khach.MaKhach,TDM_Khach.ID, Count(TXL_TinNhan.KhachID) sotin
      From TXL_TinNhan, TDM_Khach 
      Where TXL_TinNhan.Ngay = '${DateFormat("yyyy-MM-dd").format(ngaylam.value)}'
      AND TXL_TinNhan.KhachID = TDM_Khach.ID
      Group by TDM_Khach.MaKhach,TDM_Khach.ID
    ''');
    update();
  }

  loadTinNhanChiTiet(String id) async{


     tinct.value = await hamChungDB.layTable('''
      SELECT TXL_TinNhan.ID, TXL_TinNhan.Mien, TXL_TinNhan.TinGoc, TXL_TinNhan.TinXL, VXL_TongTienPhieu.Xac
      FROM TXL_TinNhan, VXL_TongTienPhieu
      WHERE TXL_TinNhan.KhachID = '$id'  
      AND VXL_TongTienPhieu.TinNhanID = TXL_TinNhan.ID
      AND TXL_TinNhan.Ngay = '${DateFormat("yyyy-MM-dd").format(ngaylam.value)}'
    ''');
     update();
    // print(tinct);
  }

  xoatin(int ID, String KhachID) async{
    await hamChungDB.deleteRow(table: "TXL_TinNhan", where: "ID", whereArgs: ID);
    await hamChungDB.deleteRow(table: "TXL_TinPhanTichCT", where: "TinNhanID", whereArgs: ID);
    loadTinNhanChiTiet(KhachID);
    lay_danhsachkhach();
    if(ID == XulyController().to.idTinNhan.value)XulyController().to.loadTinNhan();
    Get.back();
    // print(ID);
  }

}