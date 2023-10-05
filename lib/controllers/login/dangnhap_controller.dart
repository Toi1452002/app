// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ttpmn/routers.dart';
import 'package:ttpmn/widgets/tab_pages.dart';
import '../../database/api.dart';
import '../../database/hamchung_db.dart';
import '../../function/extension.dart';
import '../../server.dart';

class DangNhapController extends GetxController{
  DangNhapController get to => Get.find();
  HamChungDB hamChungDB =HamChungDB();
  TextEditingController taikhoanController = TextEditingController();
  TextEditingController matkhauController = TextEditingController();

  TextEditingController matkhaucu = TextEditingController();
  TextEditingController matkhaumoi = TextEditingController();
  TextEditingController xn_matkhaumoi = TextEditingController();
  RxString err_matkhaucu = "".obs;
  RxString err_matkhaumoi = "".obs;
  RxString err_xn_matkhaumoi = "".obs;
  @override
  void onInit() async{
    super.onInit();
    // TODO: implement onInit
    List<Map> row = await hamChungDB.layTable("select * From T00_User");
    if(row.isEmpty){
      Get.offAllNamed(routerName.v_dangky);
    }

    else if(row.length==1 && row[0]["MaKichHoat"].toString() == "null"){
      Get.offAllNamed(routerName.v_kichhoat);
    }
  }

  onDangNhap() async{
    if(!await hasNetwork()){EasyLoading.showError("Không có internet!");return;}
    var url = Uri.parse(API.hostLogin);
    var user = await hamChungDB.layTable('Select MaKichHoat From T00_User');
    try{
      // print(user[0]["MaKichHoat"]);
      EasyLoading.show(status: "Đang đăng nhập...");
      final response = await http.post(url,body: {
        "TAIKHOAN":taikhoanController.text.trim(),
        "MATKHAU":matkhauController.text.trim(),
        // "IDDEVICE":await idDevice(),
        "MAKICHHOAT": user[0]["MaKichHoat"]
      });
      if(response.statusCode==200){
        var row = jsonDecode(response.body);
        if(!row["status"]){
          EasyLoading.showToast("Đăng nhập thất bại!");
        }
        else{
          Get.offAndToNamed(TabPage.tabpageRouter);
          var data = row["data"];
          Server.ngayHetHan = data["NGAYHETHAN"].toString();
          Server.trangthai = data["TRANGTHAI"].toString();
          Server.ngayLamviec = data["NGAYLAMVIEC"].toString();
          Server.taikhoan = data["TAIKHOAN"].toString();
          Server.matkhau = data["MATKHAU"].toString();
          Server.idDevice  = data["MATHIETBI"].toString();
          Server.ID = data["ID"].toString();
          taikhoanController.clear();
          matkhauController.clear();
        }
        EasyLoading.dismiss();


      }else{
        EasyLoading.showToast("Đăng nhập thất bại!");
      }


    }catch(e){
      print(e);
      Future.delayed(const Duration(seconds: 2),(){
        EasyLoading.dismiss();
        EasyLoading.showToast("Đăng nhập thất bại!");
      });

    }
  }

  onChangePassword() async{
    err_matkhaucu.value = "";
    err_matkhaumoi.value = "";
    err_xn_matkhaumoi.value = "";
    if(matkhaucu.text.isEmpty){err_matkhaucu.value="Không được bỏ trống!";return;}
    if(matkhaucu.text!= Server.matkhau){err_matkhaucu.value="Sai mật khẩu!";return;}
    if(matkhaumoi.text.isEmpty){err_matkhaumoi.value="Không được bỏ trống!";return;}
    if(matkhaumoi.text==matkhaucu.text){err_matkhaumoi.value="Mật khẩu mới phải khác mật khẩu cũ!";return;}
    if(matkhaumoi.text!= xn_matkhaumoi.text){err_xn_matkhaumoi.value = "Mật khẩu không trùng khớp!";return;}
    EasyLoading.show(status: "Loading...");
    var url = Uri.parse(API.hostDoiMatKhau);
    try{
      final response = await http.post(url,body: {
        "MATKHAUMOI": xn_matkhaumoi.text,
        "ID": Server.ID,
      });
      Future.delayed(const Duration(seconds: 2),(){
        if(response.statusCode==200){
          EasyLoading.showSuccess("Đổi mật khẩu thành công\nQuay về trang đăng nhập");
          Future.delayed(const Duration(seconds: 2),()=>Get.offAllNamed(routerName.v_dangnhap));
        }else{
          EasyLoading.showInfo("Đường truyền lỗi");
        }
      });
    }catch(e){
      print(e);
      EasyLoading.showInfo("Đường truyền lỗi");
    }


    update();
  }

  clearError(){
    err_matkhaucu.value = "";
    err_matkhaumoi.value = "";
    err_xn_matkhaumoi.value = "";
    matkhaumoi.clear();
    matkhaucu.clear();
    xn_matkhaumoi.clear();
    update();
  }
}