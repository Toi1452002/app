import '../../database/connect_db.dart';

ConnectDb connectDb = ConnectDb();

dLookup(String FieldName,String TableName,String Condition) async{
 var db= await connectDb.init();
 List<Map> x = await db.rawQuery("SELECT $FieldName FROM $TableName WHERE $Condition");
 db.close();
 return x[0]['$FieldName'];
}


 layTable(String sql)async{
  var db= await connectDb.init();
  List<Map> x = await db.rawQuery(sql);
  // db.close();
  return x;
}