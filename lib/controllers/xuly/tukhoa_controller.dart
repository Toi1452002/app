import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../database/tukhoa_db.dart';
import '../../models/tukhoa_model.dart';

class TuKhoaController extends GetxController{
  TextEditingController motaController = TextEditingController();
  TextEditingController tukhoaController = TextEditingController();
  RxList<TuKhoaModel> lstTuKhoa = const <TuKhoaModel>[].obs;
  TuKhoaData tuKhoaDaTa = TuKhoaData();
  TuKhoaModel tukhoaUpdate  = TuKhoaModel();
  RxString motaErr = "".obs;
  @override
  void onInit() {
    // TODO: implement onInit
    loadDanhSachTuKhoa();
    super.onInit();
  }

  loadDanhSachTuKhoa()async{
    lstTuKhoa.value = await tuKhoaDaTa.laydanhsachTuKhoa();
    update();
  }

  them_tu_khoa() async{
    if(motaController.text.isEmpty){
      motaErr.value = "Không được bỏ trống";
      update();
      return;
    }
    if(await tuKhoaDaTa.ktra_mota(motaController.text, 0)){
      motaErr.value = "Đã tồn tại";
      update();
      return;
    }
    int id = await tuKhoaDaTa.insertTuKhoa(TuKhoaModel(CumTu: motaController.text, ThayThe:tukhoaController.text));
    lstTuKhoa.add(
        TuKhoaModel(ID: id,CumTu: motaController.text, ThayThe:tukhoaController.text)
    );
    Get.back();
    update();
  }

  xoa_tukhoa(TuKhoaModel tuKhoaModel) async{
    lstTuKhoa.remove(tuKhoaModel);
    await tuKhoaDaTa.deleteTuKhoa(tuKhoaModel);
    Get.back();
    update();
  }

  editTukhoa(TuKhoaModel tuKhoaModel){
    motaController.text = tuKhoaModel.CumTu;
    tukhoaController.text = tuKhoaModel.ThayThe;
    tukhoaUpdate = tuKhoaModel;
  }


  updateTuKhoa() async{
    if(motaController.text.isEmpty){
      motaErr.value = "Không được bỏ trống";
      update();
      return;
    }
    if(await tuKhoaDaTa.ktra_mota(motaController.text, tukhoaUpdate.ID!)){
      motaErr.value = "Đã tồn tại";
      update();
      return;
    }
    await tuKhoaDaTa.updateTuKhoa(TuKhoaModel(
      ID: tukhoaUpdate.ID,
      CumTu: motaController.text,
      ThayThe:  tukhoaController.text
    ));
    int indexUpdate = lstTuKhoa.indexOf(tukhoaUpdate);
    lstTuKhoa.remove(tukhoaUpdate);
    lstTuKhoa.insert(indexUpdate, TuKhoaModel(
        ID: tukhoaUpdate.ID,
        CumTu: motaController.text,
        ThayThe:  tukhoaController.text
    ));
    Get.back();
    update();

  }
  ResetText(){
    motaController.clear();
    tukhoaController.clear();
    motaErr.value = "";
    update();
  }




}