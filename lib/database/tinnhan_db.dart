import 'package:ttpmn/database/connect_db.dart';
import 'package:ttpmn/models/tinnhan_model.dart';

import '../models/tinnhan_ptct_model.dart';

class TinNhanData extends ConnectDb {
  Future<TinNhanModel> layTinNhanCuoi() async {
    final db = await init();
    List<Map<String, dynamic>> row = await db.rawQuery('''
      Select  TXL_TinNhan.*, TDM_Khach.MaKhach From TXL_TinNhan , TDM_Khach
      Where TXL_TinNhan.KhachID =TDM_Khach.ID
      Order by ID desc
      Limit 1
    ''');
    return row.isNotEmpty
        ? TinNhanModel(
            ID: row[0]["ID"],
            Ngay: row[0]["Ngay"],
            KhachID: row[0]["KhachID"],
            Mien: row[0]["Mien"],
            DaTinh: row[0]["DaTinh"],
            TongTien: row[0]["TongTien"],
            MaKhach: row[0]["MaKhach"],
            TinGoc: row[0]["TinGoc"],
            TinXL: row[0]["TinXL"],
          )
        : TinNhanModel();
  }

  Future<int> themTinNhan(TinNhanModel tn) async {
    final db = await init();
    int id = await db.insert("TXL_TinNhan", tn.toMap());
    db.close();
    return id;
  }

  Future<void> updateTinNhan(TinNhanModel tinNhanModel) async {
    final db = await init();
    await db.rawQuery('''
      UPDATE TXL_TinNhan
      Set Mien = '${tinNhanModel.Mien}', KhachID = ${tinNhanModel.KhachID}, Ngay = '${tinNhanModel.Ngay}'
      Where ID = '${tinNhanModel.ID}'
    ''');
    db.close();
  }

  Future<TinNhanModel> layTinNhanID(String ID) async {
    final db = await init();
    List<Map<String, dynamic>> row = await db.rawQuery('''
      Select  TXL_TinNhan.*, TDM_Khach.MaKhach From TXL_TinNhan , TDM_Khach
      Where TXL_TinNhan.KhachID =TDM_Khach.ID and TXL_TinNhan.ID = '$ID'
    ''');
    return row.isNotEmpty
        ? TinNhanModel(
            ID: row[0]["ID"],
            Ngay: row[0]["Ngay"],
            KhachID: row[0]["KhachID"],
            Mien: row[0]["Mien"],
            DaTinh: row[0]["DaTinh"],
            TongTien: row[0]["TongTien"],
            TinGoc: row[0]["TinGoc"],
            TinXL: row[0]["TinXL"],
            MaKhach: row[0]["MaKhach"])
        : TinNhanModel();
  }

  Future<void> updateTin(int ID, String Field, var Tin) async {
    final db = await init();
    await db.rawQuery('''
      Update TXL_TinNhan Set $Field = '$Tin' WHERE ID = $ID
    ''');
  }

  Future<void> insertTinNhanPTCT(TinNhanPhanTichCTModel tnptct) async {
    final db = await init();
    await db.insert("TXL_TinPhanTichCT", tnptct.toMap());
  }

  Future<void> deleteTinNhanPTCT(int MaTin) async {
    final db = await init();
    await db.delete("TXL_TinPhanTichCT",
        where: "TinNhanID = ?", whereArgs: [MaTin]);
    db.close();
  }
}
