

import '../models/kqxs_model.dart';
import '../models/madai_model.dart';
import 'connect_db.dart';

class KqxsData extends ConnectDb {
  Future<List<MaDaiModel>> getMaDai(String mien, String ngay) async {
    int thutrongtuan = mien =="B"?0:DateTime.parse(ngay).weekday - 1;
    final db = await init();
    List<Map<String, dynamic>> row = await db.rawQuery(
        '''Select MaDai, MoTa,substr(TT, INSTR(Thu,'$thutrongtuan'), 1) as indexTT 
        From T01_MaDai 
        Where Mien = '$mien' 
        And Thu LIKE '%$thutrongtuan%' 
        Order By indexTT''');
    db.close();
    return List.generate(
        row.length,
            (index) =>
            MaDaiModel(MaDai: row[index]["MaDai"], MoTa: row[index]["MoTa"]));
  }

  Future<List<KqxsModel>> getKqxs(String ngay, String mien) async {
    final db = await init();
    int thutrongtuan = mien =="B"?0:DateTime.parse(ngay).weekday - 1;
    List<Map<String, dynamic>> row = await db.rawQuery(
        '''Select TXL_KQXS.*,T01_MaDai.MoTa as MoTa ,  substr(T01_MaDai.TT, INSTR(T01_MaDai.Thu,'$thutrongtuan'), 1) as indexTT
        From TXL_KQXS,T01_MaDai  
        Where TXL_KQXS.Ngay = '$ngay' 
        And TXL_KQXS.Mien = '$mien' 
        And TXL_KQXS.MaDai = T01_MaDai .MaDai
        And TXL_KQXS.MaDai = T01_MaDai .MaDai
        And T01_MaDai.Thu Like '%$thutrongtuan%'
        Order by indexTT
        ''');
    db.close();
    return List.generate(
        row.length,
            (index) => KqxsModel(
            ID: row[index]["ID"],
            Ngay: row[index]["Ngay"],
            Mien: row[index]["Mien"],
            MaDai: row[index]["MaDai"],
            MaGiai: row[index]["MaGiai"],
            TT: row[index]["TT"],
            MoTa: row[index]["MoTa"],
            KqSo: row[index]["KQso"]));
  }
  Future<int> insertKqxs(KqxsModel kqxsModel) async {
    final db = await init();
    int idInsert = await db.insert("TXL_KQXS", kqxsModel.toMap());
    db.close();
    return idInsert;
  }

  Future<void> deleteAllKqxs() async {
    final db = await init();
    await db.delete("TXL_KQXS");
    db.close();
  }
}
