import 'package:ttpmn/database/connect_db.dart';

import '../models/tukhoa_model.dart';

class TuKhoaData extends ConnectDb{
  Future<int> insertTuKhoa(TuKhoaModel tuKhoaModel) async{
    final db = await init();
    int id = await db.insert("T01_TuKhoa", tuKhoaModel.toMap());
    db.close();
    return id;
  }
  Future<void> deleteTuKhoa(TuKhoaModel tuKhoaModel) async{
    final db = await init();
    await db.delete("T01_TuKhoa", where: "ID = ?", whereArgs: [tuKhoaModel.ID]);
    db.close();
  }

  Future<void> updateTuKhoa(TuKhoaModel tuKhoaModel) async{
    final db = await init();
    await db.update("T01_TuKhoa",tuKhoaModel.toMap(), where: "ID = ?", whereArgs: [tuKhoaModel.ID]);
    db.close();
  }
  
  Future<List<TuKhoaModel>> laydanhsachTuKhoa()async{
    final db = await init();
    List<Map<String, dynamic>> row = await db.query("T01_TuKhoa", where: "SoDanhHang != ?" , whereArgs: [1]);
    // db.close();
    return List.generate(row.length, (i) => TuKhoaModel(
      ID: row[i]["ID"],
      CumTu: row[i]["CumTu"],
      ThayThe: row[i]["ThayThe"]
    ));
  }

  Future<bool> ktra_mota(String CumTu, int id) async{
    final db = await init();
    bool b = false;
    List<Map> row = await db.rawQuery('''
      SELECT ID FROM T01_TuKhoa WHERE CumTu = '$CumTu'
    ''');
    if(row.isNotEmpty && row[0]["ID"]!=id)b = true;
    db.close();
    return b;
  }

}