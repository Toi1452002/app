// ignore_for_file: non_constant_identifier_names

import 'package:sqflite/sqflite.dart';
import 'package:ttpmn/database/connect_db.dart';
import 'package:ttpmn/function/extension.dart';
import 'package:ttpmn/models/sdt_model.dart';

import '../models/giakhach_model.dart';
import '../models/khach_model.dart';

class KhachData extends ConnectDb {
  Future<List<KhachModel>> getListKhach() async {
    final db = await init();
    List<Map<String, dynamic>> row = await db.query("TDM_Khach");
    return row.map((e) => KhachModel.fromMap(e)).toList();
  }


  Future<KhachModel> getKhachID(int ID) async {
    final db = await init();
    List<Map<String, dynamic>> row = await db.query("TDM_Khach", where: "ID = ?", whereArgs: [ID]);
    // db.close();
    return  KhachModel(
        ID: row[0]["ID"],
        MaKhach: row[0]["MaKhach"],
        ThuongMN: row[0]["ThuongMN"].toString().toBool,
        ThemChiMN: row[0]["ThemChiMN"].toString().toBool,
        ThuongMT: row[0]["ThuongMT"].toString().toBool,
        ThemChiMT: row[0]["ThemChiMT"].toString().toBool,
        ThuongMB: row[0]["ThuongMB"].toString().toBool,
        ThemChiMB: row[0]["ThemChiMB"].toString().toBool,
        HoiTong: row[0]["HoiTong"],
        Hoi2s: row[0]["Hoi2s"],
        Hoi3s: row[0]["Hoi3s"],
        KDauTren: row[0]["KDauTren"].toString().toBool,
        KieuTyLe: row[0]["KieuTyLe"],
        tkDa: row[0]["tkDa"]);
  }


  Future<int> InsertKhach(KhachModel khachModel) async {
    final db = await init();
    int insert = await db.insert("TDM_Khach", khachModel.toMap());
    return insert;
  }

  Future<void> insertGiaKhach(GiaKhachModel giaKhachModel) async {
    final db = await init();
    await db.insert("TDM_GiaKhach", giaKhachModel.toMap());
  }

  Future<bool> ktra_makhach(String maKhach, int id) async{
    final db = await init();
    bool b = false;
    List<Map> row = await db.rawQuery('''
      SELECT ID FROM TDM_Khach WHERE MaKhach = '$maKhach'
    ''');
    if(row.isNotEmpty && row[0]["ID"]!=id)b = true;
    db.close();
    return b;
  }

  Future<int> insertSDT(SdtModel mSdt) async {
    final db = await init();
    int idInsert = await db.insert("TDM_SoDT", mSdt.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return idInsert;
  }

  Future<void> deleteSdtKhach(int ID) async {
    final db = await init();
    await db.delete("TDM_SoDT", where: "ID = ?", whereArgs: [ID]);
    db.close();
  }

  Future<void> deleteKhach(KhachModel khachModel) async {
    final db = await init();
    await db.delete("TDM_Khach", where: "ID = ?", whereArgs: [khachModel.ID]);
    await db.delete("TDM_SoDT", where: "KhachID = ?", whereArgs: [khachModel.ID]);
    await db.delete("TDM_GiaKhach", where: "KhachID = ?", whereArgs: [khachModel.ID]);
    await db.delete("TXL_TinNhan", where: "KhachID = ?", whereArgs: [khachModel.ID]);
    await db.delete("TXL_TinPhanTichCT", where: "KhachID = ?", whereArgs: [khachModel.ID]);
    db.close();
  }
  Future<List<SdtModel>> getSdtKhachID(int ID) async {
    final db = await init();
    List<Map<String, dynamic>> row =
    await db.query("TDM_SoDT", where: "KhachID=?", whereArgs: [ID]);
    return List.generate(
        row.length,
            (index) => SdtModel(
            ID: row[index]["ID"],
            KhachID: row[index]["KhachID"],
            SoDT: row[index]["SoDT"]));
  }


  Future<List<GiaKhachModel>> loadGiaKhachID(int ID) async {
    final db = await init();
    List<Map<String, dynamic>> row =
    await db.query("TDM_GiaKhach", where: "KhachID = ?", whereArgs: [ID]);
    return row.map((e) => GiaKhachModel.fromMap(e)).toList();

  }
  Future<void> updateKhach(KhachModel khachModel) async {
    final db = await init();
    await db.update("TDM_Khach", khachModel.toMap(),
        where: "ID = ?", whereArgs: [khachModel.ID]);
  }

  Future<void> updateGiaKhach(GiaKhachModel giaKhachModel) async {
    final db = await init();
    db.update("TDM_GiaKhach", giaKhachModel.toMap(),
        where: "ID = ?", whereArgs: [giaKhachModel.ID]);
  }
  Future<List<GiaKhachModel>> getGiaKhach() async {
    final db = await init();
    List<Map<String, dynamic>> row = await db.query("TDM_GiaKhach");
    return row.map((e) => GiaKhachModel.fromMap(e)).toList();
  }

  Future<void> delete_khach_giakhach()async{
    final db = await init();
    await db.delete("TDM_Khach");
    await db.delete("TDM_GiaKhach");

  }

}
