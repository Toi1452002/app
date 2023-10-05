// ignore_for_file: non_constant_identifier_names

class TuKhoaModel {
  int? ID;
  String CumTu;
  String ThayThe;
  bool SoDanhHang;

  TuKhoaModel(
      {this.ID, this.CumTu = "", this.ThayThe = "", this.SoDanhHang = false});

  Map<String, dynamic> toMap() {
    return {
      "ID": ID,
      "CumTu": CumTu,
      "ThayThe": ThayThe,
      "SoDanhHang": SoDanhHang
    };
  }

}
