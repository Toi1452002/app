import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ttpmn/database/hamchung_db.dart';
import 'package:ttpmn/function/extension.dart';
import 'package:http/http.dart' as http;
import 'package:ttpmn/routers.dart';
import 'package:ttpmn/views/login/v_kichhoat.dart';
import '../../database/api.dart';
class DangKyController extends GetxController{
  DangKyController get to => Get.find();
  TextEditingController hoten = TextEditingController();
  TextEditingController taikhoan = TextEditingController();
  TextEditingController matkhau = TextEditingController();
  TextEditingController xacnhanmatkhau = TextEditingController();
  RxString errHoten = "".obs;
  RxString errTaikhoan = "".obs;
  RxString errMatkhau = "".obs;
  RxString errXacnhanmatkhau = "".obs;
  HamChungDB hamChungDB =HamChungDB();
  @override
  void onInit()async{
    List<Map> row = await hamChungDB.layTable("select * From T00_User");
    if(row.length==1 && row[0]["MaKichHoat"]==""){
      Get.offAndToNamed(routerName.v_kichhoat);
    }
    super.onInit();


  }

  onSubmit() async{
    clear();
    if(hoten.text.isEmpty){errHoten.value = "Họ và tên không được bỏ trống!";return;}
    if(taikhoan.text.isEmpty){errTaikhoan.value = "Tài khoản không được bỏ trống!";return;}
    if(matkhau.text.isEmpty){errMatkhau.value = "Mật khẩu không được bỏ trống!";return;}
    if(xacnhanmatkhau.text.isEmpty){errXacnhanmatkhau.value = "Xác nhận mật khẩu không được bỏ trống!";return;}
    if(matkhau.text!=xacnhanmatkhau.text){errXacnhanmatkhau.value = "Xác nhận mật khẩu không trùng khớp!"; return;}
    if(!await hasNetwork()){EasyLoading.showError("Không có internet!");return;}
    var url = Uri.parse(API.hostDangky);
    EasyLoading.show(status: "Loading...");
    try{
      final response = await http.post(url,body: {
        "HOTEN": hoten.text,
        "TAIKHOAN": taikhoan.text.trim(),
        "MATKHAU": xacnhanmatkhau.text.trim(),
        "IDDEVICE": await idDevice()
      });
      if(response.statusCode==200){
        var row = jsonDecode(response.body);


        Future.delayed(const Duration(seconds: 2),() async {
          
          EasyLoading.dismiss();
          if(row["status"]=="Failed"){
            EasyLoading.showInfo("Thiết bị này đã đăng ký.\nNhập mã kích hoạt để tiếp tục sử dụng");
            print(row["data"]);
            await hamChungDB.Insert("T00_User", {
              "UserName": row["data"]["TAIKHOAN"],
              "PassWord": row["data"]["MATKHAU"],
              "IDDevice": await idDevice()
              // "MaKichHoat": row["MAKICHHOAT"].toString()
            });
            Future.delayed(const Duration(seconds: 2), ()=>Get.offAllNamed(routerName.v_kichhoat));

          }
          if(row["status"]=="Success") {
            await hamChungDB.Insert("T00_User", {
              "UserName":taikhoan.text.trim(),
              "PassWord": xacnhanmatkhau.text.trim(),
              "IDDevice": await idDevice()
            });
            EasyLoading.showSuccess("Đăng ký thành công");
            Future.delayed(const Duration(seconds: 2), ()=>Get.offAllNamed(routerName.v_kichhoat));
          }

        });
      }
    }catch(e){
      EasyLoading.dismiss();
      print(e);
      EasyLoading.showError("Đường truyền lỗi!");
    }


    update();
  }

  clear(){
    errHoten.value = "";
    errTaikhoan.value = "";
    errMatkhau.value = "";
    errXacnhanmatkhau.value = "";
    update();
  }
}