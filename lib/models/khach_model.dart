// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:ttpmn/function/extension.dart';

class KhachModel {
  int? ID;
  String MaKhach;
  // bool TheoDoi;
  bool ThuongMN;
  bool ThemChiMN;
  bool ThuongMT;
  bool ThemChiMT;
  bool ThuongMB;
  bool ThemChiMB;
  bool KDauTren;
  double HoiTong;
  double Hoi2s;
  double Hoi3s;
  int KieuTyLe;
  int tkDa;
  bool copy;
  KhachModel({this.ID,
    this.MaKhach = "",
    // this.TheoDoi = true,
    this.ThuongMN = false,
    this.ThemChiMN = false,
    this.ThuongMT = false,
    this.ThemChiMT = false,
    this.ThuongMB = false,
    this.ThemChiMB = false,
    this.KDauTren = false,
    this.KieuTyLe = 1,
    this.tkDa = 1,
    this.HoiTong = 0,
    this.Hoi2s = 0,
    this.copy = false,
    this.Hoi3s = 0});

  Map<String, dynamic> toMap() {
    return {
      "ID": ID,
      "MaKhach": MaKhach,
      // "TheoDoi": TheoDoi,
      "KDauTren": KDauTren,
      "ThuongMN": ThuongMN,
      "ThemChiMN": ThemChiMN,
      "ThuongMT": ThuongMT,
      "ThemChiMT": ThemChiMT,
      "ThuongMB": ThuongMB,
      "ThemChiMB": ThemChiMB,
      "HoiTong": HoiTong,
      "Hoi2s": Hoi2s,
      "Hoi3s": Hoi3s,
      "KieuTyLe": KieuTyLe,
      "tkDa": tkDa
    };
  }

  factory KhachModel.fromMap(Map<String, dynamic> map)=>
      KhachModel(
        ID: map["ID"],
        MaKhach: map["MaKhach"],
        tkDa: map["tkDa"],
        KieuTyLe: map["KieuTyLe"],
        Hoi2s: map["Hoi2s"],
        Hoi3s: map["Hoi3s"],
        HoiTong: map["HoiTong"],
        ThuongMN: map["ThuongMN"].toString().toBool,
        ThemChiMB: map["ThemChiMB"].toString().toBool,
        ThemChiMN: map["ThemChiMN"].toString().toBool,
        ThemChiMT: map["ThemChiMT"].toString().toBool,
        ThuongMB: map["ThuongMB"].toString().toBool,
        ThuongMT: map["ThuongMT"].toString().toBool
      );
  // String toJson() => jsonEncode(toMap());
  // factory KhachModel.fromJson(String source)=>KhachModel.fromMap(jsonDecode(source));
}
