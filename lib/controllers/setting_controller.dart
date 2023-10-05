
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ttpmn/controllers/khach/khach_controller.dart';
import 'package:ttpmn/controllers/xuly/xuly_controller.dart';
import 'package:ttpmn/database/hamchung_db.dart';
import 'package:ttpmn/database/khach_db.dart';
import 'package:ttpmn/function/extension.dart';
import 'package:ttpmn/models/giakhach_model.dart';
import 'package:ttpmn/models/khach_model.dart';
import 'package:ttpmn/server.dart';
import 'dart:convert';

import '../database/api.dart';
class SettingController extends GetxController{
  SettingController get to => Get.find();
  KhachData khachData = KhachData();
  HamChungDB hamChungDB = HamChungDB();
  RxBool xcMN = false.obs;
  @override
  onInit() async{
    super.onInit();
    List tuychon = await hamChungDB.layTable("Select GiaTri From T00_TuyChon Where Ma = 'xsMN'");
    xcMN.value= tuychon[0]["GiaTri"].toString().toBool;

  }

  onSaoLuu()async{
    if(!await hasNetwork()) {EasyLoading.showInfo("Không có Interet");return;}
    var url = Uri.parse(API.hostJson);
    EasyLoading.show(status: "Loading...");
    try{
      List<KhachModel> khachModel = await khachData.getListKhach();
      List<GiaKhachModel> giaKhach = await khachData.getGiaKhach();
      List giaKhachJson = giaKhach.map((e) => jsonEncode(e.toMap())).toList();
      final response = await http.post(url,body: {
        'FileName':"${Server.ID}_${Server.idDevice.replaceAll(".", "")}",
        'Status':'saoluu',
        'Data' : jsonEncode( {
          "khach":khachModel,
          "giakhach":giaKhachJson
        })
      });

      if(response.statusCode==200){
        print(response.body);
        Future.delayed(const Duration(seconds: 2),()=>EasyLoading.showSuccess("Sao lưu thành công"));


      }else{
        EasyLoading.showInfo("Sao lưu thất bại!");
      }
    }catch(e){
      // print(e);
      EasyLoading.showInfo("Sao lưu thất bại!");
    }
  }


  onKhoiPhuc() async{
    if(!await hasNetwork()) {EasyLoading.showInfo("Không có Interet");return;}
    var url = Uri.parse(API.hostJson);
    EasyLoading.show(status: "Loading...");
    try{
      final response = await http.post(url,body: {
        'FileName':"${Server.ID}_${Server.idDevice.replaceAll(".", "")}",
        'Status':'khoiphuc',
        'Data':""
      });
      if(response.statusCode==200){
        List<dynamic> jsonKhach = jsonDecode(jsonDecode(response.body))["khach"] ;
        List<dynamic> jsonGiaKhach = jsonDecode(jsonDecode(response.body))["giakhach"];

        List<KhachModel> dataKhach = jsonKhach.map((e) {
          Map<String, dynamic> x = jsonDecode(e);
          return KhachModel(
              ID: x["ID"],
              MaKhach: x["MaKhach"],
              ThuongMT: x["ThuongMT"],
              ThuongMB: x["ThuongMB"],
              ThemChiMT: x["ThemChiMT"],
              ThemChiMN: x["ThemChiMN"],
              ThemChiMB: x["ThemChiMB"],
              HoiTong: x["HoiTong"],
              Hoi3s: x["Hoi3s"],
              Hoi2s: x["Hoi2s"],
              ThuongMN: x["ThuongMN"],
              tkDa: x["tkDa"]
          );
        }).toList();
        List<GiaKhachModel> dataGiaKhach = jsonGiaKhach.map((e) {
          Map<String, dynamic> x = jsonDecode(e);
          return GiaKhachModel.fromMap(x);
        }).toList();

        await khachData.delete_khach_giakhach();
        for(var x in dataKhach){
          await khachData.InsertKhach(x);
        }
        for(var x in dataGiaKhach){
          await khachData.insertGiaKhach(x);
        }
        KhachController().to.loadDanhSachKhach();
        XulyController().to.onInit();
        Future.delayed(const Duration(seconds: 2),()=>EasyLoading.showSuccess("Khôi phục thành công"));
      }

    }catch(e){
      EasyLoading.showInfo("Khôi phục thất bại");
      print(e);
    }
  }
}

