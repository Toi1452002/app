// ignore_for_file: non_constant_identifier_names

class TinNhanPhanTichCTModel {
  int? ID;
  int? TinNhanID;
  String MaKieu;
  String MaDai;
  String SoDanh;
  double SoTien;
  dynamic SoLanTrung;
  double TienXac;
  double TienVon;
  double TienTrung;
  int SoDai;
  int KhachID;

  TinNhanPhanTichCTModel(
      {this.ID,
      this.TinNhanID,
      this.MaKieu = "",
      this.MaDai = "",
      this.SoDanh = "",
      this.SoTien = 0,
      this.SoLanTrung = 0,
      this.TienXac = 0,
      this.TienVon = 0,
      this.TienTrung = 0,
      this.SoDai = 0,
      this.KhachID = 0});

  Map<String, dynamic> toMap() {
    return {
      "ID": ID,
      "TinNhanID": TinNhanID,
      "MaKieu": MaKieu,
      "MaDai": MaDai,
      "SoDanh": SoDanh,
      "SoTien": SoTien,
      "SoLanTrung": SoLanTrung,
      "TienXac": TienXac,
      "TienVon": TienVon,
      "TienTrung": TienTrung,
      "SoDai": SoDai,
      "KhachID": KhachID
    };
  }
}
