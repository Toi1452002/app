import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConnectDb {
  static const _databaseName = "data_sd.db";

  Future<Database> init() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _databaseName);
    var exist = await databaseExists(path);
    if (exist) {
      return await openDatabase(path);
    } else {
      // print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", _databaseName));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      return await openDatabase(path);
    }
  }


}
