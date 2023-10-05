import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ttpmn/routers.dart';
import '../../database/api.dart';
import '../../database/hamchung_db.dart';
import '../../function/extension.dart';

class KichHoatController extends GetxController{
  TextEditingController makichhoat = TextEditingController();
  TextEditingController taikhoan = TextEditingController();
  TextEditingController matkhau = TextEditingController();
  TextEditingController tenmaycu = TextEditingController();
  TextEditingController mathaydoi = TextEditingController();


  KichHoatController get to => Get.find();
  HamChungDB hamChungDB =HamChungDB();
  onKichHoat()async{
    if(!await hasNetwork()){EasyLoading.showError("Không có internet!");return;}
    var url = Uri.parse(API.hostKichhoat);
    EasyLoading.show(status: "Đang xác thực...");
    try{

      final response = await http.post(url,body: {
        "MAKICHHOAT":makichhoat.text.trim(),
        "IDDEVICE": await idDevice()
      });
      if(response.statusCode==200){
        var row = jsonDecode(response.body);
        // print(row);
        if(!row["status"]){
          EasyLoading.showError("Mã kích hoạt không hợp lệ!");
        }
        if(row["status"]){
          var data = row["data"][0];
          if(data["MATHIETBI"]==await idDevice()){


            String id = await idDevice();
            List user = await hamChungDB.layTable("Select * From T00_User");

            if(user.isEmpty){
              await hamChungDB.Insert("T00_User", {
                "UserName": data["TAIKHOAN"],
                "PassWord": data["MATKHAU"],
                "IDDevice": id
              });
            }

            Future.delayed(const Duration(seconds: 2),() async{
              EasyLoading.showSuccess("Kích hoạt thành công");

              await hamChungDB.RawQuery("Update T00_User Set MaKichHoat = '${makichhoat.text.trim()}' WHERE IDDevice = '$id'");


            }).whenComplete(() => Get.offAllNamed(routerName.v_dangnhap));

          }else{
            EasyLoading.dismiss();
            EasyLoading.showError("Mã kích hoạt không hợp lệ!");
          }
        }

      }

    }catch(e){
      EasyLoading.dismiss();
      EasyLoading.showError("Đường truyền lỗi");
      print(e);
    }
  }

  onDoiMay()async{
    if(!await hasNetwork()){EasyLoading.showError("Không có internet!");return;}
    var url = Uri.parse(API.hostDoiMay);
    EasyLoading.show(status: "Đang xác thực...");
    try{
      String idMay = await idDevice();
      final response = await http.post(url,body: {
        'TAIKHOAN':taikhoan.text.trim(),
        'MATKHAU':matkhau.text.trim(),
        'IDDEVICE':tenmaycu.text.trim(),
        'MADOIMAY':mathaydoi.text.trim(),
        'IDMAYMOI': idMay
      });
      if(response.statusCode==200){
        var row = jsonDecode(response.body);
        if(row["status"]){
          Future.delayed(Duration(seconds: 3),(){
            EasyLoading.showSuccess("Đổi máy thành công");

          }).whenComplete(() => Get.offAllNamed(routerName.v_kichhoat));
        }else{
          Future.delayed(const Duration(seconds: 3),(){

            EasyLoading.showError("Xác nhận thất bại!");
          });

        }
      }else{
        EasyLoading.dismiss();
        EasyLoading.showError("Đường truyền lỗi");
      }
    }catch(e){
      EasyLoading.dismiss();
      EasyLoading.showError("Đường truyền lỗi");
      print(e);
    }
  }
}