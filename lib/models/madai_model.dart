class MaDaiModel {
  int? ID;
  final String MaDai;
  String MoTa;
  final String Mien;
  final String Thu;
  final String TT;
  final bool? NghiXoSo;

  MaDaiModel(
      {this.ID,
      this.MaDai = "",
      this.MoTa = "",
      this.Mien = "",
      this.Thu = "",
      this.TT = "",
      this.NghiXoSo});

  Map<String, dynamic> toMap() {
    return {
      "ID": ID,
      "MaDai": MaDai,
      "Mien": Mien,
      "Thu": Thu,
      "TT": TT,
      "NghiXoSo": NghiXoSo
    };
  }
}
