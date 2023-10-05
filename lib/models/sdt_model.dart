
// ignore_for_file: non_constant_identifier_names

class SdtModel{
  int? ID;
  int KhachID;
  String SoDT;
  SdtModel({this.ID, this.KhachID = 0, this.SoDT =""});

  Map<String, dynamic> toMap(){
    return {
      "ID":ID,
      "KhachID": KhachID,
      "SoDT": SoDT
    };
  }
}