// ignore_for_file: non_constant_identifier_names

class TinNhanModel {
  int? ID;
   String Ngay;
   int KhachID;
   String Mien;
   int DaTinh;
   double TongTien;
   String MaKhach;
    String TinGoc;
    String TinXL;
    // bool DauTren;
  TinNhanModel(
      {this.ID,
      this.Ngay = "",
      this.KhachID = 0,
      this.Mien = "",
      this.DaTinh = 0,
      this.MaKhach = "",
      this.TongTien = 0.0,
      this.TinGoc = "",
        this.TinXL = "",
        // this.DauTren = false
      });

  Map<String, dynamic> toMap() {
    return {
      "ID": ID,
      "Ngay": Ngay,
      "KhachID": KhachID,
      "Mien": Mien,
      "DaTinh": DaTinh,
      "TongTien": TongTien,
      "TinGoc": TinGoc,
      "TinXL": TinXL,
      // "DauTren":DauTren
    };
  }
}
