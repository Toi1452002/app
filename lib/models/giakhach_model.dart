// ignore_for_file: non_constant_identifier_names


class GiaKhachModel{
  int? ID;
  int? KhachID;
  String MaKieu;
  double CoMN;
  double TrungMN;
  double CoMT;
  double TrungMT;
  double CoMB;
  double TrungMB;

  GiaKhachModel(
      {this.ID,
        this.KhachID,
        required this.MaKieu,
        required this.CoMN,
        required this.TrungMN,
        required this.CoMT,
        required this.TrungMT,
        required this.CoMB,
        required this.TrungMB});

  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'KhachID': KhachID,
      'MaKieu': MaKieu,
      'CoMN': CoMN,
      'TrungMN': TrungMN,
      'CoMT': CoMT,
      'TrungMT': TrungMT,
      'CoMB': CoMB,
      'TrungMB': TrungMB,
    };
  }
  
  factory GiaKhachModel.fromMap(Map<String, dynamic> map){
    return GiaKhachModel(
        ID: map["ID"],
        KhachID: map["KhachID"],
        MaKieu: map["MaKieu"],
        CoMN: map["CoMN"],
        TrungMN: map["TrungMN"],
        CoMT: map["CoMT"],
        TrungMT: map["TrungMT"],
        CoMB: map["CoMB"],
        TrungMB: map["TrungMB"]);
  }
}