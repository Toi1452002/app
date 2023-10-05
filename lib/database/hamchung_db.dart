// ignore_for_file: non_constant_identifier_names

import 'connect_db.dart';

class HamChungDB extends ConnectDb{
  Future<dynamic> dLookup(String FieldName,String TableName,String Condition) async{
    var db=await init();
    List<Map> x = await db.rawQuery("SELECT $FieldName FROM $TableName WHERE $Condition");
    // db.close();
    return x[0][FieldName];
  }
  layTable(String sql)async{
    var db= await init();
    List<Map> x = await db.rawQuery(sql);
    // db.close();
    return x;
  }

  Future<void> RawQuery(String sql) async {
    var db= await init();
    await db.rawQuery(sql);
  }

  Future<void> Insert(String table,Map<String, dynamic> map) async {
    var db= await init();
    await db.insert(table, map);
    db.close();
  }

  Future<void> Update({required String table,required Map<String, dynamic> map, required String where, required String whereArgs}) async {
    var db= await init();
    await db.update(table, map,where: "$where = ?", whereArgs: [whereArgs]);

  }

  deleteRow({required String table,required String where, required var whereArgs}) async{
    var db = await init();
    await db.delete(table, where: "$where=?", whereArgs: [whereArgs]);
    db.close();
  }
}